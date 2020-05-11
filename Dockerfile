FROM php
RUN curl -fsSL 'https://xcache.lighttpd.net/pub/Releases/3.2.0/xcache-3.2.0.tar.gz' -o xcache.tar.gz \
    && mkdir -p xcache \
    && tar -xf xcache.tar.gz -C xcache --strip-components=1 \
    && rm xcache.tar.gz \
    && ( \
        cd xcache \
        && phpize \
        && ./configure --enable-xcache \
        && make -j "$(nproc)" \
        && make install \
    ) \
    && rm -r xcache \
    && docker-php-ext-enable xcache
RUN apt-get update && apt-get install -y zlib1g-dev libpng-dev libfreetype6-dev libjpeg62-turbo-dev libcurl4-openssl-dev && apt-get clean \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-install curl

RUN ["service apache stop"]
RUN ["composer install"]

