FROM mediawiki:lts

ARG COMPOSER_VERSION=1.8.6

# System dependencies
RUN set -eux; \
    \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        zip unzip \
    ; \
    rm -rf /var/lib/apt/lists/*

COPY composer.local.json /var/www/html
COPY LocalSettings.local.php /var/www/html

RUN curl -o /tmp/composer-setup.php https://getcomposer.org/installer \
  && curl -o /tmp/composer-setup.sig https://composer.github.io/installer.sig \
  && php -r "if (hash('SHA384', file_get_contents('/tmp/composer-setup.php')) !== trim(file_get_contents('/tmp/composer-setup.sig'))) { unlink('/tmp/composer-setup.php'); echo 'Invalid installer' . PHP_EOL; exit(1); }"

RUN php /tmp/composer-setup.php --no-ansi --install-dir=/usr/local/bin --filename=composer --version=${COMPOSER_VERSION} && rm -rf /tmp/composer-setup.php

RUN composer update --no-dev