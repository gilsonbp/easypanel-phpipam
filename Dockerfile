FROM php:8.2-apache

RUN apt-get update && apt-get install -y \
    git \
    wget \
    unzip \
    libgmp-dev \
    libldap2-dev \
    libicu-dev \
    && rm -rf /var/lib/apt/lists/* \
    && docker-php-ext-configure gmp \
    && docker-php-ext-configure ldap \
    && docker-php-ext-install -j$(nproc) pdo_mysql gmp ldap intl

RUN a2enmod rewrite

ENV PHPIPAM_VERSION=latest

RUN wget https://github.com/phpipam/phpipam/archive/refs/tags/v${PHPIPAM_VERSION}.tar.gz -O /tmp/phpipam.tar.gz \
    && tar -xzf /tmp/phpipam.tar.gz -C /tmp \
    && mv /tmp/phpipam-${PHPIPAM_VERSION}/* /var/www/html/ \
    && rm -rf /var/www/html/index.html /tmp/phpipam.tar.gz /tmp/phpipam-${PHPIPAM_VERSION}

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["apache2-foreground"]