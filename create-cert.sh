
openssl genrsa -out root-ca.key 2048
openssl req -x509 -new -key root-ca.key -sha256 -days 1825 -out root-ca.crt
openssl x509 -in root-ca.crt -out root-ca.pem -outform PEM


openssl genrsa -out intermediate-ca.key 2048
openssl req -new -key intermediate-ca.key -out intermediate-ca.csr 

 openssl x509 -req -in intermediate-ca.csr -CA root-ca.crt -CAkey root-ca.key -CAcreateserial -out intermediate-ca.crt -days 1825 -sha256 -extfile <(printf "basicConstraints=CA:TRUE,pathlen:0\nkeyUsage = cRLSign, keyCertSign\nauthorityKeyIdentifier=keyid,issuer\nsubjectKeyIdentifier=hash")
openssl x509 -in intermediate-ca.crt -out intermediate-ca.pem -outform PEM


#Create folder first
mkdir -p /var/lib/rancher/k3s/server/tls

# Copy your root CA cert and intermediate CA cert+key into the correct location for the script.
# For the purposes of this example, we assume you have existing root and intermediate CA files in /etc/ssl.
# If you do not have an existing root and/or intermediate CA, the script will generate them for you.
cp ./root-ca.pem ./intermediate-ca.pem ./intermediate-ca.key /var/lib/rancher/k3s/server/tls

sudo cp root-ca.crt /usr/local/share/ca-certificates/root-ca.crt
sudo cp root-ca.pem /usr/local/share/ca-certificates/root-ca.crt
sudo update-ca-trust
sudo cp  root-ca.pem /etc/ssl/certs/

kubectl create secret generic ca-cert-secret --from-file=root-ca.pem=/home/tarak311/private/root-ca.pem
