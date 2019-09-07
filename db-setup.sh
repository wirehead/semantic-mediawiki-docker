cd /var/www/html/
php maintenance/install.php --dbtype sqlite --dbname "my_wiki" --dbuser "" --dbpassword "" --scriptpath "/var/www/html/" --conf "/var/www/conf/null.php" --pass "" --dbpath="/var/www/data/" Wirehead password
rm /var/www/html/LocalSettings.php
ln -s /var/www/conf/LocalSettings.php /var/www/html/LocalSettings.php

php maintenance/update.php