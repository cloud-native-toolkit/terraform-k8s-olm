#!/usr/bin/env bash

SCRIPT_DIR=$(cd $(dirname "$0"); pwd -P)

if [[ -n "${BIN_DIR}" ]]; then
  export PATH="${BIN_DIR}:${PATH}"
fi

OLM_VERSION="$1"

if kubectl get project.project.openshift.io 1> /dev/null 2> /dev/null; then
  echo "Cluster version already has OLM: ${CLUSTER_VERSION}"
  exit 0
fi

"${SCRIPT_DIR}/install.sh" "${OLM_VERSION}"
