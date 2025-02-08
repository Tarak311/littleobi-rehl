sudo yum install curl wget git -y

# Enable Firewall rule for kubernates


 sudo firewall-cmd --permanent  --zone=trusted --add-port=6443/tcp
 sudo firewall-cmd --permanent --zone=trusted --add-port=8472/udp
 sudo firewall-cmd --permanent --zone=trusted --add-port=10250/tcp
 sudo firewall-cmd --permanent --zone=trusted --add-port=51820/udp
 sudo firewall-cmd --permanent --zone=trusted --add-port=51821/udp
 sudo firewall-cmd --permanent --zone=trusted --zone=public --add-source=10.42.0.0/16
 sudo firewall-cmd --permanent --zone=trusted --add-source=10.43.0.0/16
 sudo firewall-cmd --reload

#   

#FOLLOW https://docs.tigera.io/calico/latest/getting-started/kubernetes/k3s/multi-node-install


curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--flannel-backend=none   --cluster-domain k3s.littleobi.com --disable-network-policy --cluster-cidr=192.168.0.0/16 --disable 'traefik' --disable-cloud-controller --write-kubeconfig-mode 644"  sh -

kubectl taint nodes --all node-role.kubernetes.io/control-plane-

sudo cp /usr/bin/kubectl /usr/local/bin/kubectl





#INSTALL Calico
kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.29.0/manifests/tigera-operator.yaml
kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.29.0/manifests/custom-resources.yaml
kubectl delete -f calico 
kubectl apply  -f calico 





##this is golden deployment

    #follow this for cilium  https://docs.cilium.io/en/stable/installation/k3s/
CILIUM_CLI_VERSION=$(curl -s https://raw.githubusercontent.com/cilium/cilium-cli/main/stable.txt)
CLI_ARCH=amd64
if [ "$(uname -m)" = "aarch64" ]; then CLI_ARCH=arm64; fi
curl -L --fail --remote-name-all https://github.com/cilium/cilium-cli/releases/download/${CILIUM_CLI_VERSION}/cilium-linux-${CLI_ARCH}.tar.gz{,.sha256sum}
sha256sum --check cilium-linux-${CLI_ARCH}.tar.gz.sha256sum
sudo tar xzvfC cilium-linux-${CLI_ARCH}.tar.gz /usr/local/bin
rm cilium-linux-${CLI_ARCH}.tar.gz{,.sha256sum}
cilium install --version 1.16.4 --set=ipam.operator.clusterPoolIPv4PodCIDRList="192.168.0.0/16"



please be sure to have all the network check ip forwarding and bridge and stuff

sudo tee /etc/sysctl.d/kubernetes.conf <<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF 

kubectl get pvc -n vault | grep vault  | awk  '{print $2}' | xargs kubectl delete pvc  -n vault
kubectl get pvc -A  |  awk  '{print $2}' | xargs kubectl delete pvc  
helm install consul hashicorp/consul --set global.name=consul --create-namespace --namespace consul --values values.yml
helm upgrade --install postgress bitnami/postgresql -f postgress.yaml -n boundary
 helm install cilium cilium/cilium --version 1.11.0 --namespace kube-system
