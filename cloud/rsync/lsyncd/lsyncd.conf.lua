settings {
    logfile         = "/var/log/lsyncd.log",
    statusFile      = "/var/run/lsyncd.status",
    nodaemon        = false,
    statusInterval  = 10,
    inotifyMode     = "CloseWrite",
    maxProcesses    = 4,
    maxDelays       = 4
}

sync {
    default.rsync,
    source      = "/tmp/src",
    target      = "rsync_user@192.168.10.10::rsync_mod",
    init        = true,
    delay       = 30,
    exclude     = { "lost+found", ".tmp", ".*" },
    -- excludeFrom = "/etc/rsync_exclude.lst",
    delete      = "running",

    rsync       = {
        binary      = "/usr/bin/rsync",
        password_file = "/etc/lsyncd/rsyncd.pass",
        _extra = {"--temp-dir=/tmp/"},

        bwlimit     = 4096, -- kb/s
        archive     = true,
        compress    = true,
        verbose     = true
    }
}

