#!/bin/bash
# Create Deployment1
kubectl create deployment httpd-deployment1 --image=httpd:latest --port=80

# Expose Deployment1 with ClusterIP Service
kubectl expose deployment httpd-deployment1 --name=httpd-clusterip1 --port=80 --target-port=80 --type=ClusterIP

# Create Deployment2
kubectl create deployment httpd-deployment2 --image=httpd:latest --port=80

# Expose Deployment2 with ClusterIP Service
kubectl expose deployment httpd-deployment2 --name=httpd-clusterip2 --port=80 --target-port=80 --type=ClusterIP

# Create Ingress
kubectl create ingress web1-ingress --rule="web1.example.com/*=httpd-clusterip1:80" --annotation="nginx.ingress.kubernetes.io/rewrite-target=/" --annotation="kubernetes.io/ingress.class=nginx"
kubectl create ingress web2-ingress --rule="web2.example.com/*=httpd-clusterip2:80" --annotation="nginx.ingress.kubernetes.io/rewrite-target=/" --annotation="kubernetes.io/ingress.class=nginx"
