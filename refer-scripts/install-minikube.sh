#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Install Docker if it is not already installed
if ! command -v docker &> /dev/null
then
    echo "Docker not found. Installing Docker..."
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
    rm get-docker.sh
else
    echo "Docker is already installed."
fi

# Add your user to the docker group if not already added (you might need to log out and log back in for this to take effect)
sudo usermod -aG docker $USER

# Install kubectl if it is not already installed
if ! command -v kubectl &> /dev/null
then
    echo "kubectl not found. Installing kubectl..."
    curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl"
    chmod +x kubectl
    sudo mv kubectl /usr/local/bin/
else
    echo "kubectl is already installed."
fi

# Install Minikube if it is not already installed
if ! command -v minikube &> /dev/null
then
    echo "Minikube not found. Installing Minikube..."
    curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
    chmod +x minikube
    sudo mv minikube /usr/local/bin/
else
    echo "Minikube is already installed."
fi

# Start Minikube with Docker driver
minikube start --driver=docker

# Verify Minikube installation
minikube status

sleep 60

minikube addons enable ingress
minikube addons enable metrics-server


echo "Minikube has been successfully installed and started using Docker."
