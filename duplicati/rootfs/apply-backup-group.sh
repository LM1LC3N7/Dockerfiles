#!/bin/sh

# Apply backup group to all files and directory to backup
# Script to call before each backup with option
# run-script-before
chgrp -R duplicati-backup /backups
