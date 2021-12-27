#!/bin/bash
######################################################################
# Convert binary number to decimal 
######################################################################

set -o nounset
set -o errexit

input_check() {
  if [[ ${#@} -eq 1 ]] && [[ $1 =~ (^-h$)|(^--help$)|(^1{1}[0-1]{0,19}$) ]]; then
    return 0
  else
    return 1
  fi
}

print_error() {
  printf "Valid input is one positive binary number\n"
}

main() {
  input_check "$@" || { print_error; exit 1; }

  len=${#1}
  out=0
  for ((i=0; i < $len; i++)); do
    out=$((out + $((${1:$((len-len+i)):1} * 2 ** $((len-i-1))))))
  done
  echo "$out"
}

main "$@"
