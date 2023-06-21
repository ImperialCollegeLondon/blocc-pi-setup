#!/bin/bash

source utils.sh

echo -e "${C_BLUE}Installing Docker...${C_BLUE}"

install_package docker-compose

echo -e "${C_BLUE}Installing jq...${C_BLUE}"

install_package jq

echo -e "${C_BLUE}Running Docker daemon on start...${C_BLUE}"
sudo systemctl enable docker
sudo systemctl start docker

echo -e "${C_BLUE}Adding Docker to this user group...${C_BLUE}"
sudo usermod -aG docker $USER

echo -e "${C_BLUE}Creating Go project directroy...${C_BLUE}"
mkdir -p $HOME/go/src/github.com/TonyWu3027
cd $HOME/go/src/github.com/TonyWu3027

echo -e "${C_BLUE}Downloading Hyperledger Fabric installation script...${C_BLUE}"
curl -sSLO https://raw.githubusercontent.com/hyperledger/fabric/main/scripts/install-fabric.sh && chmod +x install-fabric.sh

echo -e "${C_BLUE}Installing Hyperledger Fabric binaries...${C_BLUE}"
./install-fabric.sh binary
you
echo -e "${C_BLUE}Installing Hyperledger Fabric Docker images...${C_BLUE}"
sudo ./install-fabric.sh docker

echo -e "${C_YELLOW}Note that: you may need to log back in to use docker without sudo${C_YELLOW}"