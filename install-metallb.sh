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
  - 192.168.200.81-192.168.200.90
---
apiVersion: metallb.io/v1beta1
kind: L2Advertisement
metadata:
  name: default-advertise-all-pools
  namespace: metallb-system
EOF

kubectl -n metallb-system get all
kubectl -n metallb-system get ipaddresspool

