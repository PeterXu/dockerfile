#!/bin/bash

K8S_IP=k8s.io
ETCD_IP=dns.io


rmf_docker() {
    name="$1"
    [ "${name}" = "" ] && return 1
    if docker ps -a | grep $name; then
        return 0
        docker stop $name >/dev/null 2>&1
        docker rm -f $name >/dev/null 2>&1
    fi
    return 1
}

start_apiserver()
{
    CLOUD="--cloud-provider=mesos --cloud-config=/opt/k8s/mesos-cloud.conf"
    BIN="./km apiserver"

    CLOUD=
    BIN="./kube-apiserver"

    name=apiserver
    rmf_docker $name && return 0
    IMG="lark.io/gcr.io/google_containers/hyperkube:v1.1.3"
    OPT="-d -it --net=host --restart=always -v /opt/k8s:/opt/k8s --name=$name"
    BIN="docker run $OPT $IMG /hyperkube apiserver"
    HOSTNAME="hf-k8s-01"

    $BIN $CLOUD \
        --bind-address=0.0.0.0 \
        --external-hostname=$HOSTNAME \
        --etcd-servers=http://${ETCD_IP}:4001 \
        --insecure-bind-address=0.0.0.0 \
        --insecure-port=8080 \
        --admission-control=NamespaceLifecycle,LimitRanger,SecurityContextDeny,ServiceAccount,ResourceQuota \
        --authorization-mode=AlwaysAllow \
        --token-auth-file=/opt/k8s/auth/token-users \
        --basic-auth-file=/opt/k8s/auth/basic-users \
        --service-account-key-file=/opt/k8s/auth/service-accounts.key \
        --service-cluster-ip-range=10.10.10.0/24 \
        --service-node-port-range=30000-32767 \
        --tls-cert-file=/opt/k8s/auth/apiserver.crt \
        --tls-private-key-file=/opt/k8s/auth/apiserver.key \
        --v=1 >/opt/k8s/log/apiserver.log 2>&1
    sleep 5
}

start_controller()
{
    MASTER="https://admin:admin@10.11.220.211:6443"
    MASTER="http://$K8S_IP:8080"


    CLOUD="--cloud-provider=mesos --cloud-config=/opt/k8s/mesos-cloud.conf"
    BIN="./km controller-manager"

    CLOUD=""
    BIN="./kube-controller-manager"

    name=ccontroller
    rmf_docker $name && return 0
    IMG="lark.io/gcr.io/google_containers/hyperkube:v1.1.3"
    OPT="-d -it --net=host --restart=always -v /opt/k8s:/opt/k8s --name=$name"
    BIN="docker run $OPT $IMG /hyperkube controller-manager"

    $BIN $CLOUD \
        --address=0.0.0.0 \
        --master=$MASTER \
        --service-account-private-key-file=/opt/k8s/auth/service-accounts.key \
        --root-ca-file=/opt/k8s/auth/root-ca.crt \
        --v=1 >/opt/k8s/log/controller.log 2>&1 &
    sleep 5
}

start_scheduler()
{
    API_URI="http://${K8S_IP}:8080"

    MESOS_MASTER=k8s.io:5050
    CLOUD="--mesos-master=${MESOS_MASTER} --mesos-user=root"
    CLOUD="$CLOUD --mesos-executor-cpus=1.0 --mesos-sandbox-overlay=/opt/k8s/sandbox-overlay.tar.gz"
    CLOUD="$CLOUD --mesos-framework-roles=*,public --mesos-default-pod-roles=*,public"
    CLOUD="$CLOUD --etcd-servers=http://${ETCD_IP}:4001 --api-servers=${API_URI}"
    CLOUD="$CLOUD --cluster-dns=10.10.10.10 --cluster-domain=cluster.local"
    CLOUD="$CLOUD --static-pods-config=/opt/k8s/static-pods --executor-logv=4"
    BIN="./km scheduler"


    CLOUD="--master=${API_URI}"
    BIN="./kube-scheduler"

    name=scheduler
    rmf_docker $name && return 0
    IMG="lark.io/gcr.io/google_containers/hyperkube:v1.1.3"
    OPT="-d -it --net=host --restart=always -v /opt/k8s:/opt/k8s --name=$name"
    BIN="docker run $OPT $IMG /hyperkube scheduler"

    $BIN $CLOUD \
        --address=0.0.0.0 \
        --profiling=true \
        --v=2 >/opt/k8s/log/scheduler.log 2>&1 &
    sleep 5
}


start_apiserver

start_controller

start_scheduler

exit 0

