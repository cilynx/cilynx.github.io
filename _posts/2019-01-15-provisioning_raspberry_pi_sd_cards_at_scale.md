---
layout: post
title:  Provisioning Raspberry Pi SD Cards at Scale
date:   2019-01-15 13:55:58 -0800
tags:   raspberry_pi
---
![Raspberry Pi SD Cards](/assets/20190115_175334.jpg)
## Motivation

When I first started my RasPi clustering adventure, I found a ton of blog posts talking about automating the later stages of cluster management and I found several discussing GUI tools and other heavy and/or manual methods of setting up sdcards for the Pis in the first place.  As someone who prides myself both on being lazy and on avoiding untrusted links in the chain, I wanted to avoid specialty pre-built images as well as anything involving steps like:
* *"click on the blocks to bake an image for each node"*
* *"watch on your router to get the IPs as your nodes come online"*
* *"plug each Pi in individually, then run `$x` before plugging in the next one"*.

I also did not want to start this project with Ansible as it seems like a lot of cognitive overhead just to provision a few machines.  This left me creating a [handfull of bash scripts](https://github.com/cilynx/raspi) that do what I need with no uncommon dependencies.

## Why is SD card setup so hard?

While things have gotten a lot better with headless RasPi setup over the last few years, it still requires a bit of knowing what you're doing.  The normal singlet process goes something like this:
* Download an appropriate img file (Raspbian, etc)
* Write it to an SD card (dd or Etcher or what-have-you)
* Mount the SD card's `boot/` partition on your workstation
* Add an empty `/boot/ssh`
* Add an appropriately populated `/boot/wpa_supplicant.conf`
* Unmount the SD card from your workstation and move it to a Pi
* Boot the Pi
* SSH into `raspberrypi` (...if you're lucky enough to have functional local DHCP/DNS...else poke around at your router to find the IP)
* Run `raspi-config` to set the hostname and dork around with whatever else
* Reboot the Pi
* Actually start doing something useful

Now, this really isn't all that bad if you're only doing it once.  However, when setting up a cluster, you don't want to go through this dance over and over again.  My solution is a (hopefully) straightforward [bash script](https://github.com/cilynx/raspi/blob/master/init_sdcard.sh) that handles all the heavy lifting with no weird dependencies and with you running a single command like:
```
./init_sdcard.sh -d /dev/sdb -e clusternet raspi{00..08}
```
The script does the following:
1. Downloads the latest Raspbian image if you don't already have it
2. Mounts `boot/` from the image file
3. Touches `boot/ssh`
4. Prompts you one time for your wireless password
5. Writes an appropriate `boot/wpa_supplicant.conf`
6. Unmounts `boot/`
7. Mounts `rootfs/` from the image file
8. Adds the appropriate hostname to `rootfs/etc/hostname`
9. Unmounts `rootfs`
10. Makes sure `/dev/sdb*` is unmounted
11. Asks if you're sure you want to overwrite `/dev/sdb` (this is also your prompt to switch cards for each node)
12. Writes the node-specific image to `/dev/sdb`
13. Goes back to Step 7 and repeats for all hosts

Here's what in looks like in action:
```
rcw@xps:~/Projects/raspi$ ./init_sdcard.sh -d /dev/sdb -e clusternet raspi{00..03}

Preparing Raspbian image...

wget -q --server-response --trust-server-names -P /home/rcw/Downloads -N https://downloads.raspberrypi.org/raspbian_lite_latest
Archive:  /home/rcw/Downloads/2018-11-13-raspbian-stretch-lite.zip
replace /home/rcw/Downloads/2018-11-13-raspbian-stretch-lite.img? [y]es, [n]o, [A]ll, [N]one, [r]ename: n

Finding image partition offsets...

[sudo] password for rcw:
Preparing boot/ partition...
sudo mount -o loop,offset=4194304 /home/rcw/Downloads/2018-11-13-raspbian-stretch-lite.img /tmp/tmp.nAD6IW4Z4V/boot
Enabling SSH...
sudo touch /tmp/tmp.nAD6IW4Z4V/boot/ssh

Creating /tmp/tmp.nAD6IW4Z4V/boot/wpa_supplicant.conf...

Enter wireless password:

sudo umount /tmp/tmp.nAD6IW4Z4V/boot
sudo rmdir /tmp/tmp.nAD6IW4Z4V/boot

(raspi00): Preparing rootfs/ partition...
(raspi00): sudo mount -o loop,offset=50331648 /home/rcw/Downloads/2018-11-13-raspbian-stretch-lite.img /tmp/tmp.nAD6IW4Z4V/rootfs
(raspi00): Setting hostname
(raspi00): sudo umount /tmp/tmp.nAD6IW4Z4V/rootfs
(raspi00): Write /home/rcw/Downloads/2018-11-13-raspbian-stretch-lite.img to /dev/sdb? y
(raspi00): Making sure all sdcard partitions are unmounted...
umount: /dev/sdb: not mounted.
umount: /dev/sdb1: not mounted.
umount: /dev/sdb2: not mounted.
(raspi00): Writing image to sdcard -- this could take a few minutes...
(raspi00): sudo dd if=/home/rcw/Downloads/2018-11-13-raspbian-stretch-lite.img of=/dev/sdb bs=4M conv=fdatasync
445+0 records in
445+0 records out
1866465280 bytes (1.9 GB, 1.7 GiB) copied, 93.8622 s, 19.9 MB/s
(raspi00): done.

(raspi01): Preparing rootfs/ partition...
(raspi01): sudo mount -o loop,offset=50331648 /home/rcw/Downloads/2018-11-13-raspbian-stretch-lite.img /tmp/tmp.nAD6IW4Z4V/rootfs
(raspi01): Setting hostname
(raspi01): sudo umount /tmp/tmp.nAD6IW4Z4V/rootfs
(raspi01): Write /home/rcw/Downloads/2018-11-13-raspbian-stretch-lite.img to /dev/sdb? y
(raspi01): Making sure all sdcard partitions are unmounted...
umount: /dev/sdb: not mounted.
umount: /dev/sdb1: not mounted.
umount: /dev/sdb2: not mounted.
(raspi01): Writing image to sdcard -- this could take a few minutes...
(raspi01): sudo dd if=/home/rcw/Downloads/2018-11-13-raspbian-stretch-lite.img of=/dev/sdb bs=4M conv=fdatasync
445+0 records in
445+0 records out
1866465280 bytes (1.9 GB, 1.7 GiB) copied, 76.7828 s, 24.3 MB/s
(raspi01): done.

(raspi02): Preparing rootfs/ partition...
(raspi02): sudo mount -o loop,offset=50331648 /home/rcw/Downloads/2018-11-13-raspbian-stretch-lite.img /tmp/tmp.nAD6IW4Z4V/rootfs
(raspi02): Setting hostname
(raspi02): sudo umount /tmp/tmp.nAD6IW4Z4V/rootfs
(raspi02): Write /home/rcw/Downloads/2018-11-13-raspbian-stretch-lite.img to /dev/sdb? y
(raspi02): Making sure all sdcard partitions are unmounted...
umount: /dev/sdb: not mounted.
umount: /dev/sdb1: not mounted.
umount: /dev/sdb2: not mounted.
(raspi02): Writing image to sdcard -- this could take a few minutes...
(raspi02): sudo dd if=/home/rcw/Downloads/2018-11-13-raspbian-stretch-lite.img of=/dev/sdb bs=4M conv=fdatasync
445+0 records in
445+0 records out
1866465280 bytes (1.9 GB, 1.7 GiB) copied, 79.9994 s, 23.3 MB/s
(raspi02): done.

(raspi03): Preparing rootfs/ partition...
(raspi03): sudo mount -o loop,offset=50331648 /home/rcw/Downloads/2018-11-13-raspbian-stretch-lite.img /tmp/tmp.nAD6IW4Z4V/rootfs
(raspi03): Setting hostname
(raspi03): sudo umount /tmp/tmp.nAD6IW4Z4V/rootfs
(raspi03): Write /home/rcw/Downloads/2018-11-13-raspbian-stretch-lite.img to /dev/sdb? y
(raspi03): Making sure all sdcard partitions are unmounted...
umount: /dev/sdb: not mounted.
umount: /dev/sdb1: not mounted.
umount: /dev/sdb2: not mounted.
(raspi03): Writing image to sdcard -- this could take a few minutes...
(raspi03): sudo dd if=/home/rcw/Downloads/2018-11-13-raspbian-stretch-lite.img of=/dev/sdb bs=4M conv=fdatasync
445+0 records in
445+0 records out
1866465280 bytes (1.9 GB, 1.7 GiB) copied, 76.5434 s, 24.4 MB/s
(raspi03): done.

sudo rmdir /tmp/tmp.nAD6IW4Z4V/rootfs
sudo rmdir /tmp/tmp.nAD6IW4Z4V

rcw@xps:~/Projects/raspi$
```
All you have to do is swap the SD cards and mash `y` over and over again between each one.  Stick the cards in your Pis as they complete and your Pis will all boot up, join your wifi, and have appropriate hostnames which makes everything else we're about to get into much, *much* easier.
