#!/bin/bash

# Apply backup group to all files and directory to backup
# Script to call before each backup with option
# run-script-before
sudo -n chgrp -R duplicati-backup /backups

# Search files and directories without the correct group rights
# and apply rights
sudo find /backups -type f -not -regex ".*/.ssh/id_rsa" \! -perm /g+r -exec chmod g+r {} \;
sudo find /backups -type d \! -perm /g+rx -exec chmod g+rx {} \;

if [ $? -ne 0 ] ; then
  exit $?
else
  exit 0
fi

