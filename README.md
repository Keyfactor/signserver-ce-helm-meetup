# Helm Chart for SignServer Community ![Version: 1.0.0](https://img.shields.io/badge/Version-1.0.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 5.9.1](https://img.shields.io/badge/AppVersion-5.9.1-informational?style=flat-square)


Welcome to SignServer – the Open Source Signing Software.

There are two versions of SignServer:
* **SignServer Community** (SignServer CE) - free and open source, OSI Certified Open Source Software, LGPL-licensed subset of SignServer Enterprise
* **SignServer Enterprise** (SignServer EE) - developed and commercially supported by PrimeKey® Solutions

OSI Certified is a certification mark of the Open Source Initiative.

## Prerequisites

- [Kubernetes](http://kubernetes.io) v1.19+
- [Helm](https://helm.sh) v3+

## Getting started

The **SignServer Community Helm Chart** boostraps **SignServer Community** on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

### Add repo
```shell
helm repo add https://github.com/Keyfactor/signserver-ce-helm-meetup
helm repo update
```

### Quick start

1. Customize installation in `values.yaml`. 

2. Create a namespace and a secret with the CA certificate to be used for authenticating administrators:

```shell
kubectl create namespace signserver
kubectl create secret generic ingress-ca --from-file=ca.crt=ManagementCA.pem --namespace signserver
```

3. Install `signserver-ce-helm-meetup` on the Kubernetes cluster:

```shell
helm install signserver-ce signserver-ce-helm-meetup/ --atomic --namespace signserver
```
_See [helm install](https://helm.sh/docs/helm/helm_install/) for command documentation._


### Uninstall chart
```shell
helm uninstall [RELEASE_NAME]
```
This command removes all Kubernetes components associated with this chart and deletes the release.

_See [helm uninstall](https://helm.sh/docs/helm/helm_uninstall/) for command documentation._


## Community Support  

In our Community we welcome contributions. The Community software is open source and community supported, there is no support SLA, but a helpful best-effort Community.

* To report a problem or suggest a new feature, use the **[Issues](../../issues)** tab. 
* If you want to contribute actual bug fixes or proposed enhancements, use the **[Pull requests](../../pulls)** tab.
* Ask the community for ideas: **[SignServer Discussions](https://github.com/Keyfactor/signserver-ce/discussions)**.  
* Read more in our documentation: **[SignServer Documentation](https://doc.primekey.com/signserver)**.
* See release information: **[SignServer Release Information](https://doc.primekey.com/signserver/signserver-release-information)**. 
* Read more on the open source project website: **[SignServer website](https://www.signserver.org/)**.   

## Commercial Support
Commercial support is available for **[SignServer Enterprise](https://www.primekey.com/products/signserver-enterprise/)**.

## License
SignServer Community is licensed under the LGPL license, please see **[LICENSE](LICENSE)**. 

## Related projects 

* [Keyfactor/ansible-ejbca-signserver-playbooks](https://github.com/Keyfactor/ansible-ejbca-signserver-playbooks) 
* [Keyfactor/signserver-tools](https://github.com/Keyfactor/signserver-tools) 
