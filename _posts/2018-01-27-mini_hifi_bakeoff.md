---
layout: post
title:  Mini Hifi Bakeoff
date:   2018-01-27 10:24:42 -0700
tags:   tripath hifi reverse_engineering lepai lepy lvpin pyle kinter
last_modified_at: 2020-07-10
---
![Mini-Hifi Montage](/assets/mini_hifi_montage.png)

There are many little amps that claim to be "Class-T" (a kitschy, propriety name for Tripath's Class-D amp chips and accompanying feedback control circuitry) or "better", come in the same extruded aluminum enclosure, have conspicuously similar brand names and model numbers, and seem to be purposely difficult to tell apart.  Googling around, you can find years and years of narrow comparisons and speculation.  I got tired of reading through conflicting information and run-around, so I bought a bunch of them to tear apart and do a fair comparison.

* TOC
{:toc}

## Amplifiers Reviewed

|Amp|TL;DR|Teardown & Testing|
|---|
|[Lepy LP-2051]({% post_url 2020-07-07-lepy_lp-2051_teardown_&_testing %})|Driven by the Tripath [TK2051](/assets/Tripath TK2051.pdf) as opposed to the more common [TA2020-020](/assets/Tripath TA2020-020.pdf), this is the most powerful of the bunch.  If you're looking for clean power and don't mind the 19V power supply, it'll be hard to find a better value for your ~$40.|[![youtube](/assets/youtube.png)](https://www.youtube.com/watch?v=m5zgj7kRxLU)|
|[Lepai LP-2020TI]({% post_url 2020-07-06-lepai_lp-2020ti_teardown_&_testing %})|This is the one Parts-Express claims is the true successor to the [Lepai LP-2020A+]({% post_url 2020-06-30-lepai_lp-2020a+_teardown_&_testing %}).  Powered by the TI [TPA3118](/assets/TPA3118D2.pdf).  The power handling is good, but magical presence the Tripath brings just isn't there with the TI heart.|[![youtube](/assets/youtube.png)](https://www.youtube.com/watch?v=2erF33tHO5E)|
|[Kinter K2020A+]({% post_url 2020-07-04-kinter_k2020a+_teardown_&_testing %})|In my opinion, this is the true successor to the Lepai LP-2020A+.  It sounds slightly better than even the original.  Powered by the Tripath [TA2020-020](/assets/Tripath TA2020-020.pdf).  At ~$40, it's a bit steep, but probably still worth the cost if you're looking for a 12V Tripath.|[![youtube](/assets/youtube.png)](https://www.youtube.com/watch?v=jLqJSh1GsVc)|
|[Lepy LP-2024A+]({% post_url 2020-07-09-lepy_lp-2024a+_teardown_&_testing %})|Considering the model number, I expected this one would have a Tripath [TA2024](/assets/Tripath TA2024.pdf), but it turns to have a [TAA2008](/assets/Tripath TAA2008.pdf).  Objective performance just barely beats the [Lepai LP-2020A+]({% post_url 2020-06-30-lepai_lp-2020a+_teardown_&_testing %}), but it doesn't really matter since neither one is on the market anymore.|[![youtube](/assets/youtube.png)](https://www.youtube.com/watch?v=60FsNFW-lU4)|
|[Lepai LP-2020A+]({% post_url 2020-06-30-lepai_lp-2020a+_teardown_&_testing %})|The mini-amp that started the craze.  Great sound at a great price, but you simply can't find them anymore.  Powered by the legendary Tripath [TA2020-020](/assets/Tripath TA2020-020.pdf).|[![youtube](/assets/youtube.png)](https://www.youtube.com/watch?v=SQysHRD8FT8o)|
|[Lepy LP-2020A]({% post_url 2020-07-10-lepy_lp-2020a_teardown_&_testing %})|Powered by the Yamaha [YDA138](/assets/YDA138.pdf), this one falls short on magic.  With some component replacement it's potentially possible for this to be an quality amp, but as-shipped, steer clear.|[![youtube](/assets/youtube.png)](https://www.youtube.com/watch?v=7tZz-By4wZg)|
|[Lvpin LP-2020A+](#Lvpin LP-2020A+)|So far as I can tell, this is an exact copy of the Lepai LP-2020A+.  It sounds identical to my ears.  Powered by the legendary Tripath [TA2020-020](/assets/Tripath TA2020-020.pdf).  At ~$10, you can't really go wrong.  Buy two and wear them like shoes.|
|[Pyle PFA200](#Pyle PFA200)|Pretty similar to the Lepy LP-2020A above.  Unknown amp chips with obscured labeling.  Doesn't feel like "Class-T" as the marketing wank claims.|
|[Lepy LP-V3S](Lepy LP-V3S)|Supposedly based around the Toshiba [TA8254](/assets/Toshiba TA8254BHQ.pdf), I'm expecting this to be pretty similar to the Lepy LP-2020A.  Ordered in May 2018 -- Full review coming soon.|

## 1% THD @ 40Hz, JBL LX-22 Speakers

|Amplifier|Input Voltage|Input Current|Input Power|Volume|Output Voltage|
|---|
|[Lepy LP-2051]({% post_url 2020-07-07-lepy_lp-2051_teardown_&_testing %})|19V|2.00A|38.00W|85.8dB|13.40V|
|[Lepy LP-2051]({% post_url 2020-07-07-lepy_lp-2051_teardown_&_testing %})|18V|1.84A|33.12W|84.0dB|12.65V|
|[Lepy LP-2051]({% post_url 2020-07-07-lepy_lp-2051_teardown_&_testing %})|17V|1.75A|29.75W|82.0dB|11.89V|
|[Lepai LP-2020TI]({% post_url 2020-07-06-lepai_lp-2020ti_teardown_&_testing %})|14V|1.37A|19.18W|75.7dB|9.44V|
|[Lepy LP-2020A]({% post_url 2020-07-10-lepy_lp-2020a_teardown_&_testing %})|14V|1.4A|19.6W|75dB|9.33V|
|[Lepai LP-2020TI]({% post_url 2020-07-06-lepai_lp-2020ti_teardown_&_testing %})|13V|1.26A|16.38W|73.4dB|8.75V|
|[Lepai LP-2020TI]({% post_url 2020-07-06-lepai_lp-2020ti_teardown_&_testing %})|12V|1.19A|14.28W|73.0dB|8.27V|
|[Kinter K2020A+]({% post_url 2020-07-04-kinter_k2020a+_teardown_&_testing %})|12V|1.3A|15.6W|73.0dB|8.4V|
|[Lepy LP-2020A]({% post_url 2020-07-10-lepy_lp-2020a_teardown_&_testing %})|13V|1.3A|16.9W|73dB|8.70V|
|[Lepai LP-2020A+]({% post_url 2020-06-30-lepai_lp-2020a+_teardown_&_testing %})|14V|1.30A|18.20W|72.0dB|7.95V|
|[Lepy LP-2024A+]({% post_url 2020-07-09-lepy_lp-2024a+_teardown_&_testing %})|14V|1.30A|18.20W|71.0dB|8.07V|
|[Lepy LP-2020A]({% post_url 2020-07-10-lepy_lp-2020a_teardown_&_testing %})|12V|1.2A|14.4W|71dB|7.96V|
|[Lepai LP-2020A+]({% post_url 2020-06-30-lepai_lp-2020a+_teardown_&_testing %})|13V|1.22A|15.86W|70.4dB|7.37V|
|[Lepy LP-2024A+]({% post_url 2020-07-09-lepy_lp-2024a+_teardown_&_testing %})|13V|1.22A|15.86W|70.3dB|7.51V|
|[Lepy LP-2024A+]({% post_url 2020-07-09-lepy_lp-2024a+_teardown_&_testing %})|12V|1.15A|13.80W|70.0dB|6.92V|
|[Lepai LP-2020A+]({% post_url 2020-06-30-lepai_lp-2020a+_teardown_&_testing %})|12V|1.12A|13.44W|69.8dB|6.67V|

## Old Raw Data, Pioneer HPM-150 Speakers

|Amplifier|Channel|Frequency|Waypoint|Sound Pressure (Volume)|Vrms|
|-|-|-|-|-|-|
|[Lepy LP-2020A](#Lepy LP-2020A)|Left|1kHz|50% Volume|64dB|
|[Lepy LP-2020A](#Lepy LP-2020A)|Left|1kHz|Audible Distortion|82dB|
|[Lepy LP-2020A](#Lepy LP-2020A)|Left|1kHz|1% THD|84dB|
|[Lepy LP-2020A](#Lepy LP-2020A)|Left|1kHz|100% Volume|89dB|
|[Lepy LP-2020A](#Lepy LP-2020A)|Left|40Hz|50% Volume|64dB|
|[Lepy LP-2020A](#Lepy LP-2020A)|Left|40Hz|Audible Distortion|85dB|
|[Lepy LP-2020A](#Lepy LP-2020A)|Left|40Hz|1% THD|87dB|
|[Lepy LP-2020A](#Lepy LP-2020A)|Left|40Hz|100% Volume|88dB|
|[Lepy LP-V3S](#Lepy LP-V3S)|Left|1kHz|50% Volume|69dB|1.4V|
|[Lepy LP-V3S](#Lepy LP-V3S)|Left|1kHz|Audible Distortion|84dB|6.5V|
|[Lepy LP-V3S](#Lepy LP-V3S)|Left|1kHz|1% THD|86dB|8.7V|
|[Lepy LP-V3S](#Lepy LP-V3S)|Left|1kHz|100% Volume|90dB|10.8V|
|[Lepy LP-V3S](#Lepy LP-V3S)|Left|40Hz|50% Volume|71dB|1.1V|
|[Lepy LP-V3S](#Lepy LP-V3S)|Left|40Hz|Audible Distortion|88dB|8.4V|
|[Lepy LP-V3S](#Lepy LP-V3S)|Left|40Hz|1% THD|88dB|8.4V|
|[Lepy LP-V3S](#Lepy LP-V3S)|Left|40Hz|100% Volume|90dB|10.3V|

## Individual Breakdown

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
<tr><th>Comments</th><td>While the board itself is green instead of red, the layout looks to be identical to the [Lepai LP-2020A+]({% post_url 2020-06-30-lepai_lp-2020a+_teardown_&_testing %}). However, the components are definitely different.  For example, the Lvpin uses a single <a href="/assets/GSA-SS-212DM.pdf">GSA-SS-212DM</a> dual relay package while the [Lepai LP-2020A+]({% post_url 2020-06-30-lepai_lp-2020a+_teardown_&_testing %}) and the [Kinter K2020A+]({% post_url 2020-07-04-kinter_k2020a+_teardown_&_testing %}) both use a pair of <a href="/assets/HK4100F.pdf">HK4100F</a> single relays.
<br><br>
Doing a listening test, this amp sounds identical to the [Lepai LP-2020A+]({% post_url 2020-06-30-lepai_lp-2020a+_teardown_&_testing %}).  Power handling feels exactly the same as well.
<br><br>
While not quite as pleasing to the ear as the [Kinter K2020A+]({% post_url 2020-07-04-kinter_k2020a+_teardown_&_testing %}), it does 100% live up to the quality of its namesake and for $10 with prime delivery, you really can't go wrong.
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
Overall power on this one is not impressive. It's not as weak as the <a href="#Lepy LP-2020A">Lepy LP-2020A</a>, but it's not as strong as the [Lepai LP-2020A+]({% post_url 2020-06-30-lepai_lp-2020a+_teardown_&_testing %}). Balancing two speakers with the 2020A+ at 25%, the PFA200 is at 50%. Considering the PFA200 claims to be 3x more powerful at 60W than the 2020A+ at 20W, this is pretty sad. Also keep in mind that this "60W" amp comes with a power supply that delivers only 12.5V @2.5A or 31.25W. It's possible that this amp could be great with a 5A brick, but then again the 2020A+ is rumored to be outstanding with a 5A brick as well -- rumors being what they are.
<br><br>
As for sound quality, it's again in the middle. The clarity seems very close to the 2020A+, but it's got a little more bass and unfortunately that bass is a little muddy. If I pre-set the volumes and listened to them with a few seconds pause in between, I probably wouldn't be able to tell the difference. Listening side-by-side though, I appreciate the clarity of the 2020A+.
<br><br>
Build quality of this one seems pretty low compared to the rest. The tone button is so badly out of alignment that it barely goes in its hole. The board is slightly too narrow to fit in the support channels in the case, so the face and tail screws are the only things keeping the board from falling onto the aluminum case bottom and shorting everything out. The front and back faces feel flimsier than on the Lepai/Lvpin/Lepy versions. Overally, it just feels like the enclosure is lower quality / cheaper.
</td></tr>
</table>
