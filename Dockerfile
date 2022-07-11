FROM adminer:4.8.1

USER root

RUN echo "upload_max_filesize = 1G" >  /usr/local/etc/php/conf.d/0-upload_large_dumps.ini \
&&  echo "post_max_size = 2G"       >> /usr/local/etc/php/conf.d/0-upload_large_dumps.ini \
&&  echo "memory_limit = 4G"        >> /usr/local/etc/php/conf.d/0-upload_large_dumps.ini \
&&  echo "max_execution_time = 600" >> /usr/local/etc/php/conf.d/0-upload_large_dumps.ini \
&&  echo "max_input_vars = 5000"    >> /usr/local/etc/php/conf.d/0-upload_large_dumps.ini

RUN apk update


RUN echo ""                                                                                       >  /etc/apk/repositories
RUN echo https://dl-cdn.alpinelinux.org/alpine/v$(cut -d'.' -f1,2 /etc/alpine-release)/main/      >> /etc/apk/repositories
RUN echo https://dl-cdn.alpinelinux.org/alpine/v$(cut -d'.' -f1,2 /etc/alpine-release)/community/ >> /etc/apk/repositories
RUN echo https://dl-cdn.alpinelinux.org/alpine/edge/testing/                                      >> /etc/apk/repositories

RUN apk add build-base php7-dev mongo-c-driver mongo-c-driver-dev
RUN MAKEFLAGS="-j8" pecl -d memory_limit=128M install mongodb
RUN docker-php-ext-enable mongodb
RUN apk del build-base php7-dev
COPY plugins-enabled/* /var/www/html/plugins-enabled

USER adminer
