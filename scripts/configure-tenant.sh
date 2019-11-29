#!/bin/env bash

# Configure Dynatrace Tenant
echo Configuring tenant $DT_TENANT_ID

API="https://${DT_TENANT_ID}.live.dynatrace.com/api/config/v1/autoTags"

# Check if rule already exists...
tgrp=$(curl -s -H "Authorization: Api-Token ${DT_API_TOKEN}" -X GET "${API}" | jq '.values[] | select(.name == "deployment_group")')
if [ -z "$tgrp" ]; then
    echo "Create process_group rule."
    curl -s -H "Authorization: Api-Token ${DT_API_TOKEN}" \
      -H 'Content-Type: application/json' \
      -X POST ${API} \
      -d @dt_rule_deployment_group.json
else
    echo "Rule process_group exists."
fi

tgrp=$(curl -s -H "Authorization: Api-Token ${DT_API_TOKEN}" -X GET "${API}" | jq '.values[] | select(.name == "app")')
if [ -z "$tgrp" ]; then
    curl -s -H "Authorization: Api-Token ${DT_API_TOKEN}" \
      -H 'Content-Type: application/json' \
      -X POST ${API} \
      -d @dt_rule_app.json
else
    echo "Rule environment exists."
fi

tgrp=$(curl -s -H "Authorization: Api-Token ${DT_API_TOKEN}" -X GET "${API}" | jq '.values[] | select(.name == "environment")')
if [ -z "$tgrp" ]; then
    curl -s -H "Authorization: Api-Token ${DT_API_TOKEN}" \
      -H 'Content-Type: application/json' \
      -X POST ${API} \
      -d @dt_rule_environment.json
else
    echo "Rule app exists."
fi
set +x