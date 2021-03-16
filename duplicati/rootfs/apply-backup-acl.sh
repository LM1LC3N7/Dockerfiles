#!/bin/bash

# /!\
#
# This file as the setuid bit enabled.
# It will be executed as (real) root user on files shared with the container.
# This is the only way to allow a non-root user (duplicati) to access to protected files
# without changing owners (users or groups).
#
# /!\


# -----
# WHAT DID THIS SCRIPT WILL DO?
# * if Duplicati start a backup -> create ACL to give only read permissions on all /backup elements
# * if Duplicati start a restore -> create ACL to give full rights on /restore 
# -----


# -----
# DUPLICATI DOCUMENTATION
# See all Duplicati variables details from:
# https://github.com/duplicati/duplicati/blob/master/Duplicati/Library/Modules/Builtin/run-script-example.bat
# -----

# We read a few variables first.
EVENTNAME=$DUPLICATI__EVENTNAME
OPERATIONNAME=$DUPLICATI__OPERATIONNAME
REMOTEURL=$DUPLICATI__REMOTEURL
LOCALPATH=$DUPLICATI__LOCALPATH


# Basic setup, we use the same file for both before and after,
# so we need to figure out which event has happened
if [ "$EVENTNAME" == "BEFORE" ] ; then


    # BACKUP: --> Add ACL to grant read permissions everywhere
    if [ "${OPERATIONNAME}" == "BACKUP" ] ; then
        if [ ! -d "${LOCALPATH}" ] ; then
            echo "${LOCALPATH} does not exist." >&2
        else
            echo "Apply ACL to ${LOCALPATH}"
            # setfacl: add read permissions and execute for directories only
            echo "setfacl -R -m user:8888:rX ${LOCALPATH}"
            setfacl -R -m user:8888:rX ${LOCALPATH}
            echo "setfacl -R -m group:8888:rX ${LOCALPATH}"
            setfacl -R -m group:8888:rX ${LOCALPATH}
        fi
    fi


    # RESTORE: --> Add ACL to grant write permissions to /restore
    if [ "${OPERATIONNAME}" == "RESTORE" ] ; then
        echo "Apply ACL to /restore"
        # setfacl: add read/write permissions and execute for directories only
        echo "setfacl -R -m user:8888:rwX /restore"
        setfacl -R -m user:8888:rwX /restore
        echo "setfacl -R -m group:8888:rwX /restore"
        setfacl -R -m group:8888:rwX /restore
    fi
fi


exit 0
