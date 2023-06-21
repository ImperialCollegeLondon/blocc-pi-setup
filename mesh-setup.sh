#!/bin/bash

set -e

C_BLUE='\033[0;34m'
C_RED='\033[0;31m'
C_YELLOW='\033[1;33m'
C_GREEN='\033[0;32m'


echo "${C_BLUE}Starting setup...${C_BLUE}"

function install_package {
  local package=$1
  if dpkg -l $package; then
    echo "${C_GREEN}$package is already installed.${C_GREEN}"
  else
    echo "${C_BLUE}Installing $package...${C_BLUE}"
    sudo apt-get install -y $package
  fi
}

echo "${C_BLUE}Loading batman-adv at boot time...${C_BLUE}"
echo 'batman-adv' | sudo tee --append /etc/modules

install_package batctl

echo "${C_BLUE}Copying the start script...${C_BLUE}"

mkdir -p ~/mesh
cp ./start-batman-adv.sh ~/mesh

echo "${C_BLUE}Copying the wlan0 interface definition...${C_BLUE}"
sudo cp ./wlan0 /etc/network/interfaces.d

echo "${C_BLUE}Disabling DHCP client from managing wlan0...${C_BLUE}"
echo 'denyinterfaces wlan0' | sudo tee --append /etc/dhcpcd.conf

echo "${C_BLUE}Running start-batman-adv.sh at boot time...${C_BLUE}"
start_script="/home/pi/mesh/start-batman-adv.sh"
rc_local_file="/etc/rc.local"

# Check if the command is already in the file
if ! grep -Fxq "$start_script" "$rc_local_file"
then
    # If the command isn't in the file, add it
    # We use sed to insert the command before the 'exit 0' line
    sudo sed -i "s|^exit 0.*$|# Run batman-adv at boot time\n$start_script\n\nexit 0|" "$rc_local_file"
fi

echo "${C_BLUE}Copying the bat-hosts...${C_BLUE}"
sudo cp ./bat-hosts /etc

