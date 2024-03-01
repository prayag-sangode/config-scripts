#!/bin/bash

# Define the Kubeseal version
KUBESEAL_VERSION="0.26.0"
# Define the download URL
KUBESEAL_URL="https://github.com/bitnami-labs/sealed-secrets/releases/download/v${KUBESEAL_VERSION}/kubeseal-${KUBESEAL_VERSION}-linux-amd64.tar.gz"

# Download Kubeseal
wget "$KUBESEAL_URL" -O kubeseal.tar.gz

# Extract the Kubeseal binary
tar -xvzf kubeseal.tar.gz kubeseal

# Move the Kubeseal binary to /usr/local/bin
sudo install -m 755 kubeseal /usr/local/bin/kubeseal

# Clean up temporary files
rm kubeseal.tar.gz kubeseal

echo "Kubeseal installation completed successfully."
