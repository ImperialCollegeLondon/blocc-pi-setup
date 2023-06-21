#!/bin/bash

C_BLUE='\033[0;34m'
C_RED='\033[0;31m'
C_YELLOW='\033[1;33m'
C_GREEN='\033[0;32m'

function install_package {
  local package=$1
  if dpkg -l $package; then
    echo -e "${C_RED}$package is already installed.${C_RED}"
  else
    echo -e "${C_YELLOW}Installing $package...${C_YELLOW}"
    sudo apt-get install -y $package
  fi
}

export -f install_package