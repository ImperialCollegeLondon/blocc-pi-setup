# BLOCC Raspberry Pi Setup

This repository contains the setup scripts to prepare a Raspberry Pi 4B to be used in the BLOCC project.

## Scripts

- [`fabric-setup.sh`](./fabric-setup.sh): the script to install Hyperledger Fabric (HLF) on the Pi
- [`mesh-setup.sh`](./mesh-setup.sh): the script to setup the Pi to join a Mesh network called `blocc-mesh`
- [`pi-setup.sh`](./pi-setup.sh): the script to install miscellaneous packages required on the Pi
- [`update-bat-hosts.sh`](./update-bat-hosts.sh): `bat-hosts` is a mapping from the MAC addresses of the `wlan0` interfaces on the Pis to an identifiable name (e.g. hostname). This script replaces the `bat-hosts` file on the Pi (situated in `/etc/`) with that in this repository
