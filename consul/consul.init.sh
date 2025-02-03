kubectl create secret generic consul-master-token --from-literal=master-token=$MASTERTOCKEN
kubectl create secret generic consul-agent-token --from-literal=agent-token=$AGENTTOCKEN
 helm install consul hashicorp/consul --set global.name=consul --create-namespace --namespace consul --values values.yml
