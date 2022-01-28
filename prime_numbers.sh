#!/bin/bash

######################################################################
# Find prime numbers up to given script argument number with Sieve of
# Eratosthenes algorithm
#####################################################################

set -o nounset
set -o errexit

######################################################################
# Validate argument got with script invocation. Only one positive
# integer is allowed or one -h || --help string.
# Globals:
#   none
# Arguments: 
#   $@ as all argument passed with script
# Outputs:
#   return 1 || 0 depend on check's result
######################################################################
check_input() {
  valid_number_arg='^[1-9]{1}[0-9]{0,9}$'
  valid_help_arg='(^-h$)|(^--help$)'
  if [[ $# -eq 1 ]] && [[ $1 =~ $valid_number_arg || $1 =~ $valid_help_arg ]]; then
    return 0
  fi
  return 1
}

print_error() {
  printf "%s\n" "Only one positive integer as upper limit of numbers is valid or -h or --help for help"
}

print_help() {
  printf "%s\n%s\n%s\n",\
    "Find prime numbers up to script argument number"\
    "Use $./prime_numbers.sh 123456 for normal use or enter arguments"\
    "-h, --help to dispaly this help and exit."
}

main() {
  check_input "$@" || { print_error; exit 1; }
  echo "good $@"
}

main "$@"
