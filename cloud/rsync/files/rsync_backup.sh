#!/bin/bash


##
## To sync current files in $src, to remote rsync daemon's modle
##

# source path for syncing to remote
src="/mnt/share/data"

# mod name from remote's "rsync --daemon"
dst=backup

# user name from remote's "rsync --daemon"
user=backup

# passwd from remote's "rsync --daemon"
rsync_passwd=/etc/rsyncd.passwd            

# rsync default opts
rsync_opts="--password-file=${rsync_passwd} --temp-dir=/tmp/ --no-group"

# remote hosts of "rsync --daemon"
dst_hosts="192.168.0.100"

inotify=$(which inotifywait 2>/dev/null) || exit 1


# should cd $src and then monitor files by inotify due to rsycn's features
cd ${src} || exit 1


## full-sync
cat >> /dev/stdout  <<EOF
##
## full-sync for each two hour to avoid some un-sync files
## crontab -e
## * */2 * * * rsync -avz $rsync_opts $src $user@$dst_hosts::$dst
##
EOF

## inotify config
cat >> /dev/stdout <<EOF
##
## ls /proc/sys/fs/inotify/
## 	max_user_watches, max_user_instances, max_queued_events 
##
## update /etc/rc.local:
## [ -f /proc/sys/fs/inotify/max_user_watches ] && echo 10000000 >/proc/sys/fs/inotify/max_user_watches
## [ -f /proc/sys/fs/inotify/max_queued_events ] && echo 10000000 >/proc/sys/fs/inotify/max_queued_events
##
EOF



# monitor all changed/updated files
$inotify -mrq --format '%Xe %w%f' -e modify,create,delete,attrib,close_write,move ./ | while read file 
do
    INO_EVENT=$(echo $file | awk '{print $1}')  # INO_EVENT - event type
    INO_FILE=$(echo $file | awk '{print $2}')   # INO_FILE - file name
    ABS_FILE="$src/${INO_FILE}"
 
    echo "-------------------------------$(date)------------------------------------"
    echo "inotify of <$file>"
        
    if [[ $INO_EVENT =~ 'CREATE' ]] || [[ $INO_EVENT =~ 'MODIFY' ]] || [[ $INO_EVENT =~ 'CLOSE_WRITE' ]] || [[ $INO_EVENT =~ 'MOVED_TO' ]]; then
        echo 'CREATE or MODIFY or CLOSE_WRITE or MOVED_TO'
        for ip in $dst_hosts; do
            rsync -avzcR ${rsync_opts} "${ABS_FILE}" ${user}@${ip}::${dst}
        done
    fi
        
    if [[ $INO_EVENT =~ 'DELETE' ]] || [[ $INO_EVENT =~ 'MOVED_FROM' ]]; then
        echo 'DELETE or MOVED_FROM'
        for ip in $dst_hosts; do
            rsync -avzR --delete ${rsync_opts} "${ABS_FILE}" ${user}@${ip}::${dst}
        done
    fi
        
    if [[ $INO_EVENT =~ 'ATTRIB' ]]; then
        echo 'ATTRIB'
        if [ ! -d "$INO_FILE" ]; then
            for ip in $dst_hosts; do
                rsync -avzcR ${rsync_opts} "${ABS_FILE}" ${user}@${ip}::${dst}
            done
        fi
    fi
done


exit 0
