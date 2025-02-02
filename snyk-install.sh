# Download the Snyk binary
wget https://github.com/snyk/cli/releases/download/v1.1294.3/snyk-linux

# Rename the downloaded file
mv snyk-linux snyk

# Make the file executable
chmod 755 snyk

# Move the binary to /usr/local/bin for system-wide access
sudo mv snyk /usr/local/bin

# Verify the installation
snyk version
