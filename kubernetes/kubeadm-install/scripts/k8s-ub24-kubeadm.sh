#!/bin/bash

# Install containerd
apt update && apt -y install containerd

# Create directory for containerd and generate default config
mkdir -p /etc/containerd
containerd config default | tee /etc/containerd/config.toml

# Modify containerd configuration (replace sandbox image and enable SystemdCgroup)
sed -i 's#\(sandbox_image =\).*#\1 "registry.k8s.io/pause:3.9"#' /etc/containerd/config.toml
sed -i 's/\(SystemdCgroup =\).*false/\1 true/' /etc/containerd/config.toml

# Restart containerd service
systemctl restart containerd.service

# Update sysctl settings for Kubernetes networking
cat > /etc/sysctl.d/99-k8s-cri.conf <<EOF
net.bridge.bridge-nf-call-iptables=1
net.bridge.bridge-nf-call-ip6tables=1
net.ipv4.ip_forward=1
EOF

# Apply sysctl settings
sysctl --system

# Load required kernel modules
modprobe overlay
modprobe br_netfilter

# Persist kernel module settings
echo -e "overlay\nbr_netfilter" > /etc/modules-load.d/k8s.conf

# Disable swap
swapoff -a
sed -i '/swap.img/s/^/#/' /etc/fstab

# Disable AppArmor profiles for runc and crun
apparmor_parser -R /etc/apparmor.d/runc
apparmor_parser -R /etc/apparmor.d/crun
ln -s /etc/apparmor.d/runc /etc/apparmor.d/disable/
ln -s /etc/apparmor.d/crun /etc/apparmor.d/disable/

# Install Kubernetes packages
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.30/deb/Release.key | gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.30/deb/ /" | tee /etc/apt/sources.list.d/kubernetes.list
apt update
apt -y install kubeadm kubelet kubectl

# Check if the node hostname is 'k8s-node1.example.com' and initialize as master node if true
if [[ "$(hostname)" == "k8s-node1.example.com" ]]; then
    echo "This node is the master node. Initializing Kubernetes master setup..."

    # Initialize Kubernetes master node with pod network CIDR and containerd CRI socket
    kubeadm init --pod-network-cidr=192.168.0.0/16 --cri-socket=unix:///run/containerd/containerd.sock

    # Set up kubeconfig for kubectl
    mkdir -p $HOME/.kube
    sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
    sudo chown $(id -u):$(id -g) $HOME/.kube/config

    # Verify node status
    kubectl get nodes

    # Install Calico as the CNI plugin for pod networking
    wget https://raw.githubusercontent.com/projectcalico/calico/master/manifests/calico.yaml
    kubectl apply -f calico.yaml

    # Verify node and pod status
    kubectl get nodes
    kubectl get pods -A
 
   #Print the join command for other nodes
    kubeadm token create --print-join-command
fi

# untaint
# kubectl describe node k8s-node1.example.com | grep Taints
# kubectl taint nodes k8s-node1.example.com node-role.kubernetes.io/control-plane-
# kubectl describe node k8s-node1.example.com | grep Taints
#kubectl create deployment nginx --image=nginx
#kubectl expose deployment nginx --type="ClusterIP" --port 80

echo "Node setup is complete."
