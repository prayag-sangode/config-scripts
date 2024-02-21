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

# Check grafana by port forwarding
#kubectl port-forward --address 0.0.0.0 --namespace monitoring svc/grafana 3000

# Check prometheus by port forwarding
# kubectl port-forward --address 0.0.0.0 --namespace monitoring svc/prometheus-k8s 9090

# Check alertmanager by port forwarding
# kubectl port-forward --address 0.0.0.0 --namespace monitoring svc/alertmanager-main 9093

# If LB available
#kubectl -n monitoring patch svc alertmanager-main -p '{"spec": {"type": "LoadBalancer"}}'
#kubectl -n monitoring patch svc grafana -p '{"spec": {"type": "LoadBalancer"}}'
#kubectl -n monitoring patch svc prometheus-k8s -p '{"spec": {"type": "LoadBalancer"}}'

# For NodePort
#kubectl -n monitoring patch svc alertmanager-main -p '{"spec": {"type": "NodePort"}}'
#kubectl -n monitoring patch svc grafana -p '{"spec": {"type": "NodePort"}}'
#kubectl -n monitoring patch svc prometheus-k8s -p '{"spec": {"type": "NodePort"}}'

# For reverting back to custerip
#kubectl -n monitoring patch svc alertmanager-main -p '{"spec": {"type": "ClusterIP"}}'
#kubectl -n monitoring patch svc grafana -p '{"spec": {"type": "ClusterIP"}}'
#kubectl -n monitoring patch svc prometheus-k8s -p '{"spec": {"type": "ClusterIP"}}'

