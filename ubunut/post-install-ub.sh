#!/bin/bash

# Check if script is run as root
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root"
    exit 1
fi

# Variables
hosts_file="/etc/hosts"
sudoers_file="/etc/sudoers"
netplan_config="/etc/netplan/00-installer-config.yaml"
public_key="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDg0Yfg8X1Z5gm8GzwQBzQm0Pz0F6nbt9/BdsI1dZi332j3lohSyksPADjsVcaeA0hWp2dEzGFLkwAkEURvXe2LyykNJC+BZqI9fsmgQWdLGW8J66GOISDcs7FXYDV9pu/JKquK+mfN5OMCI1W2ulhYpAtH7c0+5YyLz7yHa+tejNzmts51+4nm3FduvjQI4XnoEghrGvdXb+uovySrOlx9V1kRXy5xTSpLZgAV8BC79pLVNRb8qyKBWQJRkEVTTjzJ9lKqECD79gdKh9Pj/SENP2sIruwQ/z/+NPU1JifrmoKKlZx+2GiRGVlF66tOPDdbZlTufDK5WLDAHmaU5xfTWNJCTXwoQK72UYry4lYAXzlJVhdDYLmCTaBb9bFg2jHyPCqcBfltz1QCAP2B9ZEzJ4fjwGAKEBJ24/Bvw73MbmQjab6r4qOgw2SDVYjNMSrYG5MC6Z8G04He+zVX+E+AGn1d1tfGmjL/fjuOrq6G6BU6YwgP5s6ppo9v3N/jIvn1L5seQs8Q5w/3ZaoN/ZScLhflF0/hr9yWLqbyJeiO48P467dHeabfgKdJVyM5TKyI5G4/SK3g65lyHw6mstSwTAaW6hHHL/9bnNzXcAnUNR5/ybyGzfSN0Lt/0+tsH3IjO4LpgOLrEUMpCDnKmR57MtYagoGnOerpmAUeYPNi5w== prayag@linux-bastion"

# Function to set hostname
set_hostname() {
    new_hostname="$1"
    current_hostname=$(hostname)
    if [ "$new_hostname" != "$current_hostname" ]; then
        hostnamectl set-hostname "$new_hostname"
        echo "Hostname set to $new_hostname"
    else
        echo "Hostname is already set to $new_hostname"
    fi
}

# Function to add entry in /etc/hosts
add_to_hosts() {
    ip_address="$1"
    new_hostname="$2"
    if ! grep -q -P "^$ip_address\s+$new_hostname$" "$hosts_file"; then
        echo "$ip_address    $new_hostname" >> "$hosts_file"
        echo "Entry added to /etc/hosts: $ip_address    $new_hostname"
    else
        echo "Entry $ip_address $new_hostname already exists in /etc/hosts"
    fi
}

# Function to add user to sudoers
add_to_sudoers() {
    username="$1"
    if ! grep -q "^$username\s" "$sudoers_file"; then
        echo "$username ALL=(ALL) NOPASSWD:ALL" >> "$sudoers_file"
        echo "User $username added to sudoers"
    else
        echo "User $username is already in sudoers list"
    fi
}

# Function to change IP address in netplan config
change_ip_address() {
    new_ip="$1"
    if grep -q "addresses" "$netplan_config"; then
        current_ip=$(grep -oP '(?<=^      addresses:\n       - )[^/]+' "$netplan_config")
        if [ "$new_ip" != "$current_ip" ]; then
            sed -i "s/$current_ip/$new_ip/g" "$netplan_config"
            echo "IP address changed to $new_ip in netplan config"
        else
            echo "IP address is already set to $new_ip in netplan config"
        fi
    else
        echo "No IP address found in netplan config"
    fi
}

# Function to create user
create_user() {
    username="$1"
    if ! id "$username" &>/dev/null; then
        useradd -m -s /bin/bash "$username"
        echo "User $username created"
    else
        echo "User $username already exists"
    fi
}

# Function to add public key to user's authorized_keys
add_public_key() {
    username="$1"
    if [ ! -f "/home/$username/.ssh/authorized_keys" ] || ! grep -q "$public_key" "/home/$username/.ssh/authorized_keys"; then
        mkdir -p "/home/$username/.ssh"
        echo "$public_key" >> "/home/$username/.ssh/authorized_keys"
        chown -R "$username:$username" "/home/$username/.ssh"
        chmod 700 "/home/$username/.ssh"
        chmod 600 "/home/$username/.ssh/authorized_keys"
        echo "Public key added to $username's authorized_keys file"
    else
        echo "Public key already exists in $username's authorized_keys file"
    fi
}

# Set hostname
set_hostname "k8s-node1.example.com"

# Add entry to /etc/hosts
add_to_hosts "192.168.200.71" "k8s-node1.example.com"

# Add user to sudoers
add_to_sudoers "prayag"

# Change IP address
change_ip_address "192.168.200.71"

# Apply the changes
netplan apply

# Create user
create_user "prayag"

# Add public key to user's authorized_keys
add_public_key "prayag"
