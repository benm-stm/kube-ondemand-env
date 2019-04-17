#!/bin/bash

#gcloud auth
KUBE_CRT=$(mktemp)
cat <<< "${DEVELOPMENT_KUBE_CA}" > ${KUBE_CRT}
chmod 0600 ${KUBE_CRT}
kubectl config set-cluster on-demand-env --server=${DEVELOPMENT_KUBE_URI} --certificate-authority=${KUBE_CRT}
kubectl config set-credentials admin --username=${DEVELOPMENT_KUBE_USER} --password=${DEVELOPMENT_KUBE_PASS}
kubectl config set-context on-demand-env --cluster=on-demand-env --user=${DEVELOPMENT_KUBE_USER}
kubectl config use-context on-demand-env

#helm init
helm init --kube-context on-demand-env --client-only

#run deployments cleanup
helm ls --namespace=on-demand-env
helm ls --namespace=on-demand-env | awk -v now_sec=$(date +%s) -v threshold=${THRESHOLD} -v dry_run=${DRY_RUN} -v now=$(date '+%Y-%m-%d,%H:%M') -f delete-old-deployments.awk