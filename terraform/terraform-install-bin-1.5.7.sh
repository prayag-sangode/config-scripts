#!/bin/bash

# Define Terraform version
TF_VERSION="1.5.7"

# Download Terraform binary
curl -LO "https://releases.hashicorp.com/terraform/${TF_VERSION}/terraform_${TF_VERSION}_linux_amd64.zip"

# Unzip Terraform binary to /usr/local/bin/
sudo unzip "terraform_${TF_VERSION}_linux_amd64.zip" -d /usr/local/bin/

# Verify installation by displaying Terraform version
terraform --version
