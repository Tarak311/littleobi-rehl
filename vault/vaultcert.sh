export VAULT_K8S_NAMESPACE="vault" \
export VAULT_HELM_RELEASE_NAME="vault" \
export VAULT_SERVICE_NAME="vault-internal" \
export K8S_CLUSTER_NAME="k3s.littleobi.com" \
export WORKDIR=/tmp/vault
openssl genrsa -out ${WORKDIR}/vault.key 2048