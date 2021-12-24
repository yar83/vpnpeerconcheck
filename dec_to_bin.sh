#!/bin/bash
######################################################################
# Convert decimal number to binary
######################################################################

set -o nounset
set -o errexit

# print_help()
# print_bits()


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
  if [[ !(${#@} -eq 1 && $1 == '-h' || $1 == '--help' || $1 =~ ^[1-9]{1}[0-9]{,9}$) ]]; then
    echo "false"
  else
    echo "true"
  fi
}

print_error() {
    echo "Valid input is one integer number greater than 0 or -h or --help for help"
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
  printf "%s\n%s\n%s\n",\
    "Convert entered number from decimal to binary."\
    "Use $./dec_to_bin.sh 24235 for normal use or enter arguments"\
    "-h, --help to dispaly this help and exit."
}

print_bits() {
  bc <<< "
    num = $1;
    bits = 1;
    # print num, \"\n\";
    while (num > 1) {
      if (num % 2 == 0) {
        bits = bits * 10 + 0;
      } else {
        bits = bits * 10 + 1;
      }
      scale=0;
      num = num / 2;
      print \"num=\", num, \"\n\", bits, \"\n\";
    }
  "
}

main() {
  if [[ $(is_valid_input $@) == "false" ]]; then
    print_error
    exit 1
  fi

  case "$1" in
    -h | --help ) print_help;;
    * ) print_bits "$1";;
  esac
  
  exit 0
}

main "$@"
