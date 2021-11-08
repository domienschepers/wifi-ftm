# Wi-Fi FTM Hardware

We confirmed Wi-Fi FTM to work on a variety of commercially available hardware.

## Summary

In summary, we confirmed the following products support Wi-Fi FTM either as an initiating or responding station.

| Wi-Fi Card | Device | Initiator | Responder |
| :--- | :--- | :---: | :---: |
| Intel AC-8260 | Compulab WILD | Yes | Yes |
| Intel AC-8265 | None | Yes | Yes <sup>1 |
| Intel AC-9260 | None | Yes | Yes <sup>1 |
| Intel AX-200 | None | Yes | Yes <sup>1 |
| Intel AX-210 | None | Yes | Yes <sup>1 |
| Broadcom BCM4375B1 | Samsung Galaxy Note 10 (SM-N970U) | Yes | No |
| Qualcomm WCN3990 | Google Pixel 4 XL (G020J) | Yes | No |
| Qualcomm QCA6390 | Xiaomi Mi 10T 5G (M2007J3SY) | Yes | No |
| Qualcomm IPQ4018 | ASUS RT-ARCH13 AP (MSQ-RTACRH00) | No  | Yes |
| Qualcomm IPQ4019 | Google Wi-Fi AP (A4RAC-1304) | No | Yes |
| Qualcomm QCS404 | Google Nest AP (A4R-H2D) | No | Yes |

<sup>1</sup> Responding only on the 2.4 GHz frequency band.

## Intel Wi-Fi Cards

We confirmed the following Intel cards support Wi-Fi FTM:
- Intel AC-8260, Intel AC-8265, Intel AC-9260, Intel AX-200, and Intel AX-210.

In order to enable support for Wi-Fi FTM, see the [instructions for Intel Wi-Fi Cards](setup/INTEL.md). 

| Wi-Fi Card | Linux Kernel | Driver <sup>1,2 | Firmware <sup>3,4 | iw <sup>5 |
| :--- | :--- | :--- | :--- | :--- |
| Intel AC-8260 | Version 4.14.41 | Core 33 | Version 31, 36 | Patched <sup>6 |
| Intel AC-8265 | Version 4.9.140 | Core 33 | Version 34, 36 | Patched <sup>6 |
| Intel AC-9260 | Version 4.9.140 | Core 43 | Version 46 | Version 5.3 |
| Intel AX-200 | Version 4.9.140 | Core 50 | Version 53 | Version 5.4 |
| Intel AX-200 | Version 5.4.0 | Core 56 | Version 53, 55, 57, 58 | Version 5.8 |
| Intel AX-200 | Version 5.0.0 | Core 56 | Version 53, 55, 57, 58, 59 | Version 5.8 |
| Intel AX-200 | Version 5.8.0 | Core 59 | Version 59 | Version 5.8 |
| Intel AX-210 | Version 5.11.0 | Core 62 | Version 62, 63 | Version 5.9 |
| Intel AX-210 | Version 5.11.0 | Core 63 | Version 66 | Version 5.9 |

<sup>1</sup> https://wireless.wiki.kernel.org/en/users/drivers/iwlwifi

<sup>2</sup> https://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/backport-iwlwifi.git/

<sup>3</sup> https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/tree/

<sup>4</sup> https://www.intel.com/content/www/us/en/support/articles/000005511/wireless.html

<sup>5</sup> https://git.kernel.org/pub/scm/linux/kernel/git/jberg/iw.git

<sup>6</sup> http://www.winlab.rutgers.edu/~gruteser/projects/ftm/Setups.htm

We purchased the NGW models and evaluated them on a variety of systems supporting the M.2 2230 form factor, for example:
- Compulab WILD, NVIDIA Jetson Nano, Dell Latitude E5470, and Lenovo ThinkPad P1.
  
## Smartphones

We tested for support on the following Android smartphones using [WifiRttScan](https://play.google.com/store/apps/details?id=com.google.android.apps.location.rtt.wifirttscan) ([source](https://github.com/android/connectivity-samples/tree/main/WifiRttScan)).
  
| Device | Wi-Fi Card <sup>1 | Android |
| :--- | :--- | :--- |
| Google Pixel 4 XL (G020J) | Qualcomm WCN3990 | Android 10, 11, 12 |
| Xiaomi Mi 10T 5G (M2007J3SY) | Qualcomm QCA6390 | Android 11 (MIUI 12.5.1.0) |
| Samsung Galaxy Note 10 (SM-N970U) | Broadcom BCM4375B1 | Android 11 |

<sup>1</sup> Though not explicitely stated by the vendors, kernel debug messages refer to these respective cards.

Presumably Android 9 and up support Wi-Fi FTM, though not all versions were explicitely tested.

## Access Points

We tested for support on the following access points.
  
| Device | Wi-Fi Card | Advertised |
| :--- | :--- | :---: |
| ASUS RT-ARCH13 AP (MSQ-RTACRH00) | Qualcomm IPQ4018 | No |
| Compulab WILD | Intel AC-8260 | Yes |
| Google Wi-Fi AP (A4RAC-1304) | Qualcomm IPQ4019 | Yes |
| Google Nest AP (A4R-H2D) | Qualcomm QCS404 | Yes |

Note not all APs advertise support for Wi-Fi FTM, for example the ASUS RT-ARCH13 AP ([reference](http://people.csail.mit.edu/bkph/ftmrtt_aps)).

## Not Supported
  
While [certified by the Wi-Fi Alliance](https://www.wi-fi.org/product-finder-results?sort_by=default&sort_order=desc&certifications=540) or Android-based smartphones, we were not able to verify support on the following devices.

| Device | Wi-Fi Card | Notes |
| :--- | :--- | :--- |
| TP-LINK Archer T4U v3 | Realtek RTL8812BU | No public driver and firmware support. |
| Linksys WRT3200ACM | NXP 88W8964 | No public driver and firmware support. |
| Motorola Nexus 6 (XT1103) | Broadcom BCM4356 | |
| Samsung Galaxy S10e (SM-G970U1) | Broadcom BCM4375B1 | |
| LG V40 ThinQ (V405UA) | Qualcomm (Unknown Model) | |

If you are able to confirm support or believe this is a mistake, please contact us.

## Additional Resources
The following resources list additional supported hardware:
- https://developer.android.com/guide/topics/connectivity/wifi-rtt#supported-devices
- http://people.csail.mit.edu/bkph/ftmrtt_aps
