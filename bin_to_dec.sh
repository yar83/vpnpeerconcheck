#!/bin/bash
######################################################################
# Convert binary number to decimal 
######################################################################

set -o nounset
set -o errexit

main() {
  len=${#1}
  out=0
  for ((i=0; i < $len; i++)); do
    out=$((out + $((${1:$((len-len+i)):1} * 2 ** $((len-i-1))))))
  done
  echo "$out"
}

main "$@"
