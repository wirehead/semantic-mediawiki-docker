#!/bin/bash
set -e

# Copy the htaccess file
mkdir -p /var/www/localstore/images
mkdir -p /var/www/localstore/smwconfig 
cp /var/www/html/images/* /var/www/localstore/images
chown -R www-data:www-data /var/www/localstore
chown -R www-data:www-data /var/www/data
