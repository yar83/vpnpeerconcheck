#!/bin/bash
######################################################################
# Find least common multiple of two integers
#
# The solution is based on formula LCM(a, b) = (a * b) / GCD(a, b)
######################################################################

# TODO(yar83): add print_help function

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

get_lcm() {
  local -i gcd=1
  local -i a="$1"
  local -i b="$2"

  gcd=$(get_gcd "$a" "$b") 
  echo $(($a*$b/$gcd))
}

main() {
  check_input "$@" || { print_error; exit 1; }
  lcm=$(get_lcm "$1" "$2")
  echo "$lcm"
}

main "$@"
