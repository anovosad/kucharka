FROM php:8-apache

RUN apt update && \
	apt install -y libxslt1-dev libsqlite3-dev sqlite3 zlib1g-dev libpng-dev libjpeg-dev && \
	docker-php-ext-configure gd --with-jpeg && \
	docker-php-ext-install gd && \
	docker-php-ext-install pdo pdo_mysql xsl && \
	docker-php-ext-install pdo_sqlite && \
	apt clean

RUN a2enmod rewrite

ENV APACHE_DOCUMENT_ROOT /var/www/html
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf
