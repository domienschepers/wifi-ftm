# Wi-Fi Fine Timing Measurement

Wi-Fi Fine Timing Measurement (FTM) enables two stations to estimate the physical distance between them.

We provide tools to experiment with the protocol, and keep track of its support and security vulnerabilities.

## Commercial Products

<sup>See [the detailed page on our setup and configuration.](setup)

We tested the following commercial products supporting Wi-Fi FTM, either as an initiating or responding station.

| Wi-Fi Card | Commercial Product | Initiator | Responder |
| :--- | :--- | :---: | :---: |
| Intel AC-8260 | Compulab WILD | Yes | Yes |
| Intel AC-8265 | None | Yes | Yes <sup>1 |
| Intel AX-200 | None | Yes | Yes <sup>1 |
| Intel AX-210 | None | Yes | Yes <sup>1 |
| Qualcomm Snapdragon 855 | Google Pixel 4 XL | Yes | No |
| Qualcomm IPQ4018 | ASUS RT-ARCH13 AP | No  | Yes |
| Qualcomm IPQ4019 | Google Wi-Fi AP | No | Yes |
| Qualcomm QCS404 | Google Nest AP | No | Yes |

<sup>1</sup> Responding only on the 2.4 GHz band.

## Support

<sup>See [the repository on Wi-Fi Surveying.](https://github.com/domienschepers/wifi-surveying)

In practice, we find little yet increasing support for Wi-Fi FTM APs.

We inspect beacon and probe response frames on the 5 GHz band for Wi-Fi FTM Responder or Initiator capabilities.

From our [October 2020 Datasets](https://github.com/domienschepers/wifi-surveying/tree/master/datasets) we find the following support rates,

| Abu Dhabi | Back Bay | Limburg (Hasselt) | Zürich |
| ---: | ---: | ---: | ---: |
| 0.17 % | 1.56 % | 0.17 % | 0.25 % |

Note not all APs advertise support for Wi-Fi FTM, for example the ASUS RT-ARCH13 AP ([reference](http://people.csail.mit.edu/bkph/ftmrtt_aps)).

Therefore the results underestimate actual support rates.

## Security and Privacy

<sup>See [the detailed page on security and privacy.](SECURITY.md)

We identified vulnerabilities and weaknesses compromising the security and privacy of Wi-Fi FTM.

We keep track of these, together with any CVE Identifiers and vendor security updates.

## Code

<sup>See [the detailed page on our code.](code)

We provide a number of tools to experiment with the Wi-Fi FTM protocol.

For example, to modify the distance measured by an initiating station.

## Publication

This work was published at ACM Conference on Security and Privacy in Wireless and Mobile Networks (WiSec '21):

- [Here, There, and Everywhere: Security Analysis of Wi-Fi Fine Timing Measurement](https://dl.acm.org/doi/10.1145/3448300.3467828)

## Conclusion

Wi-Fi FTM is not secure, and we discourage its usage for security-sensitive applications.

We disclosed our findings to all vendors, and hope to contribute and push for more secure implementations.

#### Additional Resources
Want to learn more on Wi-Fi FTM? Consider the following resources:
- http://people.csail.mit.edu/bkph/ftmrtt
- https://source.android.com/devices/tech/connect/wifi-rtt
