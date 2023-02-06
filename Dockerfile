FROM php:8-apache

RUN apt-get update
RUN apt-get install -y libxslt-dev && docker-php-ext-install pdo pdo_mysql xsl
RUN a2enmod rewrite

COPY . /var/www/html

ENV APACHE_DOCUMENT_ROOT /var/www/html/root
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf
