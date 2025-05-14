# 1. Update package info
sudo apt update

# 2. Install prerequisite packages
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common

# 3. Add Docker’s official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# 4. Add Docker's official APT repository
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) stable"

# 5. Install Docker Engine and Docker Compose plugin
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

# 6. Add current user to the docker group
sudo usermod -aG docker $USER

# 7. Print a reminder
echo "Done. Please log out and log back in (or reboot) for docker group changes to take effect."
