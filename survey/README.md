# Wi-Fi FTM Survey

We performed wireless surveys to measure and track Wi-Fi FTM's adoption rate.

## Adoption

In practice, we find little yet increasing support for Wi-Fi FTM.

We performed passive surveys, and inspected beacon and probe response frames for Wi-Fi FTM Responder or Initiator capabilities.

From our [2020 and 2021 Datasets](https://github.com/domienschepers/wifi-surveying/tree/master/datasets) we find the following adoption rates.
  
| Date | CC | Region | Frequency | Responder | Initiator |
| :--- | :- | :----- | --------: | --------: | --------: |
| October 2020 | AE | Abu Dhabi | 2.4 GHz | 0.00 % | 0.06 % |
| | | | 5 GHz | 0.17 % | 0.00 % |
| October 2020 | US | Boston (Back Bay) | 2.4 GHz | 0.00 % | 0.01 % |
| | | | 5 GHz | 1.56 % | 0.00 % |
| October 2020 | BE | Limburg (Hasselt) | 2.4 GHz | 0.00 % | 0.01 % |
| | | | 5 GHz | 0.17 % | 0.00 % |
| October 2020 | CH | Zürich | 2.4 GHz | 0.00 % | 0.02 % |
| | | | 5 GHz | 0.25 % | 0.00 % |
| May 2021 | BE | Limburg (Hasselt) | 2.4 GHz | 0.00 % | 0.00 % |
| | | | 5 GHz | 0.29 % | 0.00 % |
| October 2021 | US | Boston (Back Bay) | 2.4 GHz | 0.01 % | 0.00 % |
| | | | 5 GHz | 1.36 % | 0.00 % |
| October 2021 | US | Boston (Fenway) | 2.4 GHz | 0.00 % | 0.01 % |
| | | | 5 GHz | 0.37 % | 0.00 % |

<sup> Adoption rates for Wi-Fi FTM Responders and Initiators, listed per region and frequency band.

Note not all access points advertise support for Wi-Fi FTM; [learn more on supported hardware.](../HARDWARE.md#access-points)

Therefore, the results will underestimate actual adoption rates.
  
For example, other research (performing an active survey) found support in Boston's Back Bay is about 3% ([reference](http://people.csail.mit.edu/bkph/ftmrtt_aps)).
  
## Vendors
  
From our survey datasets, we can inspect a device's Organizationally Unique Identifier (OUI) and attribute it to a vendor.

Among the responding stations, we find nearly all can be attributed to Google:
- Google (99.78 %)
- Panasonic (0.11 %)
- Other (0.11 %)

Among the initiating stations, we find over half can be attributed to Samsung:
- Samsung (61.11 %)
- Other (38.89 %)

## Code

We provide a tool to measure the adoption rates in a network capture file.

The tool assumes the network capture file to contain a single beacon or probe response frame per unique network.

Note that, in Wireshark, one can use the following filter for Wi-Fi FTM Responder or Initiator capabilities:
```
wlan.extcap.b70 == 1 || wlan.extcap.b71 == 1
```

#### Pre-Requirements
```
apt-get install tshark
```

#### Usage
```
Usage: ./adoption-rates.sh -r filename [-w filename]

Options:
   [-h]                     Display this help message.
    -r filename             Read from a network capture file.
   [-w filename]            Write supported stations to file.
```
  
#### Example
```
./adoption-rates.sh -r example.pcapng -w output.pcapng
```

```
Analyzing <example.pcapng> with <100000> frames...

Wi-Fi Fine Timing Measurement:
     200 =   0.20 %   Wi-Fi FTM Responder
      20 =   0.02 %   Wi-Fi FTM Initiator

Wi-Fi Fine Timing Measurement on 2.4 GHz:
       0 =   0.00 %   Wi-Fi FTM Responder
      20 =   0.04 %   Wi-Fi FTM Initiator

Wi-Fi Fine Timing Measurement on 5 GHz:
     200 =   0.40 %   Wi-Fi FTM Responder
       0 =   0.00 %   Wi-Fi FTM Initiator

Writing Wi-Fi FTM Responders to <ftm-responder-output.pcapng>...
Writing Wi-Fi FTM Initiators to <ftm-initiator-output.pcapng>...
```
