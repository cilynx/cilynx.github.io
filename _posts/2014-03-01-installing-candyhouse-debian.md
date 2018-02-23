---
layout: post
title:  "Installing Debian on Candyhouse Routers"
tags: cisco linksys e4200v2 candyhouse router firmware debian reverse_engineering linux wifi
last_modified_at: 2014-08-01
redirect_from:
    - "/projects/candyhouse/install/"
    - "/projects/candyhouse/i/"
---
> All sources are available [on Github](https://github.com/cilynx/Candyhouse-Linux).

## Setup your RootFS on a USB Flash Drive

Read my other post to [build a Debian filesystem on a USB stick]({% post_url 2014-08-01-building-candyhouse-debian %}).

## Update your Kernel to Mainline Linux

* Plug the USB stick you prepared above into your router.
* Using the stock update utility, flash your router with [uImage-3.16.7-candyhouse](https://github.com/cilynx/Candyhouse-Linux/releases/download/v3.16.7/uImage-3.16.7-candyhouse).
* Your router will reboot on its own.
* When it comes back up, it'll be running Debian.
* Default creds are the same as stock (root / admin), the default ESSID is "candyhouse", and the default WPA-PSK is "Candyhouse".
