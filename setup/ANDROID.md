# Instructions for Android

Here we provide basic yet useful beginner instructions and information for Wi-Fi FTM, named [Wi-Fi RTT](https://developer.android.com/guide/topics/connectivity/wifi-rtt) on Android.

#### Support

Wi-Fi FTM is supported since Android 9 (API level 28) and later, with new features added in Android 13 (API level 33).

In our [hardware overview](../HARDWARE.md#smartphones), we verified its support on a variety of smartphones.

#### Android Developer Guides and Documentation

For more information, please refer to the Android developer guides and documentation:

- [Wi-Fi location: ranging with RTT](https://developer.android.com/guide/topics/connectivity/wifi-rtt)
- [Wi-Fi RTT (IEEE 802.11mc)](https://source.android.com/devices/tech/connect/wifi-rtt)

## Applications

A number of Google applications can be used to experiment with Wi-Fi FTM:

- [WifiRttScan](https://play.google.com/store/apps/details?id=com.google.android.apps.location.rtt.wifirttscan) ([source](https://github.com/android/connectivity-samples/tree/main/WifiRttScan)), [WifiRttLocator](https://play.google.com/store/apps/details?id=com.google.android.apps.location.rtt.wifirttlocator), and [WiFiNanScan](https://play.google.com/store/apps/details?id=com.google.android.apps.location.rtt.wifinanscan).

For an introduction to the basic protocol features, the [WifiRttScan](https://play.google.com/store/apps/details?id=com.google.android.apps.location.rtt.wifirttscan) application is well-suited.
It allows you to quickly:
- evaluate if your smartphone supports Wi-Fi FTM,
- evaluate if your access point supports (and advertises) Wi-Fi FTM, and
- measure the distance between your smartphone and access point.

## Troubleshooting

If you experience any trouble using Wi-Fi FTM, consider the following issues and solutions.

Note that some require usage of [Android Debug Bridge](https://developer.android.com/studio/command-line/adb) to issue shell commands:
```
./adb shell
```

#### Wi-Fi FTM is Unavailable

Verify Wi-Fi is enabled in your settings, and the application has location access permissions.

#### No Discovered Networks

Not all access points advertise support for Wi-Fi FTM ([example](../HARDWARE.md#access-points)), and therefore may not be discovered by Android.

#### Identifying Android Support for Wi-Fi FTM

If you are not sure if your Android supports Wi-Fi FTM, you can verify if the ```android.hardware.wifi.rtt``` feature exists:
```
./adb shell pm list features | grep android.hardware.wifi.rtt
```

Alternatively, you can try to read its permissions file directly:
```
./adb shell cat /vendor/etc/permissions/android.hardware.wifi.rtt.xml
```
