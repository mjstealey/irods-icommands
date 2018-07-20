#!/usr/bin/env bash
set -e

_update_uid_gid() {
    # update UID
    if [[ ${UID_IRODS} != 998 ]]; then
        usermod -u ${UID_IRODS} irods
    fi
    # update GID
    if [[ ${GID_IRODS} != 998 ]]; then
        groupmod -g ${GID_IRODS} irods
    fi
    # update directories
    chown -R irods:irods /var/lib/irods
    chown -R irods:irods /data
}

_irods_environment_json() {
    mkdir -p /var/lib/irods/.irods
    local OUTFILE=/var/lib/irods/.irods/irods_environment.json
    jq -n \
        --arg h "${IRODS_HOST}" \
        --arg p "${IRODS_PORT}" \
        --arg z "${IRODS_ZONE_NAME}" \
        --arg n "${IRODS_USER_NAME}" \
        --arg r "${IRODS_DEFAULT_RESOURCE}" \
        '{"irods_host": $h, "irods_port": $p | tonumber, "irods_zone_name": $z,
        "irods_user_name": $n, "irods_default_resource": $r}' > $OUTFILE
}

_irods_tgz() {
    if [ -z "$(ls -A /var/lib/irods)" ]; then
        cp /irods.tar.gz /var/lib/irods/irods.tar.gz
        cd /var/lib/irods/
        tar -zxf irods.tar.gz
        cd /
        rm -f /var/lib/irods/irods.tar.gz
    fi
}

### main ###
_irods_tgz
_irods_environment_json
_update_uid_gid
runuser -l irods -c 'iinit '${IRODS_PASSWORD}
exec sudo -u irods "$@"

exit 0;
