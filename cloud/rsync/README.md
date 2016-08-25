

data flow
=========

1. source
    a. lsyncd
    b. source path

2. target
    a. rsyncd

3. set

 ls /proc/sys/fs/inotify/
 	max_user_watches, max_user_instances, max_queued_events 

 update /etc/rc.local:
 [ -f /proc/sys/fs/inotify/max_user_watches ]  && echo 99999999 >/proc/sys/fs/inotify/max_user_watches
 [ -f /proc/sys/fs/inotify/max_queued_events ] && echo 99999999 >/proc/sys/fs/inotify/max_queued_events

