#!/bin/bash
######################################################################
# Represent entered number as a product of prime numbers, up to the
# order of factors. For example, N = 1164 = 2 * 2 * 3 * 97
######################################################################

# TODO(yar83): Add description to all functions
# TODO(yar83): Add check whether bc is installed

set -o nounset
set -o errexit

######################################################################
# Check whether script is ran with valid arguments that can be only
# one positive integer number or -h || --help stiring.
# Globals:
#   none
# Arguments:
#   $@ as all arguments passed during script run
# Outputs:
#   Prints to stdout error message if $@ is not valid data and exit
#   or pass by execution to next expression of main.
######################################################################
input_check() {
  if [[ ! (${#@} -eq 1 && $1 == '-h' || $1 == '--help' || $1 =~ ^[1-9]{1}[0-9]{,9}$) ]]; then
    echo "Valid input is one integer number greater than 0 or -h or --help for help"
    exit 1
  fi
}

######################################################################
# Prints help if script run with corresponding arguments
# Globals:
#   none
# Arguments: 
#   none
# Outputs:
#   Ptints to stdout help message and exit.
######################################################################
print_help() {
  printf "%s\n%s\n%s\n%s\n",\
    "Represent entered number as a product of prime numbers, up to the"\
    "order of factors. For example, N = 1164 = 2 * 2 * 3 * 97."\
    "Use $./prime_numbers.sh 1164 for normal mode or with options"\
    "-h, --help to dispaly this help and exit."
}

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
  input_check "$@"
  case "$1" in
    -h | --help ) print_help;;
    * ) print_primes "$1";;
  esac
}

main "$@"
