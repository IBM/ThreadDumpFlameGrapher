#!/usr/bin/awk -f
# Copyright IBM Corporation. All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

function uniqueCombinations(permutationAddition, str, choose, skip) {
  for (j = 1; j <= length(str) && j != skip; j++) {
    permutation = substr(str, j, 1) permutationAddition;
    if (choose > 1) {
      permutation = uniqueCombinations(permutation, str, choose - 1, j);
    }
    if (permutation) {
      print permutation;
    }
  }
}

BEGIN {
  if (flags) {
    if (includenone) {
      print "";
    }

    for (i = 1; i < length(flags); i++) {
      uniqueCombinations("", flags, i);
    }

    # All items
    print flags;
    
  } else {
    printf("ERROR: -v flags=\"...\" missing\n") > "/dev/stderr";
  }
}
