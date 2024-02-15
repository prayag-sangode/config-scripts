#!/bin/bash

# Deploy Ingress-Nginx controller
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.9.6/deploy/static/provider/baremetal/deploy.yaml

# Patch the Ingress-Nginx service to use LoadBalancer type
kubectl patch svc -n ingress-nginx ingress-nginx-controller -p '{"spec": {"type": "LoadBalancer"}}'

# Display Ingress-Nginx service information
kubectl -n ingress-nginx get svc
