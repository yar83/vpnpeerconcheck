#!/bin/bash 

GROUP_ID="your_group_ip"
BOT_TOKEN="your_bot_token"

if [[ "$1" = -h ]]; then
  printf '%s\n' "Usage: $(basename "$0") \"message text\""
  exit 0
fi

if [[ -z $1 ]]; then
  printf '%s\n' "Enter message text as second argument"
  exit 1
fi

if [[ "$#" -ne 1 ]]; then
  printf '%s\n' "No more than one argument can be passed. Use quotes for strings with spaces. Enter -h for help"
  exit 2
fi

curl -s --data "text=$1" --data "chat_id=$GROUP_ID" "https://api.telegram.org/bot$BOT_TOKEN/sendMessage" > /dev/null
