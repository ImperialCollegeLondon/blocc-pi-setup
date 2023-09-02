#!/bin/bash

set -e

source utils.sh

printHelp() {
    echo -e "Usage: $0 ${C_BLUE}[-r] [-h] IP_SUFFIX${C_RESET}"
    echo "Options:"
    echo -e "   ${C_BLUE}-r${C_RESET}    Reboot after the script completes"
    echo -e "   ${C_BLUE}-h${C_RESET}    Display this help message"
    echo -e "   IP_SUFFIX    Last two digits of IP for bat0 (e.g., 01)"
}

REBOOT_FLAG=0
IP_SUFFIX=""

while getopts ":rh" opt; do
    case $opt in
        r)
            REBOOT_FLAG=1
            ;;
        h)
            printHelp
            exit 0
            ;;
        \?)
            echo -e "${C_RED}Invalid option: -$OPTARG${C_RESET}" >&2
            printHelp
            exit 1
            ;;
    esac
done

shift $((OPTIND-1))  # Shift off the options and optional --.


# Retrieve IP_SUFFIX argument
if [[ $# -gt 0 ]]; then
    IP_SUFFIX=$1
else
    echo -e "${C_RED}IP_SUFFIX not provided.${C_RESET}" >&2
    printHelp
    exit 1
fi

echo -e "${C_BLUE}Loading batman-adv at boot time...${C_RESET}"
if ! grep -qxF 'batman-adv' /etc/modules; then
    echo 'batman-adv' | sudo tee --append /etc/modules
fi

install_package batctl

echo -e "${C_BLUE}Copying the start script...${C_RESET}"

mkdir -p ~/mesh
mkdir -p ~/mesh
sed "s|IP_PLACEHOLDER|192.168.199.2$IP_SUFFIX/24|" ./mesh/start-batman-adv.sh > ~/mesh/start-batman-adv-temp.sh
mv ~/mesh/start-batman-adv-temp.sh ~/mesh/start-batman-adv.sh
chmod +x ~/mesh/start-batman-adv.sh

echo -e "${C_BLUE}Copying the wlan0 interface definition...${C_RESET}"
sudo cp ./mesh/wlan0 /etc/network/interfaces.d

echo -e "${C_BLUE}Disabling DHCP client from managing wlan0...${C_RESET}"
if ! grep -qxF 'denyinterfaces wlan0' /etc/dhcpcd.conf; then
    echo 'denyinterfaces wlan0' | sudo tee --append /etc/dhcpcd.conf
fi

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
sudo cp ./mesh/bat-hosts /etc

if [[ "$REBOOT_FLAG" -eq 1 ]]; then
    echo -e "${C_GREEN}Rebooting now...${C_RESET}"
    sudo reboot
else
    echo -e "${C_YELLOW}Skipping reboot...${C_RESET}"
fi