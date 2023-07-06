#!/bin/bash

set -e

source ../utils.sh

if ! which vim; then
    echo -e "${C_RED}Vim is not installed...${C_RESET}"
    exit 1
fi