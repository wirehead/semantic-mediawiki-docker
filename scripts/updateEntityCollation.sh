#!/bin/bash
set -e

echo updateEntityCollation
echo 

php /var/www/html/extensions/SemanticMediaWiki/maintenance/updateEntityCollation.php
echo updateEntityCollation finished