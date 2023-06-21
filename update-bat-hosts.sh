#!/bin/bash

source utils.sh

echo -e "${C_BLUE}Updating bat-hosts...${C_RESET}"

rm -f /etc/bat-hosts
sudo cp ./bat-hosts /etc

echo -e "${C_GREEN}Updating bat-hosts completes...${C_RESET}"