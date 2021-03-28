# PHP Swoole

PHP Swoole 基础环境镜像


- build swoole

```shell
SWOOLE_VERSION=4.6.1 && docker build --build-arg SWOOLE_VERSION=${SWOOLE_VERSION}  -t dickens7/swoole:${SWOOLE_VERSION} .
```

- buiild sdebug swoole

```shell
SWOOLE_VERSION=4.6.1 && docker build --build-arg SWOOLE_VERSION=${SWOOLE_VERSION}  -t dickens7/swoole_sdebug:${SWOOLE_VERSION}  -f sdebug.Dockerfile .
```


- buiild sky swoole

```shell
SWOOLE_VERSION=4.6.4 && docker build --build-arg SWOOLE_VERSION=${SWOOLE_VERSION} -t dickens7/swoole_sky:${SWOOLE_VERSION} -f sky.Dockerfile .
```