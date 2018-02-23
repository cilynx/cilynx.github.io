---
layout: post
title:  "Candyhouse Serial Console"
tags: cisco linksys e4200v2 candyhouse router firmware debian serial reverse_engineering linux wifi
redirect_from: "/projects/candyhouse/serial/"
---
![Serial Session](/assets/c68073cccc81a0127f1c80a5a6bccc5e.png)

If you reboot your router after setting `mainlineLinux=yes`, but before flashing with a Candyhouse uImage, you'll find yourself with a bricked router since both the backdoored SSA and the original stock SSA require `mainlineLinux=no` to boot.

The only way to get out of this situation is to attach some pins to the J5 header and hook into the serial console. You can use any terminal software you like, but personally I prefer gtkterm. The folks at Cisco were nice enough to use the default `8,N,1`, so you don't have to do much configuration.

You will need to grant your user access to `/dev/ttyUSB0` (or whatever TTY you use) being that this permission is not granted by default.

Once you've got permissions sorted out, boot the router and repeatedly hit the spacebar in your terminal -- you'll eventually stop the autoboot and get a `Viper>>` prompt. From there, you just `setenv mainlineLinux=no`, `saveenv`, and `reset` to boot back into the stock or backdoored firmware.

[![J5](/assets/fd236f9deda8cf53c235b7e1e75d8030.jpg)](/assets/ccdf7d1f8777ba5bcb9e651c3faa6cdc.jpg)
[![USB TTY Front](/assets/a329b8c25312a30f4f436bec86fc0588.jpg)](/assets/15d0f3bdd6d2259ff82a562ed10150de.jpg)
[![USB TTY Back](/assets/7be86fbd75b763dd7d802e218070c447.jpg)](/assets/d1d4ea1c0ec104230959f42d01cb222b.jpg)
