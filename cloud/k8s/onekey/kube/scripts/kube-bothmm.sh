#!/bin/bash


export roles="ai"
export IFACE="${IFACE:-eno16777736}"
export nodes="$(ifconfig ${IFACE} | grep "inet addr:" | cut -d':' -f2 |  cut -d' ' -f1)"
export MASTER_IP=${MASTER_IP:-${nodes}}

export KUBE_ROOT="${KUBE_ROOT:-/opt/kube}"
export KUBE_CONFIG_FILE="${KUBE_CONFIG_FILE:-${KUBE_ROOT}/scripts/config-default.sh}"


echo "[INFO] role: $roles, $nodes, $MASTER_IP <${IFACE}>"
echo "[INFO] path: $KUBE_ROOT, $KUBE_CONFIG_FILE"

#exit 0

# load env
source "${KUBE_CONFIG_FILE}"
source "${KUBE_ROOT}/scripts/util.sh"

## ========================================


# clean previous
rm -rf ${KUBE_ROOT}/default/*

# copy master/minion upstart srcripts
cp -f ${KUBE_ROOT}/ubuntu/master/init_conf/* /etc/init/
cp -f ${KUBE_ROOT}/ubuntu/master/init_scripts/* /etc/init.d/
cp -f ${KUBE_ROOT}/ubuntu/minion/init_conf/* /etc/init/
cp -f ${KUBE_ROOT}/ubuntu/minion/init_scripts/* /etc/init.d/

# copy master-flannel upstart scripts
if [ -z "$CNI_PLUGIN_CONF" ] || [ -z "$CNI_PLUGIN_EXES" ]; then
    cp -f ${KUBE_ROOT}/ubuntu/master-flannel/init_conf/* /etc/init/
    cp -f ${KUBE_ROOT}/ubuntu/master-flannel/init_scripts/* /etc/init.d/
    cp -f ${KUBE_ROOT}/ubuntu/minion-flannel/init_conf/* /etc/init/
    cp -f ${KUBE_ROOT}/ubuntu/minion-flannel/init_scripts/* /etc/init.d/
    NEED_RECONFIG_DOCKER=true
    SERVICE_STARTS="service flanneld start"
else
    NEED_RECONFIG_DOCKER=false
fi

# set sans
EXTRA_SANS=(
    IP:$MASTER_IP
    IP:${SERVICE_CLUSTER_IP_RANGE%.*}.1
    DNS:kubernetes
    DNS:kubernetes.default
    DNS:kubernetes.default.svc
    DNS:kubernetes.default.svc.cluster.local
)
EXTRA_SANS=$(echo "${EXTRA_SANS[@]}" | tr ' ' ,)

# create etcd
create-etcd-opts "${MASTER_IP}"

# create kube-apiserver
create-kube-apiserver-opts \
    "${SERVICE_CLUSTER_IP_RANGE}" \
    "${ADMISSION_CONTROL}" \
    "${SERVICE_NODE_PORT_RANGE}" \
    "${MASTER_IP}"

# create kube-controoler
create-kube-controller-manager-opts "${NODE_IPS}"

# create kube-scheduler
create-kube-scheduler-opts


#-> create kubelet
create-kubelet-opts \
    "${MASTER_IP}" \
    "${MASTER_IP}" \
    "${DNS_SERVER_IP}" \
    "${DNS_DOMAIN}" \
    "${KUBELET_CONFIG}" \
    "${CNI_PLUGIN_CONF}"

#-> create kube-proxy
create-kube-proxy-opts \
    "${MASTER_IP}" \
    "${MASTER_IP}" \
    "${KUBE_PROXY_EXTRA_OPTS}"


# create flanneld
create-flanneld-opts '127.0.0.1' "${MASTER_IP}"
export FLANNEL_OTHER_NET_CONFIG="${FLANNEL_OTHER_NET_CONFIG}"

# copy master upstart config
cp -f ${KUBE_ROOT}/default/* /etc/default/

# make certs
groupadd -f -r kube-cert
export DEBUG="${DEBUG}" 
${KUBE_ROOT}/generate-cert/make-ca-cert.sh "${MASTER_IP}" "${EXTRA_SANS}"


# service start
bins="kubectl kube-apiserver kube-controller-manager kube-scheduler etcd etcdctl flanneld"
bins="$bins kubelet kube-proxy flanneld"
${KUBE_ROOT}/scripts/kube-bin.sh $bins || exit 1
systemctl daemon-reload
service etcd start

$SERVICE_STARTS

if ${NEED_RECONFIG_DOCKER}; then 
    FLANNEL_NET="${FLANNEL_NET}" KUBE_CONFIG_FILE="${KUBE_CONFIG_FILE}" DOCKER_OPTS="${DOCKER_OPTS}" ${KUBE_ROOT}/scripts/reconfDocker.sh ai; 
fi

service kube-apiserver start
sleep 5
service kube-controller-manager start
sleep 2
service kube-scheduler start
sleep 3
service kubelet start;service kube-proxy start


exit 0
