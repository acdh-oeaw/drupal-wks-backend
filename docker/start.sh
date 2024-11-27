#!/bin/bash

# as we moved some directories in the Dockerfile, we need to set the full drupal-installation to the local user
sudo chown -R 1000:1000 /var/www/drupal/

if [[ -f /var/www/drupal/settings/settings.php ]]
then
  echo "settings.php found, using it"
else
  echo "no settings.php found, create a new one"
  # cp /var/www/drupal/html/web/sites/default/default.settings.php /var/www/drupal/html/web/sites/default/settings.php
  mkdir /var/www/drupal/settings
  cp /var/www/drupal/html/web/sites/default/default.settings.php /var/www/drupal/settings/settings.php
  # that was sudo
  sed -i /var/www/drupal/root/drupal_settings.php \
    -e "s/DBNAME/${DBNAME:-}/g" \
    -e "s/DBUSER/${DBUSER:-}/g" \
    -e "s/DBPSWD/${DBPSWD:-}/g" \
    -e "s/DBPREFIX/${DBPREFIX:-}/g" \
    -e "s/DBHOST/${DBHOST:-}/g" \
    -e "s/DBPORT/${DBPORT:-}/g" \
    -e "s/DRUPALHASH/${DRUPALHASH:-}/g"
  #  -e "s|DRUPALTRUSTEDHOST|$DRUPALTRUSTEDHOST/g"
  # sudo cat /var/www/drupal/root/drupal_settings.php >> /var/www/drupal/html/web/sites/default/settings.php
  # that was sudo
  # temporary deactivate trustedhost
  # sed -i /var/www/drupal/root/drupal_settings.php \
  #   -e "s|DRUPALTRUSTEDHOST|${DRUPALTRUSTEDHOST:-}|g"
  # that was sudo
  cat /var/www/drupal/root/drupal_settings.php >> /var/www/drupal/settings/settings.php
  # sudo chown 1000:1000 /var/www/drupal/settings/settings.php
  # chown 1000:1000 /var/www/drupal/html/web/sites/default/settings.php
  # mv /var/www/drupal/html/web/sites/default/settings.php /var/www/drupal/settings/settings.php
fi

# binding volumes are permission/ownership root, change it to www-data
# chown -R www-data:www-data /var/www/drupal/
# settings is special, it should be set to ready-only for all
# sudo chmod 444 /var/www/drupal/html/web/sites/default/settings.php
# all the next three was sudo
chmod 444 /var/www/drupal/settings/settings.php
# to develop custom modules/themes they need group set to rw
chmod -R 775 /var/www/drupal/html/web/modules/custom/
chmod -R 775 /var/www/drupal/html/web/themes/custom/

if [[ -f /var/www/drupal/html/web/sites/default/settings.php ]]
then
  echo "symbolic link for settings.php exists already"
else
  echo "creating symbolic link for settings.php"
  ln -s /var/www/drupal/settings/settings.php /var/www/drupal/html/web/sites/default/settings.php
fi

# chown -R www-data:www-data /var/www/drupal/html/web/sites/default/
# sudo chown -R 1000:1000 /var/www/drupal/

sudo apache2ctl -D FOREGROUND

# source /etc/apache2/envvars && sudo exec /usr/sbin/apache2 -D FOREGROUND
