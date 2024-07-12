#!/bin/bash

# Update package list
sudo apt update

# Install necessary dependencies
sudo apt install -y wget gnupg2

# Import PostgreSQL signing key
wget -qO - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -

# Add PostgreSQL APT repository
sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'

# Update package list again
sudo apt update

# Install the latest version of PostgreSQL
sudo apt install -y postgresql

# Start the PostgreSQL service
sudo systemctl start postgresql

# Enable PostgreSQL to start on boot
sudo systemctl enable postgresql

# Verify the installation
psql --version

echo "PostgreSQL installation completed successfully."
