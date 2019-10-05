#!/bin/bash
set -e

echo removeDuplicateEntities
echo 

php /var/www/html/extensions/SemanticMediaWiki/maintenance/removeDuplicateEntities.php
echo removeDuplicateEntities finished

