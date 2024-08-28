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

# Add Kubernetes repository key
sudo curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.28/deb/Release.key | sudo gpg --dearmor -o /usr/share/keyrings/kubernetes-apt-keyring.gpg

# Add Kubernetes repository to sources list
echo 'deb [signed-by=/usr/share/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.28/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list

# Install Kubernetes components
sudo apt-get update
sudo apt-get install -y kubelet=1.28.1-1.1 kubeadm=1.28.1-1.1 kubectl=1.28.1-1.1

# Hold the Kubernetes packages to prevent automatic updates
sudo apt-mark hold kubelet kubeadm kubectl

# On the master node only
if [[ "$(hostname)" == "k8s-node1.example.com" ]]; then
  # Initialize the Kubernetes master
  sudo kubeadm init --pod-network-cidr=192.168.0.0/16 --kubernetes-version=1.28.1

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

# untaint
# kubectl describe node k8s-node1.example.com | grep Taints
# kubectl taint nodes k8s-node1.example.com node-role.kubernetes.io/control-plane-
# kubectl describe node k8s-node1.example.com | grep Taints
