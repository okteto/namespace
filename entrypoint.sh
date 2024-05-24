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

log_level=$2
if [ ! -z "$log_level" ]; then
  if [ "$log_level" = "debug" ] || [ "$log_level" = "info" ] || [ "$log_level" = "warn" ] || [ "$log_level" = "error" ] ; then
    log_level="--log-level ${log_level}"
  else
    echo "log-level supported: debug, info, warn, error"
    exit 1
  fi
fi

# https://docs.github.com/en/actions/monitoring-and-troubleshooting-workflows/enabling-debug-logging
# https://docs.github.com/en/actions/learn-github-actions/variables#default-environment-variables
if [ "${RUNNER_DEBUG}" = "1" ]; then
  log_level="--log-level debug"
fi

echo running: okteto namespace "$namespace" $personal $log_level
okteto namespace "$namespace" $personal $log_level

echo running: okteto kubeconfig
eval okteto kubeconfig

k="/github/home/.kube/config"
# TODO: update set-output https://github.blog/changelog/2022-10-11-github-actions-deprecating-save-state-and-set-output-commands/
echo "::set-output name=kubeconfig::$k"