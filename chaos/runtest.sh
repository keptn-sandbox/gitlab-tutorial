#!/bin/env bash

echo "Running tests for ${APPLICATION_SHORT_NAME} in ${CI_ENVIRONMENT_SLUG}..."

# Annotate deployment for chaos
kubectl annotate deploy/${APPLICATION_SHORT_NAME} litmuschaos.io/chaos="true" -n ${CI_ENVIRONMENT_SLUG}

# Get a worker node to run drain node test
export NODENAME=$(kubectl get pods -n test -l app.kubernetes.io/name=${APPLICATION_SHORT_NAME} -o jsonpath='{.items[0].spec.nodeName}')

echo "Selected node for Drain-Test: ${NODENAME}"
# Cordon node, so litmus will not run his containers on this node
kubectl cordon ${NODENAME}

# Prepare Chaosengine
envsubst < chaosengine.yaml > chaosengine-${APPLICATION_SHORT_NAME}.yaml

# Create Resources
kubectl create -f rbac.yaml -n ${CI_ENVIRONMENT_SLUG}
kubectl create -f https://hub.litmuschaos.io/api/chaos?file=charts/generic/experiments.yaml -n ${CI_ENVIRONMENT_SLUG}
kubectl create -f chaosengine-${APPLICATION_SHORT_NAME}.yaml -n ${CI_ENVIRONMENT_SLUG}

# Wait till runner status is completed
status=$(kubectl get pods -n test|grep engine-${APPLICATION_SHORT_NAME}-runner|awk '{print $3}')
fin="0"    
until [ "$fin" == "1" ]
do
    cnt=$((cnt + 1))
    status=$(kubectl get pods -n test|grep engine-${APPLICATION_SHORT_NAME}-runner|awk '{print $3}')
    if [ "$status" == "Completed" ]; then
        fin="1"
    else
        echo "Chaos tests still running (${cnt}/200)..."
        sleep 5
    fi
    if [ "$cnt" == "200" ]; then
        echo "Chaos tests timed out!"
        exit 1
    fi
done

# Get results
kubectl describe chaosresult engine-${APPLICATION_SHORT_NAME}-container-kill -n ${CI_ENVIRONMENT_SLUG} > result-container-kill.tmp
kubectl describe chaosresult engine-${APPLICATION_SHORT_NAME}-pod-network-loss -n ${CI_ENVIRONMENT_SLUG} > result-pod-network-loss.tmp
kubectl describe chaosresult engine-${APPLICATION_SHORT_NAME}-pod-cpu-hog -n ${CI_ENVIRONMENT_SLUG} > result-pod-cpu-hog.tmp
kubectl describe chaosresult engine-${APPLICATION_SHORT_NAME}-node-drain -n ${CI_ENVIRONMENT_SLUG} > result-node-drain.tmp

# Uncordon node
kubectl uncordon ${NODENAME}

# Clean up
kubectl delete -f rbac.yaml -n ${CI_ENVIRONMENT_SLUG}
kubectl delete -f https://hub.litmuschaos.io/api/chaos?file=charts/generic/experiments.yaml -n ${CI_ENVIRONMENT_SLUG}
kubectl delete -f chaosengine-${APPLICATION_SHORT_NAME}.yaml -n ${CI_ENVIRONMENT_SLUG}
rm chaosengine-${APPLICATION_SHORT_NAME}.yaml