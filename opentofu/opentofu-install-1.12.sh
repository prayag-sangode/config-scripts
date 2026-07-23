#!/bin/bash
set -e

# Remove any existing OpenTofu installation
echo "Removing old OpenTofu versions..."
sudo rm -f /usr/local/bin/tofu
sudo rm -f /usr/bin/tofu

# Download the installer script
curl --proto '=https' --tlsv1.2 -fsSL https://get.opentofu.org/install-opentofu.sh -o install-opentofu.sh
# Alternatively:
# wget --secure-protocol=TLSv1_2 --https-only https://get.opentofu.org/install-opentofu.sh -O install-opentofu.sh

# Grant execution permissions
chmod +x install-opentofu.sh

# Inspect the script before running (recommended)
echo "Inspect install-opentofu.sh before proceeding..."

# Run the installer for OpenTofu 1.12.0
./install-opentofu.sh --install-method standalone --opentofu-version 1.12.0

# Remove the installer script
rm -f install-opentofu.sh

# Verify installation
echo "Installed OpenTofu version:"
tofu version
