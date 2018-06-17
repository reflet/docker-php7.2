FROM php:7.2-fpm

ARG USER="www-data"
ARG UID="1000"
ARG GROUP="www-data"
ARG GID="1000"
ARG DOCUMENT_DIR="/var/www/"
ARG WORKSPACE="/home/www-data/"

# system update
RUN apt-get -y update

# locale
RUN apt-get -y install locales && localedef -f UTF-8 -i ja_JP ja_JP.UTF-8
ENV LANG ja_JP.UTF-8
ENV LANGUAGE ja_JP:ja
ENV LC_ALL ja_JP.UTF-8

# timezone (Asia/Tokyo)
ENV TZ JST-9

# etc
ENV TERM xterm

# tools
RUN apt-get install -y git vim less zip unzip

# php options (mysql)
RUN docker-php-ext-install mysqli pdo_mysql

# php options (postgres)
RUN apt-get install -y libpq-dev \
   && docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql \
   && docker-php-ext-install pdo pdo_pgsql pgsql

# php.ini
COPY php.ini /usr/local/etc/php/php.ini

# composer
RUN curl -sS https://getcomposer.org/installer | php \
    && mv composer.phar /usr/local/bin/composer

# document directory.
RUN mkdir $DOCUMENT_DIR -p

# set workspace
RUN mkdir $WORKSPACE -p
WORKDIR $WORKSPACE

# user setting
RUN usermod -u $UID $USER && groupmod -g $GID $GROUP
RUN chown -R $UID:$GID $DOCUMENT_DIR
RUN chown -R $UID:$GID $WORKSPACE
RUN usermod -d $WORKSPACE $USER
USER $USER

