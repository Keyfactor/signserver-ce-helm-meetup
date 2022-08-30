# signserver-ce-helm-meetup
SignServer CE Helm chart and resources for Community Tech Meetup

Before running, you must create a secret with the CA certificate to be used for authenticating administrators:

`kubectl create secret generic ingress-ca --from-file=ca.crt=ManagementCA.pem`
