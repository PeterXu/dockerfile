#!/bin/bash


export roles="i"
export IFACE="${IFACE:-eno16777736}"
export nodes="$(ifconfig ${IFACE} | grep "inet addr:" | cut -d':' -f2 |  cut -d' ' -f1)"
export MASTER_IP="${MASTER_IP:-}"
export KUBE_ROOT="${KUBE_ROOT:-/opt/kube}"
export KUBE_CONFIG_FILE="${KUBE_CONFIG_FILE:-${KUBE_ROOT}/scripts/config-default.sh}"


if [ ! "$MASTER_IP" ]; then
  echo >&2 "Please set MASTER_IP"
  exit 1
fi

echo "[INFO] role: $roles, $nodes, $MASTER_IP <${IFACE}>"
echo "[INFO] path: $KUBE_ROOT, $KUBE_CONFIG_FILE"

#exit 0

# load env
source "${KUBE_CONFIG_FILE}"
source "${KUBE_ROOT}/scripts/util.sh"

## ========================================


# clean previous
rm -rf ${KUBE_ROOT}/default/*

# copy minion upstart srcripts
cp ${KUBE_ROOT}/ubuntu/minion/init_conf/* /etc/init/
cp ${KUBE_ROOT}/ubuntu/minion/init_scripts/* /etc/init.d/

# copy minion-flannel upstart scripts
if [ -z "$CNI_PLUGIN_CONF" ] || [ -z "$CNI_PLUGIN_EXES" ]; then
    # Prep for Flannel use: copy the flannel binaries and scripts, set reconf flag
    cp -f ${KUBE_ROOT}/ubuntu/minion-flannel/init_conf/* /etc/init/
    cp -f ${KUBE_ROOT}/ubuntu/minion-flannel/init_scripts/* /etc/init.d/
    SERVICE_STARTS="service flanneld start"
    NEED_RECONFIG_DOCKER=true
    CNI_PLUGIN_CONF=''
else
    rm -rf tmp-cni; mkdir -p tmp-cni/exes tmp-cni/conf
    cp "$CNI_PLUGIN_CONF" tmp-cni/conf/
    cp $CNI_PLUGIN_EXES  tmp-cni/exes/
    mkdir -p /opt/cni/bin /etc/cni/net.d
    cp tmp-cni/conf/* /etc/cni/net.d/
    cp tmp-cni/exes/* /opt/cni/bin/
    sed -i.bak -e "s/start on started flanneld/start on started ${CNI_KUBELET_TRIGGER}/" -e "s/stop on stopping flanneld/stop on stopping ${CNI_KUBELET_TRIGGER}/" ${KUBE_ROOT}/ubuntu/minion/init_conf/kubelet.conf
    sed -i.bak -e "s/start on started flanneld/start on started networking/" -e "s/stop on stopping flanneld/stop on stopping networking/" ${KUBE_ROOT}/ubuntu/minion/init_conf/kube-proxy.conf
    NEED_RECONFIG_DOCKER=false
fi


# create kubelet
create-kubelet-opts \
    "${nodes#*@}" \
    "${MASTER_IP}" \
    "${DNS_SERVER_IP}" \
    "${DNS_DOMAIN}" \
    "${KUBELET_CONFIG}" \
    "${CNI_PLUGIN_CONF}" 

# create kube-proxy
create-kube-proxy-opts \
    "${nodes#*@}" \
    "${MASTER_IP}" \
    "${KUBE_PROXY_EXTRA_OPTS}"

# create flanneld
create-flanneld-opts "${MASTER_IP}" "${nodes#*@}"

# copy minion upstart scripts
cp ${KUBE_ROOT}/default/* /etc/default/


# service start
bins="kubelet kube-proxy flanneld"
${KUBE_ROOT}/scripts/kube-bin.sh $bins || exit 1
systemctl daemon-reload 2>/dev/null || true

$SERVICE_STARTS

if ${NEED_RECONFIG_DOCKER}; then 
    KUBE_CONFIG_FILE="${KUBE_CONFIG_FILE}" DOCKER_OPTS="${DOCKER_OPTS}" ${KUBE_ROOT}/scripts/reconfDocker.sh i; 
fi

service kubelet start
service kube-proxy start

exit 0
