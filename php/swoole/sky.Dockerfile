ARG PHP_VERSION=8.0
ARG SWOOLE_VERSION=4.7.1

FROM dickens7/php:${PHP_VERSION}-swoole-${SWOOLE_VERSION}

COPY ./cmake-3.19.1.tar.gz /tmp/cmake-3.19.1.tar.gz
##
# ---------- env settings ----------
##
ENV SKYWALKING_RELEASE_TAG master
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib:/usr/local/lib64
ENV LD_RUN_PATH=$LD_RUN_PATH:/usr/local/lib:/usr/local/lib64

ENV GRPC_RELEASE_TAG v1.31.x
ENV PROTOBUF_RELEASE_TAG 3.13.x

ENV PHPIZE_DEPS="boost-dev git ca-certificates autoconf automake libtool g++ make file linux-headers file re2c pkgconf openssl openssl-dev curl-dev"

RUN set -ex \
    && docker-php-ext-install mysqli \
    && apk --update add --no-cache boost-dev git ca-certificates autoconf automake libtool g++ make file linux-headers file re2c pkgconf openssl openssl-dev curl-dev nginx \
    && echo "--- clone grpc ---" \
    && git clone --depth 1 -b ${GRPC_RELEASE_TAG} https://github.com/grpc/grpc /var/local/git/grpc \
    && cd /var/local/git/grpc \
    && git submodule update --init --recursive \
    && echo "--- download cmake ---" \
    && cd /var/local/git \
    # && curl -L -o cmake-3.19.1.tar.gz  https://github.com/Kitware/CMake/releases/download/v3.19.1/cmake-3.19.1.tar.gz \
    && mv /tmp/cmake-3.19.1.tar.gz cmake-3.19.1.tar.gz \ 
    && tar zxf cmake-3.19.1.tar.gz \
    && cd cmake-3.19.1 && ./bootstrap && make -j$(nproc) && make install \
    && echo "--- installing grpc ---" \
    && cd /var/local/git/grpc \
    && mkdir -p cmake/build && cd cmake/build && cmake ../.. \
    && make -j$(nproc) \
    && echo "--- installing skywalking php ---" \
    && git clone --depth 1 -b ${SKYWALKING_RELEASE_TAG} https://github.com/SkyAPM/SkyAPM-php-sdk.git /var/local/git/skywalking \
    && cd /var/local/git/skywalking \
    && phpize && ./configure --with-grpc=/var/local/git/grpc && make && make install \
    && mkdir -p /opt \
    && cp docker/service.sh /opt/ \
    && cp docker/nginx.conf /etc/nginx/nginx.conf \
    && cp docker/index.php /var/www/html/index.php \
    && cd / \
    && rm -rf /var/cache/apk/* \
    && rm -fr /var/local/git
