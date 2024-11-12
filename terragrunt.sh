#!/bin/bash

# Define Terragrunt version
TG_VERSION="0.68.7"

# Download and install Terragrunt
echo "Downloading Terragrunt ${TG_VERSION}..."
wget "https://github.com/gruntwork-io/terragrunt/releases/download/v${TG_VERSION}/terragrunt_linux_amd64"

# Move the binary and set permissions
mv terragrunt_linux_amd64 terragrunt
chmod 755 terragrunt
sudo mv terragrunt /usr/local/bin/

# Verify Terragrunt installation
echo "Terragrunt ${TG_VERSION} installed."
terragrunt --version
