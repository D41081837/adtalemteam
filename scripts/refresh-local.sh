#!/bin/bash
set -e

MYEMAIL="robert@robertshell.com"

function __refresh_site() {
  local site="$1"
  drush cache-clear drush
  echo ""
  echo "======= Syncing Database ======="
  drush @$site.local sql-drop -y && drush sql-sync @$site.prod @$site.local
  drush sqlq TRUNCATE cache_entity
  echo "Synced site database: $site"
  echo ""
  echo "======= Syncing Files ======="
  drush rsync @$site.prod:%files/ @$site.local:%files
  echo "Synced site database: $site"
  echo ""
  echo "======= Restoring Site ======="
  drush updb -y -l "$site.local"
  drush cim sync -y -l "$site.local"
  drush cr -l "$site.local"
  drush uli -l "$site.local"
  echo "Site restored:" $site
}

echo "Refresh Local Script v1.0"
echo "Started: "`date`

echo "======= The Shell Family ======="
#composer install --prefer-dist
__refresh_site "theshellfamily"

echo "Completed: "`date`
