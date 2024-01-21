#!/bin/bash

# Create Deployment
kubectl create deployment httpd-deployment --image=httpd:latest --port=80

# Create ClusterIP Service
kubectl expose deployment httpd-deployment --name=httpd-clusterip --port=80 --target-port=80 --type=ClusterIP

# Create NodePort Service
kubectl expose deployment httpd-deployment --name=httpd-nodeport --port=80 --target-port=80 --type=NodePort

# Create NodePort Service
kubectl expose deployment httpd-deployment --name=httpd-lb --port=80 --target-port=80 --type=LoadBalancer

# Display Service Information
kubectl get services
