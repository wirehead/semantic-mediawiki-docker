docker run --name some-mediawiki --rm -p 8080:80 -v `pwd`/smwconfig:/var/www/smwconfig -v `pwd`/conf:/var/www/conf -v `pwd`/data:/var/www/data -v `pwd`/localstore:/var/www/localstore -v /home/wirehead/src/moinmoin2mediawiki/data-out/foo:/import docker.pkg.github.com/wirehead/semantic-mediawiki