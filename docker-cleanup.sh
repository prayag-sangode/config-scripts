#!/bin/bash

# Get all running container IDs
containers=$(sudo docker ps -aq)

# Stop all running containers if any exist
if [ -n "$containers" ]; then
  sudo docker stop $containers
  sudo docker rm $containers
else
  echo "No containers to stop and remove."
fi

# Get all image IDs
images=$(sudo docker images -q)

# Remove all images if any exist
if [ -n "$images" ]; then
  sudo docker rmi $images
else
  echo "No images to remove."
fi
