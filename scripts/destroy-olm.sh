#!/usr/bin/env bash

SCRIPT_DIR=$(cd $(dirname $0); pwd -P)

if [[ -n "${BIN_DIR}" ]]; then
  export PATH="${BIN_DIR}:${PATH}"
fi

UUID="$1"

if ! kubectl get configmap olm-install -n default 1> /dev/null 2> /dev/null; then
  echo "OLM install configmap not found. Skipping destroy"
  exit 0
fi

OLM_CONFIG=$(kubectl get configmap olm-install -n default -o json | jq -c '.data')

CLUSTER_UUID=$(echo "${OLM_CONFIG}" | jq -r '.uuid')
CLUSTER_VERSION=$(echo "${OLM_CONFIG}" | jq -r '.version')

if [[ "${CLUSTER_UUID}" != "${UUID}" ]]; then
  echo "UUID of module does not match installed OLM. Skipping destroy"
  exit 0
fi

operator-sdk olm uninstall --version "${CLUSTER_VERSION}" || exit 1

kubectl delete configmap olm-install -n default || exit 0
