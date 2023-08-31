#!/bin/bash

if [ $# -ne 1 ]; then
    echo "Usage: $0 <CHANNEL_NUMBER>"
    exit 1
fi

CHANNEL_NUMBER=$1

export OSN_TLS_CA_ROOT_CERT=/home/pi/fabric/organizations/ordererOrganizations/container${FABRIC_CONTAINER_NUM}.blocc.doc.ic.ac.uk/tlsca/tlsca.container${FABRIC_CONTAINER_NUM}.blocc.doc.ic.ac.uk-cert.pem
export ADMIN_TLS_SIGN_CERT=/home/pi/fabric/organizations/ordererOrganizations/container${FABRIC_CONTAINER_NUM}.blocc.doc.ic.ac.uk/orderers/orderer.container${FABRIC_CONTAINER_NUM}.blocc.doc.ic.ac.uk/tls/server.crt
export ADMIN_TLS_PRIVATE_KEY=/home/pi/fabric/organizations/ordererOrganizations/container${FABRIC_CONTAINER_NUM}.blocc.doc.ic.ac.uk/orderers/orderer.container${FABRIC_CONTAINER_NUM}.blocc.doc.ic.ac.uk/tls/server.key

# Generate genesis block
configtxgen -profile Channel"$CHANNEL_NUMBER"Genesis -outputBlock "$HOME"/fabric/channel-artefacts/channel"${CHANNEL_NUMBER}"-genesis.block -channelID channel"$CHANNEL_NUMBER"

# Join orderer to the channel
osnadmin channel join -o localhost:7053 \
    --config-block "$HOME"/fabric/channel-artefacts/channel"${CHANNEL_NUMBER}"-genesis.block \
--channelID channel"${CHANNEL_NUMBER}" --ca-file "$OSN_TLS_CA_ROOT_CERT" \
--client-cert "$ADMIN_TLS_SIGN_CERT" --client-key "$ADMIN_TLS_PRIVATE_KEY"