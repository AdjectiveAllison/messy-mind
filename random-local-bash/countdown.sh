#!/usr/bin/env bash

# Check if a valid number is provided as an argument
if [[ $# -ne 1 ]] || ! [[ $1 =~ ^[0-9]+$ ]]; then
  echo "Usage: $0 <seconds>"
  exit 1
fi

# Countdown timer
countdown() {
  local seconds=$1
  while [ $seconds -gt 0 ]; do
    local hours=$((seconds/3600))
    local minutes=$(((seconds%3600)/60))
    local remaining_seconds=$((seconds%60))
    printf "\rTime remaining: %02dh %02dm %02ds" $hours $minutes $remaining_seconds
    sleep 1
    seconds=$((seconds-1))
  done
  printf "\nTime's up!\n"
}

countdown $1
