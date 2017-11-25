---
layout: post
title:  "Making the Cisco/Linksys E4200v2 work for you"
tags: cisco linksys e4200v2 candyhouse router firmware
---

About a month ago, I ordered a [Cisco E4200](http://amzn.to/2A5tUN0) from an Amazon vendor who promised me it was a v1 and would run open-source firmware ([dd-wrt](http://dd-wrt.com), [openwrt](http://openwrt.org/), [tomato](http://tomatousb.org/), etc).  This was a big deal because I purchased this router specifically to replace my [Airport Extreme](http://amzn.to/2A4FRm3) because the Airport Extreme is an amazingly closed product and doesn't let me jigger with things the way I want to.  Well, lo-and-behold, my E4200 arrives and is in a sealed V1 / N750 box, but the actual device is a V2 / N900.  Bad for me, but good for you.

So now I have this thing and I will be making it do what I want it to.  First off, you should know that the E4200v2 runs Linux right out of the box and when pressed, Cisco honors GPL and will provide the source and toolchain.  ([Confirmed by Neubsi](http://blog.bramp.net/post/2012/01/24/hacking-linksys-e4200v2-firmware/#comment-1005230407).  I’ve not yet made my request.)

[Andrew Brampton](http://bramp.net) [took apart the firmware](http://blog.bramp.net/post/2012/01/24/hacking-linksys-e4200v2-firmware/) a bit and discovered that the E4200′s kernel was compiled with CodeSourcery Sourcery G++ Lite 2007q1-21.  [Dan Walters](http://walters.io) (working on the similar [EA3500](http://amzn.to/2iQeEua)) proved empirically that [Mentor Graphic’s Sourcery CodeBench Lite Edition](https://www.mentor.com/embedded-software/sourcery-tools/sourcery-codebench/editions/lite-edition/) works just fine and managed to run [Dropbear SSH](https://matt.ucc.asn.au/dropbear/dropbear.html) by exploiting the router’s built-in package management system.

I’ve confirmed that the /packages/ USB directory trick works on the E4200v2 and I’ve been playing around with cross-compiling applications for the device since then.  It is my understanding that the main thing preventing support of this device is the networking components of the Marvell chipset, however, [mwl8k](https://wiki.debian.org/mwl8k) looks to have support in one form or another.

As of now, I have reached out to the dd-wrt folks to find out what the blocker is to getting support on the device and I’ll be continuing to mess around with it on my own in the mean time — particularly focusing on Marvell and other [ugly stuff](https://wikidevi.com/wiki/Linksys_E4200_v2).

As an aside, the /packages/ trick is pretty cool and I wonder about adding it as a standard feature on open firmware distros.  Basically what the router does is mount the /packages/ directory from a USB stick that you insert and it runs init-style scripts from a specific directory.  This lets you add applications and configure how they run when you insert the stick.  Has quite a bit of potential around deployment management.  Forget configuring a bunch of devices manually — just put in the USB stick and go.  Being that the root filesystem can be mounted RW, this could even be a quick and dirty hack to overwrite pretty much the whole system without ever flashing the firmware.

More to come as I make more progress –
