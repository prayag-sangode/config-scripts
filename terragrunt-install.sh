#!/bin/bash

# Define Terragrunt version using GitHub's API
TERRAGRUNT_VERSION=$(curl -s https://api.github.com/repos/gruntwork-io/terragrunt/releases/latest | grep -oP '"tag_name": "\K(.*)(?=")')

# Check if the version was fetched successfully
if [ -z "$TERRAGRUNT_VERSION" ]; then
  echo "Failed to fetch the latest Terragrunt version."
  exit 1
fi

# Download Terragrunt binary
echo "Downloading Terragrunt version $TERRAGRUNT_VERSION..."
curl -LO "https://github.com/gruntwork-io/terragrunt/releases/download/${TERRAGRUNT_VERSION}/terragrunt_linux_amd64"

# Make the binary executable
echo "Making Terragrunt executable..."
chmod +x terragrunt_linux_amd64

# Move the binary to /usr/local/bin (requires sudo)
echo "Moving Terragrunt binary to /usr/local/bin/..."
sudo mv terragrunt_linux_amd64 /usr/local/bin/terragrunt

# Verify the installation
echo "Verifying the Terragrunt installation..."
sudo terragrunt --version
