


init1() {
    export K8S_VERSION=
    export ETCD_VERSION=
    export FLANNEL_VERSION=
    export FLANNEL_IFACE=
    export FLANNEL_IPMASQ=
}


init_master() {
    export FLANNEL_IFACE=eth0
    export MASTER_IP=$(ifconfig $FLANNEL_IFACE | grep "inet addr:" | sed "s#.*inet addr:\(.*\) Bcast.*#\1#")
    export ETCD_IP=dns.io
    echo $MASTER_IP

    etcdctl -C http://${ETCD_IP}:4001 set /coreos.com/network/config '{ "Network": "10.1.0.0/16", "Backend": {"Type": "vxlan"}}'
}


init_worker() {
    export FLANNEL_IFACE=eth0
    export MASTER_IP=k8s.io
    export ETCD_IP=dns.io
}


