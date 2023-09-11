#!/bin/bash

# Check for the correct number of arguments
if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <operation>"
  echo "Operation can be either 'simulate' or 'check'"
  exit 1
fi

# Get the operation from the first argument
OPERATION=$1

# Set up environment variables
PEER_CA=$HOME/fabric/organizations/peerOrganizations/container${FABRIC_CONTAINER_NUM}.blocc.doc.ic.ac.uk/peers/peer0.container${FABRIC_CONTAINER_NUM}.blocc.doc.ic.ac.uk/tls/ca.crt
ORDERER_CA=$HOME/fabric/organizations/ordererOrganizations/container${FABRIC_CONTAINER_NUM}.blocc.doc.ic.ac.uk/orderers/orderer.container${FABRIC_CONTAINER_NUM}.blocc.doc.ic.ac.uk/msp/tlscacerts/tlsca.container${FABRIC_CONTAINER_NUM}.blocc.doc.ic.ac.uk-cert.pem

# Simulate or check fork based on the operation
if [ "$OPERATION" == "simulate" ]; then
  peer blocc bscc simulatefork \
  --ordererAddress localhost:7050 \
  --rootCertFilePath "${ORDERER_CA}" \
  --channelID channel"${FABRIC_CONTAINER_NUM}" \
  --peerAddress localhost:7051 --tlsRootCertFile "${PEER_CA}"
elif [ "$OPERATION" == "check" ]; then
  peer chaincode query -C channel${FABRIC_CONTAINER_NUM} -n bscc\
  -c '{"Args":["CheckForkStatus", "channel'${FABRIC_CONTAINER_NUM}'"]}'
else
  echo "Invalid operation. Use either 'simulate' or 'check'"
  exit 1
fi
