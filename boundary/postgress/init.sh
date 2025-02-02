 kubectl create secret generic postpwd --from-literal=password='Tdf!hdjd1234' --from-literal=postgres-password='Tdjfn@6ffgg!'  --from-literal=replication-password='Tdjfn@6ffgg!'    -o yaml | kubectl apply -n boundary -f -
 openssl genrsa -out ${WORKDIR}/boundary.key 2048



[req]
default_bits = 2048
prompt = no
encrypt_key = yes
default_md = sha256
distinguished_name = kubelet_serving
req_extensions = v3_req
[ kubelet_serving ]
O = system:nodes
CN = system:node:*.boundary.svc.k3s.littleobi.com
[ v3_req ]
basicConstraints = CA:FALSE
keyUsage = nonRepudiation, digitalSignature, keyEncipherment, dataEncipherment
extendedKeyUsage = serverAuth, clientAuth
subjectAltName = @alt_names
[alt_names]
DNS.1 = *.boundary.svc.k3s.littleobi.com
DNS.2 = postgress-postgresql-primary
DNS.3 = *.consul   
IP.1 = 127.0.0.1


openssl req -new -key ./boundary.key -out ./boundary.csr -config ./boundary-csr.conf


cat > ${WORKDIR}/boundary.csr.yaml <<EOF
apiVersion: certificates.k8s.io/v1
kind: CertificateSigningRequest
metadata:
   name: boundary.svc
spec:
   signerName: kubernetes.io/kubelet-serving
   expirationSeconds: 8640000
   request: $(cat ${WORKDIR}/boundary.csr|base64|tr -d '\n')
   usages:
   - digital signature
   - key encipherment
   - server auth
EOF
kubectl create -f ${WORKDIR}/boundary.csr.yaml

kubectl certificate approve boundary.svc

kubectl get csr boundary.svc -o jsonpath='{.status.certificate}' | openssl base64 -d -A -out ${WORKDIR}/boundary.pem

kubectl config view \
--raw \
--minify \
--flatten \
-o jsonpath='{.clusters[].cluster.certificate-authority-data}' \
| base64 -d > ${WORKDIR}/root-ca.pem


kubectl create secret generic boundary-certificates-tls-secret --from-file=./boundary.pem --from-file=./boundary.key --from-file=./root-ca.pem


docker run   --network host  -v $HOME/private/root-ca.pem:/boundary/root-ca.pem    -e 'BOUNDARY_POSTGRES_URL=postgresql://postgres:Tdjfn@6ffgg!@0.0.0.0:5432/postgres?sslmode=require'   boundary database init -config /boundary/config.hcl

   

helm upgrade --install postgress bitnami/postgresql -f postgress.yaml -n boundary   

kubectl label service postgress-postgresql-primary-hl consul.hashicorp.com/service-ignore="true" -n boundary
# do this for read only