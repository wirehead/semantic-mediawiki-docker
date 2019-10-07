#!/bin/bash
set -e

echo updateSpecialPages
echo 

/usr/local/bin/php /var/www/html/maintenance/updateSpecialPages.php
echo updateSpecialPages finished