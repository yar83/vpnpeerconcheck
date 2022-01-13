#!/bin/bash
######################################################################
# Find least common multiple of two integers
######################################################################

set -o nounset
set -o errexit

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

get_lcm() {
  local -i a="$1"
  local -i b="$2"

  echo "$1 $2"
}

main() {
  check_input "$@" || { echo "error"; exit 1; }
  get_lcm "$1" "$2"
}

main "$@"
