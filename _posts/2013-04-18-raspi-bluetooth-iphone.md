---
layout: post
title:  "Raspberry Pi Bluetooth iPhone Tethering"
tags: raspberry_pi bluetooth iphone linux
redirect_from: "/projects/raspi/iphone/"
---
For the [truckputer project](/truckputer/), I want to pair with my iPhone for various things from file transfer to hand-free calling to Internet access. Towards that end, I picked up a [Cirago Bluetooth / WiFi USB mini adapter (BTA7300)](http://amzn.to/2zsiuzT) since it was cheap and reviews showed it Just Works with Linux. Happily, it did not disappoint.

## Prereqs

First, you want to install the bluetooth packages:

```
pi@raspberrypi ~ $ sudo aptitude install bluetooth bluez-utils bluez-compat
```

## Getting Started

Plug in the Bluetooth dongle and immediately the Pi knows what's up:

```
pi@raspberrypi ~ $ lsusb | grep -i bluetooth
Bus 001 Device 006: ID 0a12:0001 Cambridge Silicon Radio, Ltd Bluetooth Dongle (HCI mode)
pi@raspberrypi ~ $
```

## Scanning for Devices

In my case, I'm pairing with an iPhone 4S. Go to Settings->Bluetooth, and set Bluetooth to "on". At the bottom of your screen, you'll see the text "Now Discoverable". If the device you're pairing with isn't discoverable, the Pi isn't going to see it. In the case of the iPhone, it's only discoverable while this screen is active. Yes, that means you have to poke the screen every now and again to keep the phone awake if you're doing extended testing.

![Searching](/assets/50a70a5aa13216af17ea6b3db9c4243b.png)
![About](/assets/df307c5b5d62a9c7e20dc926a4ff8e10.png)

At any rate, once you've got the phone discoverable, you can do a scan from the Pi:

```
pi@raspberrypi ~ $ hcitool scan
Scanning ...
        18:34:51:DE:AD:BE:EF       Fanboy ][
pi@raspberrypi ~ $
```

Happily, there's my iPhone. The hex string is the Bluetooth MAC address of the phone and "Fanboy ][" is phone's name defined in Settings->General->About. **Remember to use the MAC address of your phone and not mine throughout the rest of this walkthrough.**

## Pairing

Now that we know that we can see the phone, we want to actually pair with it

```
pi@raspberrypi ~ $ sudo bluez-simple-agent hci0 18:34:51:DE:AD:BE:EF
Creating device failed: org.bluez.Error.ConnectionAttemptFailed: Page Timeout
pi@raspberrypi ~ $
```

Oh no! That doesn't look like what we want to see. Did your phone fall asleep? Wake it back up, make sure you're on the Settings->Bluetooth screen, then try it again.

```
pi@raspberrypi ~ $ sudo bluez-simple-agent hci0 18:34:51:DE:AD:BE:EF
Creating device failed: org.bluez.Error.AuthenticationRejected: Authentication Rejected
pi@raspberrypi ~ $
```

Oh no, again! It still didn't work, even with the phone discoverable! This time the problem is a little bug in bluez-simple-agent. By default, bluez-simple-agent wants to use a capability called "KeyboardDisplay" that isn't going to work for us. We need to change that to "DisplayYesNo" so that we can get a nice Yes/No prompt on the command line when pairing devices.

```
pi@raspberrypi ~ $ grep KeyboardDisplay /usr/bin/bluez-simple-agent 
        capability = "KeyboardDisplay"
pi@raspberrypi ~ $ sudo perl -i -pe 's/KeyboardDisplay/DisplayYesNo/' /usr/bin/bluez-simple-agent
pi@raspberrypi ~ $ grep DisplayYesNo /usr/bin/bluez-simple-agent
        capability = "DisplayYesNo"
pi@raspberrypi ~ $ 
```

Remember to wake your phone up before trying to pair. When the CLI on the Pi prompts you, type "yes" and hit [enter].

```
pi@raspberrypi ~ $ sudo bluez-simple-agent hci0 18:34:51:DE:AD:BE:EF
RequestConfirmation (/org/bluez/18868/hci0/dev_18_34_DE_AD_BE_EF, 160178)
Confirm passkey (yes/no): yes
Release
New device (/org/bluez/18868/hci0/dev_18_34_DE_AD_BE_EF)
pi@raspberrypi ~ $ 
```

This time, you should see a prompt on your phone to pair with your Pi. The code on your phone should match the request confirmation on the Pi. Hit "Pair" on the phone and you'll be dropped back to the Settings->Bluetooth page, but this time you'll see your Pi on the device list.

![Pairing Request](/assets/7c745c93e3d07c96efbd4c94209cd29a.png)
![Not Connected](/assets/6754f7fc7395d9a78c4e400e0eaaaabd.png)

Unless you really want to manually pair with a code every single time, add your phone as a trusted device on the Pi:

```
pi@raspberrypi ~ $ sudo bluez-test-device trusted 18:34:51:DE:AD:BE:EF yes
```

If your phone ever becomes evil and you don't want to trust it anymore, that's easy too:

```
pi@raspberrypi ~ $ sudo bluez-test-device remove 18:34:51:DE:AD:BE:EF 
```

## Internet Access

Personally, I actually pay AT&T for the privelege of tethering legally. Crazy, eh? Yeah, it's stupidly expensive and I had to give up my unlimited data plan, but the last thing I need is to be sued by AT&T and honestly, I've never come close to my cap. If you jailbroke your phone to get tethering, you probably already know what you need to adjust here to make things work. Anyway. In order to access the world through your phone, you need to setup a new Personal Area Network using `pand` and add a line to your `/etc/network/interfaces` so that the Pi knows to grab an address from DHCP when `bnep0` comes up:

```
pi@raspberrypi ~ $ echo "echo 'iface bnep0 inet dhcp' >> /etc/network/interfaces" | sudo sh
pi@raspberrypi ~ $ sudo pand -c 18:34:51:DE:AD:BE:EF -role PANU --persist 30
```

Give the Pi and phone a second or two to get their act together. Your phone may prompt you to pair with the Pi if it isn't already paired.

![Pairing Request](/assets/fa7a4f713aaaa412ccbed4972742cfdc.png)
![Personal Hotspot](/assets/6754f7fc7395d9a78c4e400e0eaaaabd.png)

Once you accept, you should see that `bnep0` on the Pi now has an address and is ready to rock.

```
pi@raspberrypi ~ $ ifconfig bnep0
bnep0     Link encap:Ethernet  HWaddr e0:91:DE:AD:BE:EF  
          inet addr:172.20.10.10  Bcast:172.20.10.15  Mask:255.255.255.240
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:14 errors:0 dropped:0 overruns:0 frame:0
          TX packets:7 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000 
          RX bytes:4426 (4.3 KiB)  TX bytes:802 (802.0 B)
```

## References

* [Look Ma, no Wires! Raspberry Pi Bluetooth tethering](http://blog.kugelfish.com/2012/10/look-ma-no-wires-raspberry-pi-bluetooth.html)
* [SOLVED. Get org.bluez.Error.AuthenticationRejected when pair](http://forums.gentoo.org/viewtopic-t-945400.html?sid=721b803316f7d6d014bdd8efe7abc4b5)

