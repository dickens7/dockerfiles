ARG PHP_VERSION

FROM php:${PHP_VERSION}-cli-alpine3.14

# --build-arg timezone=Asia/Shanghai
ARG timezone

# default use www-data user
ARG add_user=www-data

COPY ./composer.phar /tmp/composer.phar
COPY ./swoole.tar.gz /tmp/swoole.tar.gz

ENV TIMEZONE=${timezone:-"Asia/Shanghai"}

ARG SWOOLE_VERSION=4.7.1

ENV COMPOSER_VERSION=2.1.6 \
    #  install and remove building packages
    PHPIZE_DEPS="autoconf dpkg-dev dpkg file g++ make gcc libc-dev pkgconf libzip re2c pcre-dev zlib-dev openssl-dev"

##
# ---------- building ----------
##
RUN php -v \
    # change apk source repo
    && sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/' /etc/apk/repositories \
    && apk update \
    && apk add --no-cache --virtual .build-deps $PHPIZE_DEPS \
    && apk add --no-cache \
    # Install base packages ('ca-certificates' will install 'nghttp2-libs')
    ca-certificates \
    protobuf \
    curl curl-dev \
    tar xz \
    libressl \
    libstdc++ \
    # openssh  \
    tzdata \
    pcre \
    perl \
    make \
    git \
    hiredis-dev \
    libmcrypt-dev \
    linux-headers \
    libzip libzip-dev \
    libpng libpng-dev \
    jpeg-dev libjpeg-turbo-dev \
    imagemagick imagemagick-dev libgomp \
    freetype-dev \ 
    # config ext 
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    # install ext
    && docker-php-ext-install -j$(getconf _NPROCESSORS_ONLN) pcntl opcache bcmath sockets pdo_mysql zip gd \
    && cd /tmp \
    # && wget https://github.com/composer/composer/releases/download/${COMPOSER_VERSION}/composer.phar \
    && chmod +x composer.phar \
    && mv composer.phar /usr/local/bin/composer \
    # php extension: swoole
    && cd /tmp \
    # && curl -SL "https://github.com/swoole/swoole-src/archive/v${SWOOLE_VERSION}.tar.gz" -o swoole.tar.gz \
    && mkdir -p swoole \
    && tar -xf swoole.tar.gz -C swoole --strip-components=1 \
    && rm swoole.tar.gz \
    && ( \
    cd swoole \
    && phpize \
    && ./configure --enable-mysqlnd --enable-openssl --enable-http2 --enable-swoole-json --enable-swoole-curl \
    && make -j$(nproc) && make install \
    ) \
    && rm -r swoole \
    && docker-php-ext-enable swoole \
    # php extension: xlswriter
    && pecl install xlswriter \
    && docker-php-ext-enable xlswriter \
    # php extension: redis
    && pecl install redis \
    && docker-php-ext-enable redis \
    # php extension: mongodb
    && pecl install mongodb \
    && docker-php-ext-enable mongodb \
    # php extension: protobuf
    && pecl install protobuf \
    && docker-php-ext-enable protobuf \
    # php extension: imagick
    && pecl install imagick \
    && docker-php-ext-enable imagick \
    # ---------- clear works ----------
    && php -v \
    && php -m \
    && php --ri swoole \
    && apk del .build-deps \
    && apk del --purge *-dev \
    && rm -rf /var/cache/apk/* /tmp/* /usr/share/man /usr/share/php8 \
    #  ---------- some config,clear work ----------
    && cd /usr/local/etc/php \
    # - config PHP
    && { \
    echo "upload_max_filesize=100M"; \
    echo "post_max_size=108M"; \
    echo "memory_limit=1024M"; \
    echo "memory_limit=1024M"; \
    echo "date.timezone=${TIMEZONE}"; \
    } | tee conf.d/99-overrides.ini \
    # - config timezone
    && ln -sf /usr/share/zoneinfo/${TIMEZONE} /etc/localtime \
    && echo "${TIMEZONE}" > /etc/timezone \
    # ---------- some config work ----------
    # - ensure 'www-data' user exists(82 is the standard uid/gid for "www-data" in Alpine)
    # && addgroup -g 82 -S ${add_user} \
    # && adduser -u 82 -D -S -G ${add_user} ${add_user} \
    # - create user dir
    && mkdir -p /data \
    && chown -R ${add_user}:${add_user} /data \
    && echo -e "\033[42;37m Build Completed :).\033[0m\n"
