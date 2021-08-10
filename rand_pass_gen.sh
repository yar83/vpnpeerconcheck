#!/bin/bash
####################################################
# Generate a password string of 8 characters default
# length consists of minimum one digit, one lower and
# one upper case letter. Other number of letters 
# randomly generated. User can add integer number
# argument to the script betwen 6 and 30 to point out
# desired password length.
####################################################

# TODO(yar83): add help
# TODO(yar83): add argument parser to parse -h or
# --help as command to pring help

set -o errexit
set -o nounset

RANDOM=""

declare -i def_length=6

####################################################
# Generate a random string of 8 characters default
# length or length provided with first script argument
# Password strign contains minimum one digit, one lower 
# and one uppercase letter.
# Globals:
#   Target string $RANDOM
# Arguments:
#    String length got as the script argument
# Outputs:
#    An eight or passed number characters length string 
#    contains minimum one digit, one lower and one 
#    uppercase letter.
####################################################
function generate_string() {
  local -r numbers='0123456789'
  local -r lows='abcdefghijklmnopqrstuvwxyz'
  local -r caps='ABCDEFGHIJKLMNOPQRSTUVWXYZ'
  local -r specials='!@#$%^&*?'
  local -r all='0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'

  if [[ ${#@} -eq 1 ]]; then 
    def_length="$1"
  fi

  {
    echo "${numbers:RANDOM%${#numbers}:1}"
    echo "${lows:RANDOM%${#lows}:1}"
    echo "${caps:RANDOM%${#caps}:1}"
    echo "${specials:RANDOM%${#specials}:1}"
    
    
    for ((i=0; i < (def_length - 4); i++)); do
      echo "${all:RANDOM%${#all}:1}"
    done
  } | sort -R | awk '{printf "%s",$1}'
}

####################################################
# Check whether the current script first argument
# is integer number between 6 and 30. 
# Globals:
#   None
# Arguments:
#   First script argument as $1 
# Outputs:
#   Return "true" or "false" as a result of checking 
####################################################
function is_first_arg_valid() {
  if [[ $1 =~ ^[6-9]|[1-2][0-9]|30$ ]]; then
    echo "true"
  else 
    echo "false"
  fi
}

function main() {
  if [[ ${#@} -eq 0 ]]; then 
    generate_string
    exit 0
  fi

  if [[ $(is_first_arg_valid "$1") =~ "true" ]]; then
    generate_string "$1"
    exit 0
  else
    printf '%s\n' "Length argument must be a number from 6 to 30"
    exit 1
  fi
}

main "$@"
