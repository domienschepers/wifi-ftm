#!/bin/bash
# Copyright (C) 2021 Domien Schepers.

# Common TSHARK-Filters.
# https://www.wireshark.org/docs/dfref/w/wlan.html
FILTER_2GHZ="(radiotap.channel.flags.2ghz==0x01 \
	|| ppi.80211-common.chan.flags.2ghz==0x01)"
FILTER_5GHZ="(radiotap.channel.flags.5ghz==0x01 \
	|| ppi.80211-common.chan.flags.5ghz==0x01)"
# Wi-Fi Fine Timing Measurement:
# wlan.extcap.b70	Fine Timing Measurement Responder	Boolean	2.6.0 to 3.4.8
# wlan.extcap.b71	Fine Timing Measurement Initiator	Boolean	2.6.0 to 3.4.8
FILTER_WIFI_FTM_RESPONDER="(wlan.extcap.b70==1)"
FILTER_WIFI_FTM_INITIATOR="(wlan.extcap.b71==1)"

##########################################################################################
##########################################################################################
##########################################################################################

initialize () {
	TOTAL=$(tshark -r $INPUT | wc -l)
	TOTAL=$(printf "%d" $TOTAL)
	
	# Sanity check on the number of frames.
	if [ "$TOTAL" -eq "0" ]; then
		echo "Quitting: file <$INPUT> is empty."
		exit 1
	else
		echo "Analyzing <$INPUT> with <$TOTAL> frames..."
	fi
	
}

run_tshark_filter () {
	# $1 = Description of the filter.
	# $2 = The filter to be ran using TSHARK.
	DESCRIPTION=$1
	Y=$2
	
	# Execute the filter and print the results.
	result=$(tshark -r $INPUT -Y "$Y" | wc -l)
	percentage=$(bc -l <<< "($result/$TOTAL)*100")
	percentage=$(printf "%0.2f" $percentage)
	printf "%8d = %6s %%   " $result $percentage
	echo $DESCRIPTION
	
}

##########################################################################################
##########################################################################################
##########################################################################################

adoptionrates () {

	# Calculate adoption rates for all networks.
	echo
	echo "Wi-Fi Fine Timing Measurement:"
	run_tshark_filter "Wi-Fi FTM Responder" \
		"($FILTER_WIFI_FTM_RESPONDER)"
	run_tshark_filter "Wi-Fi FTM Initiator" \
		"($FILTER_WIFI_FTM_INITIATOR)"

	# Recalculate for 2.4 GHz networks only.
	TOTAL=$(tshark -r $INPUT -Y "$FILTER_2GHZ" | wc -l)
	TOTAL=$(printf "%d" $TOTAL)
	if [ ! "$TOTAL" -eq "0" ]; then
		echo
		echo "Wi-Fi Fine Timing Measurement on 2.4 GHz:"
		run_tshark_filter "Wi-Fi FTM Responder" \
			"($FILTER_2GHZ)&&($FILTER_WIFI_FTM_RESPONDER)"
		run_tshark_filter "Wi-Fi FTM Initiator" \
			"($FILTER_2GHZ)&&($FILTER_WIFI_FTM_INITIATOR)"
	fi

	# Recalculate for 5 GHz networks only.
	TOTAL=$(tshark -r $INPUT -Y "$FILTER_5GHZ" | wc -l)
	TOTAL=$(printf "%d" $TOTAL)
	if [ ! "$TOTAL" -eq "0" ]; then
		echo
		echo "Wi-Fi Fine Timing Measurement on 5 GHz:"
		run_tshark_filter "Wi-Fi FTM Responder" \
			"($FILTER_5GHZ)&&($FILTER_WIFI_FTM_RESPONDER)"
		run_tshark_filter "Wi-Fi FTM Initiator" \
			"($FILTER_5GHZ)&&($FILTER_WIFI_FTM_INITIATOR)"
	fi
	
}

dump () {

	# Create new files for the identified stations.
	echo
	echo "Writing Wi-Fi FTM Responders to <ftm-responder-$OUTPUT>..."
	tshark -r $INPUT -Y "($FILTER_WIFI_FTM_RESPONDER)" \
		-w ftm-responder-$OUTPUT
	echo "Writing Wi-Fi FTM Initiators to <ftm-initiator-$OUTPUT>..."
	tshark -r $INPUT -Y "($FILTER_WIFI_FTM_INITIATOR)" \
		-w ftm-initiator-$OUTPUT

}

##########################################################################################
##########################################################################################
##########################################################################################

usage () {
	echo "Usage: $0 -r filename [-w filename]"
	echo ""
	echo "Options:"
	echo "   [-h]                     Display this help message."
	echo "    -r filename             Read from a network capture file."
	echo "   [-w filename]            Write supported stations to file."
	exit 0
}

# Parse command-line arguments.
while getopts ":hr:w:" opt; do
	case "$opt" in
		h)
			usage
			;;
		r)
			INPUT=${OPTARG}
			;;
		w)
			OUTPUT=${OPTARG}
			;;
		*)
			usage
			;;
	esac
done
shift $((OPTIND-1))

# Verify arguments.
if [ -z "$INPUT" ]; then
    usage
fi
if [ ! -f "$INPUT" ]; then
    echo "Quitting: file <$INPUT> does not exist."
    exit 1
fi

# Run the measurements.
initialize
adoptionrates

# Write the results to file.
if [ ! -z "$OUTPUT" ]; then
	dump
fi