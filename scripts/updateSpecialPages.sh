#!/bin/bash
set -e

echo updateSpecialPages
echo 

php /var/www/html/maintenance/updateSpecialPages.php
echo updateSpecialPages finished