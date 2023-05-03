#!/usr/bin/env bash

# Check if the command line option is provided and valid
if [ "$1" == "fast" ] || [ "$1" == "slow" ]; then
  interval_option="$1"
else
  interval_option="slow"
fi

messages=(
  "Believe in your inner strength!"
  "Embrace your emotions!"
  "Mindfulness matters!"
  "Gratitude leads to happiness!"
  "Kindness is contagious!"
  "You have the power to change!"
  "Live in the present moment!"
  "Self-care is essential!"
  "Cultivate positive relationships!"
  "Be compassionate to yourself and others!"
  "Resilience is key!"
  "Growth comes from challenges!"
  "Find balance in life!"
  "Celebrate small victories!"
  "Nurture your passions!"
  "Learn from your mistakes!"
  "Positive thoughts lead to positive outcomes!"
  "Set realistic goals for yourself!"
  "Surround yourself with positivity!"
  "Visualize your success!"
  "Stay curious and keep learning!"
  "Take breaks to recharge!"
  "Focus on your strengths!"
  "Acknowledge your achievements!"
  "Laughter is the best medicine!"
  "Challenge negative thoughts!"
  "Connect with nature!"
  "Speak kindly to yourself!"
  "Practice patience!"
  "Stay true to your values!"
  "Empathy makes a difference!"
  "Don't compare yourself to others!"
  "Accept and adapt to change!"
  "Self-reflection fosters growth!"
  "Seek support when needed!"
  "Create a positive environment!"
  "Meditation can improve your well-being!"
  "Take one step at a time!"
  "Develop healthy habits!"
  "Remember to breathe!"
  "Your journey is unique!"
  "Cherish the present!"
  "Overcome obstacles with determination!"
  "Share your happiness with others!"
  "Trust your intuition!"
  "A positive mindset attracts success!"
  "Be open to new experiences!"
  "Stay persistent in the face of adversity!"
  "Listen to understand, not to respond!"
  "Embrace life's uncertainties!"
  "You're stronger than you think!"
  "The world needs your unique talents!"
  "Enjoy the journey, not just the destination!"
  "Be the change you want to see!"
  "A little progress each day adds up!"
  "You are worthy of love and happiness!"
)

while true; do
  clear
  random_message_index=$((RANDOM % ${#messages[@]}))
  echo "${messages[$random_message_index]}"
  
  if [ "$interval_option" == "fast" ]; then
    random_interval=$((RANDOM % 6 + 1)) # Random number between 1 and 6
  else
    random_interval=$((RANDOM % 11 + 5)) # Random number between 5 and 15
  fi
  
  sleep $random_interval
done