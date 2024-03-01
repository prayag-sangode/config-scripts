#!/bin/bash

# Install NFS server package
sudo apt update
sudo apt install -y nfs-kernel-server

# Create directory to be exported
sudo mkdir -p /data/export

# Set permissions for the exported directory
sudo chown nobody:nogroup /data/export
sudo chmod 777 /data/export

# Configure NFS exports
echo "/data/export *(rw,sync,no_subtree_check,no_root_squash)" | sudo tee -a /etc/exports

# Restart NFS server to apply changes
sudo systemctl restart nfs-kernel-server

# Enable NFS server to start on boot
sudo systemctl enable nfs-kernel-server

echo "NFS server installation and export setup complete."
