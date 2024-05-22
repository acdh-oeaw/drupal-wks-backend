#!/bin/bash

if [[ -f /var/www/drupal/settings/settings.php ]]
then
  echo "settings.php found, using it"
else
  echo "no settings.php found, create a new one"
  cp /var/www/drupal/html/web/sites/default/default.settings.php /var/www/drupal/html/web/sites/default/settings.php
  sudo sed -i /var/www/drupal/root/drupal_settings.php \
    -e "s/DBNAME/$DBNAME/g" \
    -e "s/DBUSER/$DBUSER/g" \
    -e "s/DBPSWD/$DBPSWD/g" \
    -e "s/DBPREFIX/$DBPREFIX/g" \
    -e "s/DBHOST/$DBHOST/g" \
    -e "s/DBPORT/$DBPORT/g"
  sudo cat /var/www/drupal/root/drupal_settings.php >> /var/www/drupal/html/web/sites/default/settings.php
  # chown 1000:1000 /var/www/drupal/html/web/sites/default/settings.php
  # mv /var/www/drupal/html/web/sites/default/settings.php /var/www/drupal/settings/settings.php
fi

# binding volumes are permission/ownership root, change it to www-data
# chown -R www-data:www-data /var/www/drupal/
# settings is special, it should be set to ready-only for all
sudo chmod 444 /var/www/drupal/html/web/sites/dfault/settings.php
# to develop custom modules/themes they need group set to rw
sudo chmod -R 775 /var/www/drupal/html/web/modules/custom/
sudo chmod -R 775 /var/www/drupal/html/web/themes/custom/

if [[ -f /var/www/drupal/html/web/sites/default/settings.php ]]
then
  echo "symbolic link for settings.php exists already"
else
  echo "creating symbolic link for settings.php"
  ln -s /var/www/drupal/settings/settings.php /var/www/drupal/html/web/sites/default/settings.php
fi

# chown -R www-data:www-data /var/www/drupal/html/web/sites/default/

sudo apache2ctl -D FOREGROUND

#source /etc/apache2/envvars && exec /usr/sbin/apache2 -D FOREGROUND
