# Basisimage
FROM php:7.4-apache

# Arbeitsverzeichnis im Container
WORKDIR /var/www/html

# Moodle-Version, die heruntergeladen werden soll
ENV MOODLE_VERSION MOODLE_4X_STABLE

# Installation von Abhängigkeiten
RUN apt-get update && apt-get install -y \
   zlib1g-dev \
   libxml2-dev \
   libpng-dev \
   libjpeg-dev \
   libfreetype6-dev \
   libzip-dev \
   unzip \
&& docker-php-ext-install -j$(nproc) \
   zip \
   mysqli \
   soap \
   gd \
&& rm -rf /var/lib/apt/lists/*

# Herunterladen und Entpacken von Moodle
RUN curl -L https://github.com/moodle/moodle/archive/$MOODLE_VERSION.tar.gz | tar xz --strip-components=1

# Kopieren der Konfigurationsdatei
COPY config.php /var/www/html/config.php

# Setzen der Berechtigungen
RUN chown -R www-data:www-data /var/www/html && chmod -R 755 /var/www/html

# Exponieren des Ports
EXPOSE 80

# Starten des Apache-Servers
CMD ["apache2-foreground"]
