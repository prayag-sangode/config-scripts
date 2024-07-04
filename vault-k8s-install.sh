#!/bin/bash

# Create a namespace to install Vault
echo "Creating namespace 'vault'..."
kubectl create ns vault

# Add the HashiCorp Helm repository
echo "Adding HashiCorp Helm repository..."
helm repo add hashicorp https://helm.releases.hashicorp.com

# Update all the repositories to ensure Helm is aware of the latest versions
echo "Updating Helm repositories..."
helm repo update

# Verify the repository by searching for the Vault chart
echo "Searching for Vault chart in Helm repository..."
helm search repo hashicorp/vault

# Create a values file for the Vault Helm chart with Integrated Storage
echo "Creating values file for Vault Helm chart..."
cat > helm-vault-raft-values.yml <<EOF
server:
  affinity: ""
  ha:
    enabled: true
    raft:
      enabled: true
EOF

# Install the Vault Helm chart
echo "Installing Vault Helm chart..."
helm install vault hashicorp/vault --values helm-vault-raft-values.yml -n vault

# Display the status of the Vault installation
echo "Vault installation status:"
helm status vault

# Wait for 30 seconds to ensure Vault pods are up and running
echo "Waiting for Vault pods to be ready..."
sleep 30

# Display all the pods within the Vault namespace
echo "Listing all pods in 'vault' namespace..."
kubectl get po -n vault

# Initialize vault-0 with one key share and one key threshold
echo "Initializing Vault..."
kubectl exec vault-0 -n vault -- vault operator init -key-shares=1 -key-threshold=1 -format=json > cluster-keys.json

# Display the initialization output
echo "Vault initialization output:"
cat cluster-keys.json

# Capture the Vault unseal key
VAULT_UNSEAL_KEY=$(jq -r ".unseal_keys_b64[]" cluster-keys.json)

# Unseal Vault running on the vault-0 pod
echo "Unsealing vault-0..."
kubectl exec vault-0 -n vault -- vault operator unseal $VAULT_UNSEAL_KEY

# Wait for 10 seconds before proceeding to join Raft cluster
sleep 10

# Join the vault-1 and vault-2 pods to the Raft cluster
echo "Joining vault-1 to the Raft cluster..."
kubectl exec -ti vault-1 -n vault -- vault operator raft join http://vault-0.vault-internal:8200

echo "Joining vault-2 to the Raft cluster..."
kubectl exec -ti vault-2 -n vault -- vault operator raft join http://vault-0.vault-internal:8200

# Wait for 10 seconds before proceeding to unseal vault-1 and vault-2
sleep 10

# Unseal vault-1 and vault-2
echo "Unsealing vault-1..."
kubectl exec -ti vault-1 -n vault -- vault operator unseal $VAULT_UNSEAL_KEY

echo "Unsealing vault-2..."
kubectl exec -ti vault-2 -n vault -- vault operator unseal $VAULT_UNSEAL_KEY

# Wait for 10 seconds before final status check
sleep 10

# Display the final status of all Vault pods
echo "Final status of all Vault pods:"
kubectl get po -n vault
