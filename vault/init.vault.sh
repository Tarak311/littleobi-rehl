kubectl create namespace vault
helm repo add hashicorp https://helm.releases.hashicorp.com

    helm install vault hashicorp/vault     --namespace vault     -f vault.override-values.yml 
sudo systemctl daemon-reload
sudo systemctl enable wazuh-agent
sudo systemctl start wazuh-agent


openssl genrsa -out ${TMPDIR}/vault.key 2048
vault auth enable -path k3s  kubernetes

vault write auth/k3s/config  kubernetes_host="https://kubernetes.default.svc.k3s.littleobi.com:443"

vault secrets enable -path=k3s-kv kv-v2

tee k3s-kv.k3s.json <<EOF
path "k3s-kv/data/webapp/config" {
   capabilities = ["read", "list"]
}
EOF
vault write auth/k3s/role/k3s-kv-role \
   bound_service_account_names=demo-sa \
   bound_service_account_namespaces=app \
   policies=k3s-kv.k3s \
   audience=vault \
   ttl=24h
vault kv put k3s-kv/webapp/config username="static-user" password="static-password" 