#!/bin/sh -x

SCRIPTDIR=$(dirname "$0")

"${SCRIPTDIR}/../flamegraph.sh" "${SCRIPTDIR}"/javacore*txt
"${SCRIPTDIR}/../flamegraph.awk" "${SCRIPTDIR}"/javacore*txt | "${SCRIPTDIR}/../flamegraph.pl" | grep -F "WebContainer : X (22 samples" >/dev/null

if [ $? -eq 0 ]; then
  echo "OK (`pwd`)"
else
  echo "FAIL (`pwd`)"
  exit 1
fi

exit 0
