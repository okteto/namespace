#!/bin/sh
set -e

namespace=$1
personal=""
if [ -z $namespace ]; then
  personal="--personal"
fi

if [ ! -z "$OKTETO_CA_CERT" ]; then
   echo "Custom certificate is provided"
   echo "$OKTETO_CA_CERT" > /usr/local/share/ca-certificates/okteto_ca_cert.crt
   update-ca-certificates
fi

echo running: okteto namespace "$namespace" $personal
okteto namespace "$namespace" $personal

echo running: okteto kubeconfig
eval okteto kubeconfig

k="/github/home/.kube/config"
echo "::set-output name=kubeconfig::$k"