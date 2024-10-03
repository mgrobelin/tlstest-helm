= About

A helm chart that runs Nginx with a set of given certificates (see `values.yaml`).



= Installing

```
# local
helm upgrade --install somename . 
```

= Configuration

Pass your own Helm values - see `values.yaml` for reference.

```sh
# use your own values file
helm upgrade --install selfsigned . -f selfsigned-values.yaml

# ... or use --set/--set-string
helm upgrade --install foo-example-com --set tls.certCN=foo.example.com --set nginx.image.tag=1.27
``` 

= Testing

```
helm test foo-example-com
```

= Generating TLS certificates

You might want to create your own certificates for testing.

```sh
CANAME="JustAnother Root CA"
CERTNAME="tlstest.local"
# optional, create a directory
mkdir "${CANAME}"
cd "${CANAME}"
# generate aes encrypted private key
openssl genrsa -aes256 -out "${CANAME}.key" 4096
# create ca certificate, valid 10 years
openssl req -x509 -new -nodes -key "${CANAME}.key" -sha256 -days 3650 -out "${CANAME}.crt" -subj "/CN=${CANAME}"
# create certificate for service
openssl req -new -nodes -out "${CERTNAME}.csr" -newkey rsa:4096 -keyout "${CERTNAME}.key" -subj "/CN=${CERTNAME}"
# create a v3 ext file for SAN properties
cat > "${CERTNAME}.v3.ext" << EOF
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
subjectAltName = @alt_names
[alt_names]
DNS.1 = ${CERTNAME}
#DNS.2 = myserver1.local
#IP.1 = 192.168.1.1
#IP.2 = 192.168.2.1
EOF
openssl x509 -req -in "${CERTNAME}.csr" -CA "${CANAME}.crt" -CAkey "${CANAME}.key" -CAcreateserial -out "${CERTNAME}.crt" -days 730 -sha256 -extfile "${CERTNAME}.v3.ext"
```
