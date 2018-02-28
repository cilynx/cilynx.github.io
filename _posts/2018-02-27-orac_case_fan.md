---
layout: post
title:  ORAC Case Fan
date:   2018-02-27 21:14:52 -0800
tags:   orac cnc lathe mc2100 smoothie
---
![Glamour Shot](/assets/IMG_4784.JPG)
The ORAC came originally with this big honkin' 230 VAC fan that weighs over 800g.  Also, look at the size of that hub.  I know most of the airflow comes from the end of the blades, but still.  I have no intention of having 230 VAC in this machine, so the big honkin' fan has got to go.
![Old Fan](/assets/IMG_4788.JPG)
One of the nice side effects of getting rid of the VFD and all the rest of the high-voltage AC guts is that heat isn't really going to be an issue anymore.  The most heat I'm going to get will be coming off of the motor controller, which is passively cooled by being bolted to an enormous finned aluminum plate and is designed to live in the closed front case of a treadmill right across from the motor.  All of the rest of the electronics have negligible heat output.  That said, even if I don't care all that much about heat, I am distinctly interested in keeping swarf away from the electronics and I figure one way to help that effort is to keep positive pressure in the cabinet via a filtered pusher fan replacing the old exhaust fan.

I like the Noctua line of fans and have a few criteria to work with:
* 120mm
* Will work as a pressure pusher
* 24V
* Better quality than a shitty computer case fan with l33t LED lights

Enter the [NF-F12 iPPC-2000 IP67 24V](http://amzn.to/2HO8HZo) -- yeah, it's a mouthful.  For filtering, I went with the [Silverstone Tek ultrafine magnetic filter](http://amzn.to/2BV50k0).  You might think a "magnetic" filter has some awesome mesh properties, but you'd be wrong.  The outer frame is basically a refrigerator magnet, which while it does nothing for the filtering prowess does make it easier to get the screw holes lined up when mounting.
![Mounting Up](/assets/IMG_4783.JPG)
The screws that came with the fan are self-tapping and grab onto the mounting holes of the fan nicely.
![Mounted](/assets/IMG_4786.JPG)
Being a 4-wire fan, this thing is expecting to get 24V all the time in addition to a 5V PWM line for desired speed.  Finally, it has a return line with a tach pulse.  I'm not sure how much I'm going to care when I wire it up.  On one side, it's a fan.  I should just hook up 24V and ground and hope it spins up at whatever speed it feels like.  On the other hand, I'm a dork and have to have PWM speed control from the Smoothie.  On the 3rd hand, I'm a total control freak and driving a fan to a specific RPM with a PID controller would be fun if not entirely unnecessary.  Either way, that all has to wait until I get the Smoothie and the MC2100 placed where I want them and the rest of the machine generally wired up. 

I'm going to want this later:

|Blue|PWM Signal (+5V)|
|Green|RPM Speed Signal|
|Yellow|V+|
|Black|Ground|

[NF-F12 FAQ](https://noctua.at/en/nf-f12-pwm/faq)
