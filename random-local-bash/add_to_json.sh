#!/usr/bin/env bash

if [[ $# -ne 2 ]]; then
  echo "Usage: $0 <type: message|trivia> <content>"
  echo "For trivia, use the format: 'question|answer'"
  exit 1
fi

entry_type=$1
content=$2
trivia_file=trivia.json
messages_file=positive_messages.json

if [[ "$entry_type" != "message" ]] && [[ "$entry_type" != "trivia" ]]; then
  echo "Invalid entry type. Use 'message' or 'trivia'."
  exit 1
fi

if [[ "$entry_type" == "message" ]]; then
  jq ".messages += [\"$content\"]" ${messages_file} > tmp.json && mv tmp.json ${messages_file}
  echo "Added new message: \"$content\""
elif [[ "$entry_type" == "trivia" ]]; then
  IFS='|' read -ra question_and_answer <<< "$content"
  question="${question_and_answer[0]}"
  answer="${question_and_answer[1]}"

  jq ".trivia += [{\"question\": \"$question\", \"answer\": \"$answer\"}]" ${trivia_file} > tmp.json && mv tmp.json ${trivia_file}
  echo "Added new trivia:"
  echo "Question: \"$question\""
  echo "Answer: \"$answer\""
fi
