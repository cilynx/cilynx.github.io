---
layout: post
title:  Wsky 1200Mbps Wireless USB Wifi Adapter
date:   2018-02-22 10:54:08 -0800
tags:   rtl88x2bu rtl8822bu wifi linux raspberry_pi drivers reverse_engineering troubleshooting kernel
---
A few days back, I was looking for some high-speed wifi adaptors to play with.  I came across the [Wsky 1200Mbps Wireless USB Wifi Adapter](http://amzn.to/2GDe4t3) which proclaims its Linux support very loudly all over the item description.  Naturally, I figured that meant it would work.  How naive of me.  There some [encouraging stuff](https://github.com/torvalds/linux/tree/master/drivers/staging/rtlwifi) in the official staging tree, but nothing ready to rock today.  I also noticed that there are [a bunch of related projects](https://github.com/search?q=rtl8822bu+OR+rtl88x2bu) on GitHub, but literally none of them would build under an up-to-date kernel.  I was originally going to pick one and fork, but they were all messier than I like to see so I [made my own](https://github.com/cilynx/rtl88x2bu).  I started with the clean `RTL88x2BU_WiFi_linux_v5.2.4.1_22719_COEX20170518-4444.20170613` source [linked](https://www.dropbox.com/s/hsa09i5txcsrt2u/Wsky-AC1200-Newest%20Driver-LINUX.zip?dl=0 ) in the product description.

Of course, the build failed right off the top:
```
rcw@carbon:~/Projects/rtl88x2bu$ make
make ARCH=x86_64 CROSS_COMPILE= -C /lib/modules/4.14.0-3-amd64/build M=/home/rcw/Projects/rtl88x2bu  modules
make[1]: Entering directory '/usr/src/linux-headers-4.14.0-3-amd64'
  CC [M]  /home/rcw/Projects/rtl88x2bu/core/rtw_cmd.o
In file included from /home/rcw/Projects/rtl88x2bu/include/drv_types.h:27:0,
                 from /home/rcw/Projects/rtl88x2bu/core/rtw_cmd.c:17:
/home/rcw/Projects/rtl88x2bu/include/osdep_service.h: In function ‘thread_enter’:
/home/rcw/Projects/rtl88x2bu/include/osdep_service.h:355:2: error: implicit declaration of function ‘allow_signal’; did you mean ‘do_signal’? [-Werror=implicit-function-declaration]
  allow_signal(SIGTERM);
  ^~~~~~~~~~~~
  do_signal
/home/rcw/Projects/rtl88x2bu/include/osdep_service.h: In function ‘flush_signals_thread’:
/home/rcw/Projects/rtl88x2bu/include/osdep_service.h:392:6: error: implicit declaration of function ‘signal_pending’; did you mean ‘timer_pending’? [-Werror=implicit-function-declaration]
  if (signal_pending(current))
      ^~~~~~~~~~~~~~
      timer_pending
/home/rcw/Projects/rtl88x2bu/include/osdep_service.h:393:3: error: implicit declaration of function ‘flush_signals’; did you mean ‘do_signal’? [-Werror=implicit-function-declaration]
   flush_signals(current);
   ^~~~~~~~~~~~~
   do_signal
cc1: some warnings being treated as errors
make[4]: *** [/usr/src/linux-headers-4.14.0-3-common/scripts/Makefile.build:326: /home/rcw/Projects/rtl88x2bu/core/rtw_cmd.o] Error 1
make[3]: *** [/usr/src/linux-headers-4.14.0-3-common/Makefile:1525: _module_/home/rcw/Projects/rtl88x2bu] Error 2
make[2]: *** [Makefile:146: sub-make] Error 2
make[1]: *** [Makefile:8: all] Error 2
make[1]: Leaving directory '/usr/src/linux-headers-4.14.0-3-amd64'
make: *** [Makefile:1794: modules] Error 2
rcw@carbon:~/Projects/rtl88x2bu$
```
Googling [`implicit declaration of function ‘allow_signal’`](https://www.google.com/search?q=implicit+declaration+of+function+%E2%80%98allow_signal%E2%80%99) turns up this [GitHub thread](https://github.com/diederikdehaas/rtl8812AU/issues/75) and this [forum thread](https://forum.manjaro.org/t/error-with-rtl8812au/24066/2).  Doing some digging through the kernel source, we find several related changes for 4.11:
* `<linux/signal.h>`, which defines `allow_signal()` was [removed](https://github.com/torvalds/linux/commit/1827adb11ad26b2290dc9fe2aaf54976b2439865) from `<linux/sched.h>`
* `signal_pending()` was [moved](https://github.com/torvalds/linux/commit/2a1f062a4acf0be50516ceece92a7182a173d55a) from `<linux/sched.h>` to `<linux/sched/signal.h>`
* `flush_signals()` was [moved](https://github.com/torvalds/linux/commit/c3edc4010e9d102eb7b8f17d15c2ebc425fed63c) from `<linux/sched.h>` to `<linux/sched/signal.h>`

Conveniently, `<linux/sched/signal.h>` does `#include` `<linux/signal.h>`, so we just need to `#include` `<linux/sched/signal.h>` for `KERNEL_VERSION >= 4.11.0`.  Technically, you could replace `<linux/sched.h>` with `<linux/sched/signal.h>` since that'll include `<linux/sched.h>` anyway, but it's more lines of code to do it that way and the compiler/linker will take care of not actually including `<linux/sched.h>` twice.

Alrighty, having [made that change](https://github.com/cilynx/rtl88x2bu/commit/c4a29326b7865e995965ec36e4c3ac915fc44348), we now make it a good bit further through the build:
```
rcw@carbon:~/Projects/rtl88x2bu$ make
make ARCH=x86_64 CROSS_COMPILE= -C /lib/modules/4.14.0-3-amd64/build M=/home/rcw/Projects/rtl88x2bu  modules
make[1]: Entering directory '/usr/src/linux-headers-4.14.0-3-amd64'
  CC [M]  /home/rcw/Projects/rtl88x2bu/core/rtw_cmd.o
  CC [M]  /home/rcw/Projects/rtl88x2bu/core/rtw_security.o
  CC [M]  /home/rcw/Projects/rtl88x2bu/core/rtw_debug.o
  CC [M]  /home/rcw/Projects/rtl88x2bu/core/rtw_io.o
  CC [M]  /home/rcw/Projects/rtl88x2bu/core/rtw_ioctl_query.o
  CC [M]  /home/rcw/Projects/rtl88x2bu/core/rtw_ioctl_set.o
  CC [M]  /home/rcw/Projects/rtl88x2bu/core/rtw_ieee80211.o
  CC [M]  /home/rcw/Projects/rtl88x2bu/core/rtw_mlme.o
  CC [M]  /home/rcw/Projects/rtl88x2bu/core/rtw_mlme_ext.o
  CC [M]  /home/rcw/Projects/rtl88x2bu/core/rtw_mi.o
  CC [M]  /home/rcw/Projects/rtl88x2bu/core/rtw_wlan_util.o
  CC [M]  /home/rcw/Projects/rtl88x2bu/core/rtw_vht.o
  CC [M]  /home/rcw/Projects/rtl88x2bu/core/rtw_pwrctrl.o
  CC [M]  /home/rcw/Projects/rtl88x2bu/core/rtw_rf.o
  CC [M]  /home/rcw/Projects/rtl88x2bu/core/rtw_recv.o
  CC [M]  /home/rcw/Projects/rtl88x2bu/core/rtw_sta_mgt.o
  CC [M]  /home/rcw/Projects/rtl88x2bu/core/rtw_ap.o
  CC [M]  /home/rcw/Projects/rtl88x2bu/core/rtw_xmit.o
  CC [M]  /home/rcw/Projects/rtl88x2bu/core/rtw_p2p.o
  CC [M]  /home/rcw/Projects/rtl88x2bu/core/rtw_tdls.o
  CC [M]  /home/rcw/Projects/rtl88x2bu/core/rtw_br_ext.o
  CC [M]  /home/rcw/Projects/rtl88x2bu/core/rtw_iol.o
  CC [M]  /home/rcw/Projects/rtl88x2bu/core/rtw_sreset.o
  CC [M]  /home/rcw/Projects/rtl88x2bu/core/rtw_btcoex_wifionly.o
  CC [M]  /home/rcw/Projects/rtl88x2bu/core/rtw_btcoex.o
  CC [M]  /home/rcw/Projects/rtl88x2bu/core/rtw_beamforming.o
  CC [M]  /home/rcw/Projects/rtl88x2bu/core/rtw_odm.o
  CC [M]  /home/rcw/Projects/rtl88x2bu/core/efuse/rtw_efuse.o
  CC [M]  /home/rcw/Projects/rtl88x2bu/os_dep/osdep_service.o
  CC [M]  /home/rcw/Projects/rtl88x2bu/os_dep/linux/os_intfs.o
  CC [M]  /home/rcw/Projects/rtl88x2bu/os_dep/linux/usb_intf.o
  CC [M]  /home/rcw/Projects/rtl88x2bu/os_dep/linux/usb_ops_linux.o
  CC [M]  /home/rcw/Projects/rtl88x2bu/os_dep/linux/ioctl_linux.o
  CC [M]  /home/rcw/Projects/rtl88x2bu/os_dep/linux/xmit_linux.o
  CC [M]  /home/rcw/Projects/rtl88x2bu/os_dep/linux/mlme_linux.o
  CC [M]  /home/rcw/Projects/rtl88x2bu/os_dep/linux/recv_linux.o
  CC [M]  /home/rcw/Projects/rtl88x2bu/os_dep/linux/ioctl_cfg80211.o
/home/rcw/Projects/rtl88x2bu/os_dep/linux/ioctl_cfg80211.c: In function ‘rtw_cfg80211_indicate_connect’:
/home/rcw/Projects/rtl88x2bu/os_dep/linux/ioctl_cfg80211.c:736:6: error: passing argument 2 of ‘cfg80211_roamed’ from incompatible pointer type [-Werror=incompatible-pointer-types]
    , notify_channel
      ^~~~~~~~~~~~~~
In file included from /home/rcw/Projects/rtl88x2bu/include/osdep_service_linux.h:91:0,
                 from /home/rcw/Projects/rtl88x2bu/include/osdep_service.h:42,
                 from /home/rcw/Projects/rtl88x2bu/include/drv_types.h:27,
                 from /home/rcw/Projects/rtl88x2bu/os_dep/linux/ioctl_cfg80211.c:17:
/usr/src/linux-headers-4.14.0-3-common/include/net/cfg80211.h:5477:6: note: expected ‘struct cfg80211_roam_info *’ but argument is of type ‘struct ieee80211_channel *’
 void cfg80211_roamed(struct net_device *dev, struct cfg80211_roam_info *info,
      ^~~~~~~~~~~~~~~
/home/rcw/Projects/rtl88x2bu/os_dep/linux/ioctl_cfg80211.c:738:6: warning: passing argument 3 of ‘cfg80211_roamed’ makes integer from pointer without a cast [-Wint-conversion]
    , cur_network->network.MacAddress
      ^~~~~~~~~~~
In file included from /home/rcw/Projects/rtl88x2bu/include/osdep_service_linux.h:91:0,
                 from /home/rcw/Projects/rtl88x2bu/include/osdep_service.h:42,
                 from /home/rcw/Projects/rtl88x2bu/include/drv_types.h:27,
                 from /home/rcw/Projects/rtl88x2bu/os_dep/linux/ioctl_cfg80211.c:17:
/usr/src/linux-headers-4.14.0-3-common/include/net/cfg80211.h:5477:6: note: expected ‘gfp_t {aka unsigned int}’ but argument is of type ‘unsigned char *’
 void cfg80211_roamed(struct net_device *dev, struct cfg80211_roam_info *info,
      ^~~~~~~~~~~~~~~
/home/rcw/Projects/rtl88x2bu/os_dep/linux/ioctl_cfg80211.c:734:3: error: too many arguments to function ‘cfg80211_roamed’
   cfg80211_roamed(padapter->pnetdev
   ^~~~~~~~~~~~~~~
In file included from /home/rcw/Projects/rtl88x2bu/include/osdep_service_linux.h:91:0,
                 from /home/rcw/Projects/rtl88x2bu/include/osdep_service.h:42,
                 from /home/rcw/Projects/rtl88x2bu/include/drv_types.h:27,
                 from /home/rcw/Projects/rtl88x2bu/os_dep/linux/ioctl_cfg80211.c:17:
/usr/src/linux-headers-4.14.0-3-common/include/net/cfg80211.h:5477:6: note: declared here
 void cfg80211_roamed(struct net_device *dev, struct cfg80211_roam_info *info,
      ^~~~~~~~~~~~~~~
/home/rcw/Projects/rtl88x2bu/os_dep/linux/ioctl_cfg80211.c: In function ‘rtw_cfg80211_add_monitor_if’:
/home/rcw/Projects/rtl88x2bu/os_dep/linux/ioctl_cfg80211.c:3811:12: error: ‘struct net_device’ has no member named ‘destructor’; did you mean ‘priv_destructor’?
  mon_ndev->destructor = rtw_ndev_destructor;
            ^~~~~~~~~~
            priv_destructor
/home/rcw/Projects/rtl88x2bu/os_dep/linux/ioctl_cfg80211.c: In function ‘rtw_cfg80211_preinit_wiphy’:
/home/rcw/Projects/rtl88x2bu/os_dep/linux/ioctl_cfg80211.c:6773:18: error: ‘WIPHY_FLAG_SUPPORTS_SCHED_SCAN’ undeclared (first use in this function); did you mean ‘WIPHY_FLAG_SUPPORTS_TDLS’?
  wiphy->flags |= WIPHY_FLAG_SUPPORTS_SCHED_SCAN;
                  ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                  WIPHY_FLAG_SUPPORTS_TDLS
/home/rcw/Projects/rtl88x2bu/os_dep/linux/ioctl_cfg80211.c:6773:18: note: each undeclared identifier is reported only once for each function it appears in
/home/rcw/Projects/rtl88x2bu/os_dep/linux/ioctl_cfg80211.c: At top level:
/home/rcw/Projects/rtl88x2bu/os_dep/linux/ioctl_cfg80211.c:6806:25: error: initialization from incompatible pointer type [-Werror=incompatible-pointer-types]
  .change_virtual_intf = cfg80211_rtw_change_iface,
                         ^~~~~~~~~~~~~~~~~~~~~~~~~
/home/rcw/Projects/rtl88x2bu/os_dep/linux/ioctl_cfg80211.c:6806:25: note: (near initialization for ‘rtw_cfg80211_ops.change_virtual_intf’)
/home/rcw/Projects/rtl88x2bu/os_dep/linux/ioctl_cfg80211.c:6829:22: error: initialization from incompatible pointer type [-Werror=incompatible-pointer-types]
  .add_virtual_intf = cfg80211_rtw_add_virtual_intf,
                      ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
/home/rcw/Projects/rtl88x2bu/os_dep/linux/ioctl_cfg80211.c:6829:22: note: (near initialization for ‘rtw_cfg80211_ops.add_virtual_intf’)
cc1: some warnings being treated as errors
make[4]: *** [/usr/src/linux-headers-4.14.0-3-common/scripts/Makefile.build:326: /home/rcw/Projects/rtl88x2bu/os_dep/linux/ioctl_cfg80211.o] Error 1
make[3]: *** [/usr/src/linux-headers-4.14.0-3-common/Makefile:1525: _module_/home/rcw/Projects/rtl88x2bu] Error 2
make[2]: *** [Makefile:146: sub-make] Error 2
make[1]: *** [Makefile:8: all] Error 2
make[1]: Leaving directory '/usr/src/linux-headers-4.14.0-3-amd64'
make: *** [Makefile:1794: modules] Error 2
rcw@carbon:~/Projects/rtl88x2bu$ 
```
Googling [`‘struct net_device’ has no member named ‘destructor’`](https://www.google.com/search?q=‘struct+net_device’+has+no+member+named+‘destructor’) brings you to this [GitHub thread](https://github.com/gnab/rtl8812au/issues/113) which references this [pull request](https://github.com/Grawp/rtl8812au_rtl8821au/pull/46).  Looking at the kernel source, we find:
* `netdev->destructor()` was [refactored](https://github.com/torvalds/linux/commit/cf124db566e6b036b8bcbe8decbed740bdfac8c6) for [4.11.9](https://www.systutorials.com/linux-kernels/57797/net-fix-inconsistent-teardown-and-release-of-private-netdev-state-linux-4-11-9/)

This is another [straightforward fix](https://github.com/cilynx/rtl88x2bu/commit/2f227787f1aa90db7084e86a31356d99a0f277a7) if you look over the in-tree drivers updated in the same commit as the rest of the refactor.

Googling [`passing argument 2 of ‘cfg80211_roamed’ from incompatible pointer type`](https://www.google.com/search?q=passing+argument+2+of+%E2%80%98cfg80211_roamed%E2%80%99+from+incompatible+pointer+type) turns up a useful [GitHub thread](https://github.com/Mange/rtl8192eu-linux-driver/issues/45) which points us to an even more useful [commit to the rtl8192eu driver](https://github.com/masterzorag/RTL8192EU-linux/pull/4/files).  Going back to the kernel source, we again find some very relevant changes:
* `cfg80211_roamed()` was [refactored](https://github.com/torvalds/linux/commit/29ce6ecbb83c9185d76e3a7c340c9702d2a54961) for 4.12.  

[This fix](https://github.com/cilynx/rtl88x2bu/commit/9deeb789c5833cb04f9f5e893f42a6ea88a3c2e6) is a little more involved and we'll take our cues from rtl8192eu.  If you want to understand why the changes are necessary, study the refactor linked above, particularly the drivers at the top and `net/wireless/sme.c` where the declarations live.

Googling [`‘WIPHY_FLAG_SUPPORTS_SCHED_SCAN’ undeclared`] gives us a bunch of hits related to this driver, but nothing that gives a good reason why the fix is what it is.  Looking in the kernel source, we find:
* `WIPHY_FLAG_SUPPORTS_SCHED_SCAN` was [deprecated](https://github.com/torvalds/linux/commit/ca986ad9bcd3893c8b0b4cc2cafcc8cf1554409c) in 4.12.

Looking throught the in-kernel drivers that were updated along with the deprecation, [the fix](https://github.com/cilynx/rtl88x2bu/commit/dfd0cde12cee25e3f35e03157afb65e3c6a6bfef) for this one is to set `wiphy->max_sched_scan_reqs = 1` instead of `wiphy->flags |= WIPHY_FLAG_SUPPORTS_SCHED_SCAN`.

Googling `cfg80211_rtw_change_iface` went down a pretty serious rabbit hole full of solutions but no explanations.  After a while, I found in the kernel source:
* Interface monitor flags were [moved](https://github.com/torvalds/linux/commit/818a986e4ebacea2020622e48c8bc04b7f500d89) to params in 4.12.

[The fix](https://github.com/cilynx/rtl88x2bu/commit/f9a6739ba7eb029899dd65a132f3a4037fda2e86) is simply to get rid of `u32 *flags` in `cfg80211_rtw_change_iface` and `cfg80211_rtw_add_virtual_intf`.

After all that, the module builds, albeit with some nasty warnings:
```
rcw@carbon:~/Projects/rtl88x2bu$ make
make ARCH=x86_64 CROSS_COMPILE= -C /lib/modules/4.14.0-3-amd64/build M=/home/rcw/Projects/rtl88x2bu  modules
make[1]: Entering directory '/usr/src/linux-headers-4.14.0-3-amd64'
  CC [M]  /home/rcw/Projects/rtl88x2bu/core/rtw_cmd.o
  CC [M]  /home/rcw/Projects/rtl88x2bu/core/rtw_security.o
  CC [M]  /home/rcw/Projects/rtl88x2bu/core/rtw_debug.o
  CC [M]  /home/rcw/Projects/rtl88x2bu/core/rtw_io.o
  CC [M]  /home/rcw/Projects/rtl88x2bu/core/rtw_ioctl_query.o
  CC [M]  /home/rcw/Projects/rtl88x2bu/core/rtw_ioctl_set.o
  CC [M]  /home/rcw/Projects/rtl88x2bu/core/rtw_ieee80211.o
  CC [M]  /home/rcw/Projects/rtl88x2bu/core/rtw_mlme.o
  CC [M]  /home/rcw/Projects/rtl88x2bu/core/rtw_mlme_ext.o
  CC [M]  /home/rcw/Projects/rtl88x2bu/core/rtw_mi.o
  CC [M]  /home/rcw/Projects/rtl88x2bu/core/rtw_wlan_util.o
  CC [M]  /home/rcw/Projects/rtl88x2bu/core/rtw_vht.o
  CC [M]  /home/rcw/Projects/rtl88x2bu/core/rtw_pwrctrl.o
  CC [M]  /home/rcw/Projects/rtl88x2bu/core/rtw_rf.o
  CC [M]  /home/rcw/Projects/rtl88x2bu/core/rtw_recv.o
  CC [M]  /home/rcw/Projects/rtl88x2bu/core/rtw_sta_mgt.o
  CC [M]  /home/rcw/Projects/rtl88x2bu/core/rtw_ap.o
  CC [M]  /home/rcw/Projects/rtl88x2bu/core/rtw_xmit.o
  CC [M]  /home/rcw/Projects/rtl88x2bu/core/rtw_p2p.o
  CC [M]  /home/rcw/Projects/rtl88x2bu/core/rtw_tdls.o
  CC [M]  /home/rcw/Projects/rtl88x2bu/core/rtw_br_ext.o
  CC [M]  /home/rcw/Projects/rtl88x2bu/core/rtw_iol.o
  CC [M]  /home/rcw/Projects/rtl88x2bu/core/rtw_sreset.o
  CC [M]  /home/rcw/Projects/rtl88x2bu/core/rtw_btcoex_wifionly.o
  CC [M]  /home/rcw/Projects/rtl88x2bu/core/rtw_btcoex.o
  CC [M]  /home/rcw/Projects/rtl88x2bu/core/rtw_beamforming.o
  CC [M]  /home/rcw/Projects/rtl88x2bu/core/rtw_odm.o
  CC [M]  /home/rcw/Projects/rtl88x2bu/core/efuse/rtw_efuse.o
  CC [M]  /home/rcw/Projects/rtl88x2bu/os_dep/osdep_service.o
  CC [M]  /home/rcw/Projects/rtl88x2bu/os_dep/linux/os_intfs.o
  CC [M]  /home/rcw/Projects/rtl88x2bu/os_dep/linux/usb_intf.o
  CC [M]  /home/rcw/Projects/rtl88x2bu/os_dep/linux/usb_ops_linux.o
  CC [M]  /home/rcw/Projects/rtl88x2bu/os_dep/linux/ioctl_linux.o
  CC [M]  /home/rcw/Projects/rtl88x2bu/os_dep/linux/xmit_linux.o
  CC [M]  /home/rcw/Projects/rtl88x2bu/os_dep/linux/mlme_linux.o
  CC [M]  /home/rcw/Projects/rtl88x2bu/os_dep/linux/recv_linux.o
  CC [M]  /home/rcw/Projects/rtl88x2bu/os_dep/linux/ioctl_cfg80211.o
  CC [M]  /home/rcw/Projects/rtl88x2bu/os_dep/linux/rtw_cfgvendor.o
  CC [M]  /home/rcw/Projects/rtl88x2bu/os_dep/linux/wifi_regd.o
  CC [M]  /home/rcw/Projects/rtl88x2bu/os_dep/linux/rtw_android.o
  CC [M]  /home/rcw/Projects/rtl88x2bu/os_dep/linux/rtw_proc.o
  CC [M]  /home/rcw/Projects/rtl88x2bu/os_dep/linux/ioctl_mp.o
  CC [M]  /home/rcw/Projects/rtl88x2bu/hal/hal_intf.o
  CC [M]  /home/rcw/Projects/rtl88x2bu/hal/hal_com.o
  CC [M]  /home/rcw/Projects/rtl88x2bu/hal/hal_com_phycfg.o
  CC [M]  /home/rcw/Projects/rtl88x2bu/hal/hal_phy.o
  CC [M]  /home/rcw/Projects/rtl88x2bu/hal/hal_dm.o
  CC [M]  /home/rcw/Projects/rtl88x2bu/hal/hal_btcoex_wifionly.o
  CC [M]  /home/rcw/Projects/rtl88x2bu/hal/hal_btcoex.o
  CC [M]  /home/rcw/Projects/rtl88x2bu/hal/hal_mp.o
  CC [M]  /home/rcw/Projects/rtl88x2bu/hal/hal_mcc.o
  CC [M]  /home/rcw/Projects/rtl88x2bu/hal/hal_hci/hal_usb.o
  CC [M]  /home/rcw/Projects/rtl88x2bu/hal/led/hal_usb_led.o
  CC [M]  /home/rcw/Projects/rtl88x2bu/hal/hal_halmac.o
  CC [M]  /home/rcw/Projects/rtl88x2bu/hal/rtl8822b/rtl8822b_halinit.o
  CC [M]  /home/rcw/Projects/rtl88x2bu/hal/rtl8822b/rtl8822b_mac.o
  CC [M]  /home/rcw/Projects/rtl88x2bu/hal/rtl8822b/rtl8822b_cmd.o
  CC [M]  /home/rcw/Projects/rtl88x2bu/hal/rtl8822b/rtl8822b_phy.o
  CC [M]  /home/rcw/Projects/rtl88x2bu/hal/rtl8822b/rtl8822b_ops.o
  CC [M]  /home/rcw/Projects/rtl88x2bu/hal/rtl8822b/hal8822b_fw.o
  CC [M]  /home/rcw/Projects/rtl88x2bu/hal/rtl8822b/usb/rtl8822bu_halinit.o
  CC [M]  /home/rcw/Projects/rtl88x2bu/hal/rtl8822b/usb/rtl8822bu_halmac.o
  CC [M]  /home/rcw/Projects/rtl88x2bu/hal/rtl8822b/usb/rtl8822bu_io.o
  CC [M]  /home/rcw/Projects/rtl88x2bu/hal/rtl8822b/usb/rtl8822bu_xmit.o
  CC [M]  /home/rcw/Projects/rtl88x2bu/hal/rtl8822b/usb/rtl8822bu_recv.o
  CC [M]  /home/rcw/Projects/rtl88x2bu/hal/rtl8822b/usb/rtl8822bu_led.o
  CC [M]  /home/rcw/Projects/rtl88x2bu/hal/rtl8822b/usb/rtl8822bu_ops.o
  CC [M]  /home/rcw/Projects/rtl88x2bu/hal/efuse/rtl8822b/HalEfuseMask8822B_USB.o
  CC [M]  /home/rcw/Projects/rtl88x2bu/hal/halmac/halmac_api.o
  CC [M]  /home/rcw/Projects/rtl88x2bu/hal/halmac/halmac_88xx/halmac_api_88xx.o
  CC [M]  /home/rcw/Projects/rtl88x2bu/hal/halmac/halmac_88xx/halmac_api_88xx_usb.o
  CC [M]  /home/rcw/Projects/rtl88x2bu/hal/halmac/halmac_88xx/halmac_api_88xx_sdio.o
  CC [M]  /home/rcw/Projects/rtl88x2bu/hal/halmac/halmac_88xx/halmac_api_88xx_pcie.o
  CC [M]  /home/rcw/Projects/rtl88x2bu/hal/halmac/halmac_88xx/halmac_func_88xx.o
  CC [M]  /home/rcw/Projects/rtl88x2bu/hal/halmac/halmac_88xx/halmac_gpio_88xx.o
  CC [M]  /home/rcw/Projects/rtl88x2bu/hal/halmac/halmac_88xx/halmac_8822b/halmac_8822b_phy.o
  CC [M]  /home/rcw/Projects/rtl88x2bu/hal/halmac/halmac_88xx/halmac_8822b/halmac_8822b_pwr_seq.o
  CC [M]  /home/rcw/Projects/rtl88x2bu/hal/halmac/halmac_88xx/halmac_8822b/halmac_api_8822b.o
  CC [M]  /home/rcw/Projects/rtl88x2bu/hal/halmac/halmac_88xx/halmac_8822b/halmac_api_8822b_pcie.o
  CC [M]  /home/rcw/Projects/rtl88x2bu/hal/halmac/halmac_88xx/halmac_8822b/halmac_api_8822b_sdio.o
  CC [M]  /home/rcw/Projects/rtl88x2bu/hal/halmac/halmac_88xx/halmac_8822b/halmac_api_8822b_usb.o
  CC [M]  /home/rcw/Projects/rtl88x2bu/hal/halmac/halmac_88xx/halmac_8822b/halmac_func_8822b.o
  CC [M]  /home/rcw/Projects/rtl88x2bu/hal/halmac/halmac_88xx/halmac_8822b/halmac_gpio_8822b.o
  CC [M]  /home/rcw/Projects/rtl88x2bu/hal/phydm/phydm_debug.o
  CC [M]  /home/rcw/Projects/rtl88x2bu/hal/phydm/phydm_antdiv.o
  CC [M]  /home/rcw/Projects/rtl88x2bu/hal/phydm/phydm_antdect.o
  CC [M]  /home/rcw/Projects/rtl88x2bu/hal/phydm/phydm_interface.o
  CC [M]  /home/rcw/Projects/rtl88x2bu/hal/phydm/phydm_hwconfig.o
  CC [M]  /home/rcw/Projects/rtl88x2bu/hal/phydm/phydm.o
/home/rcw/Projects/rtl88x2bu/hal/phydm/phydm.c: In function ‘phydm_init_soft_ml_setting’:
/home/rcw/Projects/rtl88x2bu/hal/phydm/phydm.c:567:3: warning: this ‘if’ clause does not guard... [-Wmisleading-indentation]
   if (p_dm_odm->support_ic_type & ODM_RTL8822B)
   ^~
/home/rcw/Projects/rtl88x2bu/hal/phydm/phydm.c:570:4: note: ...this statement, but the latter is misleadingly indented as if it were guarded by the ‘if’
    p_dm_odm->bsomlenabled = true;
    ^~~~~~~~
  CC [M]  /home/rcw/Projects/rtl88x2bu/hal/phydm/phydm_dig.o
  CC [M]  /home/rcw/Projects/rtl88x2bu/hal/phydm/phydm_pathdiv.o
  CC [M]  /home/rcw/Projects/rtl88x2bu/hal/phydm/phydm_rainfo.o
  CC [M]  /home/rcw/Projects/rtl88x2bu/hal/phydm/phydm_dynamicbbpowersaving.o
  CC [M]  /home/rcw/Projects/rtl88x2bu/hal/phydm/phydm_dynamictxpower.o
  CC [M]  /home/rcw/Projects/rtl88x2bu/hal/phydm/phydm_adaptivity.o
  CC [M]  /home/rcw/Projects/rtl88x2bu/hal/phydm/phydm_cfotracking.o
  CC [M]  /home/rcw/Projects/rtl88x2bu/hal/phydm/phydm_noisemonitor.o
  CC [M]  /home/rcw/Projects/rtl88x2bu/hal/phydm/phydm_acs.o
  CC [M]  /home/rcw/Projects/rtl88x2bu/hal/phydm/phydm_beamforming.o
  CC [M]  /home/rcw/Projects/rtl88x2bu/hal/phydm/phydm_dfs.o
  CC [M]  /home/rcw/Projects/rtl88x2bu/hal/phydm/txbf/halcomtxbf.o
  CC [M]  /home/rcw/Projects/rtl88x2bu/hal/phydm/txbf/haltxbfinterface.o
  CC [M]  /home/rcw/Projects/rtl88x2bu/hal/phydm/txbf/phydm_hal_txbf_api.o
  CC [M]  /home/rcw/Projects/rtl88x2bu/hal/phydm/phydm_adc_sampling.o
/home/rcw/Projects/rtl88x2bu/hal/phydm/phydm_adc_sampling.c: In function ‘phydm_la_buffer_allocate’:
/home/rcw/Projects/rtl88x2bu/hal/phydm/phydm_adc_sampling.c:62:5: warning: this ‘else’ clause does not guard... [-Wmisleading-indentation]
   } else
     ^~~~
/home/rcw/Projects/rtl88x2bu/hal/phydm/phydm_adc_sampling.c:64:4: note: ...this statement, but the latter is misleadingly indented as if it were guarded by the ‘else’
    ret = true;
    ^~~
  CC [M]  /home/rcw/Projects/rtl88x2bu/hal/phydm/phydm_ccx.o
  CC [M]  /home/rcw/Projects/rtl88x2bu/hal/phydm/phydm_psd.o
  CC [M]  /home/rcw/Projects/rtl88x2bu/hal/phydm/halrf/halrf.o
  CC [M]  /home/rcw/Projects/rtl88x2bu/hal/phydm/halrf/halphyrf_ce.o
  CC [M]  /home/rcw/Projects/rtl88x2bu/hal/phydm/halrf/halrf_powertracking_ce.o
  CC [M]  /home/rcw/Projects/rtl88x2bu/hal/phydm/halrf/halrf_kfree.o
  CC [M]  /home/rcw/Projects/rtl88x2bu/hal/phydm/rtl8822b/halhwimg8822b_bb.o
  CC [M]  /home/rcw/Projects/rtl88x2bu/hal/phydm/rtl8822b/halhwimg8822b_mac.o
  CC [M]  /home/rcw/Projects/rtl88x2bu/hal/phydm/rtl8822b/halhwimg8822b_rf.o
  CC [M]  /home/rcw/Projects/rtl88x2bu/hal/phydm/halrf/rtl8822b/halrf_8822b.o
  CC [M]  /home/rcw/Projects/rtl88x2bu/hal/phydm/rtl8822b/phydm_hal_api8822b.o
  CC [M]  /home/rcw/Projects/rtl88x2bu/hal/phydm/halrf/rtl8822b/halrf_iqk_8822b.o
/home/rcw/Projects/rtl88x2bu/hal/phydm/halrf/rtl8822b/halrf_iqk_8822b.c: In function ‘_iqk_reload_iqk_setting_8822b’:
/home/rcw/Projects/rtl88x2bu/hal/phydm/halrf/rtl8822b/halrf_iqk_8822b.c:425:55: warning: ‘~’ on a boolean expression [-Wbool-operation]
     odm_set_bb_reg(p_dm_odm, iqk_apply[path], BIT(0), ~(p_iqk_info->IQK_fail_report[channel][path][idx]));
                                                       ^
/home/rcw/Projects/rtl88x2bu/hal/phydm/halrf/rtl8822b/halrf_iqk_8822b.c:425:55: note: did you mean to use logical not?
     odm_set_bb_reg(p_dm_odm, iqk_apply[path], BIT(0), ~(p_iqk_info->IQK_fail_report[channel][path][idx]));
                                                       ^
                                                       !
/home/rcw/Projects/rtl88x2bu/hal/phydm/halrf/rtl8822b/halrf_iqk_8822b.c:427:56: warning: ‘~’ on a boolean expression [-Wbool-operation]
     odm_set_bb_reg(p_dm_odm, iqk_apply[path], BIT(10), ~(p_iqk_info->IQK_fail_report[channel][path][idx]));
                                                        ^
/home/rcw/Projects/rtl88x2bu/hal/phydm/halrf/rtl8822b/halrf_iqk_8822b.c:427:56: note: did you mean to use logical not?
     odm_set_bb_reg(p_dm_odm, iqk_apply[path], BIT(10), ~(p_iqk_info->IQK_fail_report[channel][path][idx]));
                                                        ^
                                                        !
  CC [M]  /home/rcw/Projects/rtl88x2bu/hal/phydm/rtl8822b/phydm_regconfig8822b.o
  CC [M]  /home/rcw/Projects/rtl88x2bu/hal/phydm/rtl8822b/phydm_rtl8822b.o
  CC [M]  /home/rcw/Projects/rtl88x2bu/hal/phydm/txbf/haltxbf8822b.o
  CC [M]  /home/rcw/Projects/rtl88x2bu/hal/btc/halbtc8723bwifionly.o
  CC [M]  /home/rcw/Projects/rtl88x2bu/hal/btc/halbtc8822bwifionly.o
  CC [M]  /home/rcw/Projects/rtl88x2bu/hal/btc/halbtc8821cwifionly.o
  CC [M]  /home/rcw/Projects/rtl88x2bu/hal/btc/halbtc8192e1ant.o
  CC [M]  /home/rcw/Projects/rtl88x2bu/hal/btc/halbtc8192e2ant.o
  CC [M]  /home/rcw/Projects/rtl88x2bu/hal/btc/halbtc8723b1ant.o
  CC [M]  /home/rcw/Projects/rtl88x2bu/hal/btc/halbtc8723b2ant.o
  CC [M]  /home/rcw/Projects/rtl88x2bu/hal/btc/halbtc8812a1ant.o
  CC [M]  /home/rcw/Projects/rtl88x2bu/hal/btc/halbtc8812a2ant.o
  CC [M]  /home/rcw/Projects/rtl88x2bu/hal/btc/halbtc8821a1ant.o
  CC [M]  /home/rcw/Projects/rtl88x2bu/hal/btc/halbtc8821a2ant.o
  CC [M]  /home/rcw/Projects/rtl88x2bu/hal/btc/halbtc8703b1ant.o
  CC [M]  /home/rcw/Projects/rtl88x2bu/hal/btc/halbtc8723d1ant.o
  CC [M]  /home/rcw/Projects/rtl88x2bu/hal/btc/halbtc8723d2ant.o
  CC [M]  /home/rcw/Projects/rtl88x2bu/hal/btc/halbtc8822b1ant.o
/home/rcw/Projects/rtl88x2bu/hal/btc/halbtc8822b1ant.c: In function ‘halbtc8822b1ant_set_ext_ant_switch’:
/home/rcw/Projects/rtl88x2bu/hal/btc/halbtc8822b1ant.c:2437:7: warning: ‘~’ on a boolean expression [-Wbool-operation]
       ~switch_polatiry_inverse : switch_polatiry_inverse);
       ^
/home/rcw/Projects/rtl88x2bu/hal/btc/halbtc8822b1ant.c:2437:7: note: did you mean to use logical not?
       ~switch_polatiry_inverse : switch_polatiry_inverse);
       ^
       !
  CC [M]  /home/rcw/Projects/rtl88x2bu/hal/btc/halbtc8822b2ant.o
  CC [M]  /home/rcw/Projects/rtl88x2bu/hal/btc/halbtc8821c1ant.o
  CC [M]  /home/rcw/Projects/rtl88x2bu/hal/btc/halbtc8821c2ant.o
  CC [M]  /home/rcw/Projects/rtl88x2bu/platform/platform_ops.o
  CC [M]  /home/rcw/Projects/rtl88x2bu/core/rtw_mp.o
  LD [M]  /home/rcw/Projects/rtl88x2bu/88x2bu.o
  Building modules, stage 2.
  MODPOST 1 modules
WARNING: "__vfs_read" [/home/rcw/Projects/rtl88x2bu/88x2bu.ko] undefined!
  CC      /home/rcw/Projects/rtl88x2bu/88x2bu.mod.o
  LD [M]  /home/rcw/Projects/rtl88x2bu/88x2bu.ko
make[1]: Leaving directory '/usr/src/linux-headers-4.14.0-3-amd64'
rcw@carbon:~/Projects/rtl88x2bu$ 
```
`__vfs_read` being undefined is going to be a major problem.  `vfs_read` was [deprecated](https://github.com/torvalds/linux/commit/bd8df82be66698042d11e7919e244c8d72b042ca) in 4.14.  Following everyone else's [example](https://github.com/zebulon2/rtl8812au-driver-5.2.9/commit/08e0472fbc60be09f6207b21819ed141cb81d579), we'll replace it with `kernel_read` as well.

Next, let's look at the whitespace warnings.  Looking at the code around them, it looks to me like all of these items were indented properly but not properly bracketed, so they are indeed bugs.  I added the brackets in where they go.

The tilde errors are fun as well.  There's a good explanation of this technically valid but still probably logically a bug [here on StackOverflow](https://stackoverflow.com/questions/44565126/how-to-enable-c-warnings-for-bitwise-operators-with-boolean-arguments).  I converted all of the `~` to `!` as they all appear as they should be logical nots.
