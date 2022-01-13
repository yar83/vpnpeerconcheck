#!/bin/bash
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
  check_input "$@" || { echo "error"; exit 1; }
  gcd="$(get_gcd "$1" "$2")"
  echo "$gcd"
}

main "$@"
