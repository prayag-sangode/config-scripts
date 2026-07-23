#!/bin/bash
set -e

# Fixed version
VERSION="1.5.7"

# Remove any existing Terraform binary
echo "Removing old Terraform versions..."
sudo rm -f /usr/local/bin/terraform
sudo rm -f /usr/bin/terraform

echo "Installing Terraform v$VERSION ..."

# Download the specified release
curl -LO https://releases.hashicorp.com/terraform/${VERSION}/terraform_${VERSION}_linux_amd64.zip

# Install unzip if missing
sudo apt-get update -y
sudo apt-get install -y unzip

# Extract and move binary
unzip terraform_${VERSION}_linux_amd64.zip
sudo mv terraform /usr/local/bin/

# Clean up
rm terraform_${VERSION}_linux_amd64.zip

# Verify installation
terraform version
