#!/bin/bash
set -e

cd /var/www/html/

echo Doing a semantic backup
echo

php maintenance/dumpBackup.php --full > /var/backups/dump.xml
tar -cvpjf /var/backups/localstore.tar.gz /var/www/localstore

echo Warning: this is the demo backup script that just stores
echo a backup inside the container filesystem
echo
echo You probably want to configure a real backup
echo