#!/bin/bash

set -o nounset
set -o errexit
set -e -o pipefail

#--- script flags start ---#
VERBOSE="" # verbose mode
#--- script flags end ---#

PARAMS=""
LOGFILE=/etc/wireguard/peersconnection.log
LAST_IPS_LIST_ACCESS=""
SELF="" # path to script file
SELFPATH="" # path to script's folder

#--- Constants start ---#
readonly PINGCOUNT=1
readonly PINGTIMEOUT=2
readonly MAX_OFFLINE_PERIOD=60 # maximum host offline time in seconds before sending a warning message
readonly E_WRONG_ARGS=95 # Wrong arguments error
#--- Constants end ---#

declare -A IPNAMEs IPs IPs_off

######################################################################
# Parse options set with script invocation
# Globals:
#   PARAMS
#   VERBOSE
#	  LOGFILE  - path to log file
# Arguments:
#	  $1 -- string with all options separated by one space
# Outputs:
#   if got -v option print message that verbose mode on
# Returns:
#	  None
######################################################################
get_options() {
  while (( $# )); do
    case $1 in
      -h | --help)
        print_help
        ;;
      -v | --verbose)
        VERBOSE=0
        PARAMS="$PARAMS $1"
        shift
        printf "%s\n" "Verbose mode on"
        ;;
      -c | --colored)
        # COLOREDOUT=0
        PARAMS="$PARAMS $1"
        shift
        printf "%s\n" "Colored output mode on"
        ;;
      -l=* | --log=*)
        if [[ -n ${1##*=} ]] ; then
          LOGFILE=${1##*=}
          PARAMS="$PARAMS $1"
          shift
        else
          printf "%s\n" "Error: no path to log file"
          exit 1
        fi
        ;;
      --* | -*)
        printf "%s\n" "Error: unsupported flag $1 Try '$0 -h' or '$0 --help' to print help" >&2
        exit 1
        ;;
      *) 
        printf "%s\n" "Error: invalid option -- '$1'. Try '$0 -h' or '$0 --help' to print help" >&2
        exit 1
        ;;
    esac
  done
  eval set -- "$PARAMS"
}

print_help() {
	printf "%s\n" "Continuously check connection with VPN hosts and write connection issues to log file"
	printf "\n"
	printf "%s\n" "Options:"
	printf "%s\t\t\t%s\n" "-h, --help" "display this help and exit"
	printf "%s\t\t\t%s\n" "-v, --verbose" "verbose output to standard output"
	printf "%s\t\t\t%s\n" "-c, --colored" "colored ouput"
	printf "%s\t%s\n" "-l=, --log=path_to_log_file" "print connection details to the given log file"
	exit 0
}

######################################################################
# Stop script execution with error message
######################################################################
die() {
  echo "$*" >&2
  exit "$E_WRONG_ARGS"
}


######################################################################
# Parse IP addresses and host names from ip-addresses.list file.
# Form associated array IPNAMEs where keys equal to IP addresses
# and values equal to hosts' names.
######################################################################
parse_ips_list() {
  if [[ -e "$SELFPATH"ip-addresses.list ]]; then
    LAST_IPS_LIST_ACCESS=$(stat -c "%Y" "$SELFPATH"ip-addresses.list)
    while read -r line; do
      if [[ $line =~ ^(#)*[[:space:]]*(([0-9]{1,3}\.){3}[0-9]{1,3})[[:space:]]*([[:alnum:]]*) ]]; then
        if [[ ${BASH_REMATCH[1]} != "#" ]]; then
          [[ ${BASH_REMATCH[4]} == "" ]] && BASH_REMATCH[4]="noname"
          IPNAMEs["${BASH_REMATCH[2]}"]="${BASH_REMATCH[4]}"
        fi
      fi
    done < "$SELFPATH"ip-addresses.list
  else
    die "There is no IP addresses list file" "$E_WRONG_ARGS"
  fi
}

######################################################################
# Write '__________ New day: $(date "+%d.%m.%Y %H:%M") _________' to logfile
# each midnight to visually separate log data one day from another.
# Globals:
#	  LOGFILE  - path to the log file
# Arguments:
#	  None
# Outputs:
#	  Writes formated string to LOGFILE
# Returns:
#	  None
######################################################################
next_day_stamp() {
	if (( $(date --date="$today" "+%s") < $(date --date="$(date "+%D")" "+%s") )) ; then
		echo "__________ New day: $(date "+%d.%m.%Y %H:%M") _________" >> "$LOGFILE"
		today=$(date "+%D")
    "$SELFPATH"send_msg_telegram.sh "Script is working properly $(date "+%d.%m.%Y %H:%M:%S")"
	fi
}

######################################################################
# Set initial state 'online/offline' of each host 
# Globals:
#	  PINGCOUNT 
#   PINGTIMEOUT
#   LOGFILE
#   VERBOSE
#   IPs -- associated array of all IPs. Values of keys modified during function execution.
# Arguments:
#	  $1 as current ip addr to connection check
# Outputs:
#   If VERBOSE flag is on print current IP's initial connection status 'online/offline'
# Returns:
#	  None
######################################################################
set_init_state() {
  if /bin/ping -c${PINGCOUNT} -w${PINGTIMEOUT} "$1" > /dev/null; then
    IPs[$1]="on"
    echo "Host ${IPNAMEs[$1]} ($1) initial state is online $(date +"%d.%m.%Y %H:%M:%S")" >> "$LOGFILE"
    if [[ $VERBOSE ]] ; then
      printf "%s\n" "Host ${IPNAMEs[$1]} ($1) initial state is online"
    fi
  else
    IPs[$1]="off"
    echo "Host ${IPNAMEs[$1]} ($1) initial state is offline $(date +"%d.%m.%Y %H:%M:%S")" >> "$LOGFILE"
    if [[ $VERBOSE ]] ; then
      printf "%s\n" "Host ${IPNAMEs[$1]} ($1) initial state is offline"
    fi
  fi
}

######################################################################
# Briefly: check current IP addr connection. If IP is on and was on do
# nothing just notice if VERBOSE flag is on, if IP was offline check
# whether warning message was sent, if message was sent, send message
# of IP's back from long offline. If IP is off and was off, check
# whether long time offline period expired, if expired send warning
# message, if not expired do nothing, just notice if VERBOSE flag is on.
# Globals:
#	  PINGCOUNT 
#   PINGTIMEOUT
#   LOGFILE
#   VERBOSE
#   IPs -- associated array of all IPs. Values of keys modified during
#     function execution.
#   IPs_off -- associated array of all IPs currently being offline
#     before max long time offline period is expired.
# Arguments:
#	  $1 as current ip addr to connection check
# Outputs:
#   If VERBOSE flag is on print corresponding information
# Returns:
#	  None
######################################################################
check_con() {
  if /bin/ping -c${PINGCOUNT} -w${PINGTIMEOUT} "$1" > /dev/null; then
    if [[ ${IPs[$1]} = off ]]; then
      # Set current IP as being online
      IPs[$1]="on"  
      if [[ $VERBOSE ]]; then
        printf "%s\n" "Host ${IPNAMEs[$1]} ($1) now online, was offline"
      fi
      # If $1 unset in IPs_off array that means that it's been deleted after long time offline check.
      # If $1 is present in IPs_off array that means that max offline time not expired and $1 is being deleted now.
      if [[ -z ${IPs_off[$1]:-} ]]; then
        if [[ $VERBOSE ]]; then
          printf "%s\n" "Host ${IPNAMEs[$1]} ($1) now online. Was offline more than $MAX_OFFLINE_PERIOD seconds"
        fi
        if [[ -x "$SELFPATH"send_msg_telegram.sh ]]; then
          "$SELFPATH"send_msg_telegram.sh "Host ${IPNAMEs[$1]} ($1) now online. Was offline more than $MAX_OFFLINE_PERIOD seconds"
        else
          printf "%s\n" "No sending message script" >&2
        fi
      else
        unset "IPs_off[$1]"
      fi
      echo "Host ${IPNAMEs[$1]} ($1) is online from offline $(date +"%d.%m.%Y %H:%M:%S")" >> "$LOGFILE"
    else
      if [[ $VERBOSE ]]; then
        printf "%s\n" "Host ${IPNAMEs[$1]} ($1) is still online"
      fi
    fi
  else
    if [[ ${IPs[$1]} = on ]]; then
      # add current ip to an array of newly found offline IPs
      IPs_off+=(["$1"]="$(date +%c)")
      # Set current IP as being offline
      IPs[$1]="off"
      if [[ $VERBOSE ]]; then
        printf "%s\n" "${IPNAMEs[$1]} ($1) now offline, was online"
      fi
      echo "Host ${IPNAMEs[$1]} ($1) is offline from online $(date +"%d.%m.%Y %H:%M:%S")" >> "$LOGFILE"
    else
      if [[ $VERBOSE ]]; then
        printf "%s\n" "Host ${IPNAMEs[$1]} ($1) is still offline"
      fi
      # check offline timeout period
      if [[ -n ${IPs_off[$1]:-} && $(( $(date +%s) - $(date --date="${IPs_off[$1]}" +%s) )) -ge $MAX_OFFLINE_PERIOD ]]; then
        unset "IPs_off[$1]"
        if [[ $VERBOSE ]]; then
          printf "%s\n" "Host ${IPNAMEs[$1]} ($1) offline more than $MAX_OFFLINE_PERIOD seconds"
        fi
        if [[ -x "$SELFPATH"send_msg_telegram.sh ]]; then
          "$SELFPATH"send_msg_telegram.sh "Host ${IPNAMEs[$1]} ($1) offline more than $MAX_OFFLINE_PERIOD seconds"
        else
          printf "%s\n" "No sending message script" >&2
        fi
      fi
    fi
  fi 
}

set_actual_ips() {
  for ip_addr in "${!IPNAMEs[@]}"; do
    IPs["$ip_addr"]="on"
  done

  # set initial status of each IP addr
  for ip in "${!IPs[@]}"; do
    set_init_state $ip
  done
}

main() {
  local ip start_date
  start_date=$(date '+%d.%m.%Y %H:%M:%S')

  SELF="$(readlink -f "${BASH_SOURCE[0]}")"
  SELFPATH="${SELF%/*}/"

  get_options "$@"
  echo "<------Script started $start_date ----->" >> "$LOGFILE"
  "$SELFPATH"send_msg_telegram.sh "Monitoring started at $(date '+%d.%m.%Y %H:%M:%S')"
  today=$(date +%D)
  if [[ $VERBOSE ]]; then
    printf "%s\n" "Log file path is $LOGFILE"
  fi

  parse_ips_list
  set_actual_ips

  while :; do
    if [[ $LAST_IPS_LIST_ACCESS != $(stat -c "%Y" "$SELFPATH"ip-addresses.list) ]]; then
      echo "IP addresses list was changed since last access"
      echo "IP addresses list was changed since last access $(date '+%d.%m.%Y %H:%M:%S')" >> peersconnection.log
      parse_ips_list
      "$SELFPATH"send_msg_telegram.sh "IP list was changed since last access. New list loaded."
      set_actual_ips
    fi
    next_day_stamp
    for ip in "${!IPs[@]}"; do
      check_con $ip
    done
  done
}

main "$@"
