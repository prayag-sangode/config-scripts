#!/bin/bash

# Define Terraform version using HashiCorp's checkpoint API
TERRAFORM_VERSION=$(curl -s https://checkpoint-api.hashicorp.com/v1/check/terraform | jq -r .current_version)

# Download Terraform binary
echo "Downloading Terraform version $TERRAFORM_VERSION..."
curl -LO "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip"

# Unzip the downloaded file
echo "Unzipping Terraform..."
unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip

# Move the binary to /usr/local/bin
echo "Moving Terraform binary to /usr/local/bin/..."
sudo mv terraform /usr/local/bin/

# Cleanup the downloaded zip file
echo "Cleaning up..."
rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip

# Verify the installation
echo "Verifying the Terraform installation..."
terraform --version
