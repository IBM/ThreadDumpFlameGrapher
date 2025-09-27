#!/bin/sh
# Copyright IBM Corporation. All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

SCRIPTDIR=$(dirname "$0")

usage() {
  printf "Usage: %s [FILE|DIR...]\n" "$(basename "${0}")"
  cat <<"EOF"
             -a AWKFLAGS: Extra flags to flamegraph.awk
             -d: Output directory (default: ./tdfg_$(date +%Y%m%d_%H%M%S)/)
             -o: Only specific flags (default: cilst)
EOF
  exit 22
}

EXTRA_AWK_FLAGS=""
OPTIND=1
OUTPUT_DIRECTORY="./tdfg_$(date +%Y%m%d_%H%M%S)/"
IS_DEFAULT_OUTPUT_DIRECTORY=1
while getopts "a:d:o:h?" opt; do
  case "$opt" in
    a)
      EXTRA_AWK_FLAGS="${OPTARG}"
      ;;
    d)
      OUTPUT_DIRECTORY="${OPTARG}"
      IS_DEFAULT_OUTPUT_DIRECTORY=0
      ;;
    o)
      ONLYFLAGS="${OPTARG}"
      ;;
    h|\?)
      usage
      ;;
  esac
done

shift $((OPTIND-1))

if [ "${1:-}" = "--" ]; then
  shift
fi

if [ $# -eq 0 ]; then
  echo "ERROR: No input files specified" 2>&1
  usage
fi

mkdir -p "${OUTPUT_DIRECTORY}"
if [ "${IS_DEFAULT_OUTPUT_DIRECTORY}" -eq "1" ]; then
  chmod 777 "${OUTPUT_DIRECTORY}"
fi

echo "[$(date)] Output directory: ${OUTPUT_DIRECTORY}"

SVGWIDTH="1600"
COMMON_FLAMEGRAPH_OPTIONS="--colors=red --width=${SVGWIDTH}"

FLAME_FLAGS="cilrst"
#FLAME_FLAGS="cilnrst"

TOTAL_GRAPHS="$("${SCRIPTDIR}/unique_combinations.awk" -v flags="${FLAME_FLAGS}" -v includenone=true | awk 'END { print NR; }')"
GRAPH_COUNT=0
SOME_SUCCESSFUL=0

COMBINATIONS="$("${SCRIPTDIR}/unique_combinations.awk" -v flags="${FLAME_FLAGS}" -v includenone=true)"

echo "[$(date)] Input files and/or directories: ${@}"

# Search directories for thread dumps. To deal with spaces, we use set; see:
# https://mywiki.wooledge.org/BashFAQ/050#I.27m_constructing_a_command_based_on_information_that_is_only_known_at_run_time
FILES=""
NEWLINE='
'
for arg in "${@}"; do
  if [ -d "${arg}" ]; then
    DIR_FILES="$(find "${arg}" -type f -name "*javacore*txt")"
    while read line; do
      if [ "${FILES}" != "" ]; then
        FILES="${FILES}${NEWLINE}"
      fi
      FILES="${FILES}${line}"
    done << EOF
${DIR_FILES}
EOF
  else
    if [ "${FILES}" != "" ]; then
      FILES="${FILES}${NEWLINE}"
    fi
    FILES="${FILES}${arg}"
  fi
done

# Reset positional arguments
set --
while read line; do
  set -- "$@" "${line}"
done << EOF
${FILES}
EOF

echo "[$(date)] Processing files: ${@}"

while read FLAGS_COMBINATION; do
  GRAPH_COUNT=$(( $GRAPH_COUNT + 1 ))
  ORIGINAL_FLAGS_COMBINATION="${FLAGS_COMBINATION}"
  NAME="${OUTPUT_DIRECTORY}/flamegraph_options_${FLAGS_COMBINATION}.svg"
  SPECIFIC_AWK_FLAGS=""
  SPECIFIC_PERL_FLAGS=""
  while [ ${#FLAGS_COMBINATION} -gt 0 ]; do
    REMAINING=${FLAGS_COMBINATION#?}
    CHAR="${FLAGS_COMBINATION%$REMAINING}"
    if [ "${CHAR}" = "c" ]; then
      SPECIFIC_AWK_FLAGS="-v onlyCommonThreads=true ${SPECIFIC_AWK_FLAGS}"
    elif [ "${CHAR}" = "i" ]; then
      SPECIFIC_AWK_FLAGS="-v ignoreidle=true ${SPECIFIC_AWK_FLAGS}"
    elif [ "${CHAR}" = "l" ]; then
      SPECIFIC_PERL_FLAGS="--inverted ${SPECIFIC_PERL_FLAGS}"
    elif [ "${CHAR}" = "n" ]; then
      SPECIFIC_AWK_FLAGS="-v nativeStacksForJavaThreads=true ${SPECIFIC_AWK_FLAGS}"
    elif [ "${CHAR}" = "r" ]; then
      SPECIFIC_AWK_FLAGS="-v trim=true ${SPECIFIC_AWK_FLAGS}"
    elif [ "${CHAR}" = "s" ]; then
      SPECIFIC_AWK_FLAGS="-v groupByThreadState=true ${SPECIFIC_AWK_FLAGS}"
    elif [ "${CHAR}" = "t" ]; then
      SPECIFIC_AWK_FLAGS="-v inverted=true ${SPECIFIC_AWK_FLAGS}"
    fi
    FLAGS_COMBINATION=$REMAINING
  done
  
  echo "[$(date)] [${GRAPH_COUNT} / ${TOTAL_GRAPHS}] Creating ${NAME} with awk flags ${SPECIFIC_AWK_FLAGS} ${EXTRA_AWK_FLAGS} and perl flags ${SPECIFIC_PERL_FLAGS} ${COMMON_FLAMEGRAPH_OPTIONS}"

  if [ "${ONLYFLAGS}" = "" ] || [ "${ONLYFLAGS}" = "${ORIGINAL_FLAGS_COMBINATION}" ]; then

    "${SCRIPTDIR}/flamegraph.awk" ${SPECIFIC_AWK_FLAGS} ${EXTRA_AWK_FLAGS} "${@}" | \
      "${SCRIPTDIR}/flamegraph.pl" --title="${NAME}" ${SPECIFIC_PERL_FLAGS} ${COMMON_FLAMEGRAPH_OPTIONS} > "${NAME}"
    RC=$?

    echo "[$(date)] [${GRAPH_COUNT} / ${TOTAL_GRAPHS}] Completed with RC=${RC}"
    if [ "${RC}" = "0" ]; then
      chmod a+rw "${NAME}"
      SOME_SUCCESSFUL=1
    elif [ "${RC}" = "2" ]; then
      # No stacks found which might be okay, unless all have no stacks found which will be checked below

      # Update the error message
      cat "${NAME}" | sed 's/<text.*>ERROR: No valid input provided to flamegraph.pl./<text x="24" y="24" >WARNING: No stacks found. Consider changing "Options" checkboxes on the left; most commonly, uncheck "Only common thread pools" to review if activity is on other thread pools./g' > "${NAME}.new"
      mv "${NAME}.new" "${NAME}"

      RC=0
      chmod a+rw "${NAME}" >/dev/null 2>&1
    else
      rm "${NAME}"
    fi
  else
    echo "[$(date)] [${GRAPH_COUNT} / ${TOTAL_GRAPHS}] Skipping because of -o ${ONLYFLAGS}"
  fi
done << EOF
${COMBINATIONS}
EOF

if [ "${SOME_SUCCESSFUL}" = "1" ]; then
  RC=0
else
  echo "[$(date)] ERROR: No stacks were found in any of the input files" 2>&1
  RC=64
fi

OUTPUT="${OUTPUT_DIRECTORY}/flamegraph_list.html"

# NOTE: EOF does not have single quotes around it which means that variable expansion
#       using $ within the HTML will be performed!
cat > "${OUTPUT}" << EOF
  <!DOCTYPE html>
  <html lang="en">
    <head>
      <title>Flame Graphs</title>
      <meta charset="UTF-8">
      <meta name="theme-color" content="#ffffff">
      <meta name="viewport" content="width=device-width, initial-scale=1">
      <meta name="description" content="Flame graphs">
      <style type="text/css">
        * {
          box-sizing: border-box;
        }

        body {
          margin: 0;
          padding: 0;
          font-size: 18px;
          color: #444;
          height: 100vh;
          width: 100vw;
        }

        h1, h2, h3, h4, h5, h6, ol {
          margin-top: 0;
        }
        
        iframe {
          flex: 1;
          width: 100%;
        }

        main {
          display: grid;
          grid-template-columns: 300px 1fr;
          height: 100vh;
        }

        .sidebar {
          overflow: auto;
          padding: 10px;
          padding-right: 15px;
        }

        h1 {
          font-size: 20px;
        }

        h2 {
          font-size: 18px;
        }

        h3 {
          font-size: 16px;
        }

        .category {
          font-style: italic;
        }

        .help {
          cursor: help;
          font-size: smaller;
        }

        .bold {
          font-weight: bold;
        }

        hr {
          margin-top: 10px;
          margin-bottom: 20px;
        }

        .checkbox {
          padding-bottom: 10px;
        }

        ol, ul {
            padding-left: 20px;
        }

        .rightcontent {
          display: flex;
          flex-direction: column;
        }

        #rightheader {
          padding: 0;
          margin: 0;
          padding-left: 10px;
          font-size: small;
          width: 100%;
          background-color: #f7f7f7;
        }
      </style>
      <script>
        function changeFlameGraph(newFlameGraphSource) {
          var iframe = document.getElementById("flameiframe");
          var container = iframe.parentElement;
          container.removeChild(iframe);
          iframe.setAttribute('src', newFlameGraphSource);
          container.appendChild(iframe);

          var rightheader = document.getElementById("rightheader");
          rightheader.innerHTML = "<a href='" + newFlameGraphSource + "' target='_blank'>" + newFlameGraphSource + "</a>";
        }

        function frameLoaded(iframe) {
          try {
            if (!document.getElementById("icicle").checked) {
              iframe.contentWindow.scrollTo(0, 999999);
            }
          } catch (e) {
            console.log(e);
          }
        }

        function processCheckboxStates() {
          var flags = "";
          if (document.getElementById("commonthreads").checked) {
            flags += "c";
          }
          if (document.getElementById("ignoreidle").checked) {
            flags += "i";
          }
          if (document.getElementById("icicle").checked) {
            flags += "l";
          }
          if (document.getElementById("nativestacks") && document.getElementById("nativestacks").checked) {
            flags += "n";
          }
          if (document.getElementById("trim").checked) {
            flags += "r";
          }
          if (document.getElementById("groupbystate").checked) {
            flags += "s";
          }
          if (document.getElementById("fromtop").checked) {
            flags += "t";
          }
          window.location.assign("#" + flags);
        }

        window.addEventListener("load", (event) => {
          if (window.location.hash == "") {
            processCheckboxStates();
          } else {
            processHash();
          }
        });

        function processHash() {
          var flags = window.location.hash.substring(1);
          document.getElementById("commonthreads").checked = flags.includes('c');
          document.getElementById("ignoreidle").checked = flags.includes('i');
          document.getElementById("icicle").checked = flags.includes('l');
          if (document.getElementById("nativestacks")) {
            document.getElementById("nativestacks").checked = flags.includes('n');
          }
          document.getElementById("trim").checked = flags.includes('r');
          document.getElementById("groupbystate").checked = flags.includes('s');
          document.getElementById("fromtop").checked = flags.includes('t');
          changeFlameGraph("flamegraph_options_" + flags + ".svg");
        }

        window.addEventListener("popstate", (event) => {
          processHash();
        });
      </script>
    </head>
    <body>
      <main>
        <div class="sidebar">
          <h1>Flame Graphs</h1>

          <hr />

          <h2>Options</h2>

          <div class="checkbox">
            <input type="checkbox" id="fromtop" name="fromtop" onchange="processCheckboxStates()" checked />
            <label for="fromtop">Stacks grouped from top</label>
          </div>

          <div class="checkbox">
            <input type="checkbox" id="commonthreads" name="commonthreads" onchange="processCheckboxStates()" checked />
            <label for="commonthreads">Only common thread pools <span class="help" title="Default Executor, WebContainer, SIBJMSRAThreadPool, MessageListenerThreadPool, ORB.thread.pool, WebSphere WLM Dispatch Thread, WorkManager, WMQJCAResourceAdapter, XIO">ⓘ</span></label>
          </div>

          <div class="checkbox">
            <input type="checkbox" id="ignoreidle" name="ignoreidle" onchange="processCheckboxStates()" checked />
            <label for="ignoreidle">Only non-idle Threads <span class="help" title="Idle meaning not doing any real work. Waiting on a response from a database or web service is idle in a sense but not in this sense. Idle stacks are based on well-known idle stacks and experimentally determined as likely idle. If you find idle stacks reported as non-idle, report it to the tool owner as an enhancement.">ⓘ</span></label>
          </div>

          <div class="checkbox">
            <input type="checkbox" id="groupbystate" name="groupbystate" onchange="processCheckboxStates()" checked />
            <label for="groupbystate">Group by thread state</label>
          </div>

          <div class="checkbox">
            <input type="checkbox" id="trim" name="trim" onchange="processCheckboxStates()" />
            <label for="trim">Trim names</label>
          </div>

          <div class="checkbox">
            <input type="checkbox" id="icicle" name="icicle" onchange="processCheckboxStates()" checked />
            <label for="icicle">Icicle</label>
          </div>

          <!--
          <div class="checkbox">
            <input type="checkbox" id="nativestacks" name="nativestacks" onchange="processCheckboxStates()" />
            <label for="nativestacks">Native stacks</label>
          </div>
          -->

          <hr />

          <h2>Help</h2>

          <p>Flame graphs visualize stack frame frequency over the x-axis</p>

          <h3>Tips</h3>

          <ol>
            <li>Hover over a stack frame to get the number and percent of all samples</li>
            <li>Click any stack frame to zoom in</li>
            <li>Click a higher stack frame to zoom out</li>
            <li>Right click a stack frame to get text you can copy</li>
            <li>Click 'Search' in the top right to highlight</li>
            <li>Toggle 'ic' next to 'Search' for case insensitive search</li>
          </ol>
        </div>
        <div class="rightcontent">
          <p id="rightheader"></p>
          <iframe id="flameiframe" frameborder="0" src="data:text/html,&lt;p&gt;Loading...&lt;/p&gt;" onload="frameLoaded(this)"></iframe>
        </div>
      </main>
    </body>
  </html>
EOF

chmod a+rw "${OUTPUT}"

MYDIR="$(pwd)"
if [ "${MYDIR#*ecurep}" != "${MYDIR}" ]; then
  echo "https://ecurep.mainz.de.ibm.com/rest/download/$(pwd | sed 's/^\/ecurep\/sf\/TS...\/...\///g')/${OUTPUT}"
else
  case "$OSTYPE" in
    linux*)
      xdg-open "file://${MYDIR}/${OUTPUT}" 2>/dev/null
      ;; 
    darwin*)
      open "file://${MYDIR}/${OUTPUT}"
      ;; 
  esac
fi

echo "[$(date)] $(basename "${0}") finished with RC=${RC}"

exit $RC
