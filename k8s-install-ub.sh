#!/bin/bash

# Load kernel modules for containerd
cat <<EOF | sudo tee /etc/modules-load.d/containerd.conf
overlay
br_netfilter
EOF

sudo modprobe overlay
sudo modprobe br_netfilter

# Configure sysctl settings
cat <<EOF | sudo tee /etc/sysctl.d/99-kubernetes-cri.conf
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF

sudo sysctl --system

# Install containerd
sudo apt-get update && sudo apt-get install -y containerd

# Configure containerd
sudo mkdir -p /etc/containerd
sudo containerd config default | sudo tee /etc/containerd/config.toml
sudo systemctl restart containerd

# Disable swap
sudo swapoff -a
sudo sed -i '/swap/ s/^/#/' /etc/fstab

# Install Kubernetes components
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
sudo apt-get update && sudo apt-get install -y apt-transport-https curl

cat <<EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF

sudo apt-get update
sudo apt-get install -y kubelet=1.23.0-00 kubeadm=1.23.0-00 kubectl=1.23.0-00

# Hold the Kubernetes packages to prevent automatic updates
sudo apt-mark hold kubelet kubeadm kubectl

# On the master node only
if [[ "$(hostname)" == "k8s-node1.example.com" ]]; then
  # Initialize the Kubernetes master
  sudo kubeadm init --pod-network-cidr=192.168.0.0/16 --kubernetes-version=1.23.0

  # Set up kubeconfig for the user
  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config

  # Apply Calico network addon
  kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.25.1/manifests/calico.yaml

  # Watch for node status
  #kubectl get nodes --watch

  # Print the join command for other nodes
  kubeadm token create --print-join-command
fi
# if using single node un taint using
# kubectl taint nodes k8s-node1.example.com node-role.kubernetes.io/master-
