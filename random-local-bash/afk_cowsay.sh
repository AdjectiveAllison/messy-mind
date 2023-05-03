#!/usr/bin/env bash

messages=(
  "Stay positive!"
  "Keep up the good work!"
  "You're doing great!"
  "Believe in yourself!"
  "Success is on its way!"
  "You can do it!"
  "Never give up!"
  "Hard work pays off!"
  "Stay focused!"
  "Dream big!"
)

duration=$((5 * 60)) # 5 minutes in seconds
interval=$((duration / ${#messages[@]}))

for message in "${messages[@]}"; do
  clear
  cowsay "$message"
  sleep $interval
done
