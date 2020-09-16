FROM adminer:latest

USER root

RUN apk update
RUN apk add build-base php7-dev
RUN MAKEFLAGS="-j8" pecl install mongodb
RUN docker-php-ext-enable mongodb
RUN apk del build-base php7-dev
COPY plugins-enabled/* /var/www/html/plugins-enabled

USER adminer
