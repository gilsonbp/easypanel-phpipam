# Usamos uma imagem oficial do PHP com Apache, que é limpa e estável.
FROM php:8.2-apache

# Instala dependências do sistema e extensões do PHP necessárias para o phpipam
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

# Habilita o mod_rewrite do Apache para URLs amigáveis
RUN a2enmod rewrite

# Define a versão do phpipam que queremos instalar (use uma versão estável)
ENV PHPIPAM_VERSION=latest

# Baixa o código-fonte do phpipam do GitHub e o extrai para o diretório do servidor web
# CORREÇÃO: Removido o "v" do link de download
RUN wget https://github.com/phpipam/phpipam/archive/refs/tags/${PHPIPAM_VERSION}.tar.gz -O /tmp/phpipam.tar.gz \
    && tar -xzf /tmp/phpipam.tar.gz -C /tmp \
    && mv /tmp/phpipam-${PHPIPAM_VERSION}/* /var/www/html/ \
    && rm -rf /var/www/html/index.html /tmp/phpipam.tar.gz /tmp/phpipam-${PHPIPAM_VERSION}

# Adiciona nosso script de inicialização customizado
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Define que nosso script será o ponto de entrada do contêiner
ENTRYPOINT ["/entrypoint.sh"]
# O comando padrão será iniciar o Apache
CMD ["apache2-foreground"]