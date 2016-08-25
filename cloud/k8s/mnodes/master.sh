#!/bin/bash


start_k8s(){

    # iface may change to a private network interface, eth0 is for default
    name=flannel_master
    rmf_docker $name && return 0
    flannelCID=$(docker -H $DOCKER_SOCK run \
        --restart=always \
        -d \
        --name=$name \
        --net=host \
        --privileged \
        -v /dev/net:/dev/net \
        lark.io/quay.io/coreos/flannel:${FLANNEL_VERSION} \
        /opt/bin/flanneld \
            --etcd-endpoints=http://${ETCD_IP}:4001 \
            --ip-masq \
            --iface="${FLANNEL_IFACE}")

    sleep 8

    # Copy flannel env out and source it on the host
    docker -H $DOCKER_SOCK \
        cp ${flannelCID}:/run/flannel/subnet.env .
    source subnet.env

    # Configure docker net settings, then restart it
    case "${lsb_dist}" in
        amzn)
            echo "OPTIONS=\"\$OPTIONS --mtu=${FLANNEL_MTU} --bip=${FLANNEL_SUBNET}\"" | tee -a ${DOCKER_CONF}
            ifconfig docker0 down
            yum -y -q install bridge-utils && brctl delbr docker0 && service docker restart
            ;;
        centos)
            echo "OPTIONS=\"\$OPTIONS --mtu=${FLANNEL_MTU} --bip=${FLANNEL_SUBNET}\"" | tee -a ${DOCKER_CONF}
            if ! command_exists ifconfig; then
                yum -y -q install net-tools
            fi
            ifconfig docker0 down
            yum -y -q install bridge-utils && brctl delbr docker0 && systemctl restart docker
            ;;
        ubuntu|debian)
            echo "DOCKER_OPTS=\"\$DOCKER_OPTS --mtu=${FLANNEL_MTU} --bip=${FLANNEL_SUBNET}\"" | tee -a ${DOCKER_CONF}
            ifconfig docker0 down
            apt-get install bridge-utils
            brctl delbr docker0
            service docker stop
            while [ `ps aux | grep /usr/bin/docker | grep -v grep | wc -l` -gt 0 ]; do
                echo "Waiting for docker to terminate"
                sleep 1
            done
            service docker start
            ;;
        *)
            echo "Unsupported operations system ${lsb_dist}"
            exit 1
            ;;
    esac

    # sleep a little bit
    sleep 5

    # Start kubelet and then start master components as pods
    name=kubelet_master
    rmf_docker $name && return 0

    config1=/etc/kubernetes/manifests
    config2=/etc/kubernetes/manifests-multi
    mkdir -p $config1 $config2
    cp -f files/master1.json $config1/master.json
    cp -f files/master2.json $config2/master.json
    sed -in "s#127.0.0.1:4001#${ETCD_IP}:4001#g" $config1/master.json
    sed -in "s#127.0.0.1:4001#${ETCD_IP}:4001#g" $config2/master.json
    rm -f $config1/master.jsonn $config2/master.jsonn

    docker run \
        --name=$name \
        --net=host \
        --pid=host \
        --privileged \
        --restart=always \
        -d \
        -v /sys:/sys:ro \
        -v /var/run:/var/run:rw \
        -v /:/rootfs:ro \
        -v /dev:/dev \
        -v /var/lib/docker:/var/lib/docker:rw \
        -v /var/lib/kubelet:/var/lib/kubelet:rw \
        -v /etc/kubernetes:/etc/kubernetes:rw \
        lark.io/gcr.io/google_containers/hyperkube:v${K8S_VERSION} \
        /hyperkube kubelet \
            --address=0.0.0.0 \
            --allow-privileged=true \
            --enable-server \
            --api-servers=http://localhost:8080 \
            --config=/etc/kubernetes/manifests-multi \
            --cluster-dns=10.0.0.10 \
            --cluster-domain=cluster.local \
            --containerized \
            --v=2
}


source initrc.sh
init_master

source common.sh

echo "Detecting your OS distro ..."
detect_lsb

echo "Starting bootstrap docker ..."
bootstrap_daemon

echo "Starting k8s ..."
start_k8s

echo "Master done!"
