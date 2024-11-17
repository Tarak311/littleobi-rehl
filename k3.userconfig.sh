 rm -rf ~/.kube
 mkdir ~/.kube
 sudo cp /etc/rancher/k3s/k3s.yaml ~/.kube/config
 sudo chown tarak311 ~/.kube/config
 sudo chmod 600 ~/.kube/config
 export KUBECONFIG=~/.kube/config