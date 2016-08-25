#!/bin/bash

KUBE_ROOT="${KUBE_ROOT:-/opt/kube}"
if [ ! -d "$KUBE_ROOT" ]; then
  echo >&2 "Please set KUBE_ROOT"
  exit 1
fi
mkdir -p ${KUBE_ROOT}/default


# Create ~/kube/default/etcd with proper contents.
# $1: The one IP address where the etcd leader listens.
function create-etcd-opts() {
  cat <<EOF > ${KUBE_ROOT}/default/etcd
ETCD_OPTS="\
 --name infra\
 --listen-client-urls http://127.0.0.1:4001,http://${1}:4001\
 --advertise-client-urls http://${1}:4001"
EOF
}

# Create ~/kube/default/kube-apiserver with proper contents.
# $1: CIDR block for service addresses.
# $2: Admission Controllers to invoke in the API server.
# $3: A port range to reserve for services with NodePort visibility.
# $4: The IP address on which to advertise the apiserver to members of the cluster.
function create-kube-apiserver-opts() {
  cat <<EOF > ${KUBE_ROOT}/default/kube-apiserver
KUBE_APISERVER_OPTS="\
 --insecure-bind-address=0.0.0.0\
 --insecure-port=8080\
 --etcd-servers=http://127.0.0.1:4001\
 --logtostderr=true\
 --service-cluster-ip-range=${1}\
 --admission-control=${2}\
 --service-node-port-range=${3}\
 --advertise-address=${4}\
 --client-ca-file=${KUBE_ROOT}/certs/ca.crt\
 --tls-cert-file=${KUBE_ROOT}/certs/server.cert\
 --tls-private-key-file=${KUBE_ROOT}/certs/server.key"
EOF
}

# Create ~/kube/default/kube-controller-manager with proper contents.
function create-kube-controller-manager-opts() {
  cat <<EOF > ${KUBE_ROOT}/default/kube-controller-manager
KUBE_CONTROLLER_MANAGER_OPTS="\
 --master=127.0.0.1:8080\
 --root-ca-file=${KUBE_ROOT}/certs/ca.crt\
 --service-account-private-key-file=${KUBE_ROOT}/certs/server.key\
 --logtostderr=true"
EOF

}

# Create ~/kube/default/kube-scheduler with proper contents.
function create-kube-scheduler-opts() {
  cat <<EOF > ${KUBE_ROOT}/default/kube-scheduler
KUBE_SCHEDULER_OPTS="\
 --logtostderr=true\
 --master=127.0.0.1:8080"
EOF

}

# Create ~/kube/default/kubelet with proper contents.
# $1: The hostname or IP address by which the kubelet will identify itself.
# $2: The one hostname or IP address at which the API server is reached (insecurely).
# $3: If non-empty then the DNS server IP to configure in each pod.
# $4: If non-empty then added to each pod's domain search list.
# $5: Pathname of the kubelet config file or directory.
# $6: If empty then flannel is used otherwise CNI is used.
function create-kubelet-opts() {
  if [ -n "$6" ] ; then
      cni_opts=" --network-plugin=cni --network-plugin-dir=/etc/cni/net.d"
  else
      cni_opts=""
  fi
  cat <<EOF > ${KUBE_ROOT}/default/kubelet
KUBELET_OPTS="\
 --hostname-override=${1} \
 --api-servers=http://${2}:8080 \
 --logtostderr=true \
 --cluster-dns=${3} \
 --cluster-domain=${4} \
 --config=${5} \
 $cni_opts"
EOF
}

# Create ~/kube/default/kube-proxy with proper contents.
# $1: The hostname or IP address by which the node is identified.
# $2: The one hostname or IP address at which the API server is reached (insecurely).
function create-kube-proxy-opts() {
  cat <<EOF > ${KUBE_ROOT}/default/kube-proxy
KUBE_PROXY_OPTS="\
 --hostname-override=${1} \
 --master=http://${2}:8080 \
 --logtostderr=true \
 ${3}"
EOF

}

# Create ~/kube/default/flanneld with proper contents.
# $1: The one hostname or IP address at which the etcd leader listens.
function create-flanneld-opts() {
  cat <<EOF > ${KUBE_ROOT}/default/flanneld
FLANNEL_OPTS="--etcd-endpoints=http://${1}:4001 \
 --ip-masq \
 --iface=${2}"
EOF
}
