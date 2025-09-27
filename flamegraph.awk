#!/usr/bin/awk -f
#
# Copyright IBM Corporation. All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0
#
# usage: ~/flamegraph.awk [-v "option=value"] *javacore*.txt...
#        find . -name "*javacore\.*txt" -print0 | xargs -0 ~/flamegraph.awk
# Options:
#   Skip native stacks for Java threads:
#     -v nativeStacksForJavaThreads=true
#   Only specific thread states regex:
#     -v 'onlyThreadStates=(R|CW|P|B|Z|S|N)'
#   Only match certain threads regex:
#     -v 'onlyThreads=(WebContainer|Default Executor)'
#   Group by thread state:
#     -v groupByThreadState=true
#   Invert the stacks:
#     -v inverted=true
#   Ignore idle threads:
#     -v ignoreidle=true
#   Trim package names:
#     -v trim=true

BEGIN {
  ANONYMOUS_THREAD_NAME = "Anonymous native thread";
  ANONYMOUS_THREAD_STATE = "N";

  THREAD_DUMP_TYPE_OPENJ9 = 1;
  THREAD_DUMP_TYPE_HOTSPOT = 2;
  THREAD_DUMP_TYPE_LIBERTY_TRAS0112W = 3;
  THREAD_DUMP_TYPE_TWAS_WSVR0605W = 4;
  THREAD_DUMP_TYPE_TWAS_WTRN0124I = 5;
  THREAD_DUMP_TYPE_JDMPVIEW_JAVA = 6;
  THREAD_DUMP_TYPE_JDMPVIEW_NATIVE = 7;
  THREAD_DUMP_TYPE_VALGRIND = 8;

  # https://www.ibm.com/docs/en/sdk-java-technology/8?topic=dumps-java-dump#threads
  THREAD_STATE_MAP["R"] = "Runnable"; # The thread is able to run
  THREAD_STATE_MAP["CW"] = "Condition Wait"; # The thread is waiting
  THREAD_STATE_MAP["S"] = "Suspended"; # The thread is suspended by another thread
  THREAD_STATE_MAP["Z"] = "Zombie"; # The thread is destroyed
  THREAD_STATE_MAP["P"] = "Parked"; # The thread is parked by java.util.concurrent
  THREAD_STATE_MAP["B"] = "Blocked"; # The thread is waiting to obtain a lock
  THREAD_STATE_MAP["N"] = "Native Thread Unknown"; # Anonymous native thread; no state reported
  THREAD_STATE_MAP["U"] = "Unknown State";

  # For HotSpot: https://docs.oracle.com/javase/8/docs/api/java/lang/Thread.State.html
  THREAD_STATE_MAP["NEW"] = "Unknown State";
  THREAD_STATE_MAP["RUNNABLE"] = "Runnable";
  THREAD_STATE_MAP["BLOCKED"] = "Blocked";
  THREAD_STATE_MAP["WAITING"] = "Condition Wait";
  THREAD_STATE_MAP["TIMED_WAITING"] = "Condition Wait";
  THREAD_STATE_MAP["TERMINATED"] = "Zombie";

  # Valgrind kinds
  THREAD_STATE_MAP["definitely lost"] = "Definitely lost";
  THREAD_STATE_MAP["indirectly lost"] = "Indirectly lost";
  THREAD_STATE_MAP["possibly lost"] = "Possibly lost";
  THREAD_STATE_MAP["still reachable"] = "Still reachable";

  # Set defaults or handle true values
  if (length(nativeStacksForJavaThreads) == 0) {
    nativeStacksForJavaThreads = 0;
  } else if (nativeStacksForJavaThreads == "true") {
    nativeStacksForJavaThreads = 1;
  }

  if (length(groupByThreadState) == 0) {
    groupByThreadState = 0;
  } else if (groupByThreadState == "true") {
    groupByThreadState = 1;
  }

  if (!nativeSeparator) {
    #nativeSeparator = "-- native stack --";
    nativeSeparator = "-";
  }

  # https://www.brendangregg.com/blog/2017-07-30/coloring-flamegraphs-code-type.html
  if (!rootAnnotation) {
    rootAnnotation = "_[i]";
  }

  # Create hex character } decimal map, e.g. hexhcars["A"] = 10, etc.
  for (i=0; i<16; i++) {
    hexchars[sprintf("%x", i)] = i;
    hexchars[sprintf("%X", i)] = i;
  }

  if (verbose) {
    printVerbose("CONFIG: groupByThreadState=" groupByThreadState);
  }
}

function resetStack() {

  if (hasSomeStack) {
    # End of stack
    if (key != "" || nativeKey != "") {
      if (key != "") {
        finalKey = key;
      } else {
        finalKey = nativeKey;
      }

      if (isInterestingStack(finalKey)) {
        if (threadName == threadPoolName) {
          finalKey = threadName rootAnnotation ";" finalKey;
        } else {
          finalKey = threadPoolName rootAnnotation ";" finalKey;
        }

        if (nativeStacksForJavaThreads) {
          if (key != "" && nativeKey != "") {
            finalKey = finalKey ";" nativeSeparator ";" nativeKey;
          }
        }

        if (groupByThreadState) {
          finalKey = THREAD_STATE_MAP[threadState] ";" finalKey;
        }

        shouldCount = 1;

        if (onlyThreadStates && threadState !~ onlyThreadStates) {
          shouldCount = 0;
        }

        if (shouldCount) {
          finalKey = finalStackProcessing(finalKey);
          counts[finalKey] += stackCount;
        }
      }
    }
  }

  key = "";
  nativeKey = "";
  threadState = "U";
  threadName = "Unknown Thread";
  threadPoolName = "Unknown Thread Pool";
  hasSomeStack = 0;
  shouldProcessThread = 0;
  threadDumpType = 0;
  stackCount = 1;
}

FNR == 1 {
  if (verbose)
    printVerbose("FILE: " FILENAME);

  resetStack();
}

#{
#  if (verbose)
#    printVerbose("LINE: " processInput($0));
#}

function fatalError(message) {
  printf("ERROR: %s @ %s %s\n%s\n", message, FILENAME, FNR, processInput($0)) > "/dev/stderr";
  exit 1;
}

function printVerbose(str) {
  printf("VERBOSE: %s\n", str) > "/dev/stderr";
}

function isInterestingMessageLine(message) {
  if (length(checkmessage) > 0) {
    if (!($0 ~ checkmessage)) {
      return 0;
    }
  }
  return 1;
}

/3XMTHREADINFO / {
  resetStack();
  threadDumpType = THREAD_DUMP_TYPE_OPENJ9;
  threadState = processInput($0);
  gsub(/.*, state:/, "", threadState);
  gsub(/, .*/, "", threadState);

  if (processInput($0) ~ /J9VMThread/) {
    threadName = processInput($0);
    gsub(/" J9VMThread.*/, "", threadName);
    gsub(/3XMTHREADINFO +"/, "", threadName);
    gsub(/"/, "", threadName);
  } else {
    threadName = ANONYMOUS_THREAD_NAME;
  }
  processThreadName(threadName);

  if (shouldProcessThread) {
    threadStateCounts[threadState]++;
  }
}

function processThreadName(name) {
  if (name == ANONYMOUS_THREAD_NAME) {
    name = ANONYMOUS_THREAD_STATE;
  }

  threadPoolName = getThreadPoolName(processInput(name));

  shouldProcessThread = isThreadInteresting(name);

  if (verbose) {
    printVerbose(name "," state "," threadPoolName);
  }
}

## Start TRAS0112W

shouldProcessThread && threadDumpType == THREAD_DUMP_TYPE_LIBERTY_TRAS0112W && /^[ \t]+at / {
  inputLine = processInput($0);
  gsub(/^[ \t]at /, "", inputLine);
  processStackFrame(inputLine);
}

shouldProcessThread && threadDumpType == THREAD_DUMP_TYPE_LIBERTY_TRAS0112W && !/^[ \t]+at / {
  # The TRAS0112W message is followed by a newline so we skip that
  if (shouldProcessThread == 1) {
    shouldProcessThread = 2;
  } else {
    resetStack();
  }
}

/TRAS0112W: Request/ && !skip_TRAS0112W && isInterestingMessageLine($0) {
  resetStack();
  threadDumpType = THREAD_DUMP_TYPE_LIBERTY_TRAS0112W;
  threadName = processInput($15);
  # Setting thread pool to the same would cause the thread name to be in the flame
  #threadPoolName = threadName;
  shouldProcessThread = 1;
}

## End TRAS0112W

## Start WSVR0605W

shouldProcessThread && threadDumpType == THREAD_DUMP_TYPE_TWAS_WSVR0605W && /^[ \t]+at / {
  inputLine = processInput($0);
  gsub(/^[ \t]at /, "", inputLine);
  processStackFrame(inputLine);
}

shouldProcessThread && threadDumpType == THREAD_DUMP_TYPE_TWAS_WSVR0605W && !/^[ \t]+at / {
  resetStack();
}

/WSVR0605W: / && !skip_WSVR0605W && isInterestingMessageLine($0) {
  shouldProcess = 1;

  if (mindate) {
    i = match($0, /^\[[0-9]+\/[0-9]+\/[0-9][0-9] [0-9]+:[0-9][0-9]:[0-9][0-9]/);
    if (i) {
      str = substr($0, 2);
      split(str, pieces, / /);
      split(pieces[1], datePieces, /\//);
      year = 2000 + datePieces[3];
      month = 0 + datePieces[1];
      day = 0 + datePieces[2];
      date = 0 + sprintf("%d%02d%02d", year, month, day);
      if (date < mindate) {
        shouldProcess = 0;
      }
    }
  }

  if (shouldProcess) {
    resetStack();
    threadDumpType = THREAD_DUMP_TYPE_TWAS_WSVR0605W;
    threadName = processInput($0);
    gsub(/.*Thread "/, "", threadName);
    gsub(/".*/, "", threadName);
    processThreadName(threadName);
  }
}

## End WSVR0605W

## Start WTRN0124I

shouldProcessThread && threadDumpType == THREAD_DUMP_TYPE_TWAS_WTRN0124I && /^[ \t]+[a-zA-Z]/ {
  inputLine = processInput($0);
  gsub(/^[ \t]+/, "", inputLine);
  processStackFrame(inputLine);
}

shouldProcessThread && threadDumpType == THREAD_DUMP_TYPE_TWAS_WTRN0124I && !/^[ \t]+[a-zA-Z]/ {
  inputLine = processInput($0);
  if (!(inputLine ~ /^ *: *$/)) {
    resetStack();
  }
}

/WTRN0124I:/ && !skip_WTRN0124I && isInterestingMessageLine($0) {
  resetStack();
  threadDumpType = THREAD_DUMP_TYPE_TWAS_WTRN0124I;
  threadName = processInput($0);
  gsub(/.*associated was Thread\[/, "", threadName);
  gsub(/\]. The stack.*/, "", threadName);
  processThreadName(threadName);
}

## End WTRN0124I

## Start THREAD_DUMP_TYPE_JDMPVIEW_JAVA

/name:          [^ ]+/ && isInterestingMessageLine($0) {
  resetStack();
  threadDumpType = THREAD_DUMP_TYPE_JDMPVIEW_JAVA;
  threadName = processInput($0);
  gsub(/^[ ]*name:[ ]+/, "", threadName);
  processThreadName(threadName);
}

shouldProcessThread && threadDumpType == THREAD_DUMP_TYPE_JDMPVIEW_JAVA && /^[ ]*Thread.State:/ {
  threadState = processInput($NF);
}

shouldProcessThread && threadDumpType == THREAD_DUMP_TYPE_JDMPVIEW_JAVA && /^[ ]*bp: 0x.*method: / {
  inputLine = processInput($0);
  gsub(/.*method: [^ ]+ /, "", inputLine);
  gsub(/\(.*/, "", inputLine);
  processStackFrame(inputLine);
}

## End THREAD_DUMP_TYPE_JDMPVIEW_JAVA

## Start THREAD_DUMP_TYPE_JDMPVIEW_NATIVE

/thread id: 0x/ && isInterestingMessageLine($0) {
  resetStack();
  threadDumpType = THREAD_DUMP_TYPE_JDMPVIEW_NATIVE;
  threadName = processInput($NF);
  processThreadName(threadName);
}

shouldProcessThread && threadDumpType == THREAD_DUMP_TYPE_JDMPVIEW_NATIVE && /^[ ]*bp: [^ ]+ pc: / {
  inputLine = processInput($0);
  gsub(/.*bp: [^ ]+ pc: [^ ]+ /, "", inputLine);
  processStackFrame(inputLine);
}

## End THREAD_DUMP_TYPE_JDMPVIEW_NATIVE

## Start THREAD_DUMP_TYPE_VALGRIND

/bytes in.*in loss record/ && isInterestingMessageLine($0) {
  resetStack();
  threadDumpType = THREAD_DUMP_TYPE_VALGRIND;
  threadName = "Valgrind";
  processThreadName(threadName);

  stackCount = $2;
  gsub(/,/, "", stackCount);

  threadState = processInput($0);
  gsub(/.* blocks are /, "", threadState);
  gsub(/ in loss record.*/, "", threadState);
  threadStateCounts[threadState]++;
}

shouldProcessThread && threadDumpType == THREAD_DUMP_TYPE_VALGRIND && /[at|by] 0x[0-9a-fA-F]+: / {
  inputLine = processInput($0);
  gsub(/.*[at|by] 0x[0-9a-fA-F]+: /, "", inputLine);
  processStackFrame(inputLine);
}

## End THREAD_DUMP_TYPE_VALGRIND

/tid=/ && /nid=/ {
  resetStack();
  threadDumpType = THREAD_DUMP_TYPE_HOTSPOT;
  search = processInput($0);
  gsub(/^"/, "", search);
  i = index(search, "\" ");
  if (i > 0) {
    threadName = substr(search, 1, i - 1);
    processThreadName(threadName);
  }
}

shouldProcessThread && /java.lang.Thread.State: / {
  threadState = processInput($NF);
  threadStateCounts[threadState]++;
}

shouldProcessThread && /3XMTHREADINFO1.*native thread ID:0x[^,]+,/ {
  hexThreadId = processInput($4);
  gsub(/ID:/, "", hexThreadId);
  gsub(/,/, "", hexThreadId);
  decimalThreadId = parseHex(hexThreadId);

  if (verbose)
    printVerbose(hexThreadId "," decimalThreadId);
}

shouldProcessThread && (/4XESTACKTRACE/ || /4XENATIVESTACK/) {
  processStackFrame($0);
}

function processStackFrame(frameLine) {
  if (isStackFrameInteresting(processInput(frameLine))) {
    stackFrame = getStackFrame(processInput(frameLine));
    addFrame = stackFrame;
    hasSomeStack = 1;

    if (frameLine ~ /4XENATIVESTACK/) {
      if (nativeKey == "") {
        nativeKey = addFrame;
      } else {
        if (inverted) {
          nativeKey = nativeKey ";" addFrame;
        } else {
          nativeKey = addFrame ";" nativeKey;
        }
      }
    } else {
      if (key == "") {
        key = addFrame;
      } else {
        if (inverted) {
          key = key ";" addFrame;
        } else {
          key = addFrame ";" key;
        }
      }
    }
  }
}

shouldProcessThread && threadDumpType == THREAD_DUMP_TYPE_HOTSPOT && /^[ \t]*at / {
  processStackFrame($0);
}

function doStacksMatch(compressedStack, knownComparisonStack) {

  if (verbose) {
    printVerbose("doStacksMatch: entry " compressedStack);
  }

  split(compressedStack, pieces, /;/);
  check = "";
  checkReversed = "";
  l = arrayLength(pieces);
  for (i = 1; i <= l; i++) {
    item = pieces[i];
    gsub(/\(.*/, "", item);
    if (length(check) == 0) {
      check = item;
      checkReversed = item;
    } else {
      check = check ";" item;
      checkReversed = item ";" checkReversed;
    }
  }

  if (threadDumpType == THREAD_DUMP_TYPE_HOTSPOT) {
    gsub(/\//, ".", knownComparisonStack);
  }

  if (verbose) {
    printVerbose("doStacksMatch: check: " check);
    printVerbose("doStacksMatch: checkReversed: " checkReversed);
    printVerbose("doStacksMatch: knownComparisonStack: " knownComparisonStack);
  }

  if (check == knownComparisonStack) {
    if (verbose) {
      printVerbose("doStacksMatch: exit true (forward)");
    }
    return 1;
  }
  if (checkReversed == knownComparisonStack) {
    if (verbose) {
      printVerbose("doStacksMatch: exit true (reverse)");
    }
    return 1;
  }
  if (verbose) {
    printVerbose("doStacksMatch: exit false");
  }
  return 0;
}

function isInterestingStack(compressedStack) {
  if (ignoreidle) {

    # https://www.ibm.com/support/pages/identifying-idle-threads-thread-dumps-taken-against-websphere-application-server
    if (doStacksMatch(compressedStack, "java/lang/Thread.run;java/util/concurrent/ThreadPoolExecutor$Worker.run;java/util/concurrent/ThreadPoolExecutor.runWorker;java/util/concurrent/ThreadPoolExecutor.getTask;com/ibm/ws/threading/internal/BoundedBuffer.take;com/ibm/ws/threading/internal/BoundedBuffer.waitGet_;java/lang/Object.wait;java/lang/Object.wait") ||
        doStacksMatch(compressedStack, "java/lang/Thread.run;java/util/concurrent/ThreadPoolExecutor$Worker.run;java/util/concurrent/ThreadPoolExecutor.runWorker;java/util/concurrent/ThreadPoolExecutor.getTask;com/ibm/ws/threading/internal/BoundedBuffer.take;com/ibm/ws/threading/internal/BoundedBuffer.waitGet_;java/lang/Object.wait;java/lang/Object.wait;java/lang/Object.waitImpl") ||
        doStacksMatch(compressedStack, "com/ibm/ws/util/ThreadPool$Worker.run;com/ibm/ws/util/ThreadPool.getTask;com/ibm/ws/util/BoundedBuffer.take;com/ibm/ws/util/BoundedBuffer.waitGet_;com/ibm/ws/util/BoundedBuffer$GetQueueLock.await;java/util/concurrent/locks/AbstractQueuedSynchronizer$ConditionObject.await;java/util/concurrent/locks/LockSupport.parkNanos;sun/misc/Unsafe.park") ||
        doStacksMatch(compressedStack, "com/ibm/ws/util/ThreadPool$Worker.run;com/ibm/ws/util/ThreadPool.getTask;com/ibm/ws/util/BoundedBuffer.take;com/ibm/ws/util/BoundedBuffer.waitGet_;java/lang/Object.wait;java/lang/Object.wait") ||
        doStacksMatch(compressedStack, "com/ibm/ws/util/ThreadPool$ZOSWorker.run;com/ibm/ws390/orb/CommonBridge.runApplicationThread;com/ibm/ws390/orb/CommonBridge.getAndProcessWork;com/ibm/ws390/orb/CommonBridge.getWork")) {
      return 0;
    }

    # Experimentally determined
    if (doStacksMatch(compressedStack, "java/lang/Thread.run;com/ibm/ws/asynchbeans/am/AlarmManager$1.run;java/lang/Thread.sleep;java/lang/Thread.sleep") ||
        doStacksMatch(compressedStack, "com/ibm/ws/util/ThreadPool$Worker.run;com/ibm/ws/util/ThreadPool.getTask;com/ibm/ws/util/BoundedBuffer.take;com/ibm/ws/util/BoundedBuffer.waitGet_;com/ibm/ws/util/BoundedBuffer$GetQueueLock.await;java/util/concurrent/locks/AbstractQueuedSynchronizer$ConditionObject.await;java/util/concurrent/locks/LockSupport.parkNanos;sun/misc/Unsafe.park") ||
        doStacksMatch(compressedStack, "com/ibm/ws/util/ThreadPool$Worker.run;com/ibm/ws/util/ThreadPool.getTask;com/ibm/ws/util/BoundedBuffer.poll;com/ibm/ws/util/BoundedBuffer.waitGet_;com/ibm/ws/util/BoundedBuffer$GetQueueLock.await;java/util/concurrent/locks/AbstractQueuedSynchronizer$ConditionObject.await;java/util/concurrent/locks/LockSupport.parkNanos;sun/misc/Unsafe.park") ||
        doStacksMatch(compressedStack, "java/lang/Thread.run;com/ibm/ejs/j2c/work/WorkScheduler.run;java/lang/Object.wait;java/lang/Object.wait") ||
        doStacksMatch(compressedStack, "com/ibm/ws/asynchbeans/am/AlarmManagerThread.run;java/lang/Object.wait;java/lang/Object.wait") ||
        doStacksMatch(compressedStack, "com/ibm/ws/asynchbeans/am/AlarmManagerThread.run;java/lang/Object.wait;java/lang/Object.wait;java/lang/Object.waitImpl") ||
        doStacksMatch(compressedStack, "com/ibm/ws/util/ThreadPool$Worker.run;com/ibm/ws/util/ThreadPool.getTask;com/ibm/ws/util/BoundedBuffer.poll;com/ibm/ws/util/BoundedBuffer.waitGet_;java/lang/Object.wait;java/lang/Object.wait") ||
        doStacksMatch(compressedStack, "java/util/TimerThread.run;java/util/TimerThread.mainLoop;java/lang/Object.wait;java/lang/Object.wait") ||
        doStacksMatch(compressedStack, "java/lang/Thread.run;java/util/concurrent/ThreadPoolExecutor$Worker.run;java/util/concurrent/ThreadPoolExecutor.runWorker;java/util/concurrent/ThreadPoolExecutor.getTask;java/util/concurrent/ScheduledThreadPoolExecutor$DelayedWorkQueue.take;java/util/concurrent/ScheduledThreadPoolExecutor$DelayedWorkQueue.take;java/util/concurrent/locks/AbstractQueuedSynchronizer$ConditionObject.awaitNanos;java/util/concurrent/locks/LockSupport.parkNanos;sun/misc/Unsafe.park") ||
        doStacksMatch(compressedStack, "java/lang/Thread.run;java/util/concurrent/ThreadPoolExecutor$Worker.run;java/util/concurrent/ThreadPoolExecutor.runWorker;java/util/concurrent/ThreadPoolExecutor.getTask;java/util/concurrent/ScheduledThreadPoolExecutor$DelayedWorkQueue.take;java/util/concurrent/ScheduledThreadPoolExecutor$DelayedWorkQueue.take;java/util/concurrent/locks/AbstractQueuedSynchronizer$ConditionObject.await;java/util/concurrent/locks/LockSupport.park;sun/misc/Unsafe.park") ||
        doStacksMatch(compressedStack, "java/lang/Thread.run;java/util/concurrent/ThreadPoolExecutor$Worker.run;java/util/concurrent/ThreadPoolExecutor.runWorker;java/util/concurrent/ThreadPoolExecutor.getTask;java/util/concurrent/ScheduledThreadPoolExecutor$DelayedWorkQueue.take;java/util/concurrent/ScheduledThreadPoolExecutor$DelayedWorkQueue.take;java/util/concurrent/locks/AbstractQueuedSynchronizer$ConditionObject.awaitNanos;java/util/concurrent/locks/LockSupport.parkNanos;sun/misc/Unsafe.park") ||
        doStacksMatch(compressedStack, "java/lang/Thread.run;com/ibm/ws/sib/msgstore/persistence/dispatcher/SpillDispatcher$SpillDispatcherThread.run;java/lang/Object.wait;java/lang/Object.wait") ||
        doStacksMatch(compressedStack, "org/eclipse/core/internal/jobs/InternalWorker.run;java/lang/Object.wait;java/lang/Object.wait;java/lang/Object.waitImpl") ||
        doStacksMatch(compressedStack, "org/eclipse/core/internal/jobs/Worker.run;org/eclipse/core/internal/jobs/WorkerPool.startJob;org/eclipse/core/internal/jobs/WorkerPool.sleep;java/lang/Object.wait;java/lang/Object.wait;java/lang/Object.waitImpl") ||
        doStacksMatch(compressedStack, "java/lang/Thread.run;com/ibm/ejs/j2c/work/WorkScheduler.run;java/lang/Object.wait;java/lang/Object.wait;java/lang/Object.waitImpl") ||
        doStacksMatch(compressedStack, "com/ibm/ws/util/ThreadPool$ZOSWorker.run;com/ibm/ws390/orb/CommonBridge.runApplicationThread;com/ibm/ws390/orb/CommonBridge.getAndProcessWork;com/ibm/ws390/orb/CommonBridge.getWork") ||
        doStacksMatch(compressedStack, "com/ibm/ws/util/ThreadPool$Worker.run;com/ibm/ws/util/ThreadPool.getTask;com/ibm/ws/util/BoundedBuffer.poll;com/ibm/ws/util/BoundedBuffer.waitGet_;com/ibm/ws/util/BoundedBuffer$GetQueueLock.await;java/util/concurrent/locks/AbstractQueuedSynchronizer$ConditionObject.await;java/util/concurrent/locks/LockSupport.parkNanos;sun/misc/Unsafe.park") ||
        doStacksMatch(compressedStack, "com/ibm/ws/util/ThreadPool$Worker.run;com/ibm/ws/wlm/threadmanager/SleeperThreadPool.run;java/lang/Object.wait;java/lang/Object.wait;java/lang/Object.waitImpl") ||
        doStacksMatch(compressedStack, "org/quartz/core/QuartzSchedulerThread.run;java/lang/Object.wait;java/lang/Object.wait;java/lang/Object.waitImpl") ||
        doStacksMatch(compressedStack, "java/util/TimerThread.run;java/util/TimerThread.mainLoop;java/lang/Object.wait;java/lang/Object.wait;java/lang/Object.waitImpl") ||
        doStacksMatch(compressedStack, "org/eclipse/osgi/framework/eventmgr/EventManager$EventThread.run;org/eclipse/osgi/framework/eventmgr/EventManager$EventThread.getNextEvent;java/lang/Object.wait;java/lang/Object.wait;java/lang/Object.waitImpl") ||
        doStacksMatch(compressedStack, "java/lang/Thread.run;com/ibm/ejs/util/am/AlarmThreadMonitor$AlarmThreadCheckDetector.run;java/lang/Thread.sleep;java/lang/Thread.sleep;java/lang/Thread.sleepImpl") ||
        doStacksMatch(compressedStack, "com/ibm/wsspi/bootstrap/WSPreLauncher.main;com/ibm/wsspi/bootstrap/WSPreLauncher.launchEclipse;org/eclipse/core/launcher/Main.run;org/eclipse/core/launcher/Main.basicRun;org/eclipse/core/launcher/Main.invokeFramework;java/lang/reflect/Method.invoke;sun/reflect/DelegatingMethodAccessorImpl.invoke;sun/reflect/NativeMethodAccessorImpl.invoke;sun/reflect/NativeMethodAccessorImpl.invoke0;org/eclipse/core/runtime/adaptor/EclipseStarter.run;org/eclipse/core/runtime/adaptor/EclipseStarter.startup;org/eclipse/core/runtime/adaptor/EclipseStarter.setStartLevel;org/eclipse/core/runtime/adaptor/EclipseStarter.updateSplash;org/eclipse/core/runtime/internal/adaptor/Semaphore.acquire;java/lang/Object.wait;java/lang/Object.wait;java/lang/Object.waitImpl") ||
        doStacksMatch(compressedStack, "java/lang/Thread.run;org/apache/log4j/AsyncAppender$Dispatcher.run;java/lang/Object.wait;java/lang/Object.wait;java/lang/Object.waitImpl") ||
        doStacksMatch(compressedStack, "java/lang/Thread.run;com/ibm/ws/tcp/channel/impl/ChannelSelector.run;sun/nio/ch/SelectorImpl.select;sun/nio/ch/SelectorImpl.lockAndDoSelect;sun/nio/ch/PollSelectorImpl.doSelect;sun/nio/ch/PollArrayWrapper.poll;sun/nio/ch/PollArrayWrapper.poll0") ||
        doStacksMatch(compressedStack, "sun/misc/GC$Daemon.run;java/lang/Object.wait;java/lang/Object.wait;java/lang/Object.waitImpl") ||
        doStacksMatch(compressedStack, "java/lang/Thread.run;com/ibm/ejs/util/am/AlarmManagerThreadCSLM.run;java/lang/Object.wait;java/lang/Object.wait;java/lang/Object.waitImpl") ||
        doStacksMatch(compressedStack, "openj9/internal/tools/attach/target/WaitLoop.run;openj9/internal/tools/attach/target/WaitLoop.waitForNotification;openj9/internal/tools/attach/target/CommonDirectory.waitSemaphore;openj9/internal/tools/attach/target/IPC.waitSemaphore") ||
        doStacksMatch(compressedStack, "com/ibm/ws/util/ThreadPool$Worker.run;com/ibm/ws/asynchbeans/WLMCJWorkItemImpl.run;com/ibm/ws/asynchbeans/CJWorkItemImpl.run;com/ibm/ws/asynchbeans/WorkWithExecutionContextImpl.go;com/ibm/ws/asynchbeans/J2EEContext.run;java/security/AccessController.doPrivileged;com/ibm/ws/asynchbeans/J2EEContext$RunProxy.run;org/springframework/scheduling/commonj/DelegatingWork.run;org/springframework/jms/listener/DefaultMessageListenerContainer$AsyncMessageListenerInvoker.run;org/springframework/jms/listener/DefaultMessageListenerContainer$AsyncMessageListenerInvoker.invokeListener;org/springframework/jms/listener/AbstractPollingMessageListenerContainer.receiveAndExecute;org/springframework/jms/listener/AbstractPollingMessageListenerContainer.doReceiveAndExecute;org/springframework/jms/listener/AbstractPollingMessageListenerContainer.receiveMessage;org/springframework/jms/support/destination/JmsDestinationAccessor.receiveFromConsumer;org/springframework/jms/connection/CachedMessageConsumer.receive;com/ibm/ws/sib/api/jms/impl/JmsMsgConsumerImpl.receive;com/ibm/ws/sib/api/jms/impl/JmsMsgConsumerImpl.receiveInboundMessage;com/ibm/ws/sib/comms/client/ConsumerSessionProxy.receiveWithWait;com/ibm/ws/sib/comms/client/ConsumerSessionProxy._receiveWithWait;com/ibm/ws/sib/comms/client/proxyqueue/impl/ReadAheadSessionProxyQueueImpl.receiveWithWait;com/ibm/ws/sib/comms/client/proxyqueue/impl/ReadAheadProxyQueueImpl.receiveWithWait;java/lang/Object.wait;java/lang/Object.wait;java/lang/Object.waitImpl") ||
        doStacksMatch(compressedStack, "com/ibm/ws/util/ThreadPool$Worker.run;com/ibm/ws/asynchbeans/WLMCJWorkItemImpl.run;com/ibm/ws/asynchbeans/CJWorkItemImpl.run;com/ibm/ws/asynchbeans/WorkWithExecutionContextImpl.go;com/ibm/ws/asynchbeans/J2EEContext.run;java/security/AccessController.doPrivileged;com/ibm/ws/asynchbeans/J2EEContext$DoAsProxy.run;com/ibm/websphere/security/auth/WSSubject.doAs;com/ibm/websphere/security/auth/WSSubject.doAs;javax/security/auth/Subject.doAs;java/security/AccessController.doPrivileged;com/ibm/ws/asynchbeans/J2EEContext$RunProxy.run;org/springframework/scheduling/commonj/DelegatingWork.run;org/springframework/jms/listener/DefaultMessageListenerContainer$AsyncMessageListenerInvoker.run;org/springframework/jms/listener/DefaultMessageListenerContainer$AsyncMessageListenerInvoker.invokeListener;org/springframework/jms/listener/AbstractPollingMessageListenerContainer.receiveAndExecute;org/springframework/jms/listener/AbstractPollingMessageListenerContainer.doReceiveAndExecute;org/springframework/jms/listener/AbstractPollingMessageListenerContainer.receiveMessage;org/springframework/jms/support/destination/JmsDestinationAccessor.receiveFromConsumer;com/ibm/ejs/jms/JMSMessageConsumerHandle.receive;com/ibm/ejs/jms/JMSMessageConsumerHandle.receive;com/ibm/mq/jms/MQMessageConsumer.receive;com/ibm/msg/client/jms/internal/JmsMessageConsumerImpl.receive;com/ibm/msg/client/jms/internal/JmsMessageConsumerImpl.receiveInboundMessage;com/ibm/msg/client/wmq/internal/WMQMessageConsumer.receive;com/ibm/msg/client/wmq/internal/WMQConsumerShadow.receive;com/ibm/msg/client/wmq/internal/WMQSyncConsumerShadow.receiveInternal;com/ibm/msg/client/wmq/internal/WMQConsumerShadow.getMsg;com/ibm/mq/jmqi/local/LocalMQ.jmqiGet;com/ibm/mq/jmqi/internal/JmqiTools.getMessage;com/ibm/mq/jmqi/local/LocalMQ.jmqiGetInternal;com/ibm/mq/jmqi/local/LocalMQ.MQGET;com/ibm/mq/jmqi/local/internal.base.Native.MQGET") ||
        doStacksMatch(compressedStack, "com/ibm/ws/util/ThreadPool$Worker.run;com/ibm/ws/util/ThreadPool.getTask;com/ibm/ws/util/BoundedBuffer.take;com/ibm/ws/util/BoundedBuffer$LiteAtomicInteger.get") ||
        doStacksMatch(compressedStack, "com/ibm/ws/util/ThreadPool$Worker.run;com/ibm/ws/util/ThreadPool.getTask;com/ibm/ws/util/BoundedBuffer.take;com/ibm/ws/util/BoundedBuffer.waitGet_;com/ibm/ws/util/BoundedBuffer$GetQueueLock.await;java/util/concurrent/locks/AbstractQueuedSynchronizer$ConditionObject.await") ||
        doStacksMatch(compressedStack, "com/ibm/ws/util/ThreadPool$Worker.run;com/ibm/ws/util/ThreadPool.getTask;com/ibm/ws/util/BoundedBuffer.take;com/ibm/ws/util/BoundedBuffer.waitGet_;com/ibm/ws/util/BoundedBuffer$GetQueueLock.await;java/util/concurrent/locks/AbstractQueuedSynchronizer$ConditionObject.await;java/util/concurrent/locks/AbstractQueuedSynchronizer.acquireQueued") ||
        doStacksMatch(compressedStack, "java/lang/Thread.run;java/util/concurrent/ThreadPoolExecutor$Worker.run;java/util/concurrent/ThreadPoolExecutor.runWorker;java/util/concurrent/FutureTask.run;java/util/concurrent/Executors$RunnableAdapter.call;com/ibm/ws/threading/internal/ExecutorServiceImpl$RunnableWrapper.run;com/ibm/ws/request/timing/manager/HungRequestManager$2.run;com/ibm/ws/request/timing/queue/DelayedRequestQueue.processNext;java/util/concurrent/DelayQueue.take;java/util/concurrent/locks/AbstractQueuedSynchronizer$ConditionObject.await;java/util/concurrent/locks/LockSupport.park;sun/misc/Unsafe.park") ||
        doStacksMatch(compressedStack, "java/lang/Thread.run;java/util/concurrent/ThreadPoolExecutor$Worker.run;java/util/concurrent/ThreadPoolExecutor.runWorker;java/util/concurrent/FutureTask.run;java/util/concurrent/Executors$RunnableAdapter.call;com/ibm/ws/threading/internal/ExecutorServiceImpl$RunnableWrapper.run;com/ibm/ws/request/timing/manager/SlowRequestManager$2.run;com/ibm/ws/request/timing/queue/DelayedRequestQueue.processNext;java/util/concurrent/DelayQueue.take;java/util/concurrent/locks/AbstractQueuedSynchronizer$ConditionObject.await;java/util/concurrent/locks/LockSupport.park;sun/misc/Unsafe.park") ||
        doStacksMatch(compressedStack, "java/lang/Thread.run;java/lang/Thread.runWith;java/util/concurrent/ThreadPoolExecutor$Worker.run;java/util/concurrent/ThreadPoolExecutor.runWorker;java/util/concurrent/ThreadPoolExecutor.getTask;com/ibm/ws/threading/internal/BoundedBuffer.take;com/ibm/ws/threading/internal/BoundedBuffer.waitGet_;java/lang/Object.wait;java/lang/Object.wait;java/lang/Object.waitImpl") ||
        doStacksMatch(compressedStack, "java/lang/Thread.run;com/ibm/ws/drs/ha/DRSAgentClassEvents$1.run;java/lang/Object.wait;java/lang/Object.wait;java/lang/Object.waitImpl") ||
        doStacksMatch(compressedStack, "java/lang/Thread.run;com/ibm/ws/drs/ws390/DRSControllerInstanceWrapper.run;java/lang/Object.wait;java/lang/Object.wait;java/lang/Object.waitImpl") ||
#        doStacksMatch(compressedStack, "") ||
        doStacksMatch(compressedStack, "java/lang/Thread.run;com/ibm/ws/asynchbeans/ABWorkItemImpl.run;com/ibm/ws/asynchbeans/WorkWithExecutionContextImpl.go;com/ibm/ws/asynchbeans/J2EEContext.run;java/security/AccessController.doPrivileged;com/ibm/ws/asynchbeans/J2EEContext$DoAsProxy.run;com/ibm/websphere/security/auth/WSSubject.doAs;com/ibm/websphere/security/auth/WSSubject.doAs;javax/security/auth/Subject.doAs;java/security/AccessController.doPrivileged;com/ibm/ws/asynchbeans/J2EEContext$RunProxy.run;com/ibm/ws/scheduler/SchedulerDaemonImpl.run;java/lang/Object.wait;java/lang/Object.wait")) {
      return 0;
    }
  }
  return 1;
}

shouldProcessThread && /^NULL/ {
  resetStack();
}

function finalStackProcessing(stack) {
  n = split(stack, pieces, /;/);
  finalStack = "";
  for (i = 1; i <= n; i++) {
    piece = pieces[i];
    if (length(finalStack) > 0) {
      finalStack = finalStack ";";
    }
    if (trim) {
      gsub(/\(.*/, "", piece);
      gsub(/.*\//, "", piece);
      if (threadDumpType == THREAD_DUMP_TYPE_HOTSPOT) {
        x = split(piece, subpieces, /\./);
        if (x > 2) {
          piece = subpieces[x-1] "." subpieces[x];
        }
      }
    }
    finalStack = finalStack piece;
  }
  return finalStack;
}

function trimWhitespace(str) {
  gsub(/[ \t\n\r]+/, "", str);
  return str;
}

# Return 1 if str is a number (unknown radix),
# 2 if hex (0x prefix or includes [a-fA-F]),
# and 0 if number not matched by regexes.
# str is trimmed of whitespace.
function isNumber(str) {
  str = trimWhitespace(str);
  if (length(str) > 0) {
    if (str ~ /^[+-]?[0-9]+(\.[0-9]+)?([eE][+-]?[0-9]+)?$/ || str ~ /^(0[xX])?[0-9a-fA-F]+$/) {
      if (str ~ /^0[xX]/ || str ~ /[a-fA-F]/) {
        return 2;
      } else {
        return 1;
      }
    }
  }
  return 0;
}

# If str is a hexadecimal number (0x prefix optional), then return its decimal value;
# otherwise, return -1.
# str is trimmed of whitespace.
function parseHex(str) {
  numResult = isNumber(str);
  if (numResult == 1 || numResult == 2) {
    str = trimWhitespace(str);
    if (str ~ /^0[xX]/) {
      str = substr(str, 3);
    }
    result = 0;
    for (i=1; i<=length(str); i++) {
      result = (result * 16) + hexchars[substr(str, i, 1)];
    }
    return result;
  }
  return -1;
}

# If str is a decimal number, then return its decimal value;
# otherwise, return -1.
# str is trimmed of whitespace.
function parseDecimal(str) {
  if (isNumber(str) == 1) {
    return trimWhitespace(str) + 0;
  }
  return -1;
}

function getThreadPoolName(line) {
  gsub(/^DispatchThread.*/, "DispatchThread X", line);
  gsub(/^RcvThread.*/, "RcvThread X", line);
  gsub(/^RT=.*/, "RT=X", line);
  gsub(/^LT=.*/, "LT=X", line);
  gsub(/^WT=.*/, "WT=X", line);
  gsub(/^sib.LockManagerThread.*/, "sib.LockManagerThread X", line);
  gsub(/^sib.PersistentDispatcher.*/, "sib.PersistentDispatcher X", line);
  gsub(/^sib.SpillDispatcher.*/, "sib.SpillDispatcher X", line);
  gsub(/^sib.SpillDispatcher.*/, "sib.SpillDispatcher X", line);
  gsub(/@.*/, "@X", line);
  gsub(/^Thread-.*/, "Thread-X", line);
  gsub(/^Timer-.*/, "Timer-X", line);
  gsub(/^Worker-.*/, "Worker-X", line);
  gsub(/^WsSessionInvalidatorThread .*/, "WsSessionInvalidatorThread X", line);
  gsub(/^ThreadManager.JobsProcessorThread.ApplicationThread.*/, "ThreadManager.JobsProcessorThread.ApplicationThread X", line);
  gsub(/^ThreadManager.JobsProcessorThread.RmmThread.*/, "ThreadManager.JobsProcessorThread.RmmThread X", line);
  gsub(/\[SSL: ServerSocket\[.*\]\].*/, "[SSL: ServerSocket[X]]", line);
  gsub(/HAR\.[0-9]+\.Thread/, "HAR.X.Thread", line);
  gsub(/^AIO Timer Thread.*/, "AIO Timer Thread X", line);
  gsub(/^com.ibm.son.mesh.Peer-tcp-port.*/, "com.ibm.son.mesh.Peer-tcp-port X", line);
  gsub(/^Connect Selector.*/, "Connect Selector X", line);
  gsub(/[0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F]-[0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F]-[0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F]-[0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F]-[0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F]$/, "UUID", line);
  gsub(/[\[\]\(\)\-0-9:\.]+$/, "X", line);
  gsub(/-[0-9]+ Suspended$/, "-X Suspended", line);
  gsub(/ t=[a-fA-F0-9]+/, " t=X", line);
  gsub(/ : .*/, " : X", line);
  gsub(/jgroups-[0-9]+,Sterling_NodeInfo_group,b2bi-sfg-asi-serverX/, "jgroups-X,Sterling_NodeInfo_group,b2bi-sfg-asi-serverX", line);
  gsub(/SBYS_CD_Server_.*_INT_CDSERVER_ADAPTER_.*-Scheduler/, "SBYS_CD_Server_X_INT_CDSERVER_ADAPTER_X-Scheduler", line);
  return line;
}

# Windows newlines (\r\n) may throw things off and POSIX RS only supports
# a single character, so we just pass every $N to this function to clear
# any carriage return.
function processInput(str) {
  gsub(/\r$/, "", str);
  return str;
}

function getStackFrame(line) {
  if (line ~ /4XESTACKTRACE/) {
    gsub(/4XESTACKTRACE +at /, "", line);
    #gsub(/\(.*/, "", line);
  } else if (line ~ /4XENATIVESTACK/) {
    gsub(/4XENATIVESTACK +/, "", line);
    gsub(/^\(/, "", line);
    gsub(/\)$/, "", line);
  } else {
    gsub(/^[ \t]*at /, "", line);
  }
  return line;
}

function isStackFrameInteresting(line) {
  return 1;
}

function cleanCommas(str) {
  gsub(/,/, "_", str);
  return str;
}

function arrayLength(array) {
  l = 0;
  for (i in array) l++;
  return l;
}

function isThreadInteresting(threadName) {
  if ( onlyThreads ) {
    if ( threadName ~ onlyThreads ) {
      return isInterestingThreadID(threadName);
    } else {
      return 0;
    }
  }

  # When updating this, also update the title text in flamegraph.sh
  if (onlyCommonThreads) {
    if ( \
        threadName ~ /WebContainer/ || \
        threadName ~ /Default Executor/ || \
        threadName ~ /LargeThreadPool/ || \
        threadName ~ /SIBJMSRAThreadPool/ || \
        threadName ~ /MessageListenerThreadPool/ || \
        threadName ~ /ORB\.thread\.pool/ || \
        threadName ~ /WebSphere WLM Dispatch Thread/ || \
        threadName ~ /WebSphere t=/ || \
        threadName ~ /WorkManager/ || \
        threadName ~ /XIO/ || \
        threadName ~ /server.startup/ || \
        threadName ~ /WMQJCAResourceAdapter/ \
    ) {
      return isInterestingThreadID(threadName);
    } else {
      return 0;
    }
  }
  return 1;
}

function isInterestingThreadID(threadName) {
  #if ( threadName ~ / : DMN/ ) {
  #  return 0;
  #}
  return 1;
}

END {
  resetStack();

  for (key in counts) {
    count = counts[key];
    print key " " count;
  }

  if (verbose) {
    for (key in threadStateCounts) {
      count = threadStateCounts[key];
      printVerbose("Thread State " key " " count);
    }
  }
}
