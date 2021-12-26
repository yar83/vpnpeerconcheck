#!/bin/bash
######################################################################
# Represent entered number as a product of prime numbers, up to the
# order of factors. For example, N = 1164 = 2 * 2 * 3 * 97
######################################################################

# TODO(yar83): Add check whether bc is installed
# TODO(yar83): Find limit of valid integer to pass as arg

set -o nounset
set -o errexit

######################################################################
# Check whether script is ran with valid arguments that can be only
# one positive integer number or -h || --help string.
# Globals:
#   none
# Arguments:
#   $@ as all arguments passed during script run
# Outputs:
#   Prints to stdout error message if $@ is not valid data and exit
#   or pass by execution to next expression of main.
######################################################################
check_input() {
  valid_arg_pattern='(^-h$)|(^--help$)|(^[1-9]{1}[0-9]{,9}$)'
  if [[ $# -eq 1 ]] && [[ $1 =~ $valid_arg_pattern ]]; then
    echo "true"
    exit 0
  else 
    echo "false"
    exit 1
  fi
}

######################################################################
# Prints help if script run with -h or --help argument
# Globals:
#   none
# Arguments: 
#   none
# Outputs:
#   Prints to stdout help message and exit.
######################################################################
print_help() {
  printf "%s\n%s\n%s\n%s\n",\
    "Represent entered number as a product of prime numbers, up to the"\
    "order of factors. For example, N = 1164 = 2 * 2 * 3 * 97."\
    "Use $./prime_numbers.sh 1164 for normal mode or with options"\
    "-h, --help to dispaly this help and exit."
}

######################################################################
# Decompose valid argument number to product of prime factor and print
# each factor consequently to stdout.
# Globals:
#   none
# Arguments: 
#   $1 - valid number got as script argument
# Outputs:
#   Print prime factors to stdout
######################################################################
print_primes() {
  bc <<< "
    num = $1;
    while (num % 2 == 0) {
      print 2, \" \";
      num = num / 2;
    }
    
    for (i=3; i<=sqrt(num); i = i + 2) {
      while (num % i == 0) {
        print i, \" \";
        num = num / i;
      }
    }

    if (num > 2) print num;
    
    print \"\n\";
  "
}

main() {
  if [[ $(check_input "$@") == "false" ]]; then
    echo "Valid input is one integer number greater than 0 or -h or --help for help"
    exit 1
  fi

  case "$1" in
    -h | --help ) print_help;;
    * ) print_primes "$1";;
  esac
  exit 0
}

main "$@"