#!/bin/bash

# Define variables
NEW_HOSTNAME="k8s-node2.example.com"
NEW_IP="192.168.200.62"
NEW_NETMASK="24"
NEW_GATEWAY="192.168.200.1"
USERNAME="prayag"
NEW_PASSWORD=""

# Check if script is run as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root"
  exit
fi

# Add user if it doesn't exist
if ! id "$USERNAME" &>/dev/null; then
  echo "Creating user $USERNAME..."
  useradd -m -s /bin/bash "$USERNAME"
fi

# Change password
echo -e "$NEW_PASSWORD\n$NEW_PASSWORD" | passwd $username

# Set hostname if necessary
CURRENT_HOSTNAME=$(cat /etc/hostname)
if [ "$CURRENT_HOSTNAME" != "$NEW_HOSTNAME" ]; then
  echo "Setting hostname..."
  hostnamectl set-hostname "$NEW_HOSTNAME"
else
  echo "Hostname already set correctly."
fi

# Add user to sudoers with nopasswd if not already present
if ! grep -q "^$USERNAME" /etc/sudoers; then
  echo "Adding user to sudoers..."
  echo "$USERNAME ALL=(ALL:ALL) NOPASSWD:ALL" >> /etc/sudoers
else
  echo "User is already in sudoers."
fi

# Add entry in /etc/hosts if not already present
if ! grep -q "$NEW_IP\s\+$NEW_HOSTNAME" /etc/hosts; then
  echo "Adding entry to /etc/hosts..."
  echo "$NEW_IP $NEW_HOSTNAME" >> /etc/hosts
else
  echo "Entry already exists in /etc/hosts."
fi

echo "Script completed successfully."
# Update Netplan configuration if necessary
CURRENT_IP=$(grep -oP 'addresses:\s*-\s*\K\S+' /etc/netplan/00-installer-config.yaml)
if [ "$CURRENT_IP" != "$NEW_IP/$NEW_NETMASK" ]; then
  echo "Updating Netplan configuration..."
  cat <<EOF > /etc/netplan/00-installer-config.yaml
network:
  version: 2
  ethernets:
    ens160:
      dhcp4: false
      addresses:
       - $NEW_IP/$NEW_NETMASK
      gateway4: $NEW_GATEWAY
      nameservers:
         addresses: [$NEW_GATEWAY, 8.8.8.8]
EOF
  # Apply the changes
  netplan apply
else
  echo "Netplan configuration already up to date."
fi
