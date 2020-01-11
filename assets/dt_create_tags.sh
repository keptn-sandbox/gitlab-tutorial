#!/bin/env bash

DT_TENANT_ID=$1
DT_API_TOKEN=$2

# bash <(curl -sL https://gitlab.com/checkelmann/dynatrace-pipeline/raw/master/assets/dt_create_tags.sh) $DT_TENANT_ID $DT_API_TOKEN

curl -s -o keptn_project.json https://gitlab.com/checkelmann/dynatrace-pipeline/raw/master/assets/keptn_project.json
curl -s -o keptn_service.json https://gitlab.com/checkelmann/dynatrace-pipeline/raw/master/assets/keptn_service.json
curl -s -o keptn_stage.json https://gitlab.com/checkelmann/dynatrace-pipeline/raw/master/assets/keptn_stage.json

API="https://${DT_TENANT_ID}.live.dynatrace.com/api/config/v1/autoTags"

echo "Creating keptn_project tagging rule..."
curl -s -H "Authorization: Api-Token ${DT_API_TOKEN}" \
    -H 'Content-Type: application/json' \
    -X POST ${API} \
    -d @keptn_project.json

echo "Creating keptn_service tagging rule..."
curl -s -H "Authorization: Api-Token ${DT_API_TOKEN}" \
    -H 'Content-Type: application/json' \
    -X POST ${API} \
    -d @keptn_service.json


echo "Creating keptn_stage tagging rule..."
curl -s -H "Authorization: Api-Token ${DT_API_TOKEN}" \
    -H 'Content-Type: application/json' \
    -X POST ${API} \
    -d @keptn_stage.json

echo "Done!"