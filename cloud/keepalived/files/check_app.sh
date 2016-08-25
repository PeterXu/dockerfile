#!/bin/bash

check_ok() 
{
    local ret=0 cnt=2
    while [ $cnt -gt 0 ];
    do
        </dev/tcp/127.0.0.1/443
        ret=$?
        [ $ret -eq 0 ] && break
        cnt=$((cnt-1))
        sleep 3
    done

    return $ret
}

#check_ok || service nginx stop
check_ok || exit 1

exit 0
