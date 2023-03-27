#!/usr/bin/env bash

if [[ -n "${BIN_DIR}" ]]; then
  export PATH="${BIN_DIR}:${PATH}"
fi

OLM_VERSION="$1"
UUID="$2"

if kubectl get crd subscriptions.operators.coreos.com 1> /dev/null 2> /dev/null; then
  echo "OLM is already installed"
  exit 0
fi

if [[ -z "${OLM_VERSION}" ]]; then
  OLM_VERSION="latest"
fi

operator-sdk olm install --version "${OLM_VERSION}" || exit 1

kubectl create configmap olm-install \
  -n default \
  --from-literal="uuid=$UUID" \
  --from-literal="version=${OLM_VERSION}"