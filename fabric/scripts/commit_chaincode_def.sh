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
PEER_CONTAINER1_CA_ROOT_CERT=/home/pi/fabric/organizations/peerOrganizations/container1.blocc.doc.ic.ac.uk/peers/peer0.container1.blocc.doc.ic.ac.uk/tls/ca.crt
PEER_CONTAINER2_CA_ROOT_CERT=/home/pi/fabric/organizations/peerOrganizations/container2.blocc.doc.ic.ac.uk/peers/peer0.container2.blocc.doc.ic.ac.uk/tls/ca.crt
PEER_CONTAINER3_CA_ROOT_CERT=/home/pi/fabric/organizations/peerOrganizations/container3.blocc.doc.ic.ac.uk/peers/peer0.container3.blocc.doc.ic.ac.uk/tls/ca.crt
PEER_CONTAINER4_CA_ROOT_CERT=/home/pi/fabric/organizations/peerOrganizations/container4.blocc.doc.ic.ac.uk/peers/peer0.container4.blocc.doc.ic.ac.uk/tls/ca.crt
PEER_CONTAINER5_CA_ROOT_CERT=/home/pi/fabric/organizations/peerOrganizations/container5.blocc.doc.ic.ac.uk/peers/peer0.container5.blocc.doc.ic.ac.uk/tls/ca.crt
PEER_CONTAINER6_CA_ROOT_CERT=/home/pi/fabric/organizations/peerOrganizations/container6.blocc.doc.ic.ac.uk/peers/peer0.container6.blocc.doc.ic.ac.uk/tls/ca.crt
PEER_CONTAINER7_CA_ROOT_CERT=/home/pi/fabric/organizations/peerOrganizations/container7.blocc.doc.ic.ac.uk/peers/peer0.container7.blocc.doc.ic.ac.uk/tls/ca.crt
PEER_CONTAINER8_CA_ROOT_CERT=/home/pi/fabric/organizations/peerOrganizations/container8.blocc.doc.ic.ac.uk/peers/peer0.container8.blocc.doc.ic.ac.uk/tls/ca.crt
PEER_CONTAINER9_CA_ROOT_CERT=/home/pi/fabric/organizations/peerOrganizations/container9.blocc.doc.ic.ac.uk/peers/peer0.container9.blocc.doc.ic.ac.uk/tls/ca.crt
PEER_CONTAINER10_CA_ROOT_CERT=/home/pi/fabric/organizations/peerOrganizations/container10.blocc.doc.ic.ac.uk/peers/peer0.container10.blocc.doc.ic.ac.uk/tls/ca.crt
PEER_CONTAINER11_CA_ROOT_CERT=/home/pi/fabric/organizations/peerOrganizations/container11.blocc.doc.ic.ac.uk/peers/peer0.container11.blocc.doc.ic.ac.uk/tls/ca.crt
PEER_CONTAINER12_CA_ROOT_CERT=/home/pi/fabric/organizations/peerOrganizations/container12.blocc.doc.ic.ac.uk/peers/peer0.container12.blocc.doc.ic.ac.uk/tls/ca.crt

peer lifecycle chaincode commit \
-o "$ORDERER_ENDPOINT" \
--tls --cafile ${OSN_TLS_CA_ROOT_CERT} \
--channelID channel"$CHANNEL_NUMBER" --name sensor_chaincode \
--version 1.0 --sequence 1 \
--signature-policy "AND('Container${CHANNEL_NUMBER}MSP.peer')" \
--peerAddresses 192.168.199.201:7051 \
--tlsRootCertFiles ${PEER_CONTAINER1_CA_ROOT_CERT} \
--peerAddresses 192.168.199.202:7051 \
--tlsRootCertFiles ${PEER_CONTAINER2_CA_ROOT_CERT} \
--peerAddresses 192.168.199.203:7051 \
--tlsRootCertFiles ${PEER_CONTAINER3_CA_ROOT_CERT} \
--peerAddresses 192.168.199.204:7051 \
--tlsRootCertFiles ${PEER_CONTAINER4_CA_ROOT_CERT} \
--peerAddresses 192.168.199.205:7051 \
--tlsRootCertFiles ${PEER_CONTAINER5_CA_ROOT_CERT} \
--peerAddresses 192.168.199.206:7051 \
--tlsRootCertFiles ${PEER_CONTAINER6_CA_ROOT_CERT} \
--peerAddresses 192.168.199.207:7051 \
--tlsRootCertFiles ${PEER_CONTAINER7_CA_ROOT_CERT} \
--peerAddresses 192.168.199.208:7051 \
--tlsRootCertFiles ${PEER_CONTAINER8_CA_ROOT_CERT} \
--peerAddresses 192.168.199.209:7051 \
--tlsRootCertFiles ${PEER_CONTAINER9_CA_ROOT_CERT} \
--peerAddresses 192.168.199.210:7051 \
--tlsRootCertFiles ${PEER_CONTAINER10_CA_ROOT_CERT} \
--peerAddresses 192.168.199.211:7051 \
--tlsRootCertFiles ${PEER_CONTAINER11_CA_ROOT_CERT} \
--peerAddresses 192.168.199.212:7051 \
--tlsRootCertFiles ${PEER_CONTAINER12_CA_ROOT_CERT} 

set +x
