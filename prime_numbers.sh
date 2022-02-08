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
  printf "%s\n%s\n%s\n"\
    "Find prime numbers up to script's argument number"\
    "Use $./prime_numbers.sh 123456 for normal use or enter arguments"\
    "-h, --help to dispaly this help and exit."
}

######################################################################
# Dialog with user to inform him about potentially too much
# consumption of computing time of primes with upper limit more than
# 10000 and getting his accept of reject to procceed
######################################################################
too_long_dialog() {
  local ans=''
  echo "Upper limit is too high. Computing may take too much time."
  while [[ !($ans =~ (^y$)|(^n$)) ]]; do
    read -p "Do you want to proceed? Enter y/n: " ans
    [[ !($ans =~ (^y$)|(^n$)) ]] && echo "Only 'y' or 'n' is acceptable"
  done
  if [[ $ans == "y" ]]; then 
    return 0
  fi
  return 1
}

######################################################################
# Get prime numbers up to limit got as script's argument using
# sieve of Eratosthenes algorithm.
# Globals:
#  none
# Arguments:
#   $1 as upper limit of natural numbrs row
# Output:
#   Formatted output of prime numbers
######################################################################
get_primes() {
  local -i upper_lim=$1
  local -a natural_nums
  echo "Upper limit is $upper_lim"
  
  # fill array with natural row numbers
  for (( i=0; i<$((upper_lim-1)); i++ )); do
    natural_nums[$i]=$((i+2))
  done
  
  # sieve mechanism 
  for (( i=0; i<$((upper_lim)); i++ )); do
    if [[ natural_nums[$i] -ne 0 ]]; then
      for (( j=$((i+natural_nums[$i])); j<$((upper_lim)); j+=natural_nums[$i] )); do
        natural_nums[$j]=0
      done
    fi
  done
  
  # formatted output of prime numbers
  local -i counter=0
  local -i num_len=${#upper_lim}
  for (( i=0; i<$((upper_lim)); i++ )); do
    if [[ natural_nums[i] -ne 0 ]]; then
      counter=$((counter+1))
      if [[ $((counter%20)) -eq 0 ]]; then
        printf "%${num_len}s\n" "${natural_nums[$i]}"
      else
        printf "%${num_len}s" "${natural_nums[$i]}"
      fi
    fi
  done
  echo ""
}

main() {
  check_input "$@" || { print_error; exit 1; }

  [[ $1 -gt 10 ]] && { too_long_dialog; }

  case "$1" in
    -h | --help ) print_help; exit 0;;
    * ) get_primes $1;;
  esac
}

main "$@"
