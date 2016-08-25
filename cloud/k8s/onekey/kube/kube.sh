#!/bin/bash

usage() {
    echo "usage: kube.sh master|minion|bothmm [iface [masterip]]"
    echo "  e.g:"
    echo "   kube.sh master [eth0 [127.0.0.1]]"
    echo "   kube.sh minion [none [127.0.0.1]]"
    echo "   kube.sh start|stop"
    echo "   kube.sh dns"
    echo "   kube.sh clean"
    echo
}

export KUBE_ROOT=`pwd`
export PATH="$PATH:/opt/bin"
export DOCKER_OPTS="--insecure-registry lark.io"

target="$1"
if [ $# -ge 2 ]; then
    [ "$2" != "none" ] && export IFACE="$2"
fi
[ $# -ge 3 ] && export MASTER_IP="$3"
[ $# -ge 4 ] && usage && exit 1


function check_uid() {
  if [[ "$(id -u)" != "0" ]]; then
    echo >&2 "Please run as root"
    exit 1
  fi
}


if [ "$target" = "master" ]; then
    check_uid
    ${KUBE_ROOT}/scripts/kube-master.sh
elif [ "$target" = "minion" ]; then
    check_uid
    ${KUBE_ROOT}/scripts/kube-minion.sh
elif [ "$target" = "bothmm" ]; then
    check_uid
    ${KUBE_ROOT}/scripts/kube-bothmm.sh
elif [ "$target" = "start" -o "$target" = "stop" ]; then
    check_uid
    ${KUBE_ROOT}/scripts/kube-run.sh $target
elif [ "$target" = "dns" ]; then
    ${KUBE_ROOT}/scripts/kube-dns.sh
elif [ "$target" = "clean" ]; then
    check_uid
    ${KUBE_ROOT}/scripts/kube-clean.sh
else
    usage && exit 1
fi

exit 0
