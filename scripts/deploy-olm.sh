#!/usr/bin/env bash

OLM_VERSION="$1"

echo "CLUSTER_TYPE: ${CLUSTER_TYPE}"
if [[ "${CLUSTER_TYPE}" == "ocp4" ]]; then
  echo "Cluster version already has OLM: ${CLUSTER_VERSION}"
  exit 0
fi

if [[ "${CLUSTER_TYPE}" == "ocp3" ]]; then
  echo "Installing on OCP 3. Downgrading version to 0.14.1"
  OLM_VERSION="0.14.1"
fi

curl -sL "https://github.com/operator-framework/operator-lifecycle-manager/releases/download/${OLM_VERSION}/install.sh" | bash -s "${OLM_VERSION}"
