#!/bin/bash

# Update the package index
sudo apt update

# Install the latest version of OpenJDK
sudo apt install -y openjdk-17-jdk

# Verify the Java installation
java -version

# Add the Jenkins Debian repository and the Jenkins key to your system
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee \
  /usr/share/keyrings/jenkins-keyring.asc > /dev/null

echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null

# Update the package index again
sudo apt update

# Install Jenkins
sudo apt install -y jenkins

# Start Jenkins
sudo systemctl start jenkins

# Enable Jenkins to start on boot
sudo systemctl enable jenkins

# Print the status of Jenkins
sudo systemctl status jenkins

# Print the initial admin password
echo "Jenkins installed successfully."
echo "The initial admin password is located at /var/lib/jenkins/secrets/initialAdminPassword"
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
