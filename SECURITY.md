# Wi-Fi FTM Security and Privacy

Our research resulted in a variety of vulnerabilities and weaknesses compromising the security and privacy of Wi-Fi FTM.

Due to the open and unprotected nature of Wi-Fi FTM, all vulnerabilities can be exploited remotely and pre-authentication.

Please note all findings are disclosed to their respective vendors, and published only after at least a 90-day period.

## Initiating Stations

We identified the following characteristics and weaknesses in initiating stations.

| Wi-Fi Card | Firmware | Range <sup>1 | Terminate <sup>2 | PHY-Verif. <sup>3 | Delta Verif. <sup>4 | Retrans. <sup>5 |
| :--- | :--- | ---: | :---: | :---: | :---: | :---: |
| Broadcom BCM4375B1 | Unknown | [0,+300] | Yes | No | Yes | Unknown |
| Qualcomm WCN3990 | Unknown | [-22.5,+∞] | Yes | No | No | Yes |
| Qualcomm QCA6390 | Unknown | [-22.5,+∞] | Yes | No | No | Yes |
| Intel AC-8260 | Version 31 | [-∞,+∞] | Yes | No | No | Yes |
| Intel AC-8260 | Version 36 | [-10,+100] | Yes | No | No | Unknown |
| Intel AC-8265 | Version 34, 36 | [-10,+100] | Yes | No | No | Unknown |
| Intel AX-200 | Version 53 | [0,+∞] | Yes | No | No | Yes |
| Intel AX-200 | Version 55 | [-∞,+∞] | Yes | No | No | Yes |
| Intel AX-200 | Version 57, 58, 59 | [0,+100] | Yes | No | Yes | Unknown |
| Intel AX-210 | Version 62, 63, 66, 67 | [-∞,+∞] | Yes | No | Yes | Yes |

<sup>1</sup> Receiver accepts distance measurements within these bounds, otherwise reports a failed measurement session.

<sup>2</sup> Receiver accepts frames terminating the measurement session.

<sup>3</sup> Receiver rejects frames transmitted under unexpected physical-layer parameters.

<sup>4</sup> Receiver accepts frames only within the expected Min Delta FTM window, otherwise does not transmit acknowledgement.

<sup>5</sup> Receiver accepts retransmissions and improperly manages timestamps.

## Responding Stations

We identified the following vulnerabilities in responding stations.

| Wi-Fi Card | Firmware | Wi-Fi FTM Resource Exhaust <sup>1 | Denial-of-Service <sup>2 |
| :--- | :--- | :--- | :--- |
| Qualcomm IPQ4018 | Unknown | After 16 Open Sessions | Force AP Reboot |
| Qualcomm IPQ4019 | Unknown | After 16 Open Sessions | Crash 5 GHz Band |
| Qualcomm QCS404 | Unknown | After 16 Open Sessions | Crash 5 GHz Band |
| Intel AC-8260 | Version 31, 36 | After 32 Open Sessions | No |
| Intel AC-8265 | Version 34, 36 | After 32 Open Sessions | No |
| Intel AX-200 | Version 53, 55 | After 32 Open Sessions | No |
| Intel AX-200 | Version 57, 58, 59 | After 10 Open Sessions | No |
| Intel AX-210 | Version 62, 63, 66, 67 | After 10 Open Sessions | No |

<sup>1</sup> Exhaust Wi-Fi FTM resources to perform a Denial-of-Service.

<sup>2</sup> Denial-of-Service crashing the entire AP or targetted frequency band.

#### Notes

- For Qualcomm systems, the resource exhaust lasts indefinitely and requires a manual reboot.
- For Intel systems, the resource exhaust lasts half a minute, and a full minute for firmware Version 57 onwards.

## Common Vulnerabilities and Exposures (CVE) Identifiers

Our research resulted in a variety of vulnerabilities which were assigned the following CVE Identifiers.

| CVE Identifier | Description |
| :------------- | :---------- |
| [CVE-2020-11270](https://www.qualcomm.com/company/product-security/bulletins/february-2021-bulletin#_cve-2020-11270) | Possible denial of service due to RTT responder consistently rejects all FTMR by<br />transmitting FTM1 with failure status in the FTM parameter IE. |
| [CVE-2020-11280](https://www.qualcomm.com/company/product-security/bulletins/february-2021-bulletin#_cve-2020-11280) | Denial of service while processing fine timing measurement request (FTMR) frame with<br />reserved bits set in the FTM parameter IE due to improper error handling. |
| [CVE-2020-11281](https://www.qualcomm.com/company/product-security/bulletins/february-2021-bulletin#_cve-2020-11281) | Allowing RTT frames to be linked with non randomized MAC address by comparing the<br />sequence numbers can lead to information disclosure. |
| [CVE-2020-11287](https://www.qualcomm.com/company/product-security/bulletins/february-2021-bulletin#_cve-2020-11287) | Allowing RTT frames to be linked with non randomized MAC address by comparing the<br />sequence numbers can lead to information disclosure. |
| [CVE-2021-0053](https://www.intel.com/content/www/us/en/security-center/advisory/intel-sa-00509.html) | Improper initialization in firmware for some Intel(R) PROSet/Wireless WiFi and Killer(TM) WiFi in Windows 10<br />may allow an authenticated user to potentially enable information disclosure via adjacent access. |

#### Overview of Known Security Updates
- [Intel Security Advisory](https://www.intel.com/content/www/us/en/security-center/advisory/intel-sa-00509.html) of November 2021.
- [Qualcomm Security Bulletin](https://www.qualcomm.com/company/product-security/bulletins/february-2021-bulletin) of February 2021.
- [Android Security Bulletin](https://source.android.com/security/bulletin/2021-02-01) of February 2021, including the Qualcomm mitigations.
- [ASUS RT-AC58U](https://www.asus.com/Networking-IoT-Servers/WiFi-Routers/ASUS-WiFi-Routers/RT-AC58U/HelpDesk_BIOS/) and [ASUS RT-ACRH13](https://www.asus.com/us/Networking-IoT-Servers/WiFi-Routers/ASUS-WiFi-Routers/RT-ACRH13/HelpDesk_BIOS/) firmware updates mitigate their denial-of-service vulnerability.
