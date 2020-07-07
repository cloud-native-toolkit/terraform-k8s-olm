#!/usr/bin/env bash

SCRIPT_DIR=$(dirname $0)
SRC_DIR="$(cd "${SCRIPT_DIR}"; pwd -P)"

cd ${SRC_DIR}

rm -rf "${SRC_DIR}/.terraform"
rm -rf "${SRC_DIR}/state"

echo ""

terraform init && terraform apply -auto-approve
