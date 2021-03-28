ARG SWOOLE_VERSION=4.6.3

FROM dickens7/swoole:${SWOOLE_VERSION}


ARG SDEBUG_VERSION

ENV PHPIZE_DEPS="autoconf dpkg-dev dpkg file g++ make gcc libc-dev php7-dev php7-pear pkgconf re2c pcre-dev zlib-dev"

RUN apk add --no-cache --virtual .build-deps $PHPIZE_DEPS libaio-dev openssl-dev \
    && cd /tmp \
    && curl -SL "https://github.com/swoole/sdebug/archive/${SDEBUG_VERSION:-"sdebug_2_9-beta"}.tar.gz" -o sdebug.tar.gz \
    && mkdir -p sdebug \
    && tar -xf sdebug.tar.gz -C sdebug --strip-components=1 \
    && rm sdebug.tar.gz \
    && ( \
      cd sdebug \
      && ls -al \
      && sh ./rebuild.sh \
    ) \
    && rm -r sdebug \
    && echo "zend_extension=xdebug.so" > /etc/php7/conf.d/20_sdebug.ini \
    # config xdebug
    && { \
        # 添加一个 Xdebug 节点
        echo "[Xdebug]"; \
        # 启用远程连接
        echo "xdebug.remote_enable = 1"; \
        # 这个是多人调试，但是现在有些困难，就暂时不启动
        echo ";xdebug.remote_connect_back = On"; \
        # 自动启动远程调试
        echo "xdebug.remote_autostart  = true"; \
        # 这里 host 可以填前面取到的 IP ，也可以填写 host.docker.internal 。
        echo "xdebug.remote_host = host.docker.internal"; \
        # 这里端口固定填写 9000 ，当然可以填写其他的，需要保证没有被占用
        echo "xdebug.remote_port = 9000"; \
        # 这里固定即可
        echo "xdebug.idekey=PHPSTORM"; \
        # 把执行结果保存到 99-sdebug-enable.ini 里面去
    } | tee /etc/php7/conf.d/99-sdebug-enable.ini \
    # ---------- clear works ----------
    && php -v \
    && php -m \
    && php --ri sdebug \
    && apk del .build-deps \
    && apk del --purge *-dev \
    && rm -rf /var/cache/apk/* /tmp/* /usr/share/man /usr/share/php7 \