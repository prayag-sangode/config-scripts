#!/bin/bash

echo "Stopping and uninstalling MicroK8s..."

# Stop MicroK8s
echo "Stopping MicroK8s services..."
sudo microk8s stop

# Remove MicroK8s
echo "Removing MicroK8s..."
sudo snap remove microk8s

# Remove MicroK8s configurations
echo "Cleaning up MicroK8s configuration files..."
sudo rm -rf ~/.kube ~/.microk8s /var/snap/microk8s /snap/microk8s

# Remove user from the MicroK8s group
echo "Removing current user from MicroK8s group..."
sudo gpasswd -d $USER microk8s

# Remove broken /snap/bin path if it exists
echo "Removing broken MicroK8s paths..."
sudo rm -rf /snap/bin/microk8s

# Reload bash profile to remove kubectl alias
echo "Removing kubectl alias..."
sed -i '/alias kubectl/d' ~/.bashrc
source ~/.bashrc

echo "MicroK8s has been completely uninstalled. If issues persist, try rebooting your system."
