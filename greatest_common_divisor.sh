#!/bin/bash
######################################################################
# Find greatest common divisor of two integers using Euclidean 
# algorithm
######################################################################

set -o nounset
set -o errexit

######################################################################
# Validate arguments got with script invocation. Only two integers
# are allowed or one -h || --help string.
# Globals:
#   none
# Arguments:
#   $@ as all agrument passed with script
# Outputs:
#   return 1 || 0 depend of check's result
######################################################################
check_input() {
  valid_number_arg='^[1-9]{1}[0-9]{0,9}$'
  valid_help_arg='(^-h$)|(^--help$)'
  if [[ $# -eq 2 ]] && [[ $1 =~ $valid_number_arg ]] && [[ $2 =~ $valid_number_arg ]]; then
    return 0
  fi

  if [[ $# -eq 1 ]] && [[ $1 =~ $valid_help_arg ]]; then
    return 0
  fi

  return 1
}

print_help() {
  printf "%s\n%s\n%s\n",\
    "Find greatest common divisor of two integers"\
    "Use $./greatest_common_divisor.sh 123 456 for normal use or enter arguments"\
    "-h, --help to dispaly this help and exit."
}

print_error() {
  echo "Valid input is two integer numbers greater than 0 or -h or --help for help"
}

get_gcd() {
  local -i a="$1"
  local -i b="$2"

  while [[ $a -ne 0 ]] && [[ $b -ne 0 ]]; do
    if [[ $a -gt b ]]; then
      a=$(($a%$b))
    else
      b=$(($b%$a))
    fi
  done 
  echo $((a+b))
}

main() {
  local -i gcd=1
  check_input "$@" || { print_error; exit 1; }

  case "$1" in
    -h | --help ) print_help; exit 0;;
    * ) gcd="$(get_gcd "$1" "$2")";;
  esac
  echo "$gcd"
}

main "$@"
