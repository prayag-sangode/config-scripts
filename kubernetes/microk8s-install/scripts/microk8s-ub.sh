#!/bin/bash

# Update package list
echo "Updating package list..."
sudo apt update -y

# Install dependencies
echo "Installing required dependencies..."
sudo apt install -y snapd

# Install MicroK8s
echo "Installing MicroK8s..."
sudo snap install microk8s --classic

# Sleep to allow MicroK8s to start
echo "Waiting for MicroK8s to initialize..."
sleep 20

# Add current user to the MicroK8s group
echo "Adding current user to the MicroK8s group..."
sudo usermod -a -G microk8s $USER
sudo chown -f -R $USER ~/.kube
newgrp microk8s

# Sleep to ensure the usermod command takes effect
echo "Waiting for usermod to take effect..."
sleep 20

# Verify the status of MicroK8s services
echo "Verifying the status of MicroK8s services..."
sudo microk8s status --wait-ready

# Enable necessary MicroK8s addons including MetalLB
sudo microk8s enable dns storage dashboard metallb:192.168.1.131-192.168.1.135 

sleep 60

# Add kubectl alias
alias kubectl='microk8s kubectl'
echo "alias kubectl='microk8s kubectl'" >> ~/.bashrc

# Exit (logout, later log back in to apply group changes"
exit
