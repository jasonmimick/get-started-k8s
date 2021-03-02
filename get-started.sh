#!/usr/bin/env bash

PUBLIC_KEY=${1}
PRIVATE_KEY=${2}
ORG_ID=${3}

echo "NOTE - this Get-Started needs an Org-Level Cloud Manager API key with at least PROJECT_CREATOR role"

if [ -z ${PUBLIC_KEY} ]
then
    read -p "MongoDB Atlas Public Key (Required): " PUBLIC_KEY
fi
if [ -z ${PRIVATE_KEY} ]
then
    read -p "MongoDB Atlas Private Key (Required): " PRIVATE_KEY
fi
if [ -z ${ORG_ID} ]
then
    read -p "MongoDB Atlas Org Id (Required): " ORG_ID
fi

GETSTARTED_NAME=${4-"get-started-k8s"}
NAMESPACE=${5:-mongodb}
CONFIGMAP_NAME=${6-"get-started-k8s"}
SECRET_NAME=${7-"get-started-k8s"}

echo "Launching new get-started-k8s name: ${GETSTARTED_NAME}, namespace=${NAMESPACE}"
echo "Details: CONFIGMAP_NAME=${CONFIGMAP_NAME}, SECERT_NAME=${SECRET_NAME}"

kubectl create ns ${NAMESPACE}


kubectl create secret generic "${SECRET_NAME}" -n ${NAMESPACE} \
    --from-literal="user=${PUBLIC_KEY}" \
    --from-literal="publicApiKey=${PRIVATE_KEY}"

kubectl get secret -n ${NAMESPACE} "${SECRET_NAME}" --output=yaml

kubectl -n ${NAMESPACE} \
  create configmap "${CONFIGMAP_NAME}" \
  --from-literal="baseUrl=https://cloud.mongodb.com" \
  --from-literal="projectName=${GETSTARTED_NAME}" \
  --from-literal="orgId=${ORG_ID}"

kubectl get configmap -n ${NAMESPACE} "${SECRET_NAME}" --output=yaml

#helm install -n mongodb mongodb-operator mongodb/mongodb-enterprise-operator

helm upgrade -n ${NAMESPACE} --install \
    "${GETSTARTED_NAME}" mongodb/mongodb-enterprise-database \
    --set opsManager.configMap=${CONFIGMAP_NAME} \
    --set opsManager.secretRef=${SECRET_NAME} \
    --set additionalMongodConfig="storageEngine: inMemory" \
    --set meta.helm.sh/release-name=${GETSTARTED_NAME} \

