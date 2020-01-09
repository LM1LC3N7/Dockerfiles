#!/bin/sh

# Apply backup group to all files and directory to backup
# Script to call before each backup with option
# run-script-before
sudo chgrp -R duplicati-backup /backups

if [ $? -ne 0 ] ; then
  exit $?
else
  exit 0
fi
