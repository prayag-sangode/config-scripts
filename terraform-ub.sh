#!/bin/bash

# Update and install required packages
sudo apt-get update -y
sudo apt-get install -y curl unzip jq

# Fetch the latest Terraform version
TERRAFORM_VERSION=$(curl -s https://checkpoint-api.hashicorp.com/v1/check/terraform | jq -r '.current_version')

# Download the latest Terraform version
curl -O "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip"

# Unzip the downloaded file
unzip "terraform_${TERRAFORM_VERSION}_linux_amd64.zip"

# Move the Terraform binary to /usr/local/bin/
sudo mv terraform /usr/local/bin/

# Verify the installation
terraform --version

# Clean up the downloaded files
rm "terraform_${TERRAFORM_VERSION}_linux_amd64.zip"

echo "Terraform installation is complete."
