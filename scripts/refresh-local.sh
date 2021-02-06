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
  /var/www/adtalemteam/vendor/drush/drush/drush @adtalemteam.local sql-drop -y && /var/www/adtalemteam/vendor/drush/drush/drush sql-sync -y adtalemteam.live @self
  echo "Synced site database: $site"
  echo ""
  echo -e "${BLUE}File Sync${NC}"
  echo "---------------------------------------------------------------"
  echo "Syncing the files from production..."
  echo ""
  /var/www/adtalemteam/vendor/drush/drush/drush rsync -y @adtalemteam.live:%files/ @self:%files
  echo "Synced site files: $site"
  echo ""
  echo ""
  echo -e "${BLUE}Update Database${NC}"
  echo "---------------------------------------------------------------"
  echo "Updating the site configuration in the database..."
  echo ""
  /var/www/adtalemteam/vendor/drush/drush/drush updb -y -l "$site.local"
  /var/www/adtalemteam/vendor/drush/drush/drush cim sync -y -l "$site.local"
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
composer install --prefer-dist
__refresh_site "adtalemteam"

COMPLETED=$(date +"%R %Z")

echo ""
echo "---------------------------------------------------------------"
echo -e "${GREEN}LOCAL REFRESH SCRIPT COMPLETED:${NC}"
echo -e $COMPLETED
echo "---------------------------------------------------------------"
echo ""
