root@k8s-node1:~# cat write-rbac.sh
#!/bin/bash

read -p "Enter the namespace: " namespace
read -p "Enter the username: " username
read -p "Enter the cluster_name: " cluster_name

if [[ -z "$namespace" || -z "$username" ]]; then
        echo "Please provide both namespace and username";
        exit 1;
fi

echo -e "
apiVersion: v1
kind: ServiceAccount
metadata:
  name: $username
  namespace: $namespace
---
kind: ClusterRole
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: $username-read-write
  namespace: $namespace
rules:
- apiGroups: ['', 'extensions', 'apps']
  resources: ['*']
  verbs: ['*']
- apiGroups: ['batch']
  resources:
  - jobs
  - cronjobs
  verbs: ['*']
---
kind: RoleBinding
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: $username-read-write
  namespace: $namespace
subjects:
- kind: ServiceAccount
  name: $username
  namespace: $namespace
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: $username-read-write" | kubectl apply -f -

tokenName=$(kubectl get sa $username -n $namespace -o 'jsonpath={.secrets[0].name}')
token=$(kubectl get secret $tokenName -n $namespace -o "jsonpath={.data.token}" | base64 -d)
certificate=$(kubectl get secret $tokenName -n $namespace -o "jsonpath={.data['ca\.crt']}")

context_name="$(kubectl config current-context)"
cluster_name="$(kubectl config view -o "jsonpath={.contexts[?(@.name==\"${context_name}\")].context.cluster}")"
server_name="$(kubectl config view -o "jsonpath={.clusters[?(@.name==\"${cluster_name}\")].cluster.server}")"

kubeconfig=kubeconfig-${namespace}-${username}-read-write-$(date '+%F-%H%M%S')

echo -e "apiVersion: v1
kind: Config
preferences: {}

clusters:
- cluster:
    certificate-authority-data: $certificate
    server: $server_name
  name: my-cluster

users:
- name: $username
  user:
    as-user-extra: {}
    client-key-data: $certificate
    token: $token

contexts:
- context:
    cluster: my-cluster
    namespace: $namespace
    user: $username
  name: $namespace

current-context: $namespace" > $kubeconfig

echo "$username's kubeconfig with read-write access was created into `pwd`/$kubeconfig"
echo "If you want to test execute this command \`KUBECONFIG=`pwd`/$kubeconfig kubectl get po\`"
