#!/bin/bash

set -e

C_BLUE='\033[0;34m'
C_RED='\033[0;31m'
C_YELLOW='\033[1;33m'
C_GREEN='\033[0;32m'
C_RESET='\033[0m'

function printHelp() {
    echo "Brings up/down a peer and an orderer docker container"
    echo
    echo -e "Usage: $0 ${C_YELLOW}<action>${C_RESET}"
    echo -e "  ${C_YELLOW}<action>${C_RESET}  : 'up' or 'down'"
}

function containerUp() {
    echo -e "${C_BLUE}Bringing up containers...${C_RESET}"
    docker-compose -f ~/fabric/compose.yaml up -d
    echo -e "${C_GREEN}Containers are up${C_RESET}"
}

function containerDown() {
    echo -e "${C_BLUE}Bringing down containers...${C_RESET}"
    docker-compose -f ~/fabric/compose.yaml down --volumes --remove-orphans
    echo -e "${C_GREEN}Containers are removed${C_RESET}"
}

# Check if help flag is provided
if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    printHelp
    exit 0
fi

# Check the number of arguments
if [ $# -ne 1 ]; then
    echo -e "${C_RED}Invalid number of arguments!${C_RESET}"
    printHelp
    exit 1
fi

ACTION=$1

if [ "$ACTION" != "up" ] && [ "$ACTION" != "down" ]; then
    echo "Invalid action: $ACTION"
    printHelp
    exit 1
fi

if [ "$ACTION" == "up" ]; then
    containerUp
elif [ "$ACTION" == "down" ]; then
    containerDown
fi