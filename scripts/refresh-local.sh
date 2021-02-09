#!/bin/bash

YELLOW='\033[0;33m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
LIGHTBLUE='\033[1;27m'
LIGHTERBLUE='\033[1;33m'
GRAY='\033[1;231m'
BOLD='\033[1;0m'
BLACK='\033[0;30m'
WHITE='\033[0;97m'
NC='\033[0m'

export TZ=":America/Chicago"
NOW=$(date +"%c")
TIME=$(date +"%R %Z")

set -e
set -E

function __refresh_site() {
  local site="$1"
  /var/www/adtalemteam/vendor/drush/drush/drush cache-clear drush
  echo ""
  echo -e "${BLUE}Database Sync${NC}"
  echo "---------------------------------------------------------------"
  echo "Syncing the database from production..."
  echo ""
  /var/www/adtalemteam/vendor/drush/drush/drush @self sql-drop -y && /var/www/adtalemteam/vendor/drush/drush/drush sql-sync -y @live.dev @self
  echo "Synced site database: $site"
  echo ""
  echo -e "${BLUE}File Sync${NC}"
  echo "---------------------------------------------------------------"
  echo "Syncing the files from production..."
  echo ""
  ssh -t root@68.183.57.65 "cd /var/www/adtalem.team/files/private && rm -rf adtal3mprivate.tar.gz && tar -pczf adtal3mprivate.tar.gz * && chmod 777 adtal3mprivate.tar.gz && mv adtal3mprivate.tar.gz /var/www/adtalem.team/html/sites/default/files"
  cd /var/www/adtalemteam/files/private
  wget https://www.adtalem.team/sites/default/files/adtal3mprivate.tar.gz
  tar -xvzf adtal3mprivate.tar.gz
  rm -rf adtal3mprivate.tar.gz
  ssh -t root@68.183.57.65 "cd /var/www/adtalem.team/html/sites/default/files && rm -rf adtal3mfiles.tar.gz && tar -pczf adtal3mfiles.tar.gz * && chmod 777 adtal3mfiles.tar.gz"
  cd /var/www/adtalemteam/html/sites/default/files
  wget https://www.adtalem.team/sites/default/files/adtal3mfiles.tar.gz
  tar -xvzf adtal3mfiles.tar.gz
  rm -rf adtal3mfiles.tar.gz
  echo "Synced site files: $site"
  echo ""
  echo ""
  echo -e "${BLUE}Update Database${NC}"
  echo "--
  -------------------------------------------------------------"
  echo "Updating the site configuration in the database..."
  echo ""
  cd /var/www/adtalemteam/html
  /var/www/adtalemteam/vendor/drush/drush/drush updb -y -l "$site.local"
  /var/www/adtalemteam/vendor/drush/drush/drush cex sync -y -l "$site.local"
  /var/www/adtalemteam/vendor/drush/drush/drush cr -l "$site.local"
  /var/www/adtalemteam/vendor/drush/drush/drush cim sync -y -l "$site.local"
  /var/www/adtalemteam/vendor/drush/drush/drush uli -l "$site.local"
  /var/www/adtalemteam/vendor/drush/drush/drush cim sync -y -l "$site.local"
  echo "Config updated for:" $site
}

echo ""
echo -e "${BLUE}LOCAL ENVIRONMENT REFRESH SCRIPT v2.0${NC}"
echo -e "${GREEN}Started: ${NC}"$NOW
echo ""
echo -e "${WHITE}This script syncs the database, files and configuration.${NC}"
echo ""
echo -e  "${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}"


echo ""
echo -e "${YELLOW}======================== Adtalem Team =========================${NC}"
echo -e "${WHITE}Started: ${NC}$TIME"

echo ""
echo -e "${BLUE}Install Site${NC}"
echo "---------------------------------------------------------------"
echo "Installing packages with Composer..."
echo ""

__refresh_site "adtalemteam"

COMPLETED=$(date +"%R %Z")

echo ""
echo "---------------------------------------------------------------"
echo -e "${GREEN}LOCAL REFRESH SCRIPT COMPLETED:${NC}"
echo -e $COMPLETED
echo "---------------------------------------------------------------"
echo ""
