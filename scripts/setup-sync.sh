#!/bin/bash
#
# Setup shell script to run post-provisioning.
#
# This script adds a Github token, runs the refresh script, and opens the dashboard.

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

BASH_PROFILE_FILE=/home/vagrant/.bash_profile
ACCESS_TOKEN_FILE=/home/vagrant/.setup_vars


echo -e  "${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}"
echo ""
echo -e "${BLUE}LOCAL ENVIRONMENT CONFIG SCRIPT v2.0${NC}"
echo -e "${GREEN}Started: ${NC}"$NOW
echo ""
echo -e "${WHITE}This script sets up VM configuration and refreshes the local environment.${NC}"
echo ""
echo -e  "${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}""${GREEN}-${NC}"


# Check to see if we've already performed this setup.
if [ ! -e "$BASH_PROFILE_FILE" ]; then
  # Have the user enter their Github token.
  echo ""
  echo -e "${BLUE}Add Github token${NC}"
  echo "---------------------------------------------------------------"
   read -p "$(echo -e $YELLOW"Enter your ATGE Github access token: "$NC"(from https://github.com/settings/tokens): ")" MYGITTOKEN
  echo ""
if [ -e "$ACCESS_TOKEN_FILE" ]; then
source ~/.setup_vars
  if [ ! -e "$MYGITTOKEN" ]; then
  echo ""
  echo -e "${GREEN}Adding Github token to VM... ${NC}"
  # Add the user's Github token.
  composer config -g github-oauth.github.com "$MYGITTOKEN"
  else
    read -p "$(echo -e $LIGHTERBLUE"Enter the name of your Github private key "$NC"(ex. id_rsa): ")" MYGITPRIVATEKEY
echo -e "\n"
read -p "$(echo -e $LIGHTERBLUE"Enter your Github username "$NC" ")"  MYGITUSERNAME
read -p "$(echo -e $LIGHTERBLUE"Enter your Github email address "$NC" ")"  MYGITEMAIL
read -p "$(echo -e $LIGHTERBLUE"Enter your Github access token "$NC"(from https://github.com/settings/tokens): ")" MYGITTOKEN

echo -e "\n"

SAVEDGITPRIVATEKEY='MYGITPRIVATEKEYN="'$MYGITPRIVATEKEY'"'
echo $SAVEDGITPRIVATEKEY >> /home/vagrant/.setup_vars
SAVEDGITTOKEN='MYGITTOKEN="'$MYGITTOKEN'"'
echo $SAVEDGITTOKEN >> /home/vagrant/.setup_vars
SAVEDGITUSERNAME='MYGITUSERNAME="'$MYGITUSERNAME'"'
echo $SAVEDGITUSERNAME >> /home/vagrant/.setup_vars
SAVEDGITEMAIL='MYGITEMAIL="'$MYGITEMAIL'"'
echo $SAVEDGITEMAIL >> /home/vagrant/.setup_vars
source ~/.setup_vars
  fi
  sleep 3
fi

  # Run the refresh script.
  bash scripts/refresh-local.sh

  sleep 3

  # Open the dashboard in Safari.
   open -a safari http://dashboard.adtalemteam.local

  # Remove the active bash_profile
  rm -rf /home/vagrant/.bash_profile
  source ~/.bashrc

  # Completion messages.
echo ""
echo "---------------------------------------------------------------"
echo -e "${GREEN}LOCAL ENVIRONMENT SETUP COMPLETED:${NC}"
echo -e $NOW
echo "---------------------------------------------------------------"
echo ""

else
echo ""
echo "---------------------------------------------------------------"
echo -e "${GREEN}YOUR LOCAL ENVIRONMENT HAS ALREADY BEEN SET UP${NC}"
echo -e $NOW
echo "---------------------------------------------------------------"
echo ""
  # Run the refresh script.
  bash scripts/refresh-local.sh

  sleep 3

  # Open the dashboard in Safari.
   open -a safari http://dashboard.adtalemteam.local

  # Remove the active bash_profile
  rm -rf /home/vagrant/.bash_profile
  source ~/.bashrc
  sleep 3
  exit 0
fi
