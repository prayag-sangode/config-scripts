#!/bin/bash

# https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-4.5.0.2216-linux.zip
SONAR_SCANNER_VERSION=4.5.0.2216

cd /tmp || exit
echo "Downloading sonar-scanner....."
if [ -d "/tmp/sonar-scanner-cli-$SONAR_SCANNER_VERSION-linux.zip" ];then
    sudo rm /tmp/sonar-scanner-cli-$SONAR_SCANNER_VERSION-linux.zip
fi
wget https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-$SONAR_SCANNER_VERSION-linux.zip
echo "Download completed."

echo "Unziping downloaded file..."
unzip sonar-scanner-cli-$SONAR_SCANNER_VERSION-linux.zip
echo "Unzip completed."
rm sonar-scanner-cli-$SONAR_SCANNER_VERSION-linux.zip

echo "Installing to opt..."
if [ -d "/var/opt/sonar-scanner-$SONAR_SCANNER_VERSION-linux" ];then
    sudo rm -rf /var/opt/sonar-scanner-$SONAR_SCANNER_VERSION-linux
fi
sudo mv sonar-scanner-$SONAR_SCANNER_VERSION-linux /var/opt

echo "Installation completed successfully."

echo "You can use sonar-scanner!"
