#!/bin/bash

# Download and extract Istio
curl -L https://istio.io/downloadIstio | sh -
ISTIO_VERSION="istio-1.20.3"
ISTIO_DIR="/home/prayag/config-scripts/$ISTIO_VERSION"

# Add istioctl to PATH
export PATH="$PATH:$ISTIO_DIR/bin"

# Begin pre-installation check
istioctl x precheck

# Apply Istio to the Kubernetes cluster
istioctl install --set profile=demo

# Verify Istio installation
kubectl get pods -n istio-system

