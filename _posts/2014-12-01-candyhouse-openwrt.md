---
layout: post
title:  "OpenWRT for Candyhouse Routers"
tags: cisco linksys e4200v2 candyhouse router firmware openwrt
redirect_from: "/projects/candyhouse/openwrt/"
---
## This project is deprecated

Candyhouse routers (Linksys E4200v2 / EA4500) have been [natively supported](https://wiki.openwrt.org/toh/linksys/ea4500) in OpenWRT since [r47458](https://dev.openwrt.org/changeset/47458).  My [Candyhouse-Linux](https://github.com/cilynx/Candyhouse-Linux) repo has been archived and is only available now read-only for posterity.  No one should use it for anything in real life.

Thanks to:
* [Claudio Leite](https://github.com/leitec) for [getting candyhouse routers into mainline](https://dev.openwrt.org/changeset/47458).
* [Dan Walters](http://walters.io) for [discovering the back door](https://web.archive.org/web/20131210152136/http://blog.danwalters.net/blog/2012/06/19/hacking-linksys-ea3500-firmware-for-ssh-access) to get SSH access.
* [Andrew Brampton](http://bramp.net) for [obtaining](https://blog.bramp.net/post/2012/01/22/obtaining-the-firmware-for-linksys-e4200v2/) and [dissecting](https://blog.bramp.net/post/2012/01/24/hacking-linksys-e4200v2-firmware/) the stock firmware.
* Hugh Daschback for writing and documenting much of the original Cisco GPL code and being kind enough to point me in the right direction every time I got stuck.
