---
layout: post
title:  Mini Hifi Bakeoff
date:   2018-01-27 10:24:42 -0700
tags:   tripath hifi reverse_engineering lepai lepy lvpin pyle
last_modified_at: 2018-05-18
---
![Mini-Hifi Montage](/assets/mini_hifi_montage.png)

There are many little amps that claim to be "Class-T" (a kitschy, propriety name for Tripath's Class-D amp chips and accompanying feedback control circuitry) or "better", come in the same extruded aluminum enclosure, have conspicuously similar brand names and model numbers, and seem to be purposely difficult to tell apart.  Googling around, you can find years and years of narrow comparisons and speculation.  I got tired of reading through conflicting information and run-around, so I bought a bunch of them to tear apart and do a fair comparison.

## Amplifiers Reviewed

|Amp|TL;DR|
|-|-|
|[Lepai LP-2020A+](#Lepai LP-2020A+)|The mini-amp that started the craze.  Great sound at a great price, but you simply can't find them anymore.  Powered by the legendary Tripath [TA2020-020](/assets/Tripath TA2020-020.pdf).|
|[Kinter K2020A+](#Kinter K2020A+)|In my opinion, this is the true successor to the Lepai LP-2020A+.  It sounds slightly better than even the original and at ~$30, it's well worth its cost.  Powered by the legendary Tripath [TA2020-020](/assets/Tripath TA2020-020.pdf).|
|[Lvpin LP-2020A+](#Lvpin LP-2020A+)|So far as I can tell, this is an exact copy of the Lepai LP-2020A+.  It sounds identical to my ears.  Powered by the legendary Tripath [TA2020-020](/assets/Tripath TA2020-020.pdf).  At ~$10, you can't really go wrong.  Buy two and wear them like shoes.|
|[Lepai LP-2020TI](#Lepai LP-2020TI)|This is the one Parts-Express claims is the true successor to the Lepai LP-2020A+.  Powered by the TI [TPA3118](/assets/TPA3118D2.pdf).  Personally, I'm not buying it.  Output power appears slightly lower and the magical presence the Tripath brings just isn't there with the TI heart.|
|[Lepy LP-2020A](#Lepy LP-2020A)|Powered by the Yamaha [YDA138](/assets/YDA138.pdf), this one falls short on magic.  With some component replacement it's potentially possible for this to be an quality amp, but as-shipped, steer clear.|
|[Pyle PFA200](#Pyle PFA200)|Pretty similar to the Lepy LP-2020A above.  Unknown amp chips with obscured labeling.  Doesn't feel like "Class-T" as the marketing wank claims.|
|Lepy LP-2024A+|Considering the model number, I expected this one would have a Tripath [TA2024](/assets/Tripath TA2024.pdf), but it turns to have a [TAA2008](/assets/Tripath TAA2008.pdf).  I just got this one in May 2018.  Full review coming soon.|
|[Lepy LP-V3S](Lepy LP-V3S)|Supposedly based around the Toshiba [TA8254](/assets/Toshiba TA8254BHQ.pdf), I'm expecting this to be pretty similar to the Lepy LP-2020A.  Ordered in May 2018 -- Full review coming soon.|
|Lepy LP-2051|Looking at the model number, I'm guessing this has a Tripath [TK2051](/assets/Tripath TK2051.pdf) inside, but we see how well guessing worked out on the LP-2024A+  Ordered in May 2018 -- Full review coming soon.|

## Actual Data

|Amplifier|Channel|Frequency|Waypoint|Sound Pressure (Volume)|
|-|-|-|-|-|
|[Kinter K2020A+](#Kinter K2020A+)|Left|1kHz|50% Volume|81dB|
|[Kinter K2020A+](#Kinter K2020A+)|Left|1kHz|Audible Distortion|90dB|
|[Kinter K2020A+](#Kinter K2020A+)|Left|1kHz|1% THD|91dB|
|[Kinter K2020A+](#Kinter K2020A+)|Left|1kHz|100% Volume|93dB|
|[Kinter K2020A+](#Kinter K2020A+)|Left|40Hz|50% Volume|82dB|
|[Kinter K2020A+](#Kinter K2020A+)|Left|40Hz|Audible Distortion|88dB|
|[Kinter K2020A+](#Kinter K2020A+)|Left|40Hz|1% THD|89dB|
|[Kinter K2020A+](#Kinter K2020A+)|Left|40Hz|100% Volume|94dB|
|[Lepy LP-2020A](#Lepy LP-2020A)|Left|1kHz|50% Volume|64dB|
|[Lepy LP-2020A](#Lepy LP-2020A)|Left|1kHz|Audible Distortion|82dB|
|[Lepy LP-2020A](#Lepy LP-2020A)|Left|1kHz|1% THD|84dB|
|[Lepy LP-2020A](#Lepy LP-2020A)|Left|1kHz|100% Volume|89dB|
|[Lepy LP-2020A](#Lepy LP-2020A)|Left|40Hz|50% Volume|64dB|
|[Lepy LP-2020A](#Lepy LP-2020A)|Left|40Hz|Audible Distortion|85dB|
|[Lepy LP-2020A](#Lepy LP-2020A)|Left|40Hz|1% THD|87dB|
|[Lepy LP-2020A](#Lepy LP-2020A)|Left|40Hz|100% Volume|88dB|

## Opinionated Breakdown
<a name="Lepai LP-2020A+"></a>
<table>
<tr><th>Brand</th><td>Lepai</td></tr>
<tr><th>Model</th><td>LP-2020A+</td></tr>
<tr><th>Manual</th><td><a href="/assets/Lepai LP-2020A+ - Manual.pdf">LP-2020A+ Operating Manual</a></td></tr>
<tr><th>Amplifier Chip</th><td><a href="/assets/Tripath TA2020-020.pdf">Tripath TA2020-020</a></td></tr>
<tr><th>Availability</th><td><a href="https://amzn.to/2Ip68Rv">Discontinued</a><br>Sold for ~$18 in 2014 and ~$30 in 2015.</td></tr>
<tr><th>Face Text</th><td>Lepai Stereo Class-T Digital Audio Amplifier</td></tr>
<tr><th>Board Text</th><td>Lepai LP-2020A+ MADE IN CHINA</td></tr>
<tr><th>Right Channel</th><td>Top Red Jack</td></tr>
<tr><th>Left Channel</th><td>Bottom White Jack</td></tr>
<tr><th>Input Power Label</th><td>DC12V2A</td></tr>
<tr><th>Included Power Supply</th><td>ONK-0122000 12V/2A</td></tr>
<tr><th>Front</th><td><img src="/assets/Lepai LP-2020A+ - Naked Front.png"></td></tr>
<tr><th>Top</th><td><img src="/assets/Lepai LP-2020A+ - Naked Top.png"></td></tr>
<tr><th>Back</th><td><img src="/assets/Lepai LP-2020A+ - Naked Back.png"></td></tr>
<tr><th>Comments</th><td>This is the amp that started the "cheap and tiny but actually hi-fi" amp craze.  Parts Express <a href="https://youtu.be/haBAMl22x88">claims</a> (through one *very serious* spokesdude, I might add) that they discontinued the model due to the difficulty of acquiring the Tripath chips.  This is a fairly legitimate argument considering Tripath went bankrupt in 2007.  As for durability, I have a three of the original Lepai LP-2020A+ that I picked up back in 2014 that are all still going strong.</td></tr>
</table>

<a name="Kinter K2020A+"></a>
<table>
<tr><th>Brand</th><td>Kinter</td></tr>
<tr><th>Model</th><td>K2020A+</td></tr>
<tr><th>Manual</th><td><a href="/assets/Kinter K2020A+ - Manual.pdf">Kinter K2020A+ Operating Manual</a></td></tr>
<tr><th>Amplifier Chip</th><td><a href="/assets/Tripath TA2020-020.pdf">Tripath TA2020-020</a></td></tr>
<tr><th>Availability</th><td><a href="https://amzn.to/2k4JAqx">~$30 on Amazon</a></td></tr>
<tr><th>Face Text</th><td>Kinter<sup>&reg;</sup> LIMITED EDITION TRIPATH K2020A+</td></tr>
<tr><th>Board Text</th><td>KINTER<sup>&reg;</sup> K2020A+ China 2017/10/8</td></tr>
<tr><th>Right Channel</th><td>Top White Jack</td></tr>
<tr><th>Left Channel</th><td>Bottom Red Jack</td></tr>
<tr><th>Input Power Label</th><td>DC12V5A</td></tr>
<tr><th>Included Power Supply</th><td>TH-120500 12V/5A</td></tr>
<tr><th>Front</th><td><img src="/assets/Kinter K2020A+ - Naked Front.png"></td></tr>
<tr><th>Top</th><td><img src="/assets/Kinter K2020A+ - Naked Top.png"></td></tr>
<tr><th>Back</th><td><img src="/assets/Kinter K2020A+ - Naked Back.png"></td></tr>
<tr><th>Comments</th><td>The board is laid out almost identically to the <a href="#Lepai LP-2020A+">Lepai LP-2020A+</a>, however if you look closely at the traces and component positioning/labels, you can see that it was re-laid-out and is not an exact copy.
<br><br>
As expected, power handling is practically identical to the <a href="#Lepai LP-2020A+">Lepai LP-2020A+</a> as well.  The surprising part for me is that this amp actually sounds better -- yes, better than its namesake.  Specifically, it's noticeably more clear / articulate.  Listening to Daft Punk's Solar Sailer, this amp brings through more texture in the eighth-note beat from the beginning and more depth and presence when the ambient tones come in around the 1-minute mark.
<br><br>
It's worth noting that the Kinter's over-voltage protection is a bit more zealous than the others.  Trying to run this amp with one of the 13.5V supplies that come with the Lepy amps, the Kinter's LED lights up, but the amp itself stays off -- no sound at all.  The Kinter's included power supply puts out a measured 12.29V.
<br><br>
Overall, I would say if you're looking for the best sounding cheap amp, this is the one to get.  For 1/3 of the cost, though, you can get the <a href="#Lvpin LP-2020A+">Lvpin LP-2020A+</a> which sounds identical to the original/unobtainable <a href="#Lepai LP-2020A+">Lepai LP-2020A+</a> to my untrained ears.
</td></tr>
</table>

<a name="Lvpin LP-2020A+"></a>
<table>
<tr><th>Brand</th><td>Lvpin</td></tr>
<tr><th>Model</th><td>LP-2020A+</td></tr>
<tr><th>Amplifier Chip</th><td><a href="/assets/Tripath TA2020-020.pdf">Tripath TA2020-020</a></td></tr>
<tr><th>Availability</th><td><a href="https://amzn.to/2rVt6Vs
">~$10 on Amazon</a></td></tr>
<tr><th>Face Text</th><td>Lvpin Stereo Class-T Digital Audio Amplifier</td></tr>
<tr><th>Board Text</th><td>LVPIN LP-2020A+ 20150801 caiyun.name</td></tr>
<tr><th>Right Channel</th><td>Bottom White Jack</td></tr>
<tr><th>Left Channel</th><td>Top Red Jack</td></tr>
<tr><th>Input Power Label</th><td>DC12V2A</td></tr>
<tr><th>Included Power Supply</th><td>DC12V3A</td></tr>
<tr><th>Comments</th><td>While the board itself is green instead of red, the layout looks to be identical to the <a href="#Lepai LP-2020A+">Lepai LP-2020A+</a>. However, the components are definitely different.  For example, the Lvpin uses a single <a href="/assets/GSA-SS-212DM.pdf">GSA-SS-212DM</a> dual relay package while the <a href="#Lepai LP-2020A+">Lepai LP-2020A+</a> and the <a href="#Kinter K2020A+">Kinter K2020A+</a> both use a pair of <a href="/assets/HK4100F.pdf">HK4100F</a> single relays.
<br><br>
Doing a listening test, this amp sounds identical to the <a href="#Lepai LP-2020A+">Lepai LP-2020A+</a>.  Power handling feels exactly the same as well.
<br><br>
While not quite as pleasing to the ear as the <a href="#Kinter K2020A+">Kinter K2020A+</a>, it does 100% live up to the quality of its namesake and for $10 with prime delivery, you really can't go wrong.
</td></tr>
</table>

<a name="Lepai LP-2020TI"></a>
<table>
<tr><th>Brand</th><td>Lepai</td></tr>
<tr><th>Model</th><td>LP-2020TI</td></tr>
<tr><th>Manual</th><td><a href="/assets/Lepai LP-2020TI - Manual.pdf">LP-2020TI Operating Manual</a></td></tr>
<tr><th>Amplifier Chip</th><td><a href="/assets/TPA3118D2.pdf">Texas Instruments TPA3118</a></td></tr>
<tr><th>Availability</th><td><a href="https://amzn.to/2IpWuy2">~$40 on Amazon</a></td></tr>
<tr><th>Face Text</th><td>Lepai<sup>&reg;</sup> Stereo Digital Audio Amplifier</td></tr>
<tr><th>Board Text</th><td>SM1520 2015/11/11 V1.1</td></tr>
<tr><th>Right Channel</th><td>Bottom Red Jack</td></tr>
<tr><th>Left Channel</th><td>Top White Jack</td></tr>
<tr><th>Input Power Label</th><td>DC12V3A</td></tr>
<tr><th>Included Power Supply</th><td>TH201505 12V/3A</td></tr>
<tr><th>Comments</th><td>Parts-Express <a href="https://youtu.be/haBAMl22x88">claims</a> this one is the "one true successor" to the original <a href="#Lepai LP-2020A+">Lepai LP-2020A+</a>. They claim that they designed this amp around the <a href="/assets/TPA3118D2.pdf">Texas Instruments TPA3118</a> because the <a href="/assets/Tripath TA2020-020.pdf">Tripath TA2020</a> has become hard for them to source. Further, they claim the new 2020TI sounds "cleaner" and is more powerful than the original <a href="#Lepai 2020A+">2020A+</a> with the 2020TI putting out 14W@1%THD as compared to 7W@1%THD for the 2020A+ when running on the same 12V@3A (36W) power supply.
<br><br>
To my ear, however, this new offering is inferior to its predecessor.  First off, the TI amp appears to be less efficient.  You have to turn it up higher to get the same volume and maximum output on the TI is lower than from the Tripath.  Second, at the risk of sounding like an audiophile knob, the TI seems to convey less presence and soul.
<br><br>
This amp doesn't sound bad, but to about the same degree that the <a href="#Kinter K2020A+">Kinter K2020A+</a> sounds better than the <a href="#Lepai LP-2020A+">Lepai LP-2020A+</a>, this one sounds worse.  Considering this is the most expensive of the amps on my list, I don't see any reason for anyone else to buy one as long as the <a href="#Kinter K2020A+">Kinter K2020A+</a> and <a href="#Lvpin LP-2020A+">Lvpin LP-2020A+</a> are available.
</td></tr>
</table>

<a name="Lepy LP-2020A"></a>
<table>
<tr><th>Brand</th><td>Lepy</td></tr>
<tr><th>Model</th><td>LP-2020A</td></tr>
<tr><th>Amplifier Chip</th><td><a href="/assets/YDA138.pdf">YAMAHA YDA138</a> (Rebadged as LP2020-A 1501)</td></tr>
<tr><th>Availability</th><td><a href="https://amzn.to/2KE6n7J">~$25 on Amazon</a></td></tr>
<tr><th>Face Text</th><td>Lepy Stereo Class-D Digital Audio Amplifier</td></tr>
<tr><th>Board Text</th><td>Lepy LP-2020A 170504PCB MADE IN BUKANG</td></tr>
<tr><th>Right Channel</th><td>Top Red Jack</td></tr>
<tr><th>Left Channel</th><td>Bottom White Jack</td></tr>
<tr><th>Input Power Label</th><td>DC12V3A</td></tr>
<tr><th>Included Power Supply</th><td>BK-40W-13.5Us1130905 12V/3A</td></tr>
<tr><th>Comments</th><td>
It doesn't take long to realize that this amp is nowhere near as good as its namesake.  To start off with, the product description includes such gems as "Class D is better than Class T"....which is patently impossible considering Class-T is a subset of Class-D.
<br><br>
This amp has less than half of the raw power of the 2020A+. The 2020A at 100% volume both on the input signal and the amp is just loud enough to be uncomfortable with the HPMs, but even at that volume the sound doesn't "fill" a 15'x15' room. It sounds thin, far away, fake. The real Tripath drives the HPMs to fill the room with rich sound at comfortable listening levels and even at background levels you can talk over.  For raw power, the real Tripath amps get well into "hearing protection required" territory well before maxing out either the input signal or amp volume.  It's like the difference between sitting right in front of the band in a small venue (the real Tripath) or being in the parking lot outside a concert hall (this thing).
<br><br>
Looking under the hood, it's a completely different board than its namesake.  The main chip is a <a href="/assets/YDA138.pdf">YAMAHA YDA138</a> that has been rebadged as LP2020-A 1501.  They even went as far as putting Lepy branded covers over the output filter inductors.
<br><br>
Googling around, some folks claim that the Yamaha chip used here actually does a good job if you setup its supporting circuitry correctly.  If I ever care enough if the future maybe I'll play with swapping components, but for the moment, I'm going with the idea that the amp should perform well as shipped.
</td></tr>
</table>

<a name="Lepy LP-V3S"></a>
<table>
<tr><th>Brand</th><td>Lepy</td></tr>
<tr><th>Model</th><td>LP-V3S</td></tr>
<tr><th>Amplifier Chip</th><td>STMicroelectronics TDA7377</td></tr>
<tr><th>Availability</th><td><a href="https://amzn.to/2IUTZmQ">~$30 on Amazon</a></td></tr>
<tr><th>Face Text</th><td>Lepy Hi-Fi STEREO AMPLIFIER</td></tr>
<tr><th>Board Text</th><td>Lepy MADE IN BUKANG P-V3D-2.0 lepy.com.cn 160328 PCB lepai0663.cn.alibaba.com 206C399-2</td></tr>
<tr><th>Right Channel</th><td>Top White Jack</td></tr>
<tr><th>Left Channel</th><td>Bottom Red Jack</td></tr>
<tr><th>Input Power Label</th><td>[None]</td></tr>
<tr><th>Included Power Supply</th><td>RL-1205AP 12V/5A</td></tr>
<tr><th>Comments</th><td>Coming Soon!</td></tr>
</table>

<a name="Pyle PFA200"></a>
<table>
<tr><th>Brand</th><td>Pyle</td></tr>
<tr><th>Model</th><td>PFA200</td></tr>
<tr><th>Amplifier Chip</th><td>Not sure yet.  Looks like a pair of SOIC32-packaged mono amps, but the tops of the chips have been textured to remove identifying marks and I haven't been able to sort them out so far.  The marketing copy claims this is a "Class-T" amplifier, but I've not seen a Tripath chip that looks like the surface-mount 32-pin packages on this board.  If these were actual Tripath chips, why would they obsure the markings?</td></tr>
<tr><th>Availability</th><td><a href="https://amzn.to/2LbJzO0">~$25 on Amazon</a></td></tr>
<tr><th>Face Text</th><td>Pyle PFA200</td></tr>
<tr><th>Board Text</th><td>PFA200 2015-05-10</td></tr>
<tr><th>Right Channel</th><td>Bottom Red Jack</td></tr>
<tr><th>Left Channel</th><td>Top White Jack</td></tr>
<tr><th>Input Power Label</th><td>DC12V2.5A</td></tr>
<tr><th>Included Power Supply</th><td>HANKER-1202 12.5V/2.5A</td></tr>
<tr><th>Comments</th><td>
This one isn't part of the Lepai, Lepy, Lvpin trifecta of branding awesomeness, but since it's in the same box and claims to be "Class-T", I figured it was worth a look. Under the covers, this one isn't similar to any of the others. It has two main chips, both of which are textured on top to obscure the labeling. They're definitely not Tripath TA2020 chips and there's no heat-sink to be found.
<br><br>
You will see a 5-wire jumper connecting the 1/8" line-level input on the front to the RCA inputs on the back. In the spot on the back where all the others have their 1/8" line-level input, this guy has a 1/4" microphone-level input, a nice feature if it's something you need.
<br><br>
Overall power on this one is not impressive. It's not as weak as the <a href="#Lepy LP-2020A">Lepy LP-2020A</a>, but it's not as strong as the <a href="#Lepai LP-2020A+">Lepai LP-2020A+</a>. Balancing two speakers with the 2020A+ at 25%, the PFA200 is at 50%. Considering the PFA200 claims to be 3x more powerful at 60W than the 2020A+ at 20W, this is pretty sad. Also keep in mind that this "60W" amp comes with a power supply that delivers only 12.5V@2.5A or 31.25W. It's possible that this amp could be great with a 5A brick, but then again the 2020A+ is rumored to be outstanding with a 5A brick as well -- rumors being what they are.
<br><br>
As for sound quality, it's again in the middle. The clarity seems very close to the 2020A+, but it's got a little more bass and unfortunately that bass is a little muddy. If I pre-set the volumes and listened to them with a few seconds pause in between, I probably wouldn't be able to tell the difference. Listening side-by-side though, I appreciate the clarity of the 2020A+.
<br><br>
Build quality of this one seems pretty low compared to the rest. The tone button is so badly out of alignment that it barely goes in its hole. The board is slightly too narrow to fit in the support channels in the case, so the face and tail screws are the only things keeping the board from falling onto the aluminum case bottom and shorting everything out. The front and back faces feel flimsier than on the Lepai/Lvpin/Lepy versions. Overally, it just feels like the enclosure is lower quality / cheaper.
</td></tr>
</table>
