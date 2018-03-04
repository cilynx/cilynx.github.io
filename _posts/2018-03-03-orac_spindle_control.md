---
layout: post
title:  ORAC Spindle Control
date:   2018-03-03 19:56:03 -0800
tags:   orac cnc lathe motor mc2100 dc smoothie pwm safety
---
![tach display](/assets/IMG_4818.JPG)
From the factory, the machine came with an AC motor and a big obnoxious 240VAC VFD.  The motor was missing on my machine and I don't have access to high voltage, so I found myself a free treadmill and salvaged the 2.0 HP continuous duty brushed DC motor and [mc2100](/mc2100/) controller.

I poked some holes in the flange to mount the motor to the headstock and wrapped the power leads in a Faraday sheath since they make a ton of EM noise.  I haven't decided yet what I'm going to do with the motor's built-in thermal switch.  I may just put it in series with the ground line to disconnect the motor if it overheats or I may connect it to a switch input on the Smoothie and have it trigger an alarm in software.  I've also designed a cowl and fan for the tail shaft to keep things cool in the first place, but those aren't ready for production just yet.

![motor](/assets/IMG_4826.JPG)

My first free treadmill was free because "it stops working sometimes".  I figured it was probably the LCD or controls or something else not overly related to the motor and its controller.  Well, it turned out it was the motor controller that stopped working at random.  Specifically, it stops acknowledging that its receiving a PWM signal.  Onward and upward, I found another free treadmill and this one came with a reliable controller.

![controllers](/assets/IMG_4828.JPG)

When I first started playing with Smoothie's [PWM / PID spindle control](http://smoothieware.org/spindle-module#pwm-spindle), it was pretty apparent that no one else was using it.  My first clue was that the module [didn't respond to M3 at all](https://github.com/Smoothieware/Smoothieware/commit/09c5297f5739bb9a902b850adf197fce8120696f).  After that, I found a few more minor things:  

* M958 [didn't report anything](https://github.com/Smoothieware/Smoothieware/commit/56715bb9c57122878d8db77cce66c86dafa1d35a).
* The spindle [did not stop on `HALT`](https://github.com/Smoothieware/Smoothieware/commit/92dc23fbcbdcdb6c4bf69a372b0083ac30b49816).
* M957 was [reporting target rpm instead of actual rpm](https://github.com/Smoothieware/Smoothieware/commit/d30a1e3745ab4130877b8f36a3a85f7f7e2a9daf).  (Granted, this was on the Analog as opposed to PWM module, but still.)
* M958 [only set the P-term instead of P, I, and D](https://github.com/Smoothieware/Smoothieware/commit/7b12c2529664873677400e510df4712295f435f9).

![controllers](/assets/IMG_4820.JPG)

Rounding out the hardware, I'm using a [cheap digital tach](http://amzn.to/2F8c8Iz) and I made a [mount for the Hall sensor](https://www.thingiverse.com/thing:2813873).  Instead of inventing a new part, I found some [tiny magnets](http://amzn.to/2oFRMQG) that fit inside one of the nut slots on the [spindle timing pulley](https://www.thingiverse.com/thing:2813937) I designed a while back and already had on there.

![controllers](/assets/IMG_4817.JPG)

The Hall sensor in the kit has a long tail which I cut just a few inches down and spliced over to the display which I [mounted in front of the spindle]({% post_url 2018-02-24-orac_tachometer_display %}).

![tach display](/assets/IMG_4818.JPG)

The other end of the tail splits down inside the cabinet with power/ground going over to the motor controller, feeding off it's [console power header]({% post_url 2017-11-24-mc2100-motor-controller-interface %}#hd2---console) and the tach signal from the sensor going into a PWM input on the Smoothie.  

![noise filter](/assets/IMG_4813.JPG)

It's worth noting here that after dorking around with various low pass filters for weeks trying to stop the Smoothie from picking up noise as spindle pulses, I just threw a little capacitor across the signal line and a ground pin right on the board and that worked an order of magnitude better than anything else.  KISS.

If anyone else happen to have this exact machine, I've found that the following parameters work best on the PID control:

|P|0.0001|
|I|0.000047|
|D|0.00001|

If anyone is interested, I may discuss PID tuning in a future post.
