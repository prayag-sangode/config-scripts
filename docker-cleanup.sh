#!/bin/bash

# Stop all containers
containers=$(sudo docker ps -aq)
if [ -n "$containers" ]; then
    sudo docker stop $containers
fi

# Remove all containers
containers=$(sudo docker ps -aq)
if [ -n "$containers" ]; then
    sudo docker rm $containers
fi

# Remove all images
images=$(sudo docker images -q)
if [ -n "$images" ]; then
    sudo docker rmi $images
fi
