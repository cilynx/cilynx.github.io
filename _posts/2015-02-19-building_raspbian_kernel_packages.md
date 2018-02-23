---
layout:         post
title:          Building Raspbian Kernel Packages
date:           2015-02-19
tags:           raspberry_pi kernel debian linux
redirect_from:  "/projects/raspi/kernel/"
---
Grab the kernel source:

```
rcw@initiative:~/Projects/RasPi/kernel$ git clone git://github.com/raspberrypi/linux.git
Cloning into 'linux'...
remote: Counting objects: 2866127, done.
remote: Compressing objects: 100% (490204/490204), done.
remote: Total 2866127 (delta 2370879), reused 2836481 (delta 2348395)
Receiving objects: 100% (2866127/2866127), 759.86 MiB | 2.43 MiB/s, done.
Resolving deltas: 100% (2370879/2370879), done.
Checking out files: 100% (40051/40051), done.
rcw@initiative:~/Projects/RasPi/kernel$
```

Grab the Raspberry Pi compiler:

```
rcw@initiative:~/Projects/RasPi/kernel$ git clone https://github.com/raspberrypi/tools
Cloning into 'tools'...
remote: Counting objects: 11148, done.
remote: Compressing objects: 100% (5753/5753), done.
remote: Total 11148 (delta 6433), reused 9627 (delta 4912)
Receiving objects: 100% (11148/11148), 219.74 MiB | 2.22 MiB/s, done.
Resolving deltas: 100% (6433/6433), done.
Checking out files: 100% (10692/10692), done.
rcw@initiative:~/Projects/RasPi/kernel$
```

Set some environment variables to make your life easier:

```
rcw@initiative:~/Projects/RasPi/kernel$ KERNEL_SRC=/home/rcw/Projects/RasPi/kernel/linux/
rcw@initiative:~/Projects/RasPi/kernel$ CCPREFIX=/home/rcw/Projects/RasPi/kernel/tools/arm-bcm2708/gcc-linaro-arm-linux-gnueabihf-raspbian/bin/arm-linux-gnueabihf-
rcw@initiative:~/Projects/RasPi/kernel$
```

Clean the build tree:

```
rcw@initiative:~/Projects/RasPi/kernel$ cd linux/
rcw@initiative:~/Projects/RasPi/kernel/linux$ make mrproper
rcw@initiative:~/Projects/RasPi/kernel/linux$
```

Grab /proc/config.gz from your running Raspian installation:

```
rcw@initiative:~/Projects/RasPi/kernel/linux$ ssh pi@192.168.1.44 gzip -cd /proc/config.gz > .config
pi@192.168.1.44's password:
rcw@initiative:~/Projects/RasPi/kernel/linux$
```

Configure your kernel source with the options from your running Raspian install:

```
rcw@initiative:~/Projects/RasPi/kernel/linux$ ARCH=arm CROSS_COMPILE=${CCPREFIX} INSTALL_MOD_PATH=${MODULES_TEMP} make oldconfig
HOSTCC  scripts/basic/fixdep
HOSTCC  scripts/kconfig/conf.o
SHIPPED scripts/kconfig/zconf.tab.c
SHIPPED scripts/kconfig/zconf.lex.c
SHIPPED scripts/kconfig/zconf.hash.c
HOSTCC  scripts/kconfig/zconf.tab.o
HOSTLD  scripts/kconfig/conf
scripts/kconfig/conf --oldconfig Kconfig
#
# configuration written to .config
#
rcw@initiative:~/Projects/RasPi/kernel/linux$
```

Go through menuconfig and tweak what you need. In my case, I added Si470x FM Radio drivers.

```
rcw@initiative:~/Projects/RasPi/kernel/linux$ ARCH=arm CROSS_COMPILE=${CCPREFIX} make menuconfig

...
...
...

[*]   Silicon Labs Si470x FM Radio Receiver support
<M>     Silicon Labs Si470x FM Radio Receiver support with USB
<M>     Silicon Labs Si470x FM Radio Receiver support with I2C
```

Build the kernel

```
rcw@initiative:~/Projects/RasPi/kernel/linux$ ARCH=arm CROSS_COMPILE=${CCPREFIX} INSTALL_MOD_PATH=${MODULES_TEMP} make -j8
WRAP    arch/arm/include/generated/asm/auxvec.h
WRAP    arch/arm/include/generated/asm/bitsperlong.h
CHK     include/linux/version.h
WRAP    arch/arm/include/generated/asm/cputime.h
WRAP    arch/arm/include/generated/asm/errno.h
WRAP    arch/arm/include/generated/asm/emergency-restart.h
UPD     include/linux/version.h
WRAP    arch/arm/include/generated/asm/ioctl.h
WRAP    arch/arm/include/generated/asm/irq_regs.h
WRAP    arch/arm/include/generated/asm/kdebug.h
WRAP    arch/arm/include/generated/asm/local.h
WRAP    arch/arm/include/generated/asm/local64.h

...
...
...

HEX2FW firmware/whiteheat.fw
IHEX2FW firmware/keyspan_pda/keyspan_pda.fw
IHEX2FW firmware/keyspan_pda/xircom_pgs.fw
IHEX2FW firmware/whiteheat_loader.fw
rcw@initiative:~/Projects/RasPi/kernel/linux$
```

Build the Debian packages

```
rcw@initiative:~/Projects/RasPi/kernel/linux$ CONCURRENCY_LEVEL=8 DEB_HOST_ARCH=armhf fakeroot make-kpkg --append-to-version -wolfteck --revision `date +%Y%m%d%H%M%S` --arch arm --initrd --cross-compile ${CCPREFIX} kernel_image kernel_headers

...
...
...

dpkg-deb: building package `linux-headers-3.6.11-wolfteck+' in `../linux-headers-3.6.11-wolfteck+_20130417002447_armhf.deb'.
cp -pf debian/control.dist          debian/control
make[2]: Leaving directory `/home/rcw/Projects/RasPi/kernel/linux'
make[1]: Leaving directory `/home/rcw/Projects/RasPi/kernel/linux'
rcw@initiative:~/Projects/RasPi/kernel/linux$ ls ../
config.gz  linux-headers-3.6.11-wolfteck+_20130417002447_armhf.deb  tools
linux      linux-image-3.6.11-wolfteck+_20130417002447_armhf.deb
rcw@initiative:~/Projects/RasPi/kernel/linux$ scp ../linux*.deb pi@192.168.1.44:/tmp
pi@192.168.1.44's password:
linux-headers-3.6.11-wolfteck+_20130417002447_armhf. 100% 7587KB 210.7KB/s   00:36
linux-image-3.6.11-wolfteck+_20130417002447_armhf.de 100%   13MB 859.7KB/s   00:16
rcw@initiative:~/Projects/RasPi/kernel/linux$
```

## References

* [RADclock on Raspberry Pi: cooking some patches](http://www.synclab.org/?post=blog/2012/11/radclock-raspberry-howto-patch.html)
* [RPi Kernel Compilation](http://elinux.org/RPi_Kernel_Compilation)

