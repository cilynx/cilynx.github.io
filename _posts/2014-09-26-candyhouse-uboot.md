---
layout: post
title:  "Candyhouse U-Boot"
tags: cisco linksys e4200v2 candyhouse router uboot firmware reverse_engineering
redirect_from: "/projects/candyhouse/uboot/"
---
## Install the Tools
Start off by installing [`u-boot-tools`](http://packages.debian.org/jessie/u-boot-tools):

```
aptitude install u-boot-tools
```

## Figure out Config Parameters

In order for `fw_printenv` to know what it's doing, you need to pass it a config file with an [MTD](http://en.wikipedia.org/wiki/Memory_Technology_Device) device, the offset of the actual uboot config environment, the environment size, the flash sector size, and the number of sectors making up the environment.

Looking at `/proc/mtd`, we can see that u-boot is on `mtd0` and has a sector size (erasesize) of 20000:

```
root@e4200v2:~# cat /proc/mtd 
dev:    size   erasesize  name
mtd0: 00100000 00020000 "u-boot"
mtd1: 00400000 00020000 "uImage"
mtd2: 07b00000 00020000 "root"
root@e4200v2:~# 
```

The offset and environment size are a little more interesting. Let's start by looking at `/dev/mtd0ro` (read-only device, just to be safe) with `xxd -a`. We want the `-a` flag so that we don't have to scroll through a bunch of null lines. See [`xxd(1)`](http://linux.die.net/man/1/xxd) for more details.

`mtd0` starts off with a bunch of garbage that doesn't really help us at all:

```
0000000: 8b00 0008 084b 0700 0000 0000 0002 0000  .....K..........
0000010: 0000 6000 0000 6700 0000 0000 0000 01b7  ..`...g.........
0000020: 4000 0000 0000 0000 0000 0000 0000 0000  @...............
0000030: 0000 0000 0000 0000 0000 0000 0000 0000  ................
0000040: e000 d1ff 1b1b 1b1b 0014 d0ff 300c 0143  ............0..C
0000050: 0414 d0ff 0030 7438 0814 d0ff 5155 1223  .....0t8....QU.#
0000060: 0c14 d0ff 3200 0016 1014 d0ff 0d00 000a  ....2...........
0000070: 1414 d0ff 0000 0000 1814 d0ff 0000 0000  ................
0000080: 1c14 d0ff 6206 0000 2014 d0ff 0404 0000  ....b... .......
0000090: 2414 d0ff 7ff1 0000 2814 d0ff 3066 0900  $.......(...0f..
00000a0: 7c14 d0ff 6396 0000 0415 d0ff f1ff ff07  |...c...........
00000b0: 0815 d0ff 0000 0008 0c15 d0ff 0000 0000  ................
00000c0: 1415 d0ff 0000 0000 1c15 d0ff 0000 0000  ................
00000d0: 9414 d0ff 0000 0100 9814 d0ff 0000 0000  ................
00000e0: 9c14 d0ff 0fe8 0000 8014 d0ff 0100 0000  ................
00000f0: 3401 d2ff 6666 6666 3801 d2ff 6666 6666  4...ffff8...ffff
0000100: 0000 0000 0000 0000 0000 0000 0000 0000  ................
*
00001f0: 0000 0000 0000 0000 0000 0000 0000 002d  ...............-
0000200: 1200 00ea 14f0 9fe5 14f0 9fe5 14f0 9fe5  ................
0000210: 14f0 9fe5 14f0 9fe5 14f0 9fe5 14f0 9fe5  ................
0000220: a001 6000 0002 6000 6002 6000 c002 6000  ..`...`.`.`...`.
0000230: 2003 6000 8003 6000 e003 6000 efbe adde   .`...`...`.....
0000240: 0000 6000 0000 6000 f0ff 6700 20fb 6c00  ..`...`...g. .l.
0000250: 0000 0fe1 1f00 c0e3 d300 80e3 00f0 29e1  ..............).
0000260: 1700 00eb 6c00 4fe2 3010 1fe5 0100 50e1  ....l.O.0.....P.
```

Let's try searching for something we know will be in the configuration environment...say _bootdelay_. The first result isn't too helpful:

```
00583a0: 7465 640a 0023 2320 4572 726f 723a 2022  ted..## Error: "
00583b0: 2573 2220 6e6f 7420 6465 6669 6e65 640a  %s" not defined.
00583c0: 0062 6f6f 7464 656c 6179 006c 6179 6f75  .bootdelay.layou
00583d0: 7400 6e6f 2064 6174 6100 7365 7465 6e76  t.no data.setenv
00583e0: 2025 7320 2573 006d 6163 0046 463a 4646   %s %s.mac.FF:FF
```

The second one, however, looks much more interesting:

```
007ffb0: ffff ffff ffff ffff ffff ffff ffff ffff  ................
007ffc0: ffff ffff ffff ffff ffff ffff ffff ffff  ................
007ffd0: ffff ffff ffff ffff ffff ffff ffff ffff  ................
007ffe0: ffff ffff ffff ffff ffff ffff ffff ffff  ................
007fff0: ffff ffff ffff ffff ffff ffff ffff ffff  ................
0080000: 0040 2c66 626f 6f74 6465 6c61 793d 3000  .@,fbootdelay=0.
0080010: 6261 7564 7261 7465 3d31 3135 3230 3000  baudrate=115200.
0080020: 6c6f 6164 735f 6563 686f 3d30 0069 7061  loads_echo=0.ipa
0080030: 6464 723d 3139 322e 3136 382e 312e 3130  ddr=192.168.1.10
0080040: 0073 6572 7665 7269 703d 3139 322e 3136  .serverip=192.16
0080050: 382e 312e 3235 3400 726f 6f74 7061 7468  8.1.254.rootpath
0080060: 3d2f 6d6e 742f 4152 4d5f 4653 006e 6574  =/mnt/ARM_FS.net
```

Now, that's a u-boot configuration environment if I've ever seen one. Besides the obvious `name=value` pairs, it has a start sigil and starts on a nice even sector boundary. It doesn't get much more obvious than that.

Okay, now we know that the offset is `0x80000`. All that's left is figuring out the environment size. Scroll down a ways through the configuration environment and you'll find this:

```
0080c20: 6964 3d38 3536 3534 3036 3638 4546 3141  id=856540668EF1A
0080c30: 3533 3834 4341 3431 3045 3142 4630 4138  5384CA410E1BF0A8
0080c40: 3639 4400 7770 733d 3832 3733 3933 3739  69D.wps=82739379
0080c50: 0062 6f6f 745f 7061 7274 3d31 0000 3d79  .boot_part=1..=y
0080c60: 6573 0000 0000 0000 0000 0000 0000 0000  es..............
0080c70: 0000 0000 0000 0000 0000 0000 0000 0000  ................
*
00a0000: 1108 1120 0200 0000 1308 1120 ffff ffff  ... ....... ....
00a0010: ffff ffff ffff ffff ffff ffff ffff ffff  ................
00a0020: ffff ffff ffff ffff ffff ffff ffff ffff  ................
00a0030: ffff ffff ffff ffff ffff ffff ffff ffff  ................
```

That star (`*`) means that `xxd` skipped a whole bunch of null lines instead of making us scroll through them. Thank you `-a`. In case it isn't obvious, what you're looking at here is a fairly small config environment, a bunch of blank space, then a [CRC](http://en.wikipedia.org/wiki/Cyclic_redundancy_check) starting at `0xA0000`. Now it's just simple subtraction to get the environment size.

```
0xA0000 - 0x80000 = 0x20000
```

For the hex challenged:

```
root@e4200v2:~# echo 'obase=16;ibase=16;A0000-80000'|bc
20000
root@e4200v2:~#
```

If I just lost you with the non-obvious base conversions in `bc`, [read this](http://www.basicallytech.com/blog/?/archives/23-command-line-calculations-using-bc.html#dec_hex). We'll be here when you get back.

## Configure the Tools

At any rate, dump the values we found into `/etc/fw_env.config`:

```
# MTD device name       Device offset   Env. size       Flash sector size       Number of sectors
/dev/mtd0               0x80000         0x20000         0x20000                 1
```   

## Run `fw_printenv`

Now `fw_printenv` can dump out the u-boot configuration environment:

```
root@e4200v2:~# fw_printenv 
bootdelay=0
baudrate=115200
loads_echo=0
ipaddr=192.168.1.10
serverip=192.168.1.254
rootpath=/mnt/ARM_FS
netmask=255.255.255.0
run_diag=yes
console=console=ttyS0,115200
badcount=0
bootbadcount=0
uenvbadcount=0
senvbadcount=0
buffbadcount=0
fs_bootargs=unused
mtdparts=mtdparts=nand_mtd:512k(uboot)ro,128k@512k(u_env),128k@640k(s_env),26m@2m(kernel),26m@2m(rootfs)fs,26m@28m(alt_kernel),26m@28m(alt_rootfs)fs,74m@54m(syscfg)
ethprime=egiga0
bootargs_root=root=/dev/nfs rw
fs_bootargs_root=root=/dev/mtdblock4 ro rootfstype=jffs2
alt_fs_bootargs_root=root=/dev/mtdblock6 ro rootfstype=jffs2
usb_fs_bootargs_root=root=/dev/sda1 rw rootfstype=ext2
bootargs_end=:::DB88FXX81:eth0:none
image_name=uImage
nandboot=nand read.e 0x2000000 0x200000 0x300000; setenv bootargs $(console) $(mtdparts) $(fs_bootargs_root) serial_number=$(sn) uuid=$(uuid) hw_version=$(hw) device_mac=$(mac) factory_date=$(date) wps_pin=$(wps); bootm 0x2000000;
altnandboot=nand read.e 0x2000000 0x1c00000 0x300000; setenv bootargs $(console) $(mtdparts) $(alt_fs_bootargs_root) serial_number=$(sn) uuid=$(uuid) hw_version=$(hw) device_mac=$(mac) factory_date=$(date) wps_pin=$(wps); bootm 0x2000000;
usbboot=usb start;ext2load usb 0:1 2000000 /uImage; setenv bootargs $(console) $(mtdparts) $(usb_fs_bootargs_root) rootdelay=10; bootm 0x2000000;
standalone=fsload 0x2000000 $(image_name);setenv bootargs $(console) root=/dev/mtdblock0 rw ip=$(ipaddr):$(serverip)$(bootargs_end) $(mvPhoneConfig); bootm 0x2000000;
lcd0_enable=0
lcd0_params=640x480-16@60
ethmtu=1500
eth1mtu=1500
mvPhoneConfig=mv_phone_config=dev[0]:fxs,dev[1]:fxo
mvNetConfig=mv_net_config=(00:11:88:0f:62:81,0:1:2:3),mtu=1500
usb0Mode=host
yuk_ethaddr=00:00:00:EE:51:81
nandEcc=1bit
netretry=no
rcvrip=169.254.100.100
loadaddr=0x02000000
autoload=no
image_multi=yes
mtdparts_version=4
envsaved=yes
ethact=egiga0
mfgboot=nand read.e 0x2000000 0x3600000 0x300000; setenv bootargs $(console) $(mfg_mtdparts) $(mfg_fs_bootargs_root) serial_number=$(sn) uuid=$(uuid) hw_version=$(hw) device_mac=$(mac) factory_date=$(date) wps_pin=$(wps); bootm 0x2000000;
mfg_fs_bootargs_root=root=/dev/mtdblock8 ro rootfstype=jffs2
mfg_mtdparts=mtdparts=nand_mtd:512k(uboot)ro,128k@512k(u_env),128k@640k(s_env),26m@2m(kernel),26m@2m(rootfs)fs,26m@28m(alt_kernel),26m@28m(alt_rootfs)fs,26m@54m(mfg_kernel),26m@54m(mfg_rootfs)fs,48m@80m(syscfg)
nfsboot=tftp 0x2000000 uImage; setenv bootargs $(console) $(mfg_mtdparts) $(bootargs_root) nfsroot=$(serverip):$(rootpath) ip=$(ipaddr):$(serverip)$(bootargs_end); bootm 0x2000000;
auto_recovery=yes
arcNumber=1680
boot_part_ready=3
bootcmd=run nandboot
stdin=serial
stdout=serial
stderr=serial
mainlineLinux=yes
enaMonExt=no
enaCpuStream=no
enaWrAllo=no
pexMode=RC
disL2Cache=no
setL2CacheWT=yes
disL2Prefetch=yes
enaICPref=yes
enaDCPref=yes
sata_dma_mode=yes
netbsd_en=no
vxworks_en=no
disaMvPnp=no
enaAutoRecovery=yes
pcieTune=no
pcieTune1=no
layout=ver.0.0.7
model=E4200
hw=RGWM-C4_0GA
edal_key=FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
mac=58:6D:8F:FF:93:DA
ethaddr=58:6D:8F:FF:93:DA
eth1addr=58:6D:8F:FF:93:DB
date=2012/01/21
sn=01C13601239597
uuid=856540668EF1A5384CA410E1BF0A869D
wps=82739379
boot_part=1
root@e4200v2:~# 
```

## References

* [OpenWrt Wiki: Das U-Boot Environment](http://wiki.openwrt.org/doc/techref/bootloader/uboot.config)

