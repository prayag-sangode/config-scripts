#!/bin/bash

# Define variables
SONAR_SCANNER_VERSION="6.2.1.4610"
SONAR_SCANNER_DIR="/opt/sonar-scanner"
SONAR_SCANNER_ZIP="sonar-scanner-cli-${SONAR_SCANNER_VERSION}-linux-x64.zip"
SONAR_SCANNER_URL="https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/${SONAR_SCANNER_ZIP}"

# Step 1: Install unzip if not already installed
echo "Installing unzip..."
sudo apt update && sudo apt install -y unzip

# Step 2: Download SonarScanner CLI
echo "Downloading SonarScanner CLI..."
sudo mkdir -p ${SONAR_SCANNER_DIR}
cd ${SONAR_SCANNER_DIR}
sudo wget ${SONAR_SCANNER_URL}

# Step 3: Extract SonarScanner
echo "Extracting SonarScanner CLI..."
sudo unzip ${SONAR_SCANNER_ZIP}

# Step 4: Remove the downloaded ZIP file
echo "Cleaning up..."
sudo rm -f ${SONAR_SCANNER_ZIP}

# Step 5: Set environment variable globally
echo "Setting up system-wide PATH for SonarScanner..."
echo "export PATH=\$PATH:${SONAR_SCANNER_DIR}/sonar-scanner-${SONAR_SCANNER_VERSION}-linux-x64/bin" | sudo tee -a /etc/profile > /dev/null

# Step 6: Reload profile to apply changes
echo "Reloading profile..."
source /etc/profile

# Step 7: Verify SonarScanner installation
echo "Verifying installation..."
sonar-scanner --version

echo "SonarScanner installation completed successfully!"
