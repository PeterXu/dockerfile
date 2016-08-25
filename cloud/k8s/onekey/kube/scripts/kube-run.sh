#!/bin/bash
set -e

start_svr() {
    local svrlist="etcd flannel"
    svrlist="$svrlist kube-apiserver kube-controller-manager kube-scheduler"
    svrlist="$svrlist kubelet kube-proxy"
    for item in $svrlist; do
        echo $item
        service $item start 2>/dev/null || true
        sleep 1
    done
}

stop_svr() {
    local svrlist="kubelet kube-proxy"
    svrlist="$svrlist kube-controller-manager kube-scheduler kube-apiserver"
    svrlist="$svrlist etcd flannel"
    for item in $svrlist; do
        echo $item
        service $item stop 2>/dev/null || true
        sleep 1
    done
}


if [ "$1" = "start" ]; then
    start_svr
elif [ "$1" = "stop" ]; then
    stop_svr
fi

exit 0
