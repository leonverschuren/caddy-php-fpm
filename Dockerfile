FROM php:7.2-fpm

RUN apt-get update && apt-get install -y --no-install-recommends zlib1g-dev libicu-dev zip unzip libmagickwand-dev jpegoptim && apt-get autoremove -y && apt-get clean
RUN docker-php-ext-install zip pdo pdo_mysql opcache mbstring intl exif && pecl install apcu-5.1.18 imagick-3.4.4 && docker-php-ext-enable apcu imagick

# Install Caddy
RUN curl --silent --show-error --fail --location \
      --header "Accept: application/tar+gzip, application/x-gzip, application/octet-stream" -o - \
      "https://caddyserver.com/download/linux/amd64?plugins=http.expires,http.realip&license=personal" \
    | tar --no-same-owner -C /usr/bin/ -xz caddy \
    && chmod 0755 /usr/bin/caddy \
    && /usr/bin/caddy -version

WORKDIR /srv/app/

CMD ["/usr/bin/caddy", "--conf", "Caddyfile", "--log", "stdout"]

EXPOSE 2015/tcp
