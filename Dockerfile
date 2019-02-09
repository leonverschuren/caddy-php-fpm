FROM php:5.6-fpm

RUN apt-get update && apt-get install -y zlib1g-dev zip unzip
RUN docker-php-ext-install mysql zip

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
