#!/bin/bash

source utils.sh

function printHelp() {
  echo -e "Usage: $0 ${C_BLUE}<mode> ${C_YELLOW}[options]${C_RESET}"
  echo
  echo -e "${C_BLUE}Modes:"
  echo -e "  orderer        Set up orderer"
  echo -e "  peer           Set up peer${C_RESET}"
  echo
  echo -e "${C_YELLOW}Options:"
  echo -e "  -h, --help     Display this help message"
  echo -e "  --container=<container_number>"
  echo -e "                 Set the FABRIC_CONTAINER_NUM environment variable for the peer"
  echo -e "                 (Only applicable in peer mode)"
  echo -e "                 Example: $0 peer --container=1${C_RESET}"
}

if [ "$1" == "-h" ] || [ "$1" == "--help" ]; then
  printHelp
  exit 0
fi

if [ "$1" == "orderer" ]; then
  echo -e "${C_BLUE}Adding orderer compose file to fabric directory...${C_RESET}"
  cp ./fabric/compose/compose-orderer.yaml ~/fabric/

  echo -e "${C_BLUE}Adding core.yaml to fabric directory...${C_RESET}"
  cp ./fabric/config/orderer.yaml ~/fabric/config

elif [ "$1" == "peer" ]; then
  CONTAINER_FLAG="--container"

  function setContainerEnvironmentVariable() {
    local container_num="$1"
    if ! grep -q "FABRIC_CONTAINER_NUM" ~/.bashrc; then
      echo "export FABRIC_CONTAINER_NUM=$container_num" >> ~/.bashrc
      source ~/.bashrc
      echo "FABRIC_CONTAINER_NUM has been set to: $container_num"
    else
      echo "FABRIC_CONTAINER_NUM is already set in ~/.bashrc."
    fi
  }

  if [[ "$2" == "$CONTAINER_FLAG"* ]]; then
    container_number="${2#*=}"
    setContainerEnvironmentVariable "$container_number"
  else
    echo -e "${C_RED}Missing container number!${C_RESET}"
    printHelp
    exit 1
  fi

  echo -e "${C_BLUE}Adding peer compose file to fabric directory...${C_RESET}"
  cp ./fabric/compose/compose-peer.yaml ~/fabric/

  echo -e "${C_BLUE}Adding core.yaml to fabric directory...${C_RESET}"
  sed "s/\${FABRIC_CONTAINER_NUM}/${container_number}/" ./fabric/config/core.yaml > ~/fabric/config/core.yaml

else
  printHelp
  exit 1
fi

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

  # Going back to working directory
  cd "$HOME/blocc-pi-setup" || exit
fi

# Add ~/fabric/bin to PATH if not already added
if [[ ":$PATH:" != *":$FABRIC_DIR/bin:"* ]]; then
  echo -e "${C_BLUE}Adding Hyperledger Fabric binaries to PATH...${C_RESET}"
  echo 'export PATH="$HOME/fabric/bin:$PATH"' >> ~/.bashrc
  source ~/.bashrc
fi

# Set FABRIC_CFG_PATH if not already set
if ! grep -q "export FABRIC_CFG_PATH=~/fabric/config" ~/.bashrc
then
    echo 'export FABRIC_CFG_PATH=~/fabric/config' >> ~/.bashrc
    echo 'FABRIC_CFG_PATH added to ~/.bashrc'
else
    echo 'FABRIC_CFG_PATH already exists in ~/.bashrc'
fi

echo -e "${C_BLUE}Adding container control script to fabric directory...${C_RESET}"
cp ./fabric/container.sh ~/fabric/

echo -e "${C_BLUE}Adding crytogen config to fabric directory...${C_RESET}"
cp ./fabric/config/crypto-config.yaml ~/fabric

echo -e "${C_BLUE}Adding configtx.yaml to fabric directory...${C_RESET}"
cp ./fabric/config/configtx.yaml ~/fabric/config

echo -e "${C_YELLOW}Note that: you may need to log back in to use docker without sudo${C_RESET}"
echo -e "${C_RED}Note that: you need source ~/.bashrc to activate the settings${C_RESET}"