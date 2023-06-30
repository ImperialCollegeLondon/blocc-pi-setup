#!/bin/bash

set -e

source utils.sh

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

if [ "$1" == "orderer" ] || [ "$1" == "peer" ]; then
    NODE=$1
    shift
else
    exit 0
fi

if [ "$1" == "up" ]; then
    containerUp
elif [ "$1" == "down" ]; then
    containerDown
fi