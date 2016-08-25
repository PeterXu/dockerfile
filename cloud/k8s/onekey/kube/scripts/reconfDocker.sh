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

# reconfigure docker network setting

KUBE_ROOT="${KUBE_ROOT:-/opt/kube}"
KUBE_CONFIG_FILE="${KUBE_CONFIG_FILE:-${KUBE_ROOT}/scripts/config-default.sh}"
if [ ! -f "$KUBE_CONFIG_FILE" ]; then
  echo >&2 "Please set KUBE_CONFIG_FILE"
  exit 1
fi

source "${KUBE_CONFIG_FILE}"

if [[ "$(id -u)" != "0" ]]; then
  echo >&2 "Please run as root"
  exit 1
fi


function check_etcdctl() {
  ETCDCTL="/opt/bin/etcdctl"
  [ ! -f "$ETCDCTL" ] && ETCDCTL=`which etcdctl 2>/dev/null`
  if [ ! -f "$ETCDCTL" ]; then
    echo >&2 "Please install etcdctl"
    exit 1
  fi
}

function config_etcd {
  check_etcdctl

  attempt=0
  while true; do
    /opt/bin/etcdctl get /coreos.com/network/config
    if [[ "$?" == 0 ]]; then
      break
    else
    	# enough timeout??
      if (( attempt > 600 )); then
        echo "timeout waiting for /coreos.com/network/config" >> ${KUBE_ROOT}/logs/err.log
        exit 2
      fi

      /opt/bin/etcdctl mk /coreos.com/network/config "{\"Network\":\"${FLANNEL_NET}\", \"Backend\": {\"Type\": \"vxlan\"}${FLANNEL_OTHER_NET_CONFIG}}"
      attempt=$((attempt+1))
      sleep 3
    fi
  done
}

function check_brctl() {
  if which brctl 1>/dev/null; then
    echo
  else
    echo "Please install brctl: apt-get install bridge-utils"
    exit 1
  fi
}

function restart_docker {
  check_brctl

  attempt=0
  while [[ ! -f /run/flannel/subnet.env ]]; do 
    if (( attempt > 200 )); then
      echo "timeout waiting for /run/flannel/subnet.env" >> ${KUBE_ROOT}/logs/err.log 
      exit 2
    fi
    attempt=$((attempt+1))
    sleep 3
  done
  
  sudo ip link set dev docker0 down
  sudo brctl delbr docker0

  source /run/flannel/subnet.env

  echo DOCKER_OPTS=\"${DOCKER_OPTS} -H tcp://127.0.0.1:4243 -H unix:///var/run/docker.sock \
       --bip=${FLANNEL_SUBNET} --mtu=${FLANNEL_MTU}\" > /etc/default/docker
  sudo service docker restart
}

if [[ $1 == "i" ]]; then
  restart_docker
elif [[ $1 == "ai" ]]; then
  config_etcd
  restart_docker
elif [[ $1 == "a" ]]; then
  config_etcd
else
  echo "Another argument is required."
  exit 1
fi 
