#!/bin/bash
set -e

echo removeDuplicateEntities
echo 

/usr/local/bin/php /var/www/html/extensions/SemanticMediaWiki/maintenance/removeDuplicateEntities.php
echo removeDuplicateEntities finished

