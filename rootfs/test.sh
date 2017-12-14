#!/bin/bash

#-- configuración
set -o allexport; source /test.conf; set +o allexport

#-- comprobación de parámetros
getopt --test > /dev/null
if [[ $? -ne 4 ]]; then
    echo "opss!! `getopt --test` failed in this environment"
    exit 1
fi

SHORT=b:
LONG=branch:

# -temporarily store output to be able to check for errors
# -activate advanced mode getopt quoting e.g. via “--options”
# -pass arguments only via   -- "$@"   to separate them correctly
PARSED=`getopt --options $SHORT --longoptions $LONG --name "$0" -- "$@"`
if [[ $? -ne 0 ]]; then
    # e.g. $? == 1
    #  then getopt has complained about wrong arguments to stdout
    exit 2
fi

# use eval with "$PARSED" to properly handle the quoting
eval set -- "$PARSED"

# now enjoy the options in order and nicely split until we see --
while true; do
    case "$1" in
        -b|--branch)
            branch=$2
            shift 2
            ;;
        --)
            shift
            break
            ;;
        *)
            echo "Opps! error al procesar opciones"
            exit 3
            ;;
    esac
done

echo "branch: $branch"
#-- esperamos si dupral no está listo
while [ -f /stop.drupal_not_ready ]
do
  echo "drupal no listo... esperamos"
  sleep 4
done

cd /drupalExtension

npm install

cd $drupal

#-- comprobamos que tenemos instalado behat y drupal-extension
behat_instalado=`composer show -N | grep behat/behat`

if [ "${behat_instalado%/*}" != "behat" ];then
  #-- activamos behat
  composer require --dev behat/behat

fi

composer config repositories.local path /drupalExtension

#-- activamos drupal-extension
composer require --dev --prefer-source drupal/drupal-extension

composer require --dev behat/mink-zombie-driver

cd /drupalExtension

export NODE_PATH="`pwd`/node_modules"

cp -r fixtures/blackbox $drupal
mkdir -p ${MODULE_PATH}
cp -r fixtures/drupal8/modules/behat_test $drupal/sites/all/modules

cd $drupal
drush --yes en behat_test

drush cc drush

# Disable the page cache on Drupal 8.
drush --yes pmu page_cache

# Test with big_pipe enabled for Drupal 8.
drush --yes en -y big_pipe

# Clear the cache on Drupal 6 and 7, rebuild on Drupal 8.
drush cr

cd /drupalExtension

$drupal/vendor/bin/behat -f progress
