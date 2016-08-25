#!/bin/bash 

[ $# -lt 1 ] && exit 1
ppath=/tmp/bins
mkdir -p $ppath

parse_kube() {
    local pkg=~/Downloads/kubernetes-server-linux-amd64.tar.gz
    if [ ! -f "$pkg" ]; then
        echo "Please provide package: $pkg " >&2
        exit 1
    fi

    local dst="$ppath/kube" 
    if [ ! -d $dst ]; then
        mkdir -p $dst
        tar xf $pkg -C $dst || exit 1
    fi
}

parse_etcd() {
    local pkg=~/Downloads/etcd.tar.gz
    if [ ! -f "$pkg" ]; then
        ETCD_VERSION=${ETCD_VERSION:-"2.2.1"}
        ETCD="etcd-v${ETCD_VERSION}-linux-amd64"
        curl -L https://github.com/coreos/etcd/releases/download/v${ETCD_VERSION}/${ETCD}.tar.gz -o $pkg
    fi

    local dst="$ppath/etcd" 
    if [ ! -d $dst ]; then
        mkdir -p $dst
        tar xf $pkg -C $dst || exit 1
    fi
}

parse_flannel() {
    local pkg=~/Downloads/flannel.tar.gz
    if [ ! -f "$pkg" ]; then
        FLANNEL_VERSION=${FLANNEL_VERSION:-"0.5.5"}
        curl -L  https://github.com/coreos/flannel/releases/download/v${FLANNEL_VERSION}/flannel-${FLANNEL_VERSION}-linux-amd64.tar.gz -o $pkg
    fi

    local dst="$ppath/flannel" 
    if [ ! -d $dst ]; then
        mkdir -p $dst
        tar xf $pkg -C $dst || exit 1
    fi
}


mkdir -p /opt/bin
for bin in $*; do
    prefix="${bin:0:4}"
    if [ "${prefix}" = "kube" ]; then
        parse_kube
    elif [ "${prefix}" = "etcd" ]; then
        parse_etcd
    elif [ "${prefix}" = "flan" ]; then
        parse_flannel
    else
        echo "Wrong bin: $bin " >&2
        exit 1
    fi
    find $ppath -name $bin -exec cp -f {} /opt/bin \;
done

rm -rf $ppath

exit 0
