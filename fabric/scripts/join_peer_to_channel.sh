#!/bin/bash

set -x

if [ $# -ne 1 ]; then
    echo "Usage: $0 <CHANNEL_NUMBER>"
    exit 1
fi

CHANNEL_NUMBER=$1

export OSN_TLS_CA_ROOT_CERT=/home/pi/fabric/organizations/ordererOrganizations/container${CHANNEL_NUMBER}.blocc.doc.ic.ac.uk/tlsca/tlsca.container${CHANNEL_NUMBER}.blocc.doc.ic.ac.uk-cert.pem

# Fetch genesis block
peer channel fetch 0 ~/fabric/channel-artefacts/channel"${CHANNEL_NUMBER}"-genesis.block \
-c channel"${CHANNEL_NUMBER}" \
-o blocc-container"${CHANNEL_NUMBER}":7050 \
--tls --cafile "$OSN_TLS_CA_ROOT_CERT"

# Join channel
peer channel join -b ~/fabric/channel-artefacts/channel"${CHANNEL_NUMBER}"-genesis.block

### Make itself the anchor peer ###

# Fetch latest config block
peer channel fetch config ~/fabric/channel-artefacts/config_block.pb \
-o blocc-container"${CHANNEL_NUMBER}":7050 \
-c channel"${CHANNEL_NUMBER}" \
--tls --cafile "$OSN_TLS_CA_ROOT_CERT"

# Decode config block to config_block.json and isolating config to original.json
configtxlator proto_decode \
--input ~/fabric/channel-artefacts/config_block.pb \
--type common.Block \
--output ~/fabric/channel-artefacts/config_block.json

jq .data.data[0].payload.data.config ~/fabric/channel-artefacts/config_block.json > ~/fabric/channel-artefacts/original.json


# Modify the config to append the anchor peer
jq '.channel_group.groups.Application.groups.Container'"$FABRIC_CONTAINER_NUM"'MSP.values += {"AnchorPeers":{"mod_policy": "Admins","value":{"anchor_peers": [{"host": "blocc-container'"$FABRIC_CONTAINER_NUM"'","port": 7051}]},"version": "0"}}'  ~/fabric/channel-artefacts/original.json >  ~/fabric/channel-artefacts/modified.json


# Takes an original and modified config, and produces the config update tx

configtxlator proto_encode --input ~/fabric/channel-artefacts/original.json --type common.Config --output ~/fabric/channel-artefacts/original_config.pb

configtxlator proto_encode --input ~/fabric/channel-artefacts/modified.json --type common.Config --output ~/fabric/channel-artefacts/modified_config.pb

configtxlator compute_update --channel_id channel"$CHANNEL_NUMBER" --original ~/fabric/channel-artefacts/original_config.pb --updated ~/fabric/channel-artefacts/modified_config.pb --output ~/fabric/channel-artefacts/config_update.pb

configtxlator proto_decode --input ~/fabric/channel-artefacts/config_update.pb --type common.ConfigUpdate --output ~/fabric/channel-artefacts/config_update.json

echo '{"payload":{"header":{"channel_header":{"channel_id":"channel'"$CHANNEL_NUMBER"'", "type":2}},"data":{"config_update":'$(cat ~/fabric/channel-artefacts/config_update.json)'}}}' | jq . > ~/fabric/channel-artefacts/config_update_in_envelope.json

configtxlator proto_encode --input ~/fabric/channel-artefacts/config_update_in_envelope.json --type common.Envelope --output ~/fabric/channel-artefacts/anchors.tx

# Update the channel config
peer channel update \
-o blocc-container"$CHANNEL_NUMBER":7050 \
-c channel"$CHANNEL_NUMBER" \
-f ~/fabric/channel-artefacts/anchors.tx \
--tls --cafile "$OSN_TLS_CA_ROOT_CERT"

# Clean up generated files
rm -f ~/fabric/channel-artefacts/config_block \
~/fabric/channel-artefacts/original.json \
~/fabric/channel-artefacts/modified.json \
~/fabric/channel-artefacts/original_config.pb \
~/fabric/channel-artefacts/modified_config.pb \
~/fabric/channel-artefacts/config_update.pb \
~/fabric/channel-artefacts/config_update.json \
~/fabric/channel-artefacts/config_update_in_envelope.json \
~/fabric/channel-artefacts/anchors.tx

set +x