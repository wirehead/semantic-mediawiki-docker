#!/bin/bash
set -e

echo setupStore
echo 

/usr/local/bin/php /var/www/html/extensions/SemanticMediaWiki/maintenance/setupStore.php --skip-import
echo setupStore finished