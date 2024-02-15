#!/bin/bash

# Display cluster info
kubectl cluster-info

# Clone the kube-prometheus repository
git clone https://github.com/prometheus-operator/kube-prometheus.git
cd kube-prometheus

# Apply setup manifests
kubectl create -f manifests/setup

# Wait for the setup to complete
echo "Waiting for setup to complete..."
sleep 30

# Check if the monitoring namespace is created
kubectl get ns monitoring

# Apply remaining manifests
kubectl create -f manifests/

# Wait for the pods to be created and ready
echo "Waiting for pods to be created and ready..."
kubectl get pods -n monitoring -w

# Get the services in the monitoring namespace
kubectl get svc -n monitoring
