---
layout: post
title:  "BIQU Kossel Plus"
tags: kossel 3d_printing cnc smoothie
last_modified_at: 2017-12-5
---
## Overview

For my first foray into 3d printing, I picked up a [BIQU Kossel Plus](http://amzn.to/2jinHnO) kit.  I love my printer, but I have to take off a couple stars because it took a lot of DIY to get it where it is now.  The basic kit is honestly pretty good and [BIQU](https://www.biqu.equipment/) is very active on their [Facebook group](https://www.facebook.com/groups/1680600228892779). The manufactured parts are very good and the printed parts are passable.  

![BIQU Kossel Plus in Box](/assets/IMG_4287.JPG) ![BIQU Kossel Plus Assembled](/assets/IMG_4455.JPG)

My first real complaint is that the BigTree [Marlin](http://marlinfw.org/) board that came in the kit never did work right. It would crash into the endstops, crash into the bed, make motions that were obviously out of calibration and try to break the arms, etc. Further, adjusting Marlin's configuration requires recompiling the Arduino firmware, which is just a pain.  If I cared to fight with it, the Marlin board could probably be made to work, but why bother when the Smoothieboard Just Works out of the box?  Since I never got the included controller working, I never tried the include LCD and encoder either. They could be awesome for all I know, but they're in the spares bin now.

My next big complaint is that there's no place to put the power supply and there's wiring hanging out all over the place. The cable wrap kinda works, but having the whole umbilical cord falling off to the side instead of up out the top leads to botched prints and melted wires. Ask me how I know. 

## Hardware Mods
* Replaced the BigTree RAMPS board with a [Smoothieboard clone](http://amzn.to/2kp69d8) I hadn't gotten around to sticking in the [ORAC](/orac).  

<p style="background:pink; border:1px solid silver; padding:5px">Please <a href="http://smoothieware.org/donate">support the Smoothieware project</a> if you find it useful.  This is how open source developers can afford to spend time on the projects we love.  Personally, I donate $20/month to the Smoothieware  project via PayPal.</p>

* Moved the extruder to the top and lengthened all the wire runs going from the base to the hot end.  Wrapped everything up in [1/2" conduit](http://amzn.to/2iXh8tY) secured to the top with [velcro cable ties](http://amzn.to/2iV4aNb) then running back down outside the print area.

* Printed up [Peaberry's Kossel Base Stands](https://www.thingiverse.com/thing:2024677) to make room underneath for the power supply and the rest of the guts.

* Designed some [panels](https://www.thingiverse.com/thing:2577313) to go with the stands for a more finished look.

* Printed up a [Fabrikator Mini Cooler / Fan Shroud](https://www.thingiverse.com/thing:1658075) and upgraded to a [Noctua 40mm Fan](http://amzn.to/2kprV0e).

* Cobbled on some [LED strip lights](http://amzn.to/2iXATlb).

![Umbilical and base mods](/assets/IMG_4367.JPG)

* Hand cut a couple layers of cardboard for insulation between the hot plate and the guts under the base as well as a couple strips of [flexible plastic mat](http://amzn.to/2kqnQZE) to insulate the hot plate from the 2020 aluminum frame.

![Cardboard insulation](/assets/IMG_4368.JPG)

* Designed a [simple mount](https://www.thingiverse.com/thing:2588290) to attach the power supply to the 2020 t-slot underneath.

* Printed up a [2020 SBASE mount](https://www.thingiverse.com/thing:1417254) and installed the Smoothie clone upside-down making it easily accessible from the bottom.

![Base guts](/assets/IMG_4376.JPG)

* Designed an [enclosure](https://www.thingiverse.com/thing:2589438) for a [Raspberry Pi](http://amzn.to/2koq5N9) and [official 7" touchscreen](http://amzn.to/2BD1urp) running [OctoPi](https://octopi.octoprint.org/).  I also added a [relay](http://amzn.to/2ko29cB) so I can turn the main power supply on and off programmatically.  This is very nicely supported by [OctoPrint](http://octoprint.org/)'s [PSU Control](http://plugins.octoprint.org/plugins/psucontrol/) plugin.  

<p style="background:pink; border:1px solid silver; padding:5px">Please <a href="http://octoprint.org/support-octoprint/">support the OctoPrint project</a> if you find it useful.  This is how open source developers can afford to spend time on the projects we love.  Personally, I donate $20/month to the OctoPrint project via Patreon.</p>

![Pi guts](/assets/IMG_4380.JPG)

* Upgraded the fan rig to an [e3d All-in-One fan mount](https://www.thingiverse.com/thing:1667012) with two more [Noctua 40mm Fans](http://amzn.to/2kprV0e).  The center fan is wired straight to 12V on the supply, so if the machine is on, the heat sink is being cooled.  The side fans are driven by the Smoothieboard via M-codes send from the slicer.

![Cooler](/assets/IMG_4381.JPG)
