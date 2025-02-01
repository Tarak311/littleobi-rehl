kubectl create secret generic consul-master-token --from-literal=master-token=$MASTERTOCKEN
kubectl create secret generic consul-agent-token --from-literal=agent-token=$AGENTTOCKEN
