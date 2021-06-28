# Instructions for Intel Wi-Fi Cards

Example instructions to enable support for Wi-Fi FTM using an Intel Wi-Fi Card.

## Ubuntu
Drivers for Wi-Fi FTM require a system running a recent kernel ([examples](README.md#intel-wi-fi-cards)).

For clean installs, consider Ubuntu Server 21.04 which comes with a stable Linux 5.11 kernel:
- https://ubuntu.com/blog/ubuntu-server-21-04

## Driver

Using backports, we can install iwlwifi, the wireless driver for Intel Wi-Fi Cards:
- https://wireless.wiki.kernel.org/en/users/drivers/iwlwifi
- https://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/backport-iwlwifi.git

#### Pre-Requirements
```
apt update
apt install make gcc
```

#### Installation
Use the following commands to install the driver, for example, release Core 62:
```
git clone https://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/backport-iwlwifi.git -b release/core62
cd backport-iwlwifi
make defconfig-iwlwifi-public
make -j4
sudo make install
```
Reboot your system.

## Firmware

The latest Intel firmware versions are available from:
- https://wireless.wiki.kernel.org/en/users/drivers/iwlwifi
- https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git

Use the following commands to download, for example, Version 63 for the Intel AX-210:
```
wget https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/iwlwifi-ty-a0-gf-a0-63.ucode
mv iwlwifi-ty-a0-gf-a0-63.ucode /lib/firmware
``` 

Load the firmware by reloading the kernel module:
```
modprobe -r iwlwifi
modprobe iwlwifi
```

To verify which firmware was loaded, you can inspect kernel messages:
```
dmesg | grep iwlwifi
```

#### Miscellaneous
- Wi-Fi FTM fails on the Intel AX-210 with firmware Version 59, however does work with Version 62 and 63.
- Version 62 and higher require pNVM: for example, ```/lib/firmware/iwlwifi-ty-a0-gf-a0.pnvm``` ([source](https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/tree/)).

## iw

While Linux may pre-install the network configuration utility, you may want to modify its source code ([example](README.md#Miscellaneous-1)):
- https://wireless.wiki.kernel.org/en/users/documentation/iw
- https://git.kernel.org/pub/scm/linux/kernel/git/jberg/iw.git

#### Pre-Requirements
```
apt update
apt install pkg-config libnl-3-dev libnl-genl-3-dev
```

#### Installation
```
wget https://git.kernel.org/pub/scm/linux/kernel/git/jberg/iw.git/snapshot/iw-5.9.tar.gz
tar xzf iw-5.9.tar.gz
cd iw-5.9
make
```

The local binary can now be used, and can be verified by displaying its version:
```
./iw --version
```
