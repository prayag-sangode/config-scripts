#!/bin/bash

# Stop Jenkins service
echo "Stopping Jenkins service..."
sudo systemctl stop jenkins

# Disable Jenkins service from starting on boot
echo "Disabling Jenkins service..."
sudo systemctl disable jenkins

# Remove Jenkins package and configuration files
echo "Removing Jenkins package and configuration..."
sudo apt-get purge -y jenkins

# Remove unused dependencies
echo "Removing unused dependencies..."
sudo apt-get autoremove -y

# Remove Jenkins user and group (optional)
echo "Removing Jenkins user and group..."
sudo deluser --remove-home jenkins
sudo delgroup jenkins

# Remove Jenkins data and configuration directories
echo "Removing Jenkins data and configuration directories..."
sudo rm -rf /var/lib/jenkins
sudo rm -rf /etc/jenkins

# Remove Jenkins log files
echo "Removing Jenkins log files..."
sudo rm -rf /var/log/jenkins

# Verify Jenkins removal
echo "Verifying Jenkins removal..."
dpkg -l | grep jenkins

echo "Jenkins has been completely removed."
