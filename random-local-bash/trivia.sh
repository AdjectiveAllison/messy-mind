#!/usr/bin/env bash

# Read trivia questions and answers from trivia.json
json_file="trivia.json"
if [ ! -f "$json_file" ]; then
  echo "Error: $json_file not found."
  exit 1
fi

questions=()
answers=()

while IFS= read -r line; do
  questions+=("$line")
done < <(jq -r '.trivia[].question' "$json_file")

while IFS= read -r line; do
  answers+=("$line")
done < <(jq -r '.trivia[].answer' "$json_file")

clear

for i in "${!questions[@]}"; do
  echo -e "\033[1;33mQuestion $(($i + 1)):\033[0m ${questions[$i]}"
  echo -e "\033[1;32mAnswer will be revealed in 60 seconds...\033[0m"
  sleep 60
  clear
  echo -e "\033[1;33mQuestion $(($i + 1)):\033[0m ${questions[$i]}"
  echo -e "\033[1;32mAnswer: ${answers[$i]}\033[0m"
  echo
  if [ $i -ne $((${#questions[@]} - 1)) ]; then
    echo -e "\033[1;34mNext question in 30 seconds...\033[0m"
    sleep 30
    clear
  fi
done

echo -e "\033[1;35mThanks for playing! AdjectiveAllison will be back soon.\033[0m"
