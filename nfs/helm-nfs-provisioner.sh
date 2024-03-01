helm repo ls
helm repo add nfs-subdir-external-provisioner https://kubernetes-sigs.github.io/nfs-subdir-external-provisioner/
helm install nfs-client -n kube-system --set nfs.server=localhost --set nfs.path=/data/export nfs-subdir-external-provisioner/nfs-subdir-external-provisioner
helm repo ls
helm -n kube-system ls
