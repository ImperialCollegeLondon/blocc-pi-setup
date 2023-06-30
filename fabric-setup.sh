#!/bin/bash

source utils.sh

echo -e "${C_BLUE}Installing Docker...${C_RESET}"

install_package docker-compose

echo -e "${C_BLUE}Installing jq...${C_RESET}"

install_package jq

echo -e "${C_BLUE}Running Docker daemon on start...${C_RESET}"
sudo systemctl enable docker
sudo systemctl start docker

echo -e "${C_BLUE}Adding Docker to this user group...${C_RESET}"
sudo usermod -aG docker $USER

echo -e "${C_BLUE}Creating fabric directroy...${C_RESET}"
mkdir -p "$HOME"/fabric
cd "$HOME"/fabric || exit

echo -e "${C_BLUE}Downloading Hyperledger Fabric installation script...${C_RESET}"
curl -sSLO https://raw.githubusercontent.com/hyperledger/fabric/main/scripts/install-fabric.sh && chmod +x install-fabric.sh

echo -e "${C_BLUE}Installing Hyperledger Fabric binaries...${C_RESET}"
./install-fabric.sh binary

echo -e "${C_BLUE}Installing Hyperledger Fabric Docker images...${C_RESET}"
sudo ./install-fabric.sh docker

echo -e "${C_YELLOW}Note that: you may need to log back in to use docker without sudo${C_RESET}"