#!/bin/bash

pgrep etcd && service etcd stop
rm -rf \
    /opt/bin/etcd* \
    /etc/init/etcd.conf \
    /etc/init.d/etcd \
    /etc/default/etcd


pgrep flanneld && service flanneld stop
rm -f /run/flannel/subnet.env


service kubelet stop 2>/dev/null
service kube-proxy stop 2>/dev/null
service kube-controller-manager stop 2>/dev/null
service kube-scheduler stop 2>/dev/null
service kube-apiserver stop 2>/dev/null
rm -f \
    /opt/bin/kube* \
    /opt/bin/flanneld \
    /etc/init/kube* \
    /etc/init/flanneld.conf \
    /etc/init.d/kube* \
    /etc/init.d/flanneld \
    /etc/default/kube* \
    /etc/default/flanneld


systemctl daemon-reload 2>/dev/null || true

exit 0
