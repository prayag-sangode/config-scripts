#!/bin/bash

# Stop and delete Minikube cluster
minikube stop
minikube delete

# Remove Minikube binary
sudo rm -rf $(which minikube)

# Remove Minikube configuration and data directories
rm -rf ~/.minikube

# Optional: Remove the Minikube context from kubectl config
kubectl config delete-context minikube
kubectl config delete-cluster minikube

echo "Minikube has been completely uninstalled."
