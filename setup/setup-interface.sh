#!/bin/bash
# Copyright (C) 2021 Domien Schepers.

if [[ $# -eq 0 ]] ; then
    echo "Usage; $0 iface [channel] [bandwidth] [mode] [mode-flag]"
    exit 1
fi

# Parameters, defaulting to Channel 149/80MHz in monitor mode.
# Set monitor mode flag to "active" to acknowledge unicast traffic. 
IFACE=$1
CHANNEL=${2:-"149"}
BW=${3:-"80MHz"}
MODE=${4:-"monitor"}
MODE_FLAG=${5:-"control"}

# Reconfigure default bandwidth for 2.4 GHz channels.
if [ "$CHANNEL" -le 14 ] ; then
	BW="HT20"
fi

# Configure the interface.
iw reg set HK
ifconfig $IFACE down
if [ "$MODE_FLAG" == "active" ] ; then
	macchanger -p $IFACE
fi
iw $IFACE set $MODE $MODE_FLAG
ifconfig $IFACE up
iw dev $IFACE set channel $CHANNEL $BW

# Print interface information for verification.
iw $IFACE info
