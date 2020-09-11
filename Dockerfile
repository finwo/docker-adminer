FROM adminer:latest

USER root

RUN apk update \
&&  apk add build-base php7-dev \
&&  pecl install mongodb \
&&  docker-php-ext-enable mongodb \
&&  apk del build-base php7-dev

USER adminer
