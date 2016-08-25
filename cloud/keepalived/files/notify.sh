#!/bin/bash
#

contact='root@localhost'
notify() {
    subject="`hostname` to be $1:$2 floating"
    body="`date '+%F %H:%M:%S'`: vrrp transition, `hostname` changed to be $1:$2"
    touch /var/log/keepalived.log
    echo $body >>/var/log/keepalived.log
    #echo $body | mail -s "$subject" $contact
}

case "$1" in
    master)
        notify master $2
        #service nginx start
        exit 0
        ;;
    backup)
        notify backup $2
        exit 0
        ;;
    fault)
        notify fault $2
        exit 0
        ;;
    *)
        echo 'Usage: `basename $0` master|backup|fault vrrp'
        exit 1
        ;;
esac

