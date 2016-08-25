#!/bin/bash
set -e


set_host() 
{
    cfg="/home/git/gitlab/config/gitlab.yml"
    [ "$sshHost" != "" ] && sed -in "s/ssh_host: localhost/ssh_host: ${sshHost}/" $cfg
    [ "$httpHost" != "" ] && sed -in "s/host: localhost/host: ${httpHost}/" $cfg
    rm -f ${cfg}n
}


source ${GITLAB_RUNTIME_DIR}/functions

[[ $DEBUG == true ]] && set -x

case ${1} in
  app:init|app:start|app:sanitize|app:rake)

    initialize_system
    configure_gitlab
    configure_gitlab_shell
    configure_nginx
    set_host

    case ${1} in
      app:start)
        migrate_database
        exec /usr/bin/supervisord -nc /etc/supervisor/supervisord.conf
        ;;
      app:init)
        migrate_database
        ;;
      app:sanitize)
        sanitize_datadir
        ;;
      app:rake)
        shift 1
        execute_raketask $@
        ;;
    esac
    ;;
  app:help)
    echo "Available options:"
    echo " app:start        - Starts the gitlab server (default)"
    echo " app:init         - Initialize the gitlab server (e.g. create databases, compile assets), but don't start it."
    echo " app:sanitize     - Fix repository/builds directory permissions."
    echo " app:rake <task>  - Execute a rake task."
    echo " app:help         - Displays the help"
    echo " [command]        - Execute the specified command, eg. bash."
    ;;
  *)
    exec "$@"
    ;;
esac

exit 0
