---
layout: post
title:  OpenWRT / LEDE on late serial number TP-LINK Archer C7 V2
date:   2018-03-24 22:02:33 -0700
tags:   openwrt tp-link router wifi dd-wrt
---
![Archer C7](/assets/archer-c7.jpg)

I work from home full time and as such require multiple Internet connections to ensure high-availability in spite of consumer-grade uplinks.  Most of the time, when my primary connection craps out, I switch wifi networks over to the router on the secondary connection and continue on with my life.  Ideally, I'd like to use a single router or maybe even a mesh so my work terminal doesn't even notice when one or the other connection drops as long as at least one is working.  Being somewhat familiar with OpenWRT's abilities from [other projects](/openwrt/), I figure setting up multi-wan routing on OpenWRT is the way to go.  Reading through the [mwan3 docs](https://wiki.openwrt.org/doc/howto/mwan3) it appears that the [ar71xx target](https://openwrt.org/docs/targets/ar71xx) is the way to go.  

Poking around Amazon, I settled on the [TP-LINK Archer C7](https://amzn.to/2xw5soQ).  Reading through the Q&A, it looked like a crapshoot which version would show up, but I figured anything beyond V1 would work so I had a 75% chance of not having to return whatever I got.  I was of course hoping for a V4, which TP-LINK ships with OpenWRT source, but a V2.0 showed up.  Good enough.  Now, to get OpenWRT running on the thing.

If you don't care about the journey and just want the result, you can skip ahead to [the path that works](#the-path-that-works).

## Things that Didn't Work

I figured I would start with OpenWRT's [table of hardware](https://openwrt.org/toh/views/toh_fwdownload?dataflt%5BModel*%7E%5D=Archer+C7).

[![table of hardware](/assets/Screenshot from 2018-03-24 09-37-34.png)](https://openwrt.org/toh/views/toh_fwdownload?dataflt%5BModel*%7E%5D=Archer+C7)

According to the table, [lede-17.01.4-ar71xx-generic-archer-c7-v2-squashfs-factory.bin](http://downloads.lede-project.org/releases/17.01.4/targets/ar71xx/generic/lede-17.01.4-ar71xx-generic-archer-c7-v2-squashfs-factory.bin) is available to install OpenWRT from OEM.  

![upgrade firmware](/assets/Screenshot from 2018-03-24 09-44-24.png)

It would have been super cool if that worked.  Of course, if it were that straightforward, you wouldn't be here reading this post.

![Error code: 18005](/assets/Screenshot from 2018-03-24 09-43-20.png)

```
Error code 18005

Upgrade unsuccessfully because the version of the upgraded file was incorrect.  Please check the file name.
```

That's not the most useful error message in the world, but it does get the point across that it didn't work.  I read somewhere that TP-LINK's OEM firmware doesn't like long filenames for the upgrade procedure, so I tried renaming it to something shorter.

![shorter name](/assets/Screenshot from 2018-03-24 09-44-42.png)

Unfortunately, I got the same error.  Apparently the long filename was not the problem.  Looking at the OEM Firmware Upgrade tool, we can see that the router was running OEM firmware `3.15.1 Build 160719 Rel.57530n` with hardware version `Archer C7 V2 00000000`.  Looking on the [TP-LINK download site](https://www.tp-link.com/us/download/Archer-C7_V2.html#Firmware), we find this fun disclosure:


```
3. The US firmware was specialized for FCC certification and can't be downgraded to other version, please click [here](http://www.tp-link.com/us/choose-your-location.html) for choosing your region and selecting the most suitable firmware version to upgrade.
```

[![Archer C7(US)_V2_160719](/assets/Screenshot from 2018-03-24 09-53-53.png)](https://www.tp-link.com/us/download/Archer-C7_V2.html#Firmware)

Conveniently, there's also no versions older than `160719` available on the US download page, so I thought I'd have a little fun and try [Archer C7_V2_150427](https://static.tp-link.com/res/down/soft/Archer_C7_v2_150427.zip) from [the UK download page](https://www.tp-link.com/uk/download/Archer-C7_V2.html#Firmware).

[![UK firmware](/assets/Screenshot from 2018-03-24 09-54-13.png)](https://www.tp-link.com/uk/download/Archer-C7_V2.html#Firmware)

Of course that didn't work either (same error).  Who'd-a-thunk that TP-LINK actually prevented downgrade when they say they do?

I really didn't want to have to flash [dd-wrt](https://www.dd-wrt.com) in order to get over to OpenWRT, but alas it was more important to me to Get This Done than to enforce my opinion that the path to OpenWRT should not have to go through dd-wrt.  As such, here's...

## The Path That Works

Download [factory-to-ddwrt-US.bin from r28598](http://download1.dd-wrt.com/dd-wrtv2/downloads/betas/2015/12-24-2015-r28598/tplink_archer-c7-v2/factory-to-ddwrt-US.bin) from dd-wrt.  (While the r28598 US version worked on my router, some folks have reported the 18005 error when trying to flash this version, but had success with the [unlocalized firmware from r35874](https://download1.dd-wrt.com/dd-wrtv2/downloads/betas/2018/05-04-2018-r35874/tplink_archer-c7-v2/factory-to-ddwrt.bin).)

Download `ArcherC7v2_webrevert.rar` from [this dd-wrt forum thread](https://www.dd-wrt.com/phpBB2/viewtopic.php?p=936939#936939).  You have to be logged in to the forum to see the download links.

Unrar `ArcherC7v2_webrevert.rar` so you've got `ArcherC7v2_webrevert.bin`.

Connect your computer to the router with an ethernet cable.  There are multiple steps coming up that will not work over wifi.

Flash your C7v2 to dd-wrt using that firmware image.

![flash](/assets/Screenshot from 2018-03-24 11-26-28.png)

![it works](/assets/Screenshot from 2018-03-24 11-26-47.png)

Up until now, you've had your browser pointed at [192.168.0.1](http://192.168.0.1), the IP TP-LINK assigns the router by default.  DD-WRT on the other hand, uses [192.168.1.1](http://192.168.1.1), so we now need to point our browser over there.

DD-WRT will force you to set an admin user and password.  These don't matter much since they're only going exist long enough to flash the router back to OEM firmware.

![set password](/assets/Screenshot from 2018-03-24 11-52-34.png)

Now, from dd-wrt, flash the router with `ArcherC7v2_webrevert.bin` that you extracted earlier.

![flash revert image](/assets/Screenshot from 2018-03-24 11-53-24.png)

Flashing...

![flashing](/assets/Screenshot from 2018-03-24 11-53-44.png)

Rebooting...

![rebooting](/assets/Screenshot from 2018-03-24 11-55-08.png)

We're back to TP-LINK OEM firmware, so point your browser back at [192.168.0.1](http://192.168.0.1), but now we're running the relatively ancient `3.13.34 Build 131217 Rel.60903n` which came out before all the firmware version signing nonsense was added.  At this point, we can finally flash the router with [lede-17.01.4-ar71xx-generic-archer-c7-v2-squashfs-factory.bin](http://downloads.lede-project.org/releases/17.01.4/targets/ar71xx/generic/lede-17.01.4-ar71xx-generic-archer-c7-v2-squashfs-factory.bin).

![flashing lede](/assets/Screenshot from 2018-03-24 12-06-45.png)

Flashing...

![progress](/assets/Screenshot from 2018-03-24 12-07-16.png)

Rebooting...

![rebooting](/assets/Screenshot from 2018-03-24 12-08-52.png)

Like dd-wrt, OpenWRT/LEDE use [192.168.1.1](http://192.168.1.1), so point your browser back over there.

![lede login](/assets/Screenshot from 2018-03-25 12-40-19.png)

Log into OpenWRT/LEDE and enable your wireless interfaces.

![setup wifi](/assets/Screenshot from 2018-03-24 12-14-07.png)

That's it.  From here, you can configure OpenWRT/LEDE however you like and go on your merry way.
