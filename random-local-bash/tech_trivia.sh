#!/usr/bin/env bash

questions=("What does 'ALU' stand for?"
           "What is the standard port number for the HTTPS protocol?"
           "Which programming language was developed by Yukihiro Matsumoto?"
           "What does 'SSD' stand for?"
           "What is the default file extension for a Java script?")

answers=("Arithmetic Logic Unit"
         "443"
         "Ruby"
         "Solid State Drive"
         ".java")

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
