ARG ALPINE_VERSION=3.12
FROM alpine:${ALPINE_VERSION}
LABEL Maintainer="Oscar Caballero <hola@ehupi.com>"
LABEL Description="Docker Container for Laravel Nginx PHP 7 Alpine."

WORKDIR /var/www/html

RUN apk add --no-cache \
  curl \
  nginx \
  php7 \
  php7-fpm \
  php7-mcrypt \
  php7-tokenizer \
  php7-mysqli \
  php7-phar \
  php7-pdo_mysql \
  php7-json \
  php7-sqlite3 \
  php7-gd \
  php7-imagick \
  php7-tidy \
  php7-xml \
  php7-xmlrpc \
  php7-bcmath \
  php7-mbstring \
  php7-curl \
  php7-iconv \
  php7-zip \
  php7-simplexml \
  php7-soap \
  php7-sodium \
  php7-openssl \
  php7-ctype \
  php7-zlib \
  php7-dom \
  php7-xmlreader \
  php7-intl \
  php7-fileinfo \
  php7-exif \
  supervisor

COPY config/nginx.conf /etc/nginx/nginx.conf

COPY config/fpm-pool.conf /etc/php7/php-fpm.d/www.conf

COPY config/php.ini /etc/php7/conf.d/custom.ini

COPY config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

RUN chown -R nobody.nobody /var/www/html /run /var/lib/nginx /var/log/nginx

USER nobody

EXPOSE 8080

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]

HEALTHCHECK --timeout=10s CMD curl --silent --fail http://127.0.0.1:8080/fpm-ping
