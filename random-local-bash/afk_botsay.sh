#!/usr/bin/env bash

# Check if the command line option is provided and valid
if [ "$1" == "fast" ] || [ "$1" == "slow" ] || [ "$1" == "ultra" ]; then
  interval_option="$1"
else
  interval_option="slow"
fi

# Read messages from positive_messages.json
json_file="positive_messages.json"
if [ ! -f "$json_file" ]; then
  echo "Error: $json_file not found."
  exit 1
fi

#define what messages is, an array.
message=()

# Read JSON messages line by line and append them to the messages array
while IFS= read -r line; do
  messages+=("$line")
done < <(jq -r '.messages[]' "$json_file")

while true; do
  clear
  random_message_index=$((RANDOM % ${#messages[@]}))
  botsay "${messages[$random_message_index]}"
  
  if [ "$interval_option" == "fast" ]; then
    random_interval=$((RANDOM % 6 + 1)) # Random number between 1 and 6
  elif [ "$interval_option" == "ultra" ]; then
    random_interval=0.1
  else
    random_interval=$((RANDOM % 11 + 5)) # Random number between 5 and 15
  fi
  
  sleep $random_interval
done
