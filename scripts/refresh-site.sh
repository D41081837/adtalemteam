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
SITE="$1"

set -e
set -E

MYEMAIL="csrwebteam+test@adtalem.com"

function __deploy_site() {
  local site="$1"
  echo ""
  echo -e "${BLUE}Update Site for Local Environment${NC}"
  echo "---------------------------------------------------------------"
  echo "Running database updates, importing site config, configuring modules, and creating test users..."
  echo ""
  /var/www/adtalemteam/vendor/drush/drush/drush cache-clear drush
  echo ""
  echo -e "${BLUE}Database Sync${NC}"
  echo "---------------------------------------------------------------"
  echo "Syncing the database from production..."
  echo ""
  /var/www/adtalemteam/vendor/drush/drush/drush @local.dev sql-drop -y && /var/www/adtalemteam/vendor/drush/drush/drush sql-sync -y @prod.dev @self
  echo "Synced site database: $site"
  echo ""
  echo -e "${BLUE}File Sync${NC}"
  echo "---------------------------------------------------------------"
  echo "Syncing the files from production..."
  echo ""
  /var/www/adtalemteam/vendor/drush/drush/drush rsync -y @prod.dev:%files/ @self:%files
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

  echo ""
  echo ""
  echo -e "${BLUE}Refreshing ${NC}"$site
  echo "---------------------------------------------------------------"
  echo ""

  /var/www/adtalemteam/vendor/drush/drush/drush user:create "$MYEMAIL" --password=pass --mail="$MYEMAIL" -l $SITE
  /var/www/adtalemteam/vendor/drush/drush/drush user-add-role "administrator" "$MYEMAIL" -l $SITE
  echo "Login as admin: "
  /var/www/adtalemteam/vendor/drush/drush/drush uli -l $SITE
  echo "Login as content author: "
  /var/www/adtalemteam/vendor/drush/drush/drush uli --name="$MYEMAIL" -l $SITE

echo ""
echo "---------------------------------------------------------------"
echo -e "${GREEN}REFRESH SITE SCRIPT COMPLETED:${NC}"
echo -e $NOW
echo "---------------------------------------------------------------"
echo ""
}

echo ""
echo -e "${BLUE}LOCAL SITE REFRESH SCRIPT v2.0${NC}"
echo -e "${GREEN}Started: ${NC}"$NOW
echo ""
echo -e "${WHITE}This script syncs databases, files and configuration for one site.${NC}"
echo ""
echo -e  "${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}"

if [ -e "$SITE" ]; then
__deploy_site $SITE;
else
options=("adtalemteam.local")
select stack in "${options[@]}"; do
    SAVEDSITE='MYSITE="'$mysite'"'
    echo $SAVEDSITE >> /home/vagrant/.setup_vars;
  case "$mysite,$REPLY" in
    adtalemteam.local,*|*,adtalemteam.local)     __deploy_site 'adtalemteam.local'; break ;;
  esac
done
fi