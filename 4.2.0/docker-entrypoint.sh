#!/bin/bash
set -e

# if LOCAL_UID and LOCAL_GID are not set, then run as root user
if [[ -z "$LOCAL_UID" ]] && [[ -z "$LOCAL_GID" ]]; then
    gosu root iinit ${IRODS_PASSWORD}
    gosu root "$@"
# if LOCAL_UID and LOCAL_GID are set, then run as irods user
elif [[ ! -z "$LOCAL_UID" ]] || [[ ! -z "$LOCAL_GID" ]]; then
    if [[ ! -z "$LOCAL_UID" ]]; then
        gosu root usermod -u ${LOCAL_UID} irods
    fi
    if [[ ! -z "$LOCAL_GID" ]]; then
        gosu root groupmod -g ${LOCAL_GID} irods
    fi
    gosu root chown -R $(id -u irods):$(id -g irods) /var/lib/irods
    gosu irods iinit ${IRODS_PASSWORD}
    gosu irods "$@"
fi

exit 0;