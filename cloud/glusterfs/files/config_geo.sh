#!/bin/bash
# for gluster geo-replication


# step1: should set root/ssh login with key
#   PermitRootLogin without-password => PermitRootLogin yes
#   set key in /root/.ssh


# step2: set ssh key
ROOT="/home/peter"
ln -sf $ROOT/.ssh/id_rsa        /var/lib/glusterd/geo-replication/secret.pem
ln -sf $ROOT/.ssh/id_rsa.pub    /var/lib/glusterd/geo-replication/secret.pem.pub
ln -sf $ROOT/.ssh/id_rsa        /var/lib/glusterd/geo-replication/tar_ssh.pem
ln -sf $ROOT/.ssh/id_rsa.pub    /var/lib/glusterd/geo-replication/tar_ssh.pem.pub


# step3: set gsyncd.conf
temp="/var/lib/glusterd/geo-replication/gsyncd_template.conf"
conf="/var/lib/glusterd/geo-replication/gsyncd.conf"
cp -f $temp $conf

gsyncd="/usr/lib/x86_64-linux-gnu/glusterfs/gsyncd"
sed -i "s#remote_gsyncd = /nonexistent/gsyncd#remote_gsyncd = $gsyncd#" $conf


# step4: fix non-found gsyncd
mkdir -p /nonexistent/
ln -sf $gsyncd /nonexistent/gsyncd


# step5: create geo-replication (use root, many issues for other users)
#   gluster system:: execute gsec_create
#   gluster volume geo-replication <master_volname> slave_host::<slave_volname> create push-pem [force]
#   gluster volume geo-replication <master_volname> slave_host::<slave_volname> start|stop [force]
#   gluster volume geo-replication <master_volname> slave_host::<slave_volname> status
#
# others:
#   gluster volume geo-replication <master_volname> slave_host::<slave_volname> config use_tarssh false



exit 0
