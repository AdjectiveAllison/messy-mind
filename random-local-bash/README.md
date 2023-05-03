# .bin Folder Scripts

This repository contains a collection of useful scripts to streamline and assist your local processes. Below is a brief description of each script and its purpose.

## afk_botsay.sh

This script displays a random positive message on the terminal at a random interval between 5 and 15 seconds. Use this script to bring some positivity and inspiration to your day.

## setAudioOutput.sh

This script allows you to change the audio output sink for all currently playing audio streams. Provide the sink ID or sink name as an argument to switch the output.

Usage:
```
./setAudioOutput.sh <sinkId/sinkName>
```

## stop_docker_containers.sh

This script stops and removes all running Docker containers. Use this script to quickly clean up your Docker environment.

## update_task

This script helps you keep track of your current task. Provide a short description of your task as an argument, and the script will save it to a file named `current_task.txt`.

Usage:
```
./update_task "Your current task"
```

Remember to give execute permissions to the scripts by running `chmod +x script_name.sh` before using them.
