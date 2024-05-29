FROM ubuntu:focal
MAINTAINER Klaus Illmayer <klaus.illmayer@oeaw.ac.at>

ENV DEBIAN_FRONTEND=noninteractive PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/var/www/drupal/html/vendor/drush/drush/

ARG UNAME=www-data
ARG UGROUP=www-data
ARG UID=1000
ARG GID=1000

RUN groupmod --gid $GID $UGROUP \
    && usermod -d /var/www/drupal --uid $UID --gid $GID -m $UNAME

# prepare the software list and add the php repository
RUN apt-get update && \
    apt-get install -y locales gnupg sudo vim apache2 apache2-utils && \
    apt-get install -y software-properties-common && \
    add-apt-repository ppa:ondrej/php \
    && echo $UNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$UNAME \
    && chmod 0440 /etc/sudoers.d/$UNAME \
    && apt-get clean

# install languages and php install
ENV LANG=en_US.UTF-8 LANGUAGE=en_US:en
RUN locale-gen en_US.UTF-8 && \
    locale-gen de_DE.UTF-8 && \
    apt-get update && \
    apt-get install -y curl git vim mysql-client unzip \
                   apache2 libapache2-mod-php8.1 \
                   php8.1-cli php8.1-curl php8.1-gd php8.1-mbstring php8.1-mysql php8.1-opcache php8.1-pgsql php8.1-sqlite3 php8.1-xml php8.1-yaml php8.1-zip && \
    apt-get clean

# set time
RUN rm -f /etc/localtime && \
    ln -s /usr/share/zoneinfo/Europe/Vienna /etc/localtime && \
    dpkg-reconfigure --frontend noninteractive tzdata

# prepare apache
RUN a2enmod rewrite && \
    sed -i -e 's/StartServers.*/StartServers 1/g' /etc/apache2/mods-enabled/mpm_prefork.conf && \
    sed -i -e 's/MinSpareServers.*/MinSpareServers 1/g' /etc/apache2/mods-enabled/mpm_prefork.conf && \
    sed -i -e 's/upload_max_filesize.*/upload_max_filesize = 64M/' -e 's/post_max_size.*/post_max_size = 64M/' /etc/php/*/apache2/php.ini

# get and install composer
RUN curl -sS https://getcomposer.org/installer -o composer-setup.php && \
    php composer-setup.php --install-dir=/usr/local/bin --filename=composer && \
    rm composer-setup.php

# prepare user and directory structure
#RUN usermod -d /var/www/drupal www-data &&\
#    mkdir -p /var/www/drupal/html
RUN mkdir -p /var/www/drupal \
    && chown -R $UNAME:$UGROUP /var/www/drupal/

USER $UNAME

# prepare user and directory structure
RUN mkdir -p /var/www/drupal/html \
  && mkdir -p /var/www/drupal/composer \
  && mkdir -p /var/www/drupal/config \
  && mkdir -p /var/www/drupal/html/web/modules/custom \
  && mkdir -p /var/www/drupal/html/web/themes/custom \
  && mkdir -p /var/www/drupal/root

WORKDIR /var/www/drupal/

# copy current structure into container
# todo: it is expected, that a Drupal was already set up otherwise run the initial dockerfile local and push the results
# for development we create bindings, whereas for deployment on the server we only copy the files
# for deployment not every directory is necessary, e.g. files/ and settings/ is bound as a volume, no need to copy it
COPY ./composer/ /var/www/drupal/composer/
COPY ./config/ /var/www/drupal/config/
COPY ./custom/modules/ /var/www/drupal/html/web/modules/custom/
COPY ./custom/themes/ /var/www/drupal/html/web/themes/custom/

# install from the existing composer.json and set permissions to www-data user
RUN cd /var/www/drupal/html \
    && ln -s /var/www/drupal/composer/composer.json composer.json \
    && composer install
#    && chown -R www-data:www-data /var/www/drupal \
#    && runuser -u www-data -- composer install

# prepare and run the entrypoint
COPY ./docker/start.sh /var/www/drupal/root/start.sh
COPY ./docker/drupal_settings.php /var/www/drupal/root/drupal_settings.php
# intialize apache configuration
COPY ./docker/apache2.conf /etc/apache2/sites-enabled/000-default.conf

CMD ["/var/www/drupal/root/start.sh"]

EXPOSE 5000

