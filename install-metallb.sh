#!/bin/bash

# Apply the MetalLB native configuration
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.13.12/config/manifests/metallb-native.yaml

sleep 120

# Apply the custom IP address pool
kubectl apply -f - <<EOF
apiVersion: metallb.io/v1beta1
kind: IPAddressPool
metadata:
  name: first-pool
  namespace: metallb-system
spec:
  addresses:
  - 192.168.1.240-192.168.1.250
EOF

kubectl -n metallb-system get all
kubectl -n metallb-system get ipaddresspool

