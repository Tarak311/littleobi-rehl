helm repo add teleport https://charts.releases.teleport.dev
kubectl create namespace teleport-cluster
kubectl label namespace teleport-cluster 'pod-security.kubernetes.io/enforce=baseline'
kubectl config set-context --current --namespace=teleport-cluster