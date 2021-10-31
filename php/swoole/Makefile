.PHONY:default
default:build

down:
	curl -L -o cmake-3.19.1.tar.gz https://github.com/Kitware/CMake/releases/download/v3.19.1/cmake-3.19.1.tar.gz
	wget https://github.com/swoole/swoole-src/archive/v4.8.1.tar.gz -O swoole.tar.gz
	wget https://github.com/composer/composer/releases/download/2.1.6/composer.phar -O composer.phar

### Build:  build swoole
build:
	docker build -t dickens7/php:${PHP_VERSION}-swoole-${SWOOLE_VERSION} --build-arg SWOOLE_VERSION=${SWOOLE_VERSION} --build-arg PHP_VERSION=${PHP_VERSION} .

build_sdebug:
	docker build -t dickens7/php:${PHP_VERSION}-swoole-${SWOOLE_VERSION}-sdebug -f sdebug.Dockerfile --build-arg SWOOLE_VERSION=${SWOOLE_VERSION}  --build-arg PHP_VERSION=${PHP_VERSION}  .

build_sky:
	docker build -t dickens7/php:${PHP_VERSION}-swoole-${SWOOLE_VERSION}-sky -f sky.Dockerfile  --build-arg SWOOLE_VERSION=${SWOOLE_VERSION} --build-arg PHP_VERSION=${PHP_VERSION} .
