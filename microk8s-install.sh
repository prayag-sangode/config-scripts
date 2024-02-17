#!/bin/bash

# Update package index
sudo apt-get update

# Install prerequisites
sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common

# Install Docker
sudo apt-get install -y docker.io

# Add current user to docker group
sudo usermod -aG docker $USER

# Install MicroK8s
sudo snap install microk8s --classic

# Sleep for 5 minutes
sleep 300

# Wait for microk8s to become ready
#microk8s status --wait-ready

# Add alias
alias kubectl='microk8s kubectl'
echo "alias kubectl='microk8s kubectl'" >> ~/.bashrc

# Install kubectl
sudo snap install kubectl --classic

# Allow current user to use kubectl
sudo usermod -a -G microk8s $USER
sudo chown -f -R $USER ~/.kube
newgrp microk8s

# Sleep for 5 minutes
sleep 300

# Enable necessary MicroK8s addons including MetalLB
sudo microk8s enable dns storage dashboard metallb:192.168.1.131-192.168.1.135 ingress

# Sleep for 5 minutes
sleep 300

# Define the YAML content for the Service
SERVICE_YAML=$(cat <<EOF
apiVersion: v1
kind: Service
metadata:
  name: ingress
  namespace: ingress
spec:
  selector:
    name: nginx-ingress-microk8s
  type: LoadBalancer
  ports:
    - name: http
      protocol: TCP
      port: 80
      targetPort: 80
    - name: https
      protocol: TCP
      port: 443
      targetPort: 443
EOF
)

# Apply the YAML using kubectl
echo "$SERVICE_YAML" | kubectl apply -f -

# Output success message
echo "MicroK8s, Docker, MetalLB with specified IP range, Ingress, and kubectl have been installed and configured successfully."
