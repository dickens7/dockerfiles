FROM alpine:3.12

# --build-arg timezone=Asia/Shanghai
ARG timezone

# default use www-data user
ARG add_user=www-data

ENV TIMEZONE=${timezone:-"Asia/Shanghai"}

ARG SWOOLE_VERSION=4.6.1
##
# ---------- env settings ----------
##

RUN apk add gnu-libiconv --update-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/community/ --allow-untrusted
ENV LD_PRELOAD /usr/lib/preloadable_libiconv.so php

ENV COMPOSER_VERSION=2.0.8 \
    #  install and remove building packages
    PHPIZE_DEPS="autoconf dpkg-dev dpkg file g++ make gcc libc-dev php7-dev php7-pear pkgconf re2c pcre-dev zlib-dev"
 


# 下载太慢，所以可以先下载好
#COPY ./swoole-src-${SWOOLE_VERSION}.tar.gz /tmp/swoole.tar.gz

##
# ---------- building ----------
##
RUN set -ex \
        # change apk source repo
        && sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/' /etc/apk/repositories \
        && apk update \
        && apk add --no-cache \
        # Install base packages ('ca-certificates' will install 'nghttp2-libs')
        ca-certificates \
        protobuf \
        curl \
        curl-dev \
        tar \
        xz \
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
        # install php7 and some extensions
        php7 \
        # php7-common \
        php7-phpdbg \
        php7-bcmath \
        php7-curl \
        php7-ctype \
        php7-dom \
        php7-fileinfo \
        # php7-gettext \
        php7-gd \
        php7-iconv \
        php7-imagick \
        php7-json \
        php7-mbstring \
        # php7-mongodb \
        php7-mysqlnd \
        php7-openssl \
        php7-opcache \
        php7-pdo \
        php7-pdo_mysql \
        # php7-pdo_sqlite \
        php7-phar \
        php7-ldap \
        php7-posix \
        php7-redis \
        php7-simplexml \
        php7-sockets \
        php7-sodium \
        # php7-sqlite \
        # php7-session \
        php7-sysvshm \
        php7-sysvmsg \
        php7-sysvsem \
        php7-tokenizer \
        php7-zip \
        php7-zlib \
        php7-xml \
        php7-xmlwriter \
        php7-protobuf \
        openssh \
        && apk add --no-cache --virtual .build-deps $PHPIZE_DEPS libaio-dev openssl-dev \
        && php -v \
        # install composer
        && cd /tmp \
        && wget https://github.com/composer/composer/releases/download/${COMPOSER_VERSION}/composer.phar \
        && chmod +x composer.phar \
        && mv composer.phar /usr/local/bin/composer \
        # php extension: swoole
        && cd /tmp \
        && curl -SL "https://github.com/swoole/swoole-src/archive/v${SWOOLE_VERSION}.tar.gz" -o swoole.tar.gz \
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
        && echo "extension=swoole.so" > /etc/php7/conf.d/20_swoole.ini \
        # php extension: xlswriter
        && pecl install xlswriter \
        && echo "extension=xlswriter.so" > /etc/php7/conf.d/20_xlswriter.ini \
        # php extension: mongodb
        && pecl install mongodb \
        && echo "extension=mongodb.so" > /etc/php7/conf.d/20_mongodb.ini \
        # ---------- clear works ----------
        && php -v \
        && php -m \
        && php --ri swoole \
        && apk del .build-deps \
        && apk del --purge *-dev \
        && rm -rf /var/cache/apk/* /tmp/* /usr/share/man /usr/share/php7 \
        #  ---------- some config,clear work ----------
        && cd /etc/php7 \
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
        && addgroup -g 82 -S ${add_user} \
        && adduser -u 82 -D -S -G ${add_user} ${add_user} \
        # - create user dir
        && mkdir -p /data \
        && chown -R ${add_user}:${add_user} /data \
        && echo -e "\033[42;37m Build Completed :).\033[0m\n"
