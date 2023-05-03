#!/usr/bin/env bash

# Stop all running containers
docker stop $(docker ps -aq)

# Remove all stopped containers
docker rm $(docker ps -aq)


echo "Success, hooray! posititvity! :)"
