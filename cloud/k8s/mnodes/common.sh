#!/bin/bash

# Copyright 2015 The Kubernetes Authors All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# A script to setup the k8s in docker containers.
# Authors @wizard_cxy @resouer

set -e

# Make sure docker daemon is running
if ( ! ps -ef | grep "/usr/bin/docker" | grep -v 'grep' &> /dev/null ); then
    echo "Docker is not running on this machine!"
    exit 1
fi

# Make sure k8s version env is properly set
K8S_VERSION=${K8S_VERSION:-"1.1.3"}
ETCD_VERSION=${ETCD_VERSION:-"2.2.1"}
FLANNEL_VERSION=${FLANNEL_VERSION:-"0.5.5"}
FLANNEL_IFACE=${FLANNEL_IFACE:-"eth0"}


DOCKER_VNAME=""
DOCKER_CONF=""
DOCKER_REG=${DOCKER_REG:-"lark.io"}
DOCKER_SOCK=${DOCKER_SOCK:-"unix:///var/run/docker.sock"}
DOCKER_PID=${DOCKER_PID:-"/var/run/docker.pid"}
DOCKER_GRAPH=${DOCKER_GRAPH:-"/var/lib/docker"}



# Run as root
if [ "$(id -u)" != "0" ]; then
    echo >&2 "Please run as root"
    exit 1
fi

# Make sure master ip is properly set
if [ -z ${MASTER_IP} ]; then
    MASTER_IP=$(hostname -I | awk '{print $1}')
    echo "Please export MASTER_IP in your env"
    exit 1
fi

echo "K8S_VERSION is set to: ${K8S_VERSION}"
echo "ETCD_VERSION is set to: ${ETCD_VERSION}"
echo "FLANNEL_VERSION is set to: ${FLANNEL_VERSION}"
echo "FLANNEL_IFACE is set to: ${FLANNEL_IFACE}"
echo "MASTER_IP is set to: ${MASTER_IP}"

# Check if a command is valid
command_exists() {
    command -v "$@" > /dev/null 2>&1
}

lsb_dist=""

# Detect the OS distro, we support ubuntu, debian, mint, centos, fedora dist
detect_lsb() {
    case "$(uname -m)" in
        *64)
            ;;
         *)
            echo "Error: We currently only support 64-bit platforms."       
            exit 1
            ;;
    esac

    if command_exists lsb_release; then
        lsb_dist="$(lsb_release -si)"
    fi
    if [ -z ${lsb_dist} ] && [ -r /etc/lsb-release ]; then
        lsb_dist="$(. /etc/lsb-release && echo "$DISTRIB_ID")"
    fi
    if [ -z ${lsb_dist} ] && [ -r /etc/debian_version ]; then
        lsb_dist='debian'
    fi
    if [ -z ${lsb_dist} ] && [ -r /etc/fedora-release ]; then
        lsb_dist='fedora'
    fi
    if [ -z ${lsb_dist} ] && [ -r /etc/os-release ]; then
        lsb_dist="$(. /etc/os-release && echo "$ID")"
    fi

    lsb_dist="$(echo ${lsb_dist} | tr '[:upper:]' '[:lower:]')"

    case "${lsb_dist}" in
        amzn|centos)
            DOCKER_CONF="/etc/sysconfig/docker"
            DOCKER_VNAME="OPTIONS"
            ;;
        debian|ubuntu)
            DOCKER_CONF="/etc/default/docker"
            DOCKER_VNAME="DOCKER_OPTS"
            ;;
        *)
            echo "Error: We currently only support ubuntu|debian|amzn|centos."
            exit 1
            ;;
    esac
}


# Start the bootstrap daemon
# TODO: do not start docker-bootstrap if it's already running
bootstrap_daemon() {
    sed -in "s#^$DOCKER_VNAME=.*--mtu=.*##" $DOCKER_CONF
    rm -f ${DOCKER_CONF}n

    DOCKER_OPTS="--insecure-registry $DOCKER_REG -H $DOCKER_SOCK -p $DOCKER_PID"
    #DOCKER_OPTS="$DOCKER_OPTS --bridge=none"
    DOCKER_OPTS="$DOCKER_OPTS --iptables=false --ip-masq=false --graph=$DOCKER_GRAPH"
    cat $DOCKER_CONF | grep "iptables" >/dev/null 2>&1 && return 0

    echo "[INFO] config docker daemon $DOCKER_OPTS"
    sed -in "s#^$DOCKER_VNAME=.*#$DOCKER_VNAME=\"$DOCKER_OPTS\"#" $DOCKER_CONF
    rm -f ${DOCKER_CONF}n
    service docker restart
    sleep 5
    return 0

    docker -d \
        -H $DOCKER_SOCK \
        -p $DOCKER_PID \
        --iptables=false \
        --ip-masq=false \
        --bridge=none \
        --graph=$DOCKER_GRAPH \
            2> /var/log/docker-bootstrap.log \
            1> /dev/null &
    
    sleep 5
}

# Start k8s components in containers


start_etcd() {
    # Start etcd 
    docker -H $DOCKER_SOCK run \
        --restart=always \
        --net=host \
        -d \
        lark.io/gcr.io/google_containers/etcd:${ETCD_VERSION} \
        /usr/local/bin/etcd \
            --listen-client-urls=http://127.0.0.1:4001,http://${MASTER_IP}:4001 \
            --advertise-client-urls=http://${MASTER_IP}:4001 \
            --data-dir=/var/etcd/data

    sleep 5
    # Set flannel net config
    docker -H $DOCKER_SOCK run \
        --net=host lark.io/gcr.io/google_containers/etcd:${ETCD_VERSION} \
        etcdctl \
        set /coreos.com/network/config \
            '{ "Network": "10.1.0.0/16", "Backend": {"Type": "vxlan"}}'
    
    #etcdctl set /coreos.com/network/config '{ "Network": "10.1.0.0/16", "Backend": {"Type": "vxlan"}}'
}

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
