#!/bin/bash

sudo apt-get update && sudo apt -y install apache2-utils

# Define the username
USERNAME="admin"

# Generate the htpasswd file
htpasswd -c auth.htpasswd $USERNAME

# Create a Kubernetes secret in the 'ingress-nginx' namespace
kubectl create secret generic basic-auth --from-file=auth=auth.htpasswd -n ingress-nginx

# Clean up the local auth.htpasswd file (optional)
rm auth.htpasswd

# Check secret
kubectl -n ingress-nginx get secret
