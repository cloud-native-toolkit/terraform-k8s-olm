#!/usr/bin/env bash

CLUSTER_TYPE="$1"

OUTER_LENGTH=$(yq r ./resources.yaml --length)

outer_index=0

while [ $outer_index -lt "${OUTER_LENGTH}" ]; do
  NAMESPACE=$(yq read ./resources.yaml "[$outer_index].namespace")

  echo "Verifying resources in $NAMESPACE namespace"

  LENGTH=$(yq r ./resources.yaml "[$outer_index].resources" --length)

  index=0
  while [ $index -lt "${LENGTH}" ]; do
    kind=$(yq r ./resources.yaml "[$outer_index].resources[$index].kind")
    name=$(yq r ./resources.yaml "[$outer_index].resources[$index].name")
    label=$(yq r ./resources.yaml "[$outer_index].resources[$index].label")

    destroy=$(yq r ./resources.yaml "[$outer_index].resources[$index].destroy")
    when_field=$(yq r ./resources.yaml "[$outer_index].resources[$index].when.field")
    when_operation=$(yq r ./resources.yaml "[$outer_index].resources[$index].when.operation")
    when_value=$(yq r ./resources.yaml "[$outer_index].resources[$index].when.value")

    if [[ -z "$when_operation" ]]; then
      when_operation="equal"
    fi

    index=$((index + 1))

    if [[ -n $when_field ]] && [[ -n $when_value ]]; then
      if [[ "$when_operation" == "equal" ]]; then
        if [[ "${!when_field}" != "$when_value" ]]; then
          continue
        fi
      else
        if [[ "${!when_field}" == "$when_value" ]]; then
          continue
        fi
      fi
    fi

    if [[ "${NAMESPACE}" == "*" ]]; then
      namespace="--all-namespaces"
    else
      namespace="-n ${NAMESPACE}"
    fi

    if [[ "$destroy" == "false" ]]; then
      destroy_description="no destroy"
    else
      destroy_description="destroy"
    fi

    if [[ -n $name ]]; then
      echo "  Verifying $destroy_description of $kind/$name"

      if kubectl get $namespace $kind $name 1> /dev/null 2> /dev/null; then
        if [[ "$destroy" != "false" ]]; then
          echo "    Error: Found unexpected resources after destroy: $kind/$name"
          exit 1
        fi
      elif [[ "$destroy" == "false" ]]; then
        echo "    Error: Missing expected resource(s) after destroy: $kind/$name"
        exit 1
      fi
    else
      description=""
      command_args=""
      if [[ -n $label ]]; then
        description="with label=$label"
        command_args="-l $label"
      fi

      echo "  Verifying $destroy_description of $kind $description"

      resource_count=$(kubectl get $namespace $kind $command_args -o jsonpath='{range .items[*]}{.metadata.name}{"\n"}{end}' | wc -l)

      if [[ "$resource_count" -gt 0 ]]; then
        if [[ "$destroy" != "false" ]]; then
          echo "    Error: Found unexpected resources after destroy: $kind $command_args"
          kubectl get $namespace $kind $command_args
          exit 1
        fi
      elif [[ "$destroy" == "false" ]]; then
        echo "    Error: Missing expected resource(s) after destroy: $kind $command_args"
        exit 1
      fi
    fi
  done

  outer_index=$((outer_index + 1))
done
