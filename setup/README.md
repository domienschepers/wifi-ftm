# Setup and Configuration

We provide an overview of the various setup and configurations we confirmed to work, and provide some practical tips and tricks.

## Hardware 

#### Intel Wi-Fi Cards

We confirm the following Intel cards to work, on a variety of systems.

| Host Device | Wi-Fi Card | Linux Kernel | Driver <sup>1,2 | Firmware <sup>3 | iw <sup>4 |
| :--- | :--- | :--- | :--- | :--- | :--- |
| Compulab WILD | Intel AC-8260 | Version 4.14.41 | Core 33 | Version 36 | Patched <sup>5 |
| NVIDIA Jetson Nano | Intel AC-8265 | Version 4.9.140 | Core 33 | Version 34, 36 | Patched <sup>5 |
| NVIDIA Jetson Nano | Intel AX-200 | Version 4.9.140 | Core 50 | Version 53 | Version 5.4 |
| Dell Latitude E5470 | Intel AX-200 | Version 5.4.0 | Core 56 | Version 53, 55, 57, 58 | Version 5.8 |
| Lenovo ThinkPad P1 | Intel AX-200 | Version 5.0.0 | Core 56 | Version 53, 55, 57, 58, 59 | Version 5.8 |
| Compulab WILD | Intel AX-200 | Version 5.8.0 | Core 59 | Version 59 | Version 5.8 |
| Compulab WILD | Intel AX-210 | Version 5.11.0 | Core 62 | Version 62, 63 | Version 5.9 |

<sup>1</sup> https://wireless.wiki.kernel.org/en/users/drivers/iwlwifi

<sup>2</sup> https://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/backport-iwlwifi.git/

<sup>3</sup> https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/tree/

<sup>4</sup> https://git.kernel.org/pub/scm/linux/kernel/git/jberg/iw.git

<sup>5</sup> http://www.winlab.rutgers.edu/~gruteser/projects/ftm/Setups.htm

In order to enable support for Wi-Fi FTM, see [instructions for Intel Wi-Fi Cards](INTEL.md). 

#### Smartphones

| Smartphone | Wi-Fi Card | Notes |
| :--- | :--- | :--- |
| Google Pixel 4 XL | Qualcomm Snapdragon 855 | [WifiRttScan](https://play.google.com/store/apps/details?id=com.google.android.apps.location.rtt.wifirttscan) can be used to use measurements ([source](https://github.com/android/connectivity-samples/tree/main/WifiRttScan)). |

## Setting up a Wi-Fi FTM Initiator

On Android, [WifiRttScan](https://play.google.com/store/apps/details?id=com.google.android.apps.location.rtt.wifirttscan) can be used to initiate distance measurements.

The following configuration assumes a Linux-based system.

#### Configuration File
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
Wi-Fi FTM Responders can be set up using ```hostapd``` Version 2.9 ([source](https://w1.fi/hostapd/)). 

#### Configuration File
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
Curently we are unable to set up a 5 GHz network.

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
It will print the one-way distance measurement result, calculated from the reported average round-trip time.

We provide a patch, which can be applied to ```iw``` Version 5.9: 
```
patch < iw-5.9-ftm-dist-avg.patch
```
