# From debian jessie.
# Check https://hub.docker.com/_/php/ for updates.
# Note: Installing php extensions is not trival...
FROM php:7.1.6-fpm

# PHP7.1 + Nginx = #StillWinning
# @todo prod you may wanna split nginx & fpm up. Ex: https://goo.gl/9vMd48
RUN docker-php-source extract \
    && apt-get update \
    # System Binaries
    && apt-get -y --no-install-recommends install \
        nginx \
        vim \
        nano \
    # PHP Extensions
    && docker-php-ext-install \
        pdo_mysql \
        opcache \
    && docker-php-source delete \
    # Cleanup
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/*

# Point all the logs to route out of the docker container to the docker engine
RUN ln -sf /proc/1/fd/1 /var/log/nginx/access.log && \
    ln -sf /proc/1/fd/2 /var/log/nginx/error.log && \
    ln -sf /proc/1/fd/1 /var/log/nginx/www.access.log && \
    ln -sf /proc/1/fd/2 /var/log/nginx/www.error.log

# We'll assume that port 80 and 443 are gonna be the web server ports
EXPOSE 80 443
