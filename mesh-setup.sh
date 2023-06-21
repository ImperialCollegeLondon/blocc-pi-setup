#!/bin/bash

set -e

source utils.sh

echo -e "${C_BLUE}Starting setup...${C_RESET}"

echo -e "${C_BLUE}Loading batman-adv at boot time...${C_RESET}"
echo 'batman-adv' | sudo tee --append /etc/modules

install_package batctl

echo -e "${C_BLUE}Copying the start script...${C_RESET}"

mkdir -p ~/mesh
cp ./start-batman-adv.sh ~/mesh

echo -e "${C_BLUE}Copying the wlan0 interface definition...${C_RESET}"
sudo cp ./wlan0 /etc/network/interfaces.d

echo -e "${C_BLUE}Disabling DHCP client from managing wlan0...${C_RESET}"
echo 'denyinterfaces wlan0' | sudo tee --append /etc/dhcpcd.conf

echo -e "${C_BLUE}Running start-batman-adv.sh at boot time...${C_RESET}"
start_script="/home/pi/mesh/start-batman-adv.sh"
rc_local_file="/etc/rc.local"

# Check if the command is already in the file
if ! grep -Fxq "$start_script" "$rc_local_file"
then
    # If the command isn't in the file, add it
    # We use sed to insert the command before the 'exit 0' line
    sudo sed -i "s|^exit 0.*$|# Run batman-adv at boot time\n$start_script\n\nexit 0|" "$rc_local_file"
fi

echo -e "${C_BLUE}Copying the bat-hosts...${C_RESET}"
sudo cp ./bat-hosts /etc

