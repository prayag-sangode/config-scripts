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

# Remove all volumes
volumes=$(sudo docker volume ls -q)
if [ -n "$volumes" ]; then
    sudo docker volume rm $volumes
fi

# Remove unused networks
unused_networks=$(sudo docker network ls -q --filter "dangling=true")
if [ -n "$unused_networks" ]; then
    sudo docker network rm $unused_networks
fi

echo "All containers, images, volumes, and unused networks have been removed."
