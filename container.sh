#!/bin/bash

set -e

source utils.sh

function printHelp() {
    echo "Brings up/down a peer/orderer docker container"
    echo
    echo -e "Usage: $0 ${C_YELLOW}<node> <action>${C_RESET}"
    echo -e "  ${C_YELLOW}<node>${C_RESET}    : 'orderer' or 'peer'"
    echo -e "  ${C_YELLOW}<action>${C_RESET}  : 'up' or 'down'"
}

function containerUp() {
    echo -e "${C_BLUE}Bringing up ${NODE}...${C_RESET}"
    docker-compose -f ~/fabric/compose-"${NODE}".yaml up -d
    echo -e "${C_GREEN}${NODE} container is up${C_RESET}"
}

function containerDown() {
    echo -e "${C_BLUE}Bringing down ${NODE}...${C_RESET}"
    docker-compose -f ~/fabric/compose-"${NODE}".yaml down --volumes --remove-orphans
    echo -e "${C_GREEN}${NODE} container is removed${C_RESET}"
}

# Check if help flag is provided
if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    printHelp
    exit 0
fi

# Check the number of arguments
if [ $# -ne 2 ]; then
    echo -e "${C_RED}Invalid number of arguments!${C_RESET}"
    printHelp
    exit 1
fi

NODE=$1
ACTION=$2

if [ "$NODE" != "orderer" ] && [ "$NODE" != "peer" ]; then
    echo "Invalid node: $NODE"
    printHelp
    exit 1
fi

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