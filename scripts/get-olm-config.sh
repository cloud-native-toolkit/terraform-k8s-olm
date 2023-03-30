#!/usr/bin/env bash

INPUT=$(tee)

BIN_DIR=$(echo "${INPUT}" | grep "bin_dir" | sed -E 's/.*"bin_dir": ?"([^"]*)".*/\1/g')

if [[ -n "${BIN_DIR}" ]]; then
  export PATH="${BIN_DIR}:${PATH}"
fi

if ! command -v jq 1> /dev/null 2> /dev/null; then
  echo "jq cli not found" >&2
  echo "bin_dir: ${BIN_DIR}" >&2
  ls -l "${BIN_DIR}" >&2
  exit 1
fi

if ! command -v kubectl 1> /dev/null 2> /dev/null; then
  echo "kubectl cli not found" >&2
  echo "bin_dir: ${BIN_DIR}" >&2
  ls -l "${BIN_DIR}" >&2
  exit 1
fi

export KUBECONFIG=$(echo "${INPUT}" | jq -r '.kube_config')

operator_namespace=""
if kubectl get namespace openshift-marketplace 1> /dev/null 2> /dev/null; then
  operator_namespace="openshift-marketplace"
elif kubectl get namespace olm 1> /dev/null 2> /dev/null; then
  operator_namespace="olm"
fi

target_namespace=""
if kubectl get namespace openshift-operators 1> /dev/null 2> /dev/null; then
  target_namespace="openshift-operators"
elif kubectl get namespace operators 1> /dev/null 2> /dev/null; then
  target_namespace="operators"
fi

jq -n --arg operator "${operator_namespace}" --arg target "${target_namespace}" \
  '{"operator_namespace": $operator, "target_namespace": $target, "olm_namespace": $operator}'
