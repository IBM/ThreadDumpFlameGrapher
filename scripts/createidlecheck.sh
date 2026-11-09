#!/bin/sh
SCRIPTDIR="$(dirname -- "$0")"

awk '{ x = $0; gsub(/\(.*/, "", x); lines[NR] = x; } END { printf("        doStacksMatch(compressedStack, \""); for (i = NR; i >= 1; i--) { if (i == 1) { printf("%s", lines[i]); } else { printf("%s;", lines[i]); } } printf("\") ||\n"); }' "${SCRIPTDIR}/input.txt"
