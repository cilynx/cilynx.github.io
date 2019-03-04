---
layout: post
title:  Packaging rtl88x2bu for Synology NAS
date:   2019-03-02 15:23:55 -0800
tags:   rtl88x2bu linux kernel
---
## Work in a VM

IMHO, the Synology development environment is terrible, mostly because all of the scripts assume you're `root` and the archives contain device nodes and other nastiness.  To keep yourself safe and sane, just make yourself a VM and let Synology take it over.

For this project, I brought up a Debian 9 virt using VirtualBox.

## (Apt) Get yourself some dependencies

Before you can get very far, you're going to need `git`.

```
rcw@synology-dev:~$ sudo apt install git
Reading package lists... Done
Building dependency tree       
Reading state information... Done
The following additional packages will be installed:
  git-man liberror-perl patch rsync
Suggested packages:
  git-daemon-run | git-daemon-sysvinit git-doc git-el git-email git-gui gitk gitweb git-arch git-cvs git-mediawiki git-svn ed diffutils-doc
The following NEW packages will be installed:
  git git-man liberror-perl patch rsync
0 upgraded, 5 newly installed, 0 to remove and 0 not upgraded.
Need to get 6,131 kB of archives.
After this operation, 32.0 MB of additional disk space will be used.
Do you want to continue? [Y/n]
Get:1 http://ftp.us.debian.org/debian stretch/main amd64 liberror-perl all 0.17024-1 [26.9 kB]
Get:2 http://ftp.us.debian.org/debian stretch/main amd64 git-man all 1:2.11.0-3+deb9u4 [1,433 kB]
Get:3 http://ftp.us.debian.org/debian stretch/main amd64 git amd64 1:2.11.0-3+deb9u4 [4,167 kB]
Get:4 http://ftp.us.debian.org/debian stretch/main amd64 patch amd64 2.7.5-1+deb9u1 [112 kB]
Get:5 http://ftp.us.debian.org/debian stretch/main amd64 rsync amd64 3.1.2-1+deb9u1 [393 kB]
Fetched 6,131 kB in 3s (1,822 kB/s)
Selecting previously unselected package liberror-perl.
(Reading database ... 128960 files and directories currently installed.)
Preparing to unpack .../liberror-perl_0.17024-1_all.deb ...
Unpacking liberror-perl (0.17024-1) ...
Selecting previously unselected package git-man.
Preparing to unpack .../git-man_1%3a2.11.0-3+deb9u4_all.deb ...
Unpacking git-man (1:2.11.0-3+deb9u4) ...
Selecting previously unselected package git.
Preparing to unpack .../git_1%3a2.11.0-3+deb9u4_amd64.deb ...
Unpacking git (1:2.11.0-3+deb9u4) ...
Selecting previously unselected package patch.
Preparing to unpack .../patch_2.7.5-1+deb9u1_amd64.deb ...
Unpacking patch (2.7.5-1+deb9u1) ...
Selecting previously unselected package rsync.
Preparing to unpack .../rsync_3.1.2-1+deb9u1_amd64.deb ...
Unpacking rsync (3.1.2-1+deb9u1) ...
Setting up git-man (1:2.11.0-3+deb9u4) ...
Setting up liberror-perl (0.17024-1) ...
Setting up rsync (3.1.2-1+deb9u1) ...
Created symlink /etc/systemd/system/multi-user.target.wants/rsync.service → /lib/systemd/system/rsync.service.
Setting up patch (2.7.5-1+deb9u1) ...
Processing triggers for systemd (232-25+deb9u9) ...
Processing triggers for man-db (2.7.6.1-2) ...
Setting up git (1:2.11.0-3+deb9u4) ...
rcw@synology-dev:~$
```

## Setup the Synology Toolkit

From this point forward, you basically need to be `root`.  Throw out everything you know about security / accountability / safety, and just do it.  You're in a virt, right?

```
rcw@synology-dev:~$ sudo -s

We trust you have received the usual lecture from the local System
Administrator. It usually boils down to these three things:

    #1) Respect the privacy of others.
    #2) Think before you type.
    #3) With great power comes great responsibility.

[sudo] password for rcw:
root@synology-dev:/home/rcw# cd
root@synology-dev:~#
```

For our next terrible practice, we're going to follow [the official docs](https://originhelp.synology.com/developer-guide/create_package/install_toolkit.html) and work out of `/toolkit`.

```
root@synology-dev:~# mkdir /toolkit
root@synology-dev:~# cd /toolkit
root@synology-dev:/toolkit#
```

Clone yourself Synology's [`pkgscripts-ng`](https://github.com/SynologyOpenSource/pkgscripts-ng) -- they'll be setting up the environment.

```
root@synology-dev:/toolkit# git clone https://github.com/SynologyOpenSource/pkgscripts-ng
Cloning into 'pkgscripts-ng'...
remote: Enumerating objects: 207, done.
remote: Total 207 (delta 0), reused 0 (delta 0), pack-reused 207
Receiving objects: 100% (207/207), 102.48 KiB | 0 bytes/s, done.
Resolving deltas: 100% (122/122), done.
root@synology-dev:/toolkit#
```

## Setup the actual environment

`EnvDeploy` from `pkgscripts-ng` handles this for us.  It'll take a while as it downloads and extracts a couple gigs or so of environment tarballs.  Use `-v` to specify DSM version and `-p` to specify desired platform.  You don't want to leave out `-p` as it'll waste a bunch of your time / bandwidth / disk setting up every available platform.

For today, I'm targeting `DSM 6.2` on `braswell`.

```
root@synology-dev:/toolkit/pkgscripts-ng# ./EnvDeploy -v 6.2 -p braswell
Download... https://sourceforge.net/projects/dsgpl/files/toolkit/DSM6.2/base_env-6.2.txz
Download destination: /toolkit/toolkit_tarballs/base_env-6.2.txz
Download... https://sourceforge.net/projects/dsgpl/files/toolkit/DSM6.2/ds.braswell-6.2.env.txz
Download destination: /toolkit/toolkit_tarballs/ds.braswell-6.2.env.txz
Download... https://sourceforge.net/projects/dsgpl/files/toolkit/DSM6.2/ds.braswell-6.2.dev.txz
Download destination: /toolkit/toolkit_tarballs/ds.braswell-6.2.dev.txz
tar -xhf /toolkit/toolkit_tarballs/base_env-6.2.txz -C /toolkit/build_env/ds.braswell-6.2
tar -xhf /toolkit/toolkit_tarballs/ds.braswell-6.2.env.txz -C /toolkit/build_env/ds.braswell-6.2
tar -xhf /toolkit/toolkit_tarballs/ds.braswell-6.2.dev.txz -C /toolkit/build_env/ds.braswell-6.2
All task finished.
root@synology-dev:/toolkit/pkgscripts-ng#
```

After the environment is downloaded and extracted, you want to make yourself a GPG key with no passphrase.  The hits just keep on coming.

```
root@synology-dev:/toolkit/pkgscripts-ng# gpg --gen-key
gpg (GnuPG) 2.1.18; Copyright (C) 2017 Free Software Foundation, Inc.
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.

Note: Use "gpg --full-generate-key" for a full featured key generation dialog.

GnuPG needs to construct a user ID to identify your key.

Real name: Test Key
Email address: test@example.com
You selected this USER-ID:
    "Test Key <test@example.com>"

Change (N)ame, (E)mail, or (O)kay/(Q)uit? o
We need to generate a lot of random bytes. It is a good idea to perform
some other action (type on the keyboard, move the mouse, utilize the
disks) during the prime generation; this gives the random number
generator a better chance to gain enough entropy.

gpg: key 1F7DD1467A795899 marked as ultimately trustedd idea to perform
gpg: revocation certificate stored as '/root/.gnupg/openpgp-revocs.d/C388F288BA99CB8D578BACA01F7DD1467A795899.rev'
public and secret key created and signed.

pub   rsa3072 2019-03-03 [SC] [expires: 2021-03-02]
      C388F288BA99CB8D578BACA01F7DD1467A795899
      C388F288BA99CB8D578BACA01F7DD1467A795899
uid                      Test Key <test@example.com>
sub   rsa3072 2019-03-03 [E] [expires: 2021-03-02]

root@synology-dev:/toolkit/pkgscripts-ng#
```

Once your key shows up, move it into the development environment:

```
root@synology-dev:/toolkit/pkgscripts-ng# cp -r ~/.gnupg /toolkit/build_env/ds.braswell-6.2/root/
root@synology-dev:/toolkit/pkgscripts-ng#
```

## Prepare your module source

Clone your module source into a `source` directory under `/toolkit`.  For this project, I'm building the `rtl88x2bu` driver.

```
root@synology-dev:/toolkit/pkgscripts-ng# mkdir /toolkit/source
root@synology-dev:/toolkit/pkgscripts-ng# cd ../source/
root@synology-dev:/toolkit/source# git clone https://github.com/cilynx/rtl88x2BU_WiFi_linux_v5.3.1_27678.20180430_COEX20180427-5959.git
Cloning into 'rtl88x2BU_WiFi_linux_v5.3.1_27678.20180430_COEX20180427-5959'...
remote: Enumerating objects: 681, done.
remote: Counting objects: 100% (681/681), done.
remote: Compressing objects: 100% (467/467), done.
remote: Total 681 (delta 221), reused 665 (delta 210), pack-reused 0
Receiving objects: 100% (681/681), 3.62 MiB | 2.23 MiB/s, done.
Resolving deltas: 100% (221/221), done.
root@synology-dev:/toolkit/source#
```
We need to add the platform to the `Makefile`:
```
99c99,100
< CONFIG_PLATFORM_I386_PC = y
---
> CONFIG_PLATFORM_I386_PC = n
> CONFIG_PLATFORM_SYNOLOGY_DSM62_BRASWELL = y
1038a1040,1048
> ifeq ($(CONFIG_PLATFORM_SYNOLOGY_DSM62_BRASWELL), y)
>    EXTRA_CFLAGS += -DCONFIG_LITTLE_ENDIAN
>    EXTRA_CFLAGS += -DCONFIG_IOCTL_CFG80211 -DRTW_USE_CFG80211_STA_EVENT
>    ARCH := x86_64
>    CROSS_COMPILE := /usr/local/x86_64-pc-linux-gnu/bin/x86_64-pc-linux-gnu-
>    KVER := 3.10.102
>    KSRC := /usr/local/x86_64-pc-linux-gnu/x86_64-pc-linux-gnu/sys-root/usr/lib/modules/DSM-6.2/build
> endif
>
2002c2012,2014
< 	/sbin/depmod -a ${KVER}
---
>         ifneq ($(CONFIG_PLATFORM_SYNOLOGY_DSM62_BRASWELL), y)
> 	   /sbin/depmod -a ${KVER}
>         endif
2063d2074
<
```
Next we need a Synology build script.  Make a new `SynoBuildConf/` folder inside your module source and put this in that folder in a file called `build`.  In my case, this is `/toolkit/source/rtl88x2BU_WiFi_linux_v5.3.1_27678.20180430_COEX20180427-5959/SynoBuildConf/build`.

```
#!/bin/bash
# Copyright (C) 2000-2017 Synology Inc. All rights reserved.

case ${MakeClean} in
	[Yy][Ee][Ss])
		make clean
		;;
esac

make ${MAKE_FLAGS}
```

We also need a Synology dependency script.  In the same `SynoBuildConf/` folder inside your module source, create a `depends` file like so.  In my case, this is `/toolkit/source/rtl88x2BU_WiFi_linux_v5.3.1_27678.20180430_COEX20180427-5959/SynoBuildConf/depends`.

```
# Copyright (C) 2000-2017 Synology Inc. All rights reserved.

[default]
all="6.2"
```

## Build your module

Now, you can finally build the module.

```
root@synology-dev:/toolkit# pkgscripts-ng/PkgCreate.py -p braswell -I rtl88x2BU_WiFi_linux_v5.3.1_27678.20180430_COEX20180427-5959

============================================================
                   Parse argument result                    
------------------------------------------------------------
build_opt    :
branch       : master
only_install : False
link         : True
dep_level    : 1
suffix       :
collect      : False
sdk_ver      : 6.0
install      : False
env_version  : None
update       : True
build        : True
env_section  : default
install_opt  :
sign         : True
print_log    : False
package      : rtl88x2BU_WiFi_linux_v5.3.1_27678.20180430_COEX20180427-5959

Processing [6.2-23739]: braswell

============================================================
              Start to run "Traverse project"               
------------------------------------------------------------
[INFO] Branch projects: rtl88x2BU_WiFi_linux_v5.3.1_27678.20180430_COEX20180427-5959
[INFO] Tag projects:
[INFO] Reference projects:
[INFO] Reference tag projects:

============================================================
                Start to run "Link Project"                 
------------------------------------------------------------
Link /toolkit/pkgscripts-ng -> /toolkit/build_env/ds.braswell-6.2/pkgscripts-ng
Link /toolkit/source/rtl88x2BU_WiFi_linux_v5.3.1_27678.20180430_COEX20180427-5959 -> /toolkit/build_env/ds.braswell-6.2/source/rtl88x2BU_WiFi_linux_v5.3.1_27678.20180430_COEX20180427-5959

============================================================
                Start to run "Build Package"                
------------------------------------------------------------
[braswell] set -o pipefail; env PackageName=rtl88x2BU_WiFi_linux_v5.3.1_27678.20180430_COEX20180427-5959 /pkgscripts-ng/SynoBuild --braswell -c --min-sdk 6.0 rtl88x2BU_WiFi_linux_v5.3.1_27678.20180430_COEX20180427-5959 2>&1 | tee logs.build

============================================================
                    Time Cost Statistic                     
------------------------------------------------------------
00:00:00: Traverse project
00:00:00: Link Project
00:01:17: Build Package

[SUCCESS] pkgscripts-ng/PkgCreate.py -p braswell -I rtl88x2BU_WiFi_linux_v5.3.1_27678.20180430_COEX20180427-5959 finished.
root@synology-dev:/toolkit#
```
Here's the build log, in case you're curious.  The warnings look to be due to not knowing about mac80211.  Googling around a bit, it looks like mac80211.ko is available on the NAS, but someone with access to the hardware will have to verify.
```
root@synology-dev:/toolkit# cat build_env/ds.braswell-6.2/logs.build
Set cache size limit to 3.0 Gbytes
Statistics cleared
rm: cannot remove '/env32.mak': No such file or directory
rm: cannot remove '/env64.mak': No such file or directory
[INFO] projectList="rtl88x2BU_WiFi_linux_v5.3.1_27678.20180430_COEX20180427-5959"
[INFO] Start to build rtl88x2BU_WiFi_linux_v5.3.1_27678.20180430_COEX20180427-5959.
[SCRIPT] build script: //source/rtl88x2BU_WiFi_linux_v5.3.1_27678.20180430_COEX20180427-5959/SynoBuildConf/build
[INFO] ======= Run build script =======
#make -C /usr/local/x86_64-pc-linux-gnu/x86_64-pc-linux-gnu/sys-root/usr/lib/modules/DSM-6.2/build M=/source/rtl88x2BU_WiFi_linux_v5.3.1_27678.20180430_COEX20180427-5959 clean
cd hal ; rm -fr */*/*/*.mod.c */*/*/*.mod */*/*/*.o */*/*/.*.cmd */*/*/*.ko
cd hal ; rm -fr */*/*.mod.c */*/*.mod */*/*.o */*/.*.cmd */*/*.ko
cd hal ; rm -fr */*.mod.c */*.mod */*.o */.*.cmd */*.ko
cd hal ; rm -fr *.mod.c *.mod *.o .*.cmd *.ko
cd core ; rm -fr */*.mod.c */*.mod */*.o */.*.cmd */*.ko
cd core ; rm -fr *.mod.c *.mod *.o .*.cmd *.ko
cd os_dep/linux ; rm -fr *.mod.c *.mod *.o .*.cmd *.ko
cd os_dep ; rm -fr *.mod.c *.mod *.o .*.cmd *.ko
cd platform ; rm -fr *.mod.c *.mod *.o .*.cmd *.ko
rm -fr Module.symvers ; rm -fr Module.markers ; rm -fr modules.order
rm -fr *.mod.c *.mod *.o .*.cmd *.ko *~
rm -fr .tmp_versions
WARNING: "cfg80211_del_sta" [/source/rtl88x2BU_WiFi_linux_v5.3.1_27678.20180430_COEX20180427-5959/88x2bu.ko] undefined!
WARNING: "cfg80211_mgmt_tx_status" [/source/rtl88x2BU_WiFi_linux_v5.3.1_27678.20180430_COEX20180427-5959/88x2bu.ko] undefined!
WARNING: "wiphy_apply_custom_regulatory" [/source/rtl88x2BU_WiFi_linux_v5.3.1_27678.20180430_COEX20180427-5959/88x2bu.ko] undefined!
WARNING: "ieee80211_frequency_to_channel" [/source/rtl88x2BU_WiFi_linux_v5.3.1_27678.20180430_COEX20180427-5959/88x2bu.ko] undefined!
WARNING: "cfg80211_rx_mgmt" [/source/rtl88x2BU_WiFi_linux_v5.3.1_27678.20180430_COEX20180427-5959/88x2bu.ko] undefined!
WARNING: "cfg80211_new_sta" [/source/rtl88x2BU_WiFi_linux_v5.3.1_27678.20180430_COEX20180427-5959/88x2bu.ko] undefined!
WARNING: "cfg80211_connect_result" [/source/rtl88x2BU_WiFi_linux_v5.3.1_27678.20180430_COEX20180427-5959/88x2bu.ko] undefined!
WARNING: "cfg80211_unlink_bss" [/source/rtl88x2BU_WiFi_linux_v5.3.1_27678.20180430_COEX20180427-5959/88x2bu.ko] undefined!
WARNING: "wiphy_new" [/source/rtl88x2BU_WiFi_linux_v5.3.1_27678.20180430_COEX20180427-5959/88x2bu.ko] undefined!
WARNING: "cfg80211_put_bss" [/source/rtl88x2BU_WiFi_linux_v5.3.1_27678.20180430_COEX20180427-5959/88x2bu.ko] undefined!
WARNING: "cfg80211_roamed" [/source/rtl88x2BU_WiFi_linux_v5.3.1_27678.20180430_COEX20180427-5959/88x2bu.ko] undefined!
WARNING: "cfg80211_scan_done" [/source/rtl88x2BU_WiFi_linux_v5.3.1_27678.20180430_COEX20180427-5959/88x2bu.ko] undefined!
WARNING: "cfg80211_ibss_joined" [/source/rtl88x2BU_WiFi_linux_v5.3.1_27678.20180430_COEX20180427-5959/88x2bu.ko] undefined!
WARNING: "cfg80211_michael_mic_failure" [/source/rtl88x2BU_WiFi_linux_v5.3.1_27678.20180430_COEX20180427-5959/88x2bu.ko] undefined!
WARNING: "cfg80211_disconnected" [/source/rtl88x2BU_WiFi_linux_v5.3.1_27678.20180430_COEX20180427-5959/88x2bu.ko] undefined!
WARNING: "cfg80211_get_bss" [/source/rtl88x2BU_WiFi_linux_v5.3.1_27678.20180430_COEX20180427-5959/88x2bu.ko] undefined!
WARNING: "cfg80211_inform_bss_frame" [/source/rtl88x2BU_WiFi_linux_v5.3.1_27678.20180430_COEX20180427-5959/88x2bu.ko] undefined!
WARNING: "wiphy_free" [/source/rtl88x2BU_WiFi_linux_v5.3.1_27678.20180430_COEX20180427-5959/88x2bu.ko] undefined!
WARNING: "__ieee80211_get_channel" [/source/rtl88x2BU_WiFi_linux_v5.3.1_27678.20180430_COEX20180427-5959/88x2bu.ko] undefined!
WARNING: "cfg80211_ready_on_channel" [/source/rtl88x2BU_WiFi_linux_v5.3.1_27678.20180430_COEX20180427-5959/88x2bu.ko] undefined!
WARNING: "cfg80211_ch_switch_notify" [/source/rtl88x2BU_WiFi_linux_v5.3.1_27678.20180430_COEX20180427-5959/88x2bu.ko] undefined!
WARNING: "wiphy_unregister" [/source/rtl88x2BU_WiFi_linux_v5.3.1_27678.20180430_COEX20180427-5959/88x2bu.ko] undefined!
WARNING: "cfg80211_remain_on_channel_expired" [/source/rtl88x2BU_WiFi_linux_v5.3.1_27678.20180430_COEX20180427-5959/88x2bu.ko] undefined!
WARNING: "wiphy_register" [/source/rtl88x2BU_WiFi_linux_v5.3.1_27678.20180430_COEX20180427-5959/88x2bu.ko] undefined!
[INFO] install-dev scripts not found!
Time cost: 00:01:17 [Build-->rtl88x2BU_WiFi_linux_v5.3.1_27678.20180430_COEX20180427-5959]
[INFO] Build rtl88x2BU_WiFi_linux_v5.3.1_27678.20180430_COEX20180427-5959 finished!

----------------- Time cost statistics -----------------
Time cost: 00:01:17 [Build-->rtl88x2BU_WiFi_linux_v5.3.1_27678.20180430_COEX20180427-5959]

1 projects, 0 failed.

root@synology-dev:/toolkit#
```
You can test at this point by copying `/toolkit/build_env/ds.braswell-6.2/source/rtl88x2BU_WiFi_linux_v5.3.1_27678.20180430_COEX20180427-5959/88x2bu.ko` to your NAS and see if you can `insmod` it.
## Preparing to package
First, we'll need to add an `install` file to that same `SynoBuildConf/` directory as before:
```
#!/bin/bash
# Copyright (C) 2000-2017 Synology Inc. All rights reserved.

### Use PKG_DIR as working directory.
PKG_DIR=/tmp/_test_spk
rm -rf $PKG_DIR
mkdir -p $PKG_DIR

### get spk packing functions
source /pkgscripts-ng/include/pkg_util.sh

create_package_tgz() {
	local package_tgz_dir=/tmp/_package_tgz

	### clear destination directory
	rm -rf $package_tgz_dir && mkdir -p $package_tgz_dir

	### install needed file into PKG_DIR
	make install MODDESTDIR="$package_tgz_dir"

	### create package.tgz $1: source_dir $2: dest_dir
	pkg_make_package $package_tgz_dir "${PKG_DIR}"
}

create_spk(){
	local scripts_dir=$PKG_DIR/scripts

	### Copy package center scripts to PKG_DIR
	mkdir -p $scripts_dir
	cp -av scripts/* $scripts_dir

	### Copy package icon
	cp -av PACKAGE_ICON*.PNG $PKG_DIR

	### Generate INFO file
	./INFO.sh > INFO
	cp INFO $PKG_DIR/INFO

	### Create the final spk.
	# pkg_make_spk <source path> <dest path> <spk file name>
	# Please put the result spk into /image/packages
	# spk name functions: pkg_get_spk_name pkg_get_spk_unified_name pkg_get_spk_family_name
	mkdir -p /image/packages
	pkg_make_spk ${PKG_DIR} "/image/packages" $(pkg_get_spk_name)
}

main() {
	create_package_tgz
	create_spk
}

main "$@"
```
Next, we need an `INFO.sh` at the root of our module source:
```
#!/bin/bash
# Copyright (c) 2000-2017 Synology Inc. All rights reserved.

source /pkgscripts-ng/include/pkg_util.sh

package="rtl88x2bu"
version="5.3.1_27678.20180430_COEX20180427-5959"
displayname="rtl88x2bu"
maintainer="@cilynx"
arch="$(pkg_get_platform)"
description="rtl88x2bu wireless driver"
[ "$(caller)" != "0 NULL" ] && return 0
pkg_dump_info
```
Make sure it's executable:
```
root@synology-dev:/toolkit# chmod +x source/rtl88x2BU_WiFi_linux_v5.3.1_27678.20180430_COEX20180427-5959/INFO.sh
root@synology-dev:/toolkit#
```
We should also make some package scripts.  These go inside your module source directory in a new `scripts` directory.  You should make placeholders named `postinst`, `postuninst`, `postupgrade`, `preinst`, `preuninst`, and `preupgrade` that each contain the following:
```
#!/bin/sh
# Copyright (C) 2000-2017 Synology Inc. All rights reserved.

exit 0
```
You also need to make one called `start-stop-status` as follows:
```
#!/bin/sh
# Copyright (C) 2000-2017 Synology Inc. All rights reserved.

case $1 in
	start)
		/sbin/insmod $SYNOPKG_PKGDEST/rtl88x2BU_WiFi_linux_v5.3.1_27678.20180430_COEX20180427-5959/rtl88x2bu.ko
		exit 0
	;;
	stop)
		/sbin/rmmod $SYNOPKG_PKGDEST/rtl88x2BU_WiFi_linux_v5.3.1_27678.20180430_COEX20180427-5959/rtl88x2bu.ko
		exit 0
	;;
	status)
		/sbin/lsmod | grep rtl88x2bu && exit 0 || exit 3
	;;
	killall)
        ;;
	log)
		exit 0
	;;
esac
```
Make sure all the scripts are executable:
```
root@synology-dev:/toolkit# chmod +x source/rtl88x2BU_WiFi_linux_v5.3.1_27678.20180430_COEX20180427-5959/scripts/*
root@synology-dev:/toolkit#
```
Finally, you need a `PACKAGE_ICON.PNG` to keep the install script happy.
```
root@synology-dev:/toolkit# touch source/rtl88x2BU_WiFi_linux_v5.3.1_27678.20180430_COEX20180427-5959/PACKAGE_ICON.PNG
```
## Package the thing
At long last, we can create the `spk`:
```
root@synology-dev:/toolkit# pkgscripts-ng/PkgCreate.py -c rtl88x2BU_WiFi_linux_v5.3.1_27678.20180430_COEX20180427-5959

============================================================
                   Parse argument result                    
------------------------------------------------------------
install      : True
only_install : False
env_version  : None
package      : rtl88x2BU_WiFi_linux_v5.3.1_27678.20180430_COEX20180427-5959
branch       : master
install_opt  :
link         : True
print_log    : False
sdk_ver      : 6.0
sign         : True
dep_level    : 1
platforms    : None
suffix       :
build_opt    :
build        : True
env_section  : default
collect      : True
update       : True

Processing [6.2-23739]: braswell

============================================================
              Start to run "Traverse project"               
------------------------------------------------------------
[INFO] Branch projects: rtl88x2BU_WiFi_linux_v5.3.1_27678.20180430_COEX20180427-5959
[INFO] Tag projects:
[INFO] Reference projects:
[INFO] Reference tag projects:

============================================================
                Start to run "Link Project"                 
------------------------------------------------------------
Link /toolkit/pkgscripts-ng -> /toolkit/build_env/ds.braswell-6.2/pkgscripts-ng
Link /toolkit/source/rtl88x2BU_WiFi_linux_v5.3.1_27678.20180430_COEX20180427-5959 -> /toolkit/build_env/ds.braswell-6.2/source/rtl88x2BU_WiFi_linux_v5.3.1_27678.20180430_COEX20180427-5959

============================================================
                Start to run "Build Package"                
------------------------------------------------------------
[braswell] set -o pipefail; env PackageName=rtl88x2BU_WiFi_linux_v5.3.1_27678.20180430_COEX20180427-5959 /pkgscripts-ng/SynoBuild --braswell -c --min-sdk 6.0 rtl88x2BU_WiFi_linux_v5.3.1_27678.20180430_COEX20180427-5959 2>&1 | tee logs.build

============================================================
               Start to run "Install Package"               
------------------------------------------------------------
[braswell] set -o pipefail; env PackageName=rtl88x2BU_WiFi_linux_v5.3.1_27678.20180430_COEX20180427-5959 /pkgscripts-ng/SynoInstall  --with-debug rtl88x2BU_WiFi_linux_v5.3.1_27678.20180430_COEX20180427-5959 2>&1 | tee logs.install

============================================================
               Start to run "Install Package"               
------------------------------------------------------------
[braswell] set -o pipefail; env PackageName=rtl88x2BU_WiFi_linux_v5.3.1_27678.20180430_COEX20180427-5959 /pkgscripts-ng/SynoInstall  rtl88x2BU_WiFi_linux_v5.3.1_27678.20180430_COEX20180427-5959 2>&1 | tee logs.install

============================================================
             Start to run "Generate code sign"              
------------------------------------------------------------
gpg: checking the trustdb
gpg: 3 marginal(s) needed, 1 complete(s) needed, PGP trust model
gpg: depth: 0  valid:   3  signed:   0  trust: 0-, 0q, 0n, 0m, 0f, 3u
gpg: next trustdb check due at 2021-03-01
[braswell] Sign package:  php /pkgscripts-ng/CodeSign.php --sign=/image/packages/rtl88x2bu-braswell-5.3.1_27678.20180430_COEX20180427-5959_debug.spk
[braswell] Sign package:  php /pkgscripts-ng/CodeSign.php --sign=/image/packages/rtl88x2bu-braswell-5.3.1_27678.20180430_COEX20180427-5959.spk

============================================================
               Start to run "Collect package"               
------------------------------------------------------------
/toolkit/build_env/ds.braswell-6.2/image/packages/rtl88x2bu-braswell-5.3.1_27678.20180430_COEX20180427-5959.spk -> /toolkit/result_spk/rtl88x2bu-5.3.1_27678.20180430_COEX20180427-5959
/toolkit/build_env/ds.braswell-6.2/image/packages/rtl88x2bu-braswell-5.3.1_27678.20180430_COEX20180427-5959_debug.spk -> /toolkit/result_spk/rtl88x2bu-5.3.1_27678.20180430_COEX20180427-5959

============================================================
                    Time Cost Statistic                     
------------------------------------------------------------
00:00:00: Traverse project
00:00:00: Link Project
00:01:12: Build Package
00:00:02: Install Package
00:00:03: Install Package
00:00:04: Generate code sign
00:00:00: Collect package

[SUCCESS] pkgscripts-ng/PkgCreate.py -c rtl88x2BU_WiFi_linux_v5.3.1_27678.20180430_COEX20180427-5959 finished.
root@synology-dev:/toolkit#
```
You'll find your SPKs under `/toolkit/results_spk/`:
```
root@synology-dev:/toolkit# ls result_spk/rtl88x2bu-5.3.1_27678.20180430_COEX20180427-5959/
rtl88x2bu-braswell-5.3.1_27678.20180430_COEX20180427-5959_debug.spk  rtl88x2bu-braswell-5.3.1_27678.20180430_COEX20180427-5959.spk
root@synology-dev:/toolkit#
```
