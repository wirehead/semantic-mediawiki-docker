docker run --env-file=local_settings -v `pwd`/smwconfig:/var/www/smwconfig -v `pwd`/conf:/var/www/conf -v `pwd`/data:/var/www/data -v `pwd`/localstore:/var/www/localstore wirehead/semantic-mediawiki-docker mwjobrunner