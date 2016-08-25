#!/bin/bash
set -e

if [ "${1:0:1}" = '-' ]; then
	set -- keepalived "$@"
fi

cp -f /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

if [ "$1" = 'keepalived' ]; then
    conf="/etc/keepalived/keepalived.conf"
    if [ ! -f "$conf" ]; then
        cp -f /root/keepalived.conf $conf

        [ "$vrrpId" ] || vrrpId="101"
        [ "$vrrpPass" ] || vrrpPass="vrrp@pass"
        [ "$vrrpState" ] || vrrpState="MASTER"
        [ "$vrrpInt1" ] || vrrpInt1="eth0"
        [ "$vrrpInt2" ] || vrrpInt2="$vrrpInt1"
        [ "$vrrpPri" ] || vrrpPri="100"
        [ "$vrrpAddr" ] || vrrpAddr="192.168.10.1/24"

        sed -in "s/vrrpId/$vrrpId/"         $conf
        sed -in "s/vrrpPass/$vrrpPass/"     $conf
        sed -in "s/vrrpState/$vrrpState/"   $conf
        sed -in "s/vrrpInt1/$vrrpInt1/"     $conf
        sed -in "s/vrrpInt2/$vrrpInt2/"     $conf
        sed -in "s/vrrpPri/$vrrpPri/"       $conf
        sed -in "s#vrrpAddr#$vrrpAddr#"     $conf
        rm -f ${conf}n
    fi

    sh="/etc/keepalived/check_app.sh"
    [ ! -f $sh ] && cp -f /root/check_app.sh $sh

    sh="/etc/keepalived/notify.sh"
    [ ! -f $sh ] && cp -f /root/notify.sh $sh
fi

exec "$@"
