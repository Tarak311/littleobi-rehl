# SERVICE is the name of the Vault service in kubernetes.
# It does not have to match the actual running service, though it may help for consistency.
export SERVICE=vault.vault.svc.k3s.littleobi.com

# NAMESPACE where the Vault service is running.
export NAMESPACE=vault

# SECRET_NAME to create in the kubernetes secrets store.
export SECRET_NAME=vault-server-tls

# TMPDIR is a temporary working directory.
export TMPDIR=/tmp

# CSR_NAME will be the name of our certificate signing request as seen by kubernetes.
export CSR_NAME=vault-csr