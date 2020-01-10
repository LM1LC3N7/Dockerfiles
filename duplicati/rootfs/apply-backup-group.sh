#!/bin/bash

# Apply backup group to all files and directory to backup
# Script to call before each backup with option
# run-script-before
sudo -n chgrp -R duplicati-backup /backups

# Apply rights to duplicati-backup group

find /backups -type f -exec chmod g+r {} \;
find /backups -type d -exec chmod g+rx {} \;

if [ $? -ne 0 ] ; then
  exit $?
else
  exit 0
fi

