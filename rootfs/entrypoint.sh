#!/bin/bash -e
# basado en app-entrypoint.sh de bitnami

touch /stop.drupal_not_ready

. /opt/bitnami/base/functions
. /opt/bitnami/base/helpers

print_welcome_page

if [[ "$1" == "nami" && "$2" == "start" ]] || [[ "$1" == "/run.sh" ]]; then
  info "Starting drupal... "
  nami_initialize apache php drupal

  info "Starting drupalExtension... "
  /install_drupalExtension.sh
fi

rm /stop.drupal_not_ready

info "Starting... "
exec tini -- "$@"
