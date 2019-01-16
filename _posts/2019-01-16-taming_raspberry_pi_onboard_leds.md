---
layout: post
title:  Taming Raspberry Pi Onboard LEDs
date:   2019-01-16 10:04:16 -0800
tags:   raspberry_pi clustering
---
![Raspberry Pi SD Cards](/assets/20190116_092621.gif)

## Motivation

From the factory, the Raspberry Pi has a red LED that shows power status and a green LED that flashes to indicate SD card activity.  I find the power LED to be virtually useless and I wanted to be able to see when the CPUs were busy in my cluster in addition to disk activity.

## Not so fast...

You would think that the easy solution would be to leave the green activity LED triggered by disk activity and trigger the red power LED on CPU, right?  Unfortunately, that doesn't work as expected.  As you can see in the gif above, when configured this way, the red LED just stays on.  For reasons I don't understand, the red LED is binary -- it's full on or full off -- while the green LED operates at varying brightness.

Since our CPU usage is always non-zero, we'll have to use the green LED there, which leaves the red LED for disk activity, which does have a zero baseline.

To set your LED triggers, all you have to do is `echo` (as root) your chosen trigger to `/sys/class/leds/led0/trigger` for the green activity LED or `/sys/class/leds/led1/trigger` for the red power LED.  Your trigger options are `none rc-feedback kbd-scrolllock kbd-numlock kbd-capslock kbd-kanalock kbd-shiftlock kbd-altgrlock kbd-ctrllock kbd-altlock kbd-shiftllock kbd-shiftrlock kbd-ctrlllock kbd-ctrlrlock timer oneshot heartbeat backlight gpio [cpu] cpu0 cpu1 cpu2 cpu3 default-on input panic mmc1 mmc0 rfkill-any rfkill0 rfkill1`.  As an example, to turn off both LEDs, just run:
```
root@raspi03:/home/pi# echo none > /sys/class/leds/led0/trigger && echo none > /sys/class/leds/led1/trigger
```

## Deploying at scale

As with everything else in this series, I'm never going to leave it at *"SSH into each Pi and type..."*.  Instead, we have [another bash script](https://github.com/cilynx/raspi/blob/master/setup_leds.sh) which you can run from any host that can see your cluster nodes.

This is a very simple script, with the vast majority of it being just UX overhead.  The guts just set `/sys/class/leds/led0/trigger` (`-g`) and/or `/sys/class/leds/led1/trigger` (`-p`) and then persist to `/boot/config.txt` if you pass `-p`.

Here's what it looks like setting and persisting my preferred configuration across four nodes:
```
rcw@xps:~/Projects/raspi$ ./setup_leds.sh -g cpu -r mmc0 -p raspi{00..03}

(raspi00): Triggering power LED with mmc0...
mmc0
(raspi00): Persisting power LED configuration...
(raspi00): Triggering activity LED with cpu...
cpu
(raspi00): Persisting activity LED configuration...

(raspi01): Triggering power LED with mmc0...
mmc0
(raspi01): Persisting power LED configuration...
(raspi01): Triggering activity LED with cpu...
cpu
(raspi01): Persisting activity LED configuration...

(raspi02): Triggering power LED with mmc0...
mmc0
(raspi02): Persisting power LED configuration...
(raspi02): Triggering activity LED with cpu...
cpu
(raspi02): Persisting activity LED configuration...

(raspi03): Triggering power LED with mmc0...
mmc0
(raspi03): Persisting power LED configuration...
(raspi03): Triggering activity LED with cpu...
cpu
(raspi03): Persisting activity LED configuration...

rcw@xps:~/Projects/raspi$
```
