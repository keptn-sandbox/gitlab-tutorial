#!/bin/env bash

kubectl create namespace dynatrace
LATEST_RELEASE=$(curl -s https://api.github.com/repos/dynatrace/dynatrace-oneagent-operator/releases/latest | grep tag_name | cut -d '"' -f 4)
kubectl create -f https://raw.githubusercontent.com/Dynatrace/dynatrace-oneagent-operator/$LATEST_RELEASE/deploy/kubernetes.yaml
kubectl -n dynatrace logs -f deployment/dynatrace-oneagent-operator
kubectl -n dynatrace create secret generic oneagent --from-literal="apiToken=${DT_API_TOKEN}" --from-literal="paasToken=${DT_PAAS_TOKEN}"

curl -o cr.yaml https://raw.githubusercontent.com/Dynatrace/dynatrace-oneagent-operator/$LATEST_RELEASE/deploy/cr.yaml
sed -i -- s/ENVIRONMENTID/${DT_TENANT_ID}/g cr.yaml
kubectl create -f cr.yaml