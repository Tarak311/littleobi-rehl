kubectl create secret generic consul-master-token --from-literal=master-token=$MASTERTOCKEN
kubectl create secret generic consul-agent-token --from-literal=agent-token=$AGENTTOCKEN
 helm install consul hashicorp/consul --set global.name=consul --create-namespace --namespace consul --values values.yml






 TLS 
#!/bin/sh

# NAME is set to either the value from `global.name` from your Consul K8s value file, or your $HELM_RELEASE_NAME-consul
export NAME=consul
# NAMESPACE is where the Consul on Kubernetes is installed
export NAMESPACE=consul
# DATACENTER is the value of `global.datacenter` from your Helm values config file
export DATACENTER=dc1

echo allowed_domains=\"$DATACENTER.consul, $NAME-server, $NAME-server.$NAMESPACE, $NAME-server.$NAMESPACE.svc\"

 vault write pki_int/roles/consul-server \
    allowed_domains="dc1.consul, consul-server, consul-server.consul, consul-server.consul.svc" \
    allow_subdomains=true \
    allow_bare_domains=true \
    allow_localhost=true \
    max_ttl="720h"



vault write auth/kubernetes/role/consul-server \
    bound_service_account_names=consul-server \
    bound_service_account_namespaces=consul \
    policies=consul-server \
    ttl=1h


vault write auth/kubernetes/role/consul-client \
    bound_service_account_names=consul-client  \
    bound_service_account_namespaces=default \
    policies=ca-policy \
    ttl=1h


For Setting up Server TLS follow this
https://developer.hashicorp.com/consul/docs/k8s/deployment-configurations/vault/data-integration/server-tls#bootstrapping-the-pki-engine

apt install  iputils-ping tcpdump net-tools dnsutils