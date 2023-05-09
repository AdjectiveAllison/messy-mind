#!/usr/bin/env bash

# THIS IS A COMLETE NIGHTMARE OF A FILE. WHY IS IT HAPPENING.
source countdown.sh
source afk_botsay.sh
source trivia.sh

trivia_interval=1800  # 30 minutes
countdown_seconds=300


tmux new-session -d -s trivia
tmux split-window -h -t trivia
tmux split-window -v -t trivia


while true; do
  tmux send-keys -t trivia:0.0 "echo 'Trivia starting in:'" Enter
  tmux send-keys -t trivia:0.0 "./countdown.sh $countdown_seconds" Enter
  tmux send-keys -t trivia:0.1 "./afk_botsay.sh slow" Enter
  tmux send-keys -t trivia:0.2 "./trivia.sh" Enter

  sleep $trivia_interval
done
