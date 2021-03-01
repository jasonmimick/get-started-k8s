#!/usr/bin/env bash

NAMESPACE=${1:-mongodb}
echo "Deleting get-started-k8s namespace=${NAMESPACE}"
kubectl delete ns "${NAMESPACE}"

kubectl delete role mongodb-enterprise-operator


