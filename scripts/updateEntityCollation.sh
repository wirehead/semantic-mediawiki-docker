#!/bin/bash
set -e

echo updateEntityCollation
echo 

/usr/local/bin/php /var/www/html/extensions/SemanticMediaWiki/maintenance/updateEntityCollation.php
echo updateEntityCollation finished