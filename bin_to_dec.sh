#!/bin/bash
######################################################################
# Convert binary number to decimal 
######################################################################

set -o nounset
set -o errexit

######################################################################
# Validate script argument. It's valid if it's a interger decimal
# number or -h or --help string.
# Globals:
#   none
# Arguments:
#   $@ as all arguments passed to script
# Outputs:
#   return 0 when argument is valid otherwise 1
######################################################################
input_check() {
  if [[ ${#@} -eq 1 ]] && [[ $1 =~ (^-h$)|(^--help$)|(^1{1}[0-1]{0,19}$) ]]; then
    return 0
  else
    return 1
  fi
}

print_error() {
  printf "Valid input is one positive binary number or -h or --help for help\n"
}

######################################################################
# Print help if script run with -h or --help argument
# Globals:
#   none
# Arguments: 
#   none
# Outputs:
#   Print to stdout help message and exit.
######################################################################
print_help() {
  printf "%s\n%s\n%s\n",\
    "Convert entered number from binary to decimal."\
    "Use $./dec_to_bin.sh 111101010101 for normal use or enter arguments"\
    "-h, --help to dispaly this help and exit."
}

######################################################################
# Get decimal number from converted binary.
# Globals:
#   None
# Arguments:
#   $1 as binary number
# Outputs:
#   Print decimal number to stdout
###################################################################### 
get_decimal() {
  len=${#1}
  out=0
  for ((i = 0; i < $len; i++)); do
    out=$((out + $((${1:$((len-len+i)):1} * 2 ** $((len-i-1))))))
  done
  echo "$out"
}

main() {
  input_check "$@" || { print_error; exit 1; }
  
  get_decimal "$@"
}

main "$@"
