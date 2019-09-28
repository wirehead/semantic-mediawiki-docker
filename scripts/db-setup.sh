#!/bin/bash
set -e

cd /var/www/html/

# The install script doesn't want there to be a LocalSettings.php file
rm /var/www/html/LocalSettings.php
#php maintenance/install.php --dbtype sqlite --dbname "my_wiki" --dbuser "" --dbpassword "" --scriptpath "/var/www/html/" --conf "/var/www/conf/null.php" --pass "" --dbpath="/var/www/data/" Wirehead password
php maintenance/install.php --dbtype postgres --dbname "my_wiki" --dbuser "postgres" --dbport 5432 --dbpass "mysecretpassword" --scriptpath "/var/www/html/" --dbserver 192.168.1.64 --conf "/var/www/conf/null.php" --pass "password" --dbpath="/var/www/data/" tst Wirehead

# Now, we're going to replace the LocalSettings.php file that install.php just generated with ours
# This way, update.php will work.
rm /var/www/html/LocalSettings.php
ln -s /var/www/conf/LocalSettings.php /var/www/html/LocalSettings.php

# Run update.php, to set up all of the extensions
php maintenance/update.php

# Copy the htaccess file
mkdir -p /var/www/localstore/images
mkdir -p /var/www/localstore/smwconfig 
cp /var/www/html/images/* /var/www/localstore/images
chown -R www-data:www-data /var/www/localstore