FROM php:7.4-alpine

STOPSIGNAL SIGINT

COPY conf.d/* /usr/local/etc/php/conf.d
COPY repositories /etc/apk/repositories

RUN apk update
RUN apk upgrade

RUN addgroup -S adminer \
&& adduser -S -G adminer adminer \
&& mkdir -p /var/www/html \
&& mkdir /var/www/html/plugins-enabled \
&& chown -R adminer:adminer /var/www/html

WORKDIR /var/www/html

RUN set -x \
&& apk add --no-cache --virtual .build-deps \
   postgresql-dev \
   sqlite-dev \
   unixodbc-dev \
   freetds-dev \
&& docker-php-ext-configure pdo_odbc --with-pdo-odbc=unixODBC,/usr \
&& docker-php-ext-install \
   mysqli \
   pdo_pgsql \
   pdo_sqlite \
   pdo_odbc \
   pdo_dblib

# && apk add --virtual .phpexts-rundeps $runDeps \
# && apk del --no-network .build-deps

COPY src/*.php /var/www/html/


ENV	ADMINER_VERSION 4.8.1
ENV	ADMINER_DOWNLOAD_SHA256 2fd7e6d8f987b243ab1839249551f62adce19704c47d3d0c8dd9e57ea5b9c6b3
ENV	ADMINER_COMMIT 1f173e18bdf0be29182e0d67989df56eadea4754

RUN set -x \
&& apk add --no-cache --virtual .build-deps git \
&& curl -fsSL "https://github.com/vrana/adminer/releases/download/v$ADMINER_VERSION/adminer-$ADMINER_VERSION.php" -o adminer.php \
&& echo "$ADMINER_DOWNLOAD_SHA256  adminer.php" |sha256sum -c - \
&& git clone --recurse-submodules=designs --depth 1 --shallow-submodules --branch "v$ADMINER_VERSION" https://github.com/vrana/adminer.git /tmp/adminer \
&& commit="$(git -C /tmp/adminer/ rev-parse HEAD)" \
&& [ "$commit" = "$ADMINER_COMMIT" ] \
&& cp -r /tmp/adminer/designs/ /tmp/adminer/plugins/ . \
&& rm -rf /tmp/adminer/ \
&& apk del --no-network  .build-deps

COPY src/entrypoint.sh /usr/local/bin/
ENTRYPOINT [ "entrypoint.sh", "docker-php-entrypoint" ]

USER adminer
CMD	[ "php", "-S", "[::]:8080", "-t", "/var/www/html" ]

EXPOSE 8080

# RUN apk add build-base php7-dev mongo-c-driver mongo-c-driver-dev
# RUN MAKEFLAGS="-j8" pecl install mongodb
# RUN MAKEFLAGS="-j8" pecl install oci8
# RUN docker-php-ext-enable mongodb
# RUN docker-php-ext-enable oci8
# RUN apk del build-base php7-dev
# COPY plugins-enabled/* /var/www/html/plugins-enabled

# USER adminer
