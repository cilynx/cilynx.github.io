---
layout: post
title:  Lepy LP-2020A Teardown & Testing
date:   2020-07-10 07:46:15 -0700
tags:   lepy hifi
---
<iframe width="560" height="315" src="https://www.youtube.com/embed/XmKI3ewdxcQ" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

It doesn't take long to realize that this amp is nowhere near as good as its namesake.  To start off with, the product description includes such gems as "Class D is better than Class T"....which is patently impossible considering Class-T is a subset of Class-D.

The 2020A at 100% volume both on the input signal and the amp is just loud enough to be uncomfortable with the HPMs, but even at that volume the sound doesn't "fill" a 15'x15' room. It sounds thin, far away, fake. The real Tripath drives the HPMs to fill the room with rich sound at comfortable listening levels and even at background levels you can talk over.  For raw power, the real Tripath amps get well into "hearing protection required" territory well before maxing out either the input signal or amp volume.  It's like the difference between sitting right in front of the band in a small venue (the real Tripath) or being in the parking lot outside a concert hall (this thing).

Looking under the hood, it's a completely different board than its namesake.  The main chip is a [Yamaha YDA138](/assets/YDA138.pdf) that has been rebadged as LP2020-A 1501.  They even went as far as putting Lepy branded covers over the output filter inductors.

Googling around, some folks claim that the Yamaha chip used here actually does a good job if you setup its supporting circuitry correctly.  If I ever care enough in the future maybe I'll play with swapping components, but for the moment, I'm going with the idea that the amp should perform well as shipped.

## 1% THD @ 40Hz, JBL LX-22 Speakers

|Input Voltage|Input Current|Input Power|Volume|Output Voltage|
|---|
|12V|1.2A|14.4W|71dB|7.96V|
|13V|1.3A|16.9W|73dB|8.70V|
|14V|1.4A|19.6W|75dB|9.33V|

## 1% THD @ 1kHz, JBL LX-22 Speakers

|Input Voltage|Input Current|Input Power|Volume|Output Voltage|
|---|
|12V|0.64A|7.68W|107dB|7.93V|
|13V|0.60A|7.80W|108dB|7.94V|
|14V|0.58A|8.12W|107dB|7.94V|

## Specifications

|Brand|Model|Chipset|Avaliability|Included Power Supply|
|---|
|Lepy|LP-2020A|[YDA138](/assets/YDA138.pdf) (rebadged as LP2020-A 1501)|[~$35 on Amazon](https://amzn.to/2ZYQXV1), but seriously, get [something else]({% post_url 2018-01-27-mini_hifi_bakeoff %}#amplifiers-reviewed)|BK-40W-13.5Us1130905 12V/3A|
