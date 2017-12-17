#!/bin/bash

#-- configuración
set -o allexport; source /test.conf; set +o allexport

#-- esperamos si dupral no está listo
while [ -f /stop.drupal_not_ready ]
do
  echo "drupal no listo... esperamos"
  sleep 4
done

cd $drupal

composer update

drush --debug runserver :8888 > ~/debug.txt 2>&1 &
sleep 4s

# vamos con los tests
cd /drupalExtension

$drupal/vendor/bin/behat -f progress

$drupal/vendor/bin/behat -f progress --profile=drupal8
