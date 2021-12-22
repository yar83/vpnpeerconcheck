#!/bin/bash
######################################################################
# Represent entered number as a product of prime numbers, up to the
# order of factors. For example, N = 1164 = 2 * 2 * 3 * 97
######################################################################

# TODO(yar83): add help
# TODO(yar83): add argument parser to parse -h or --help to print help
# TODO(yar83): prove entered whether -h/--help or one integer number

input_check() {
  if [[ ! (${#@} -eq 1 && $1 == '-h' || $1 == '--help' || $1 =~ ^[1-9]{1}[0-9]{,9}$) ]]; then
    echo "Valid input is one integer number greater than 0 or -h or --help for help"
    exit 1
  fi
}

print_help() {
  printf "%s\n%s\n%s\n%s\n",\
    "Represent entered number as a product of prime numbers, up to the"\
    "order of factors. For example, N = 1164 = 2 * 2 * 3 * 97."\
    "Use $./prime_numbers.sh 1164 for normal mode or with options"\
    "-h, --help to dispaly this help and exit."
}

main() {
  input_check "$@"
  print_help
}

main "$@"
