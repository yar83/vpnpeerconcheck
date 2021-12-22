#!/bin/bash
######################################################################
# Represent entered number as a product of prime numbers, up to the
# order of factors. For example, N = 1164 = 2 * 2 * 3 * 97
######################################################################

# TODO(yar83): add help
# TODO(yar83): add argument parser to parse -h or --help to print help
# TODO(yar83): prove entered whether -h/--help or one integer number

main() {
  if [[ ${#@} -ne 1 || ! ($1 =~ ^[1-9]{1}[0-9]{,9}$) ]]; then
    echo "Valid input is one integer number greater than 0"
    exit 1
  fi
}

main "$@"
