#!/bin/bash

set -x

if [ $# -ne 1 ]; then
    echo "Usage: $0 <CHANNEL_NUMBER>"
    exit 1
fi

CHANNEL_NUMBER=$1

# Calculate IP Suffix based on CHANNEL_NUMBER
if [[ $CHANNEL_NUMBER -ge 1 && $CHANNEL_NUMBER -le 9 ]]; then
    IP_SUFFIX=20$CHANNEL_NUMBER
elif [[ $CHANNEL_NUMBER -ge 10 && $CHANNEL_NUMBER -le 12 ]]; then
    IP_SUFFIX=2$CHANNEL_NUMBER
else
    echo "Invalid CHANNEL_NUMBER"
    exit 1
fi

# Replace hostname with static IP
ORDERER_ENDPOINT=192.168.199.$IP_SUFFIX:7050

OSN_TLS_CA_ROOT_CERT=/home/pi/fabric/organizations/ordererOrganizations/container${CHANNEL_NUMBER}.blocc.doc.ic.ac.uk/tlsca/tlsca.container${CHANNEL_NUMBER}.blocc.doc.ic.ac.uk-cert.pem

peer lifecycle chaincode commit \
-o "$ORDERER_ENDPOINT" \
--tls --cafile ${OSN_TLS_CA_ROOT_CERT} \
--channelID channel"$CHANNEL_NUMBER" --name sensor_chaincode \
--version 1.0 --sequence 1 \
--signature-policy "AND('Container${CHANNEL_NUMBER}MSP.peer')"

set +x
