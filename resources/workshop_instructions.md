# Workshop Part 2a: ​Deploying SignServer ​with Helm​

## Clone SignServer Helm Repo​

```shell
git clone https://github.com/Keyfactor/signserver-ce-helm-meetup.git
```

## Configure Authentication Secret​

```shell
kubectl create namespace signserver​
```

```shell
kubectl create secret generic ingress-ca --from-file=ca.crt=ManagementCA.pem -n signserver
```

## Install SignServer​ Helm Chart​

Edit helm chart values.yaml file:​
```shell
vi signserver-ce-helm-meetup/values.yaml
```

Install SignServer with Helm:​
```shell
cd signserver-ce-helm-meetup​
helm install signserver-ce . --atomic -n signserver​
```

Confirm that the deployments are ready:
```shell
kubectl get deployments -n signserver
```

# Workshop Part 2b: Container Signing with Cosign​

## Container Validation with Connaisseur​

Extract the public key from your signer keystore:​
```shell
openssl pkcs12 -in sample_signer_keystore.p12 -nokeys -clcerts | openssl x509 -pubkey -noout
```

Edit connaisseur/helm/values.yaml file:
```shell
validators:
  - name: allow
    type: static
    approve: true
  - name: signserver-cosign-signature
    type: cosign
    trust_roots:
      - name: default
        key: |
          -----BEGIN PUBLIC KEY-----
          MFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcDQgAEeFd2Qc/zkLJ0wI5htxILOcD9Xzyg
          NrWseN4tSzxqMQVZM4TWBAAJpb09/gWxWxbbWJHDdM8SO8sRFvD3PAkmFQ==
          -----END PUBLIC KEY-----

policy:
  # Allow all containers
  - pattern: "*:*"
    validator: allow
  # Only allow signed containers from ttl.sh. Supersedes allow all
  - pattern: "ttl.sh/*:*"
    validator: signserver-cosign-signature
```

Install Connaisseur to enable container validation in Kubernetes:​
```shell
helm install connaisseur connaisseur/helm --atomic --create-namespace --namespace connaisseur​
```

## Create Container Image with Buildah​

Generate a UUID for the container name:
```shell
IMAGE_NAME=$(uuidgen)
```

Build container image:
```shell
buildah build-using-dockerfile -f ./Dockerfile -t ttl.sh/${IMAGE_NAME}:1h .
```

## Push Container Image to ttl.sh Registry

Upload your image to the test registry ttl.sh:
```shell
buildah push ttl.sh/${IMAGE_NAME}:1h
```

Test deploying your unsigned image:
```shell
kubectl create deployment unsigned-container --image=ttl.sh/${IMAGE_NAME}:1h
```

## Sign Container Image with Cosign and SignServer

Generate an unsigned payload for your image:
```shell
cosign generate ttl.sh/${IMAGE_NAME}:1h > ${IMAGE_NAME}-payload.json
```

Sign the payload with SignServer:
```shell
curl -F workerName=PlainSigner -F file=@${IMAGE_NAME}-payload.json --output ${IMAGE_NAME}-payload.sig http://<Your EC2 Instance>/signserver/process
```

Convert signed payload to base64:
```shell
cat ${IMAGE_NAME}-payload.sig | base64 > ${IMAGE_NAME}-payload.sig.b64
```

Attach signed payload to your registry image:
```shell
cosign attach signature --payload ${IMAGE_NAME}-payload.json --signature ${IMAGE_NAME}-payload.sig.b64 ttl.sh/${IMAGE_NAME}:1h
```

## Verifying Signed Container Images

Deploy your signed image:
```shell
kubectl create deployment signed-container --image=ttl.sh/${IMAGE_NAME}:1h
```

Manually verify image signatures with cosign:
```shell
cosign verify --cert <PlainSigner certificate> ttl.sh/${IMAGE_NAME}:1h​
```
or​
```shell
cosign verify –-key <PlainSigner public key> ttl.sh/${IMAGE_NAME}:1h​
```
