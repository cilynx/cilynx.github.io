---
layout: post
title:  ORAC Tachometer Display
date:   2018-02-24 12:17:57 -0800
tags:   orac cnc motor controller lathe pwm interface 3d_printing openscad smoothie thingiverse
---
![ORAC Before](/assets/IMG_4752.JPG)
Even though (or maybe "especially since") the spindle speed is computer controlled, I've found that one of the most valuable pieces of information is the RPM readout on an [old school 7-segment display](http://amzn.to/2ENZB14).  I've been going back and forth with myself around where I want to put the tach display.  Originally, I was planning on mounting it low on one of the doors I'm printing to replace the original faceplate.  I still like that idea to some extent, but thinking more about it, I'm probably going to put a touchscreen down there at some point, which will have RPM readout among other things.  
![Display position](/assets/IMG_4755.JPG)
I also like the idea of having the tachometer as close to the workpiece as possible so they're more likely to be in my field of vision at the same time.  In order to accomplish that, I'm looking at replacing the original faceplate with the G-code list.  I'm a little sad to give up the awesome 80's logo and the training gcode list, but those are the breaks.
![Wiring hole](/assets/IMG_4756.JPG)
Conveniently, there's already a hole passing from behind the spindle plate into the main pulley access compartment.
![Access compantment](/assets/IMG_4758.JPG)
The faceplate is nominally 130mm x 175mm.  It's actually a smidge over 130 and under 175, but this is a faceplate and not a precision bearing, so we're going to work with easy nominal numbers.  The screws are M4.  The holes in the faceplate don't exactly line up with the mounting holes on the machine, so it seems I'm not the only one who didn't take the precision of this faceplate too seriously.  Using the super-precise eyeballs and [metal ruler](http://amzn.to/2EQj3dt) method, the mounting holes look to be 120mm center-to-center horizontally and 165mm center-to-center vertically.  That means each hole center is 5mm from each edge, which actually makes sense.  Amazing.
![Not flush](/assets/IMG_4759.JPG)
The next fun part is that the tach display is a bit bigger than the space available behind the faceplate if it's flush.  In order for everything to sit nice, we need to make up 7mm of thickness with our new faceplate.
![Weird size](/assets/IMG_4760.JPG)
The body of the tach display itself is a bit weirder sized.  It's right close to 68mm wide, which is fine, but it's ~33.25mm tall.  That 1-5/16" tall by 2-11/16" wide, which doesn't make any sense either.  Being that the holding clips are on the top and bottom, I'm going to go with 34mm tall and stick to 68mm wide for a snug fit.
![Weird size](/assets/54120997167__517BC521-F4D5-4ED3-8F72-5C13E9CCAE52.JPG)
If you want to make this faceplate yourself, the STL, SCAD and additional info are available on [Thingiverse](https://www.thingiverse.com/thing:2805616).
