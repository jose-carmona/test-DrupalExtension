#!/bin/bash

#-- configuración
set -o allexport; source /test.conf; set +o allexport

# Instalamos zombie driver
cd /drupalExtension

npm install

ln -s $drupal drupal

cd $drupal
composer config repositories.local path /drupalExtension

# activamos drupal-extension
# activamos zombie-driver para Mink Extension
composer require --dev --prefer-source drupal/drupal-extension:^4.0 behat/mink-zombie-driver behat/behat

# copiamos blackbox y módulo behat_test
cp -r /drupalExtension/fixtures/blackbox $drupal
mkdir -p $drupal/sites/all/modules
cp -r /drupalExtension/fixtures/drupal8/modules/behat_test $drupal/sites/all/modules

# Activamos módulo behat_test
drush --yes en behat_test

drush cc drush

# Disable the page cache on Drupal 8.
drush --yes pmu page_cache

# Test with big_pipe enabled for Drupal 8.
drush --yes en -y big_pipe

# Clear the cache on Drupal 6 and 7, rebuild on Drupal 8.
drush cr
