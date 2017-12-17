---
layout:         post
title:          Breezy P4 Clockmod Bug
date:           2005-12-09
tags:           ubuntu kernel
redirect_from:  "/clockmod/"
---
There is a bug in the Intel specification of some of their CPUs that is known as the N60 Errata. Because of this bug, some Intel CPUs hang when running below 2GHz under Linux. The Ubuntu developers patched the kernel to check for the N60 Errata and if it finds it, it doesn't let you clock down your CPU below 2GHz.

This effect is rather annoying. To rectify the situation, [djkork](http://ubuntuforums.org/member.php?u=46517) has built a couple of kernel packages specifically for Breezy. These kernels were build with the detection phase for this bug disabled. These kernels do not detect the bug. Thus, you can work below 2GHz. If you were a false positive, your computer will work perfectly now. (All things considered.) If you really have the bug, your computer will hang with these kernels.

There are two packages, one for P4 with Hyperthreading and another without Hypertheading. They work for P4, Celeron (p4 Based) or centrino CPUs

Don't forget to add the p4-clockmod module or the one for the centrino.

See the [original thread](https://web.archive.org/web/20060712231152/http://ubuntuforums.org:80/showthread.php?t=83907) that spawned this page

The kernel packages are available on a few different mirrors. If you can, please use the torrents. We've been seeing a lot of load recently and don't really have the bandwidth to handle it. Don't worry, if nowhere else, the torrents are seeded on Blessed.

### Torrent
* [kernel-image-2.6.12.no-n60-p4_10.00.Custom_i386.deb.torrent](/assets/kernel-image-2.6.12.no-n60-p4_10.00.Custom_i386.deb.torrent)
* [kernel-image-2.6.12.no-n60-hyperthreading_10.00.Custom_i386.deb.torrent](/assets/kernel-image-2.6.12.no-n60-hyperthreading_10.00.Custom_i386.deb.torrent)

### Blessed
* [kernel-image-2.6.12.no-n60-p4_10.00.Custom_i386.deb](/assets/kernel-image-2.6.12.no-n60-p4_10.00.Custom_i386.deb)
* [kernel-image-2.6.12.no-n60-hyperthreading_10.00.Custom_i386.deb](/assets/kernel-image-2.6.12.no-n60-hyperthreading_10.00.Custom_i386.deb)

### Tranq
* [kernel-image-2.6.12.no-n60-p4_10.00.Custom_i386.deb](/assets/kernel-image-2.6.12.no-n60-p4_10.00.Custom_i386.deb)
* [kernel-image-2.6.12.no-n60-hyperthreading_10.00.Custom_i386.deb](/assets/kernel-image-2.6.12.no-n60-hyperthreading_10.00.Custom_i386.deb)

### Amparito
* [kernel-image-2.6.12.no-n60-p4_10.00.Custom_i386.deb](/assets/kernel-image-2.6.12.no-n60-p4_10.00.Custom_i386.deb)
* [kernel-image-2.6.12.no-n60-hyperthreading_10.00.Custom_i386.deb](/assets/kernel-image-2.6.12.no-n60-hyperthreading_10.00.Custom_i386.deb)
