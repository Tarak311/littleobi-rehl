sudo yum install curl wget git -y

# Enable Firewall rule for kubernates


 sudo firewall-cmd --permanent --add-port=6443/tcp
 sudo firewall-cmd --permanent --add-port=8472/udp
 sudo firewall-cmd --permanent --add-port=10250/tcp
 sudo firewall-cmd --permanent --add-port=51820/udp
 sudo firewall-cmd --permanent --add-port=51821/udp
 sudo firewall-cmd --permanent --zone=trusted --add-source=10.42.0.0/16
 sudo firewall-cmd --permanent --zone=trusted --add-source=10.43.0.0/16
 sudo firewall-cmd --reload

#curl -sfL https://get.k3s.io | sh -

#FOLLOW https://docs.tigera.io/calico/latest/getting-started/kubernetes/k3s/multi-node-install


curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--flannel-backend=none --cluster-domain k3s.littleobi.com --cluster-cidr=192.168.0.0/16" sh -

kubectl taint nodes --all node-role.kubernetes.io/control-plane-

sudo cp /usr/bin/kubectl /usr/local/bin/kubectl

#INSTALL Calico
kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.29.0/manifests/tigera-operator.yaml
kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.29.0/manifests/custom-resources.yaml

#NFS

#https://github.com/kubernetes-csi/csi-driver-nfs

git clone https://github.com/kubernetes-csi/csi-driver-nfs.git
cd csi-driver-nfs
./deploy/install-driver.sh v4.9.0 local


 curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

 kubectl create -f https://raw.githubusercontent.com/kubernetes-csi/csi-driver-nfs/master/deploy/example/nfs-provisioner/nfs-server.yaml