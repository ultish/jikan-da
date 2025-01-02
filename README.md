# jikan-da

## Installation

- `git clone <repository-url>` this repository
- `cd jikan-da`
- `pnpm install`

## Running / Development

- `pnpm start`
- Visit your app at [http://localhost:4200](http://localhost:4200).
- Visit your tests at [http://localhost:4200/tests](http://localhost:4200/tests).

## Running with self-signed certificate
- `ember serve --ssl true`

## Running with specific host name
- `ember serve --ssl true --host 192.168.1.2`

## Generate self signed cert
1. generate key `openssl genrsa -out somedomain.key 2048`
2. make `openssl.cnf`
   ```
   [req]
   default_md = sha256
   prompt = no
   req_extensions = req_ext
   distinguished_name = req_distinguished_name
   [req_distinguished_name]
   commonName = *.yourdomain.com
   countryName = US
   stateOrProvinceName = No state
   localityName = City
   organizationName = LTD
   [req_ext]
   keyUsage=critical,digitalSignature,keyEncipherment
   extendedKeyUsage=critical,serverAuth,clientAuth
   subjectAltName = @alt_names
   [alt_names]
   DNS.1=yourdomain.com
   DNS.2=*.yourdomain.com
   ```
3. create csr `openssl req -new -nodes -key somedomain.key -config openssl.cnf -out somedomain.csr`
4. verify csf cn `openssl req -noout -text -in somedomain.csr`
5. sign it `openssl x509 -req -in somedomain.csr -CA selfsignCA.crt -CAkey selfsignCA.key -CAcreateserial -out somedomain.crt -days 1024 -sha256 -extfile openssl.cnf -extensions req_ext`


## GQL Code Generators
- `pnpm run generate`
- see codegen.ts for graphql config
- this will verify your graphql queries, mutations, subscriptions match whats in the graphql schema on the server (as defined by codegen.ts config)
