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

FABRIC_DIR="$HOME/fabric"

if [ -d "$FABRIC_DIR" ]; then
  echo -e "${C_YELLOW}Hyperledger Fabric is already installed. Skipping installation.${C_RESET}"
else
  echo -e "${C_BLUE}Creating fabric directory...${C_RESET}"
  mkdir -p "$FABRIC_DIR"
  cd "$FABRIC_DIR" || exit

  echo -e "${C_BLUE}Downloading Hyperledger Fabric installation script...${C_RESET}"
  curl -sSLO https://raw.githubusercontent.com/hyperledger/fabric/main/scripts/install-fabric.sh && chmod +x install-fabric.sh

  echo -e "${C_BLUE}Installing Hyperledger Fabric binaries...${C_RESET}"
  ./install-fabric.sh binary
  echo -e "${C_GREEN}Hyperledger Fabric binaries installed.${C_RESET}"

  echo -e "${C_BLUE}Installing Hyperledger Fabric Docker images...${C_RESET}"
  sudo ./install-fabric.sh docker
  echo -e "${C_GREEN}Hyperledger Fabric Docker images installed.${C_RESET}"
fi

# Add ~/fabric/bin to PATH if not already added
if [[ ":$PATH:" != *":$FABRIC_DIR/bin:"* ]]; then
  echo -e "${C_BLUE}Adding Hyperledger Fabric binaries to PATH...${C_RESET}"
  echo 'export PATH="$HOME/fabric/bin:$PATH"' >> ~/.bashrc
  source ~/.bashrc
fi

if [ "$1" == "orderer" ] || [ "$1" == "peer" ]; then
  echo -e "${C_BLUE}Adding ${1} compose file to fabric directory...${C_RESET}"
  cp ./compose/compose-${1}.yaml ~/fabric/
fi

echo -e "${C_BLUE}Adding container control script to fabric directory...${C_RESET}"
cp ./container.sh ~/fabric/

echo -e "${C_YELLOW}Note that: you may need to log back in to use docker without sudo${C_RESET}"