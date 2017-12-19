---
layout: post
title:  Candyhouse IPFire
date:   2014-12-05
tags:   cisco linksys e4200v2 candyhouse router firmware reverse_engineering ipfire
last_modified_at: 2015-03-29
redirect_from: "/projects/candyhouse/ipfire/"
---
[IPFire](http://www.ipfire.org/) is a hardened Linux appliance distribution designed for use as a firewall. This build is based on the pre-existing [ARM/Kirkwood port](http://wiki.ipfire.org/en/hardware/arm/kirkwood).

Get the IPFire ARM image from the source:

<http://downloads.ipfire.org/releases/ipfire-2.x/2.15-core85/ipfire-2.15.1gb-ext4-scon.armv5tel-full-core85.img.gz>

Zcat that compressed image to a blank USB stick, 1G or larger. After zcat finishes, put the USB stick into your router.

Clone the [ipfire branch](https://github.com/cilynx/Candyhouse-Linux/tree/ipfire) of [Candyhouse-Linux](https://github.com/cilynx/Candyhouse-Linux/) and build yourself a uImage.

Flash your router with the uImage you just created and watch over your [serial port](/projects/candyhouse/serial/) as your router boots IPFire. Setting up IPFire requires a serial connection as it blocks the boot so you can setup the network. There are no defaults.
