#!/bin/bash

######################################################################
# Find prime numbers up to given script argument number with Sieve of
# Eratosthenes algorithm
#####################################################################

set -o nounset
set -o errexit

main() {
  echo "$@"
}

main "$@"
