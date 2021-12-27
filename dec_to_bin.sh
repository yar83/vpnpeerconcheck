#!/bin/bash
######################################################################
# Convert decimal number to binary
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
#   echoes 'true' or 'false'
######################################################################
is_valid_input() {
  if [[ $# -eq 1 ]] && [[ $1 == '-h' || $1 == '--help' || $1 =~ ^[1-9]{1}[0-9]{,9}$ ]]; then
    return 0
  else
    return 1
  fi
}

print_error() {
    echo "Valid input is one integer number greater than 0 or -h or --help for help"
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
    "Convert entered number from decimal to binary."\
    "Use $./dec_to_bin.sh 24235 for normal use or enter arguments"\
    "-h, --help to dispaly this help and exit."
}

######################################################################
# Get decimal number converted to binary in backwards state
# Globals: 
#   None
# Arguments:
#   $1 as decimal number
# Outputs
#   bits of converted number in backwars state
######################################################################
get_backwards_bits() {
  local -i num="$1"
  local bits_string=""
  while [ "$num" -gt 1 ]; do
    if [ $(( num % 2 )) -eq 1 ]; then
      bits_string=$bits_string$(echo -n "1")
    else
      bits_string=$bits_string$(echo -n "0")
    fi
    num=$((num / 2))
    if [ "$num" -eq 1 ]; then
      bits_string=$bits_string$(echo -n "1")
    fi
  done
  echo "$bits_string"
}

######################################################################
# Reverse bits of converted number
# Globals: 
#   None
# Arguments:
#   $1 as bits of cenverted number in backwards state
# Outputs
#   bits of converted number in proper order
######################################################################
reverse_bits() {
  local backwards_bits="$1"
  local -i backwards_bits_len=${#1};
  local bits=""
  for ((i = (backwards_bits_len - 1); i >= 0; i--)); do
    bits=$bits$(echo ${backwards_bits:i:1})
  done
  echo $bits
}

main() {
  is_valid_input $@ || { print_error; exit 1; }

  case "$1" in
    -h | --help ) print_help;;
    * ) echo $(reverse_bits $(get_backwards_bits "$1"));;
  esac
  
  exit 0
}

main "$@"
