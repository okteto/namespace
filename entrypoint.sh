#!/bin/sh
set -e

if [[ ! -z "$OKTETO_CA_CERT" ]]; then
   echo "Custom certificate is provided"
   echo "$OKTETO_CA_CERT" > /usr/local/share/ca-certificates/okteto_ca_cert
   update-ca-certificates
fi

namespace=$1
echo running: okteto namespace "$namespace"
okteto namespace "$namespace"
k="/github/home/.kube/config"
echo "::set-output name=kubeconfig::$k"