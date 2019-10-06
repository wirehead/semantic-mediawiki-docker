#!/bin/bash
set -e

cd /var/www/html/

# The install script doesn't want there to be a LocalSettings.php file
echo Killing LocalSettings.php
echo

rm /var/www/html/LocalSettings.php

echo Install.php
echo

php maintenance/install.php --dbtype "${MEDIAWIKI_DB_TYPE}" --dbname "${MEDIAWIKI_DB_NAME}" --dbuser "${MEDIAWIKI_DB_USER}" --dbport "${MEDIAWIKI_DB_PORT}" --dbpass "${MEDIAWIKI_DB_PASSWORD}" --scriptpath "/var/www/html/" --dbserver "${MEDIAWIKI_DB_HOST}" --pass "${MEDIAWIKI_ADMIN_PASS}" --dbpath "${MEDIAWIKI_DATABASE_DIR}" "${MEDIAWIKI_SITE_NAME}" "${MEDIAWIKI_ADMIN_USER}"

# Now, we're going to replace the LocalSettings.php file that install.php just generated with ours
# This way, update.php will work.
rm /var/www/html/LocalSettings.php
ln -s /var/www/conf/LocalSettings.php /var/www/html/LocalSettings.php

echo LocalSettings.php restored
echo

echo Creating localstore
echo

# Copy the htaccess file
mkdir -p /var/www/localstore/images
mkdir -p /var/www/localstore/smwconfig 
cp /var/www/html/images/* /var/www/localstore/images
chown -R www-data:www-data /var/www/localstore

# Run update.php, to set up all of the extensions

echo update.php
echo

php maintenance/update.php --quick