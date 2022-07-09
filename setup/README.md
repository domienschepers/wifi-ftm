# Setup and Configuration

We provide an overview of the various setup and configurations we confirmed to work, and provide some practical tips and tricks.

- Are you configuring Wi-Fi FTM on an Intel Card? See the [instructions for Intel Wi-Fi Cards](INTEL.md).
- Are you configuring Wi-Fi FTM on an Android? See the [instructions for Android](ANDROID.md).

## Setting up a Wi-Fi FTM Initiator

The following configuration assumes a Linux-based system.

For more information on Android, see the [instructions for Android](ANDROID.md).

#### Configuration
Using ```iw``` Version 5.9, a configuration file has the following options:
```
dev <devname> measurement ftm_request <config-file> [timeout=<seconds>] [randomise[=<addr>/<mask>]]
	Send an FTM request to the targets supplied in the config file.
	Each line in the file represents a target, with the following format:
	<addr> bw=<[20|40|80|80+80|160]> cf=<center_freq> [cf1=<center_freq1>] [cf2=<center_freq2>] [ftms_per_burst=<samples per burst>] [ap-tsf] [asap] [bursts_exp=<num of bursts exponent>] [burst_period=<burst period>] [retries=<num of retries>] [burst_duration=<burst duration>] [preamble=<legacy,ht,vht,dmg>] [lci] [civic] [tb] [non_tb]
```
Though some options, for example usage of 160 MHz bandwidth, may not be supported by all Wi-Fi Cards.

For example, using 80 MHz bandwidth on channel 48, using ASAP-mode:
```
xx:xx:xx:xx:xx:xx bw=80 cf=5240 cf1=5210 asap
```

#### Execution
A measurement can be executed using the following command, given with an example output:
```
./iw wlan0 measurement ftm_request example.conf
```
```
wdev 0x1 (phy #0): Peer measurements (cookie 1):
  Peer xx:xx:xx:xx:xx:xx: status=0 (SUCCESS) @3250511642082 tsf=0
    FTM
      BURST_INDEX: 0
      NUM_BURSTS_EXP: 0
      BURST_DURATION: 0
      FTMS_PER_BURST: 0
      RSSI_AVG: 4294967246
      RSSI_SPREAD: 0
      RTT_AVG: 48877
      RTT_VARIANCE: 3814209
      RTT_SPREAD: 3906
wdev 0x1 (phy #0): peer measurement complete
```

#### Miscellaneous
- Overview of wireless frequencies: https://en.wikipedia.org/wiki/List_of_WLAN_channels#5_GHz_or_5.9_GHz_(802.11a/h/j/n/ac/ax)
- Need help converting picoseconds to distance at speed of light? https://jumk.de/math-physics-formulary/speed-of-light.php

## Setting up a Wi-Fi FTM Responder
Wi-Fi FTM Responders can be set up using ```hostapd``` Version 2.9 ([reference](https://w1.fi/hostapd/)). 

If supported, the card will advertise this in its extended features (use ```iw dev``` to identify your physical interface):
```
iw phy phy0 info | grep ENABLE_FTM_RESPONDER
```

#### Configuration
For example, a minimalistic configuration file is the following:
```
driver=nl80211

ssid=ftmresponder
channel=1

hw_mode=g
ieee80211n=1

ftm_responder=1
ftm_initiator=0
```
Curently we are unable to set up a 5 GHz network with support for Wi-Fi FTM.

#### Execution
```
hostapd -i wlan0 hostapd-ftm-responder.conf
```

## Network Interface and Wireshark
Make sure to configure your network interface to the appropriate channel and bandwidth.
We provide a tool to easily do so:
```
./setup-interface.sh iface [channel] [bandwidth] [mode] [mode-flag]
```
For example, configure interface wlan0 to channel 149 with 80 MHz in bandwidth:
```
./setup-interface.sh wlan0 149 80MHz
```
In Wireshark, one can filter for Wi-Fi FTM action frames:
```
wlan.fixed.publicact == 0x20 || wlan.fixed.publicact == 0x21
```
In Wireshark, one can filter for Wi-Fi FTM Responder support:
```
wlan.extcap.b70 == 0x01
```

## Miscellaneous
If ```DIST_AVG``` is not provided by the Wi-Fi Card, you can modify ```iw``` and add this snippet to ```parse_pmsr_ftm_data``` in ```event.c```:
```c
if (!ftm[NL80211_PMSR_FTM_RESP_ATTR_DIST_AVG] \
	&& ftm[NL80211_PMSR_FTM_RESP_ATTR_RTT_AVG]){
	signed long long dist_avg = (signed long long)nla_get_u64( \
		ftm[NL80211_PMSR_FTM_RESP_ATTR_RTT_AVG]);
	dist_avg = dist_avg * 100 / 6666;
	printf("      DEBUG_DIST_AVG: %lld\n", dist_avg );
}
```
It will print the one-way distance measurement result in centimeter, calculated from the reported average round-trip time.

We provide patches which can be applied to ```iw``` Version 5.9 and Version 5.19. For example:
```
patch < iw-5.19-ftm-dist-avg.patch
```
