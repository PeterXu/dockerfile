#!/bin/bash

export KUBE_ROOT="${KUBE_ROOT:-/opt/kube}"
export KUBE_CONFIG_FILE="${KUBE_CONFIG_FILE:-${KUBE_ROOT}/scripts/config-default.sh}"

source "${KUBE_CONFIG_FILE}"


sed -e "s/{{ pillar\['dns_replicas'\] }}/${DNS_REPLICAS}/g;s/{{ pillar\['dns_domain'\] }}/${DNS_DOMAIN}/g;s/{{ pillar\['dns_server'\] }}/${DNS_SERVER_IP}/g" ${KUBE_ROOT}/yaml/skydns.yaml.in >/tmp/skydns.yaml
cp -f ${KUBE_ROOT}/yaml/kube-system.yaml /tmp


cat >/dev/stdout <<EOF

# If the kube-system namespace isn't already created, create it
kubectl get ns
kubectl create -f /tmp/kube-system.yaml
kubectl create -f /tmp/skydns.yaml

# Check DNS if works
kubectl create -f yaml/busybox.yaml
kubectl get pods busybox
kubectl describe pod busybox
kubectl exec busybox -- nslookup kubernetes.default

EOF

