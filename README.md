# BLOCC Raspberry Pi Setup

This repository contains the setup scripts to prepare a Raspberry Pi 4B to be used in the BLOCC project.

## Scripts

- [`fabric-setup.sh`](./fabric-setup.sh): the script to install Hyperledger Fabric (HLF) on the Pi
- [`mesh-setup.sh`](./mesh-setup.sh): the script to setup the Pi to join a Mesh network called `blocc-mesh`
- [`pi-setup.sh`](./pi-setup.sh): the script to install miscellaneous packages required on the Pi

## Docker Compose files

[`fabric/compose/`](./fabric/compose/) directory consists of 2 docker-compose for composing a peer and an orderer container. This is to be used with [`fabric/container.sh`](./fabric/container.sh) to bring up/down the containers.
