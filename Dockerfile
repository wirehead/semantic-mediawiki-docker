FROM mediawiki:1.31

ARG COMPOSER_VERSION=1.9.0

# System dependencies
RUN set -eux; \
    \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        zip unzip \
        graphviz mscgen \
    ; \
    rm -rf /var/lib/apt/lists/*

RUN mkdir /var/www/conf

COPY composer.local.json /var/www/html
COPY conf/LocalSettings.local.php /var/www/conf
COPY conf/LocalSettings.php /var/www/conf

RUN curl -o /tmp/JsonConfig-REL1_31-168e4bf.tar.gz https://extdist.wmflabs.org/dist/extensions/JsonConfig-REL1_31-168e4bf.tar.gz \
  && tar -xzf /tmp/JsonConfig-REL1_31-168e4bf.tar.gz -C /var/www/html/extensions \
  && curl -o /tmp/Graph-REL1_31-c455379.tar.gz https://extdist.wmflabs.org/dist/extensions/Graph-REL1_31-c455379.tar.gz \
  && tar -xzf /tmp/Graph-REL1_31-c455379.tar.gz -C /var/www/html/extensions \
  && curl -o /tmp/SubPageList3-REL1_31-f5bc2ea.tar.gz https://extdist.wmflabs.org/dist/extensions/SubPageList3-REL1_31-f5bc2ea.tar.gz \
  && tar -xzf /tmp/SubPageList3-REL1_31-f5bc2ea.tar.gz -C /var/www/html/extensions

RUN curl -o /tmp/composer-setup.php https://getcomposer.org/installer \
  && curl -o /tmp/composer-setup.sig https://composer.github.io/installer.sig \
  && php -r "if (hash('SHA384', file_get_contents('/tmp/composer-setup.php')) !== trim(file_get_contents('/tmp/composer-setup.sig'))) { unlink('/tmp/composer-setup.php'); echo 'Invalid installer' . PHP_EOL; exit(1); }"

RUN php /tmp/composer-setup.php --no-ansi --install-dir=/usr/local/bin --filename=composer --version=${COMPOSER_VERSION} \
    && rm -rf /tmp/composer-setup.php \
    && ln -s /var/www/conf/LocalSettings.local.php /var/www/html/LocalSettings.local.php \
    && ln -s /var/www/conf/LocalSettings.php /var/www/html/LocalSettings.php

#RUN ln -s /var/www/conf/LocalSettings.php /var/www/html/LocalSettings.php

RUN composer update

COPY db-setup.sh /var/www/html