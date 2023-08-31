#!/bin/bash

if [ $# -ne 1 ]; then
    echo "Usage: $0 <CHANNEL_NUMBER>"
    exit 1
fi

CHANNEL_NUMBER=$1

OSN_TLS_CA_ROOT_CERT=/home/pi/fabric/organizations/ordererOrganizations/container${CHANNEL_NUMBER}.blocc.doc.ic.ac.uk/tlsca/tlsca.container${CHANNEL_NUMBER}.blocc.doc.ic.ac.uk-cert.pem

cd ~/fabric || exit

# Download packaged chaincode to ~/fabric
wget https://github.com/ImperialCollegeLondon/blocc-temp-humidity-chaincode/releases/download/blocc-test/sensor_chaincode.tar.gz

# Install chaincode
peer lifecycle chaincode install ./sensor_chaincode.tar.gz

# Verify installation
peer lifecycle chaincode queryinstalled --output json | jq

# Get package ID
PACKAGE_ID=$(peer lifecycle chaincode calculatepackageid ./sensor_chaincode.tar.gz)

peer lifecycle chaincode approveformyorg \
-o blocc-container"${CHANNEL_NUMBER}":7050 \
--tls --cafile "${OSN_TLS_CA_ROOT_CERT}" \
--channelID channel"${CHANNEL_NUMBER}" \
--name sensor_chaincode --package-id "${PACKAGE_ID}" --version 1.0 --sequence 1 \
--signature-policy "AND('Container${CHANNEL_NUMBER}MSP.peer')"

peer lifecycle chaincode checkcommitreadiness \
--channelID channel"${CHANNEL_NUMBER}" --name sensor_chaincode --version 1.0 --sequence 1 \
--signature-policy "AND('Container${CHANNEL_NUMBER}MSP.peer')" --output json | jq