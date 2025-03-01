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
helm install longhorn longhorn/longhorn --namespace longhorn-system --create-namespace -f values.yaml
curl https://api.cloudflare.com/client/v4/accounts/3a87f03414d4f450308a9d3376f5ab5c/cfd_tunnel/0a3c7ff3-f6d3-4fe4-a239-be2913ce46f6/tocken \
    -H "X-Auth-Email: tarak311@outlook.com" \
    -H "X-Auth-Key: A_OMuzf8wQPRDB5I07HidYVKWsAfGKPwKzsL-GaX"



# Vault - Kube config

vault secrets enable -path=cloudflare kv-v2
vault secrets enable -path=internal kv-v2
MY_PASSWORD="P0lkaD@nce43"
ACCOUNTNAME='tarak311iam'
# 1)Enable Vault UserPass
vault auth enable userpass
# 2) Get Accessor id
USERPASS_ACCESSOR=$(vault auth list | grep userpass | awk '{print $3}')
/sys/mounts
# 3) create User 

vault write auth/userpass/users/$ACCOUNTNAME password=$MY_PASSWORD
# 4) find entity id of Admin

ENTITY_ID=$(vault write -field=id identity/entity name=$ACCOUNTNAME)


# 5) Create alies

vault write identity/entity-alias name=$ACCOUNTNAME canonical_id="$ENTITY_ID" mount_accessor="$USERPASS_ACCESSOR"


# 6) Enable MFA  - create method id

METHOD_ID=$(vault write -field=method_id identity/mfa/method/totp issuer=HCP-Vault-$ACCOUNTNAME period=30 key_size=30 qr_size=200 algorithm=SHA256 digits=6 name=$ACCOUNTNAME)

vault read identity/mfa/method/totp/$METHOD_ID


# 7) Genrate token

vault write identity/mfa/method/totp/admin-generate method_id=$METHOD_ID entity_id=$ENTITY_ID



# 8) Login enforcement

vault write identity/mfa/login-enforcement/userpass  mfa_method_ids="$METHOD_ID" auth_method_accessors="$USERPASS_ACCESSOR"






vault write auth/kubernetes/role/cloudflaredtoken bound_service_account_names=cloudflared-sa bound_service_account_namespaces=consul policies=cloudflaredtoken ttl=24h



vault kv put cloudflare/data/cloudflardtoken/rehl TunnelID="0a3c7ff3-f6d3-4fe4-a239-be2913ce46f6" token="eyJhIjoiM2E4N2YwMzQxNGQ0ZjQ1MDMwOGE5ZDMzNzZmNWFiNWMiLCJ0IjoiMGEzYzdmZjMtZjZkMy00ZmU0LWEyMzktYmUyOTEzY2U0NmY2IiwicyI6IllUbGpNamxrWkRBdE4yVXpaQzAwTWpWbExXSmtNV1F0WWpFek5EazVZbVJrT0RWaiJ9"



TOKEN_REVIEWER_JWT_COMMAND=$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)

vault write auth/kubernetes/config kubernetes_host=https://kubernetes.default.svc.k3s.littleobi.com  kubernetes_ca_cert=@/var/run/secrets/kubernetes.io/serviceaccount/ca.crt
Success! Data written to: auth/kubernetes/config



# unseal vault

jq -r ".unseal_keys_b64[]" /tmp/vault/cluster-keys.json | xargs -I {] kubectl exec -n vault vault-0 -- vault operator unseal {}







curl --request POST  --data '{"jwt": "$TOKEN_REVIEWER_JWT_COMMAND", "role": "cloudflaredtoken"}' https://10.43.145.9:8200/v1/auth/kubernetes/login -k










curl --request POST --data '{"jwt": "$TKNVLT" , "role": "cloudflaredtoken"}' https://10.43.74.70:8200/v1/auth/kubernetes/login -k











curl \
    --request POST \
    --data '{"jwt": "eyJhbGciOiJSUzI1NiIsImtpZCI6ImxCNjZXdDJHR1MxeWJ3cEpTdmRMTXE3WmZ4Z1F0NmlqUDZaMjRvcENvSUkifQ.eyJhdWQiOlsiaHR0cHM6Ly9rdWJlcm5ldGVzLmRlZmF1bHQuc3ZjLmszcy5saXR0bGVvYmkuY29tIiwiazNzIl0sImV4cCI6MTczOTcyOTY1OSwiaWF0IjoxNzM5NzI2MDU5LCJpc3MiOiJodHRwczovL2t1YmVybmV0ZXMuZGVmYXVsdC5zdmMuazNzLmxpdHRsZW9iaS5jb20iLCJqdGkiOiI3NTRmNDdjOS01ZmVkLTQ3YTgtYmU5NS1kNmQxNzk1MWFkMGEiLCJrdWJlcm5ldGVzLmlvIjp7Im5hbWVzcGFjZSI6ImNvbnN1bCIsInNlcnZpY2VhY2NvdW50Ijp7Im5hbWUiOiJjbG91ZGZsYXJlZC1zYSIsInVpZCI6ImIzNDdmNWMxLTM4NTUtNGUwOC1iN2Y4LWRjODUwMGZiMTBhYSJ9fSwibmJmIjoxNzM5NzI2MDU5LCJzdWIiOiJzeXN0ZW06c2VydmljZWFjY291bnQ6Y29uc3VsOmNsb3VkZmxhcmVkLXNhIn0.J5IvTkDs6Gjn6P_cFM9Y4I73DsM4Qshv9gj214IepI8l7rJz9oOtrl1OpHOimlTE4YgTewImOCyDe_jsIGiA2stJSxBkStsiQahQT5bFhjDLdh7qwKdfIA2wD3RyNMDPY8FtwAUzz2D69eeCQWpjRo907zynTJ39s2VMNobWaabYRT3o6rm-Te-ZI09k9qxbQ4StRB4TdV14gYurDjTDTuw1XKRrq8ICzLZcpIV4fyS0-EoNktaIBGvawU1gIboKrzTwfAlDFejRwZEFX6QelCv8pweL5d_9idgrpO2qRyJnqSYzRIZtwszBgRDhx33maYd6gNoYXDo65V-tXdvgOA", "role": "cloudflaredtoken"}' \
    https://10.43.145.9:8200/v1/auth/kubernetes/login -k




curl -L --output cloudflared.rpm https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-x86_64.rpm && 

sudo yum localinstall -y cloudflared.rpm && 

sudo cloudflared service install eyJhIjoiM2E4N2YwMzQxNGQ0ZjQ1MDMwOGE5ZDMzNzZmNWFiNWMiLCJ0IjoiMGEzYzdmZjMtZjZkMy00ZmU0LWEyMzktYmUyOTEzY2U0NmY2IiwicyI6IllUbGpNamxrWkRBdE4yVXpaQzAwTWpWbExXSmtNV1F0WWpFek5EazVZbVJrT0RWaiJ9