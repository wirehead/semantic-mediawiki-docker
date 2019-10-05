#!/bin/bash
set -e

echo rebuildData
echo 

php /var/www/html/extensions/SemanticMediaWiki/maintenance/rebuildData.php -d 100
echo rebuildData finished