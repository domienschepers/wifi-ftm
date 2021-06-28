# Code for Wi-Fi FTM

We provide a number of tools to experiment with, and test for weaknesses and vulnerabilities in, Wi-Fi FTM-enabled Wi-Fi Cards.

Remember to configure your network interface appropriately;
[learn more on our setup and configuration.](../setup)

#### Pre-Requirements
```
apt update
apt install gcc libpcap-dev
```

## Distance Modification

Add a relative distance modification, in meters, to the distance measured by the initiating station. 

The tool spoofs the responding station, and transmits a response frame with a modified time-of-arrival timestamp _t<sub>4</sub>_.

#### Usage
```
./distance-modification interface ap-mac-address distance
```

#### Example
```
gcc distance-modification.c -o distance-modification -lpcap
./distance-modification wlan0 xx:xx:xx:xx:xx:xx 50
```

#### Notes

- Reducing the distance is suported too, by providing a negative input distance, for example, ```-5``` meters.

## Terminate a Session

Terminate a session by responding to any measurement request made towards the responding station.

The tool spoofs the responding station, and transmits a response frame with the dialog token set to zero.

#### Usage
```
./terminate interface ap-mac-address
```

#### Example
```
gcc terminate.c -o terminate -lpcap
./terminate wlan0 xx:xx:xx:xx:xx:xx
```
