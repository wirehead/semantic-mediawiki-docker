FROM mediawiki:1.33

ARG COMPOSER_VERSION=1.9.0

ENV MEDIAWIKI_SITE_SERVER http://127.0.0.1:8080
ENV MEDIAWIKI_SCRIPT_PATH ""
ENV MEDIAWIKI_UPLOAD_PATH "/uploads"
ENV MEDIAWIKI_SITE_NAME tst
ENV MEDIAWIKI_SITE_LANG en
ENV MEDIAWIKI_ADMIN_USER admin
ENV MEDIAWIKI_ADMIN_PASS password
ENV MEDIAWIKI_DB_TYPE sqlite
ENV MEDIAWIKI_DB_NAME my_wiki
ENV MEDIAWIKI_DATABASE_DIR /var/www/data
ENV MEDIAWIKI_SECRET_KEY 38e094128cb103129e13530c86c389350c94dfc7c278f28da4f387064908192b
ENV MEDIAWIKI_EMAIL_PW_SENDER nobody@example.com
ENV MEDIAWIKI_EMAIL_EMERG_CONT nobody@example.com
ENV SMW_SEMANTIC_URL http://www.example.com/

# System dependencies for extensions
RUN set -eux; \
    \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        zip unzip \
        graphviz mscgen \
        libpq-dev \
        cron \
        rclone \
    ; \
    rm -rf /var/lib/apt/lists/*

# PHP extensions
RUN docker-php-ext-install -j$(nproc) pgsql \
 && docker-php-ext-install -j$(nproc) pdo_pgsql

# Make the necessary directories
RUN mkdir /var/www/conf \
 && mkdir -p /var/www/localstore/smwconfig \
 && mkdir -p /var/www/localstore/images

# Place config files
COPY composer.local.json /var/www/html
COPY conf/* /var/www/conf/
COPY 000-default.conf /etc/apache2/sites-available

# Place icons
COPY icons/* /var/www/html/

# Download the non-Composer-based extensions
RUN curl -o /tmp/JsonConfig-REL1_33-e19c474.tar.gz https://extdist.wmflabs.org/dist/extensions/JsonConfig-REL1_33-e19c474.tar.gz \
  && tar -xzf /tmp/JsonConfig-REL1_33-e19c474.tar.gz -C /var/www/html/extensions \
  && curl -o /tmp/Graph-REL1_33-7e100b5.tar.gz https://extdist.wmflabs.org/dist/extensions/Graph-REL1_33-7e100b5.tar.gz \
  && tar -xzf /tmp/Graph-REL1_33-7e100b5.tar.gz -C /var/www/html/extensions \
  && curl -o /tmp/SubPageList3-REL1_33-5f9e91b.tar.gz https://extdist.wmflabs.org/dist/extensions/SubPageList3-REL1_33-5f9e91b.tar.gz \
  && tar -xzf /tmp/SubPageList3-REL1_33-5f9e91b.tar.gz -C /var/www/html/extensions \
  && curl -o /tmp/Scribunto-REL1_33-8328acb.tar.gz https://extdist.wmflabs.org/dist/extensions/Scribunto-REL1_33-8328acb.tar.gz \
  && tar -xzf /tmp/Scribunto-REL1_33-8328acb.tar.gz -C /var/www/html/extensions \
  && curl -o /tmp/MsUpload-REL1_33-2c533f8.tar.gz https://extdist.wmflabs.org/dist/extensions/MsUpload-REL1_33-2c533f8.tar.gz \
  && tar -xzf /tmp/MsUpload-REL1_33-2c533f8.tar.gz -C /var/www/html/extensions \
  && curl -o /tmp/TemplateStyles-REL1_31-814b63c.tar.gz https://extdist.wmflabs.org/dist/extensions/TemplateStyles-REL1_31-814b63c.tar.gz \
  && tar -xzf /tmp/TemplateStyles-REL1_31-814b63c.tar.gz -C /var/www/html/extensions \
  && rm /tmp/*.tar.gz

# Install Composer
RUN curl -o /tmp/composer-setup.php https://getcomposer.org/installer \
  && curl -o /tmp/composer-setup.sig https://composer.github.io/installer.sig \
  && php -r "if (hash('SHA384', file_get_contents('/tmp/composer-setup.php')) !== trim(file_get_contents('/tmp/composer-setup.sig'))) { unlink('/tmp/composer-setup.php'); echo 'Invalid installer' . PHP_EOL; exit(1); }"

RUN php /tmp/composer-setup.php --no-ansi --install-dir=/usr/local/bin --filename=composer --version=${COMPOSER_VERSION} \
    && rm -rf /tmp/composer-setup.php \
    && ln -s /var/www/conf/LocalSettings.local.php /var/www/html/LocalSettings.local.php \
    && ln -s /var/www/conf/LocalSettings.php /var/www/html/LocalSettings.php

# Install all of the composer dependencies
RUN composer update

# Place our maintenence and setup scripts
COPY scripts/* /usr/local/bin/
RUN chmod 755 /usr/local/bin/*
COPY backup/* /usr/local/backup-scripts/
RUN chmod 755 /usr/local/backup-scripts/*

# Add crontab file in the cron directory
ADD crontab /etc/crontab
RUN chmod 0644 /etc/crontab

# Set for production
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"