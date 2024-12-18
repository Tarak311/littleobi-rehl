kubectl create namespace vault
helm repo add hashicorp https://helm.releases.hashicorp.com

    helm install vault hashicorp/vault     --namespace vault     -f vault.override-values.yml 
sudo systemctl daemon-reload
sudo systemctl enable wazuh-agent
sudo systemctl start wazuh-agent