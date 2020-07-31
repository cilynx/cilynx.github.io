---
layout: post
title:  Kinter K2020A+ Teardown & Testing
date:   2020-07-04 10:04:43 -0700
tags:   kinter tripath hifi
---
<iframe width="560" height="315" src="https://www.youtube.com/embed/jLqJSh1GsVc" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
The board is laid out almost identically to the [Lepai LP-2020A+]({% post_url 2020-06-30-lepai_lp-2020a+_teardown_&_testing %}), however if you look closely at the traces and component positioning/labels, you can see that it was re-laid-out and is not an exact copy.

Power handling is just barely better than the [Lepai LP-2020A+]({% post_url 2020-06-30-lepai_lp-2020a+_teardown_&_testing %}) as well.  The surprising part for me is that this amp actually sounds better -- yes, better than its namesake.  Specifically, it's noticeably more clear / articulate.  Listening to Daft Punk's Solar Sailor, this amp brings through more texture in the eighth-note beat from the beginning and more depth and presence when the ambient tones come in around the 1-minute mark.

It's worth noting that the Kinter's over-voltage protection is a bit more zealous than the others.  Running it over-voltage, the Kinter's LED lights up, but the amp itself stays off -- no sound at all.  If you slowly increase the voltage, you can hear the over-voltage protection trip at 12.5V.  The Kinter's included power supply puts out a measured 12.29V.

Overall, I would say if you're looking for the best sounding cheap amp, this is the one to get.  For 1/2 of the cost, though, you can get the [Lvpin LP-2020A+]({% post_url 2018-01-27-mini_hifi_bakeoff %}#Lvpin LP-2020A+) which sounds identical to the original/unobtainable [Lepai LP-2020A+]({% post_url 2020-06-30-lepai_lp-2020a+_teardown_&_testing %}) to my untrained ears.

## 1% THD @ 40Hz, JBL LX-22 Speakers

|Input Voltage|Input Current|Input Power|Volume|Output Voltage|
|---|
|12V|1.3A|15.6W|73dB|8.4V|

## 1% THD @ 1kHz, JBL LX-22 Speakers

|Input Voltage|Input Current|Input Power|Volume|Output Voltage|
|---|
|12V|0.77A|9.24W|112dB|8.65V|

## Specifications
<table>
<tr><th>Brand</th><td>Kinter</td></tr>
<tr><th>Model</th><td>K2020A+</td></tr>
<tr><th>Manual</th><td><a href="/assets/Kinter K2020A+ - Manual.pdf">Kinter K2020A+ Operating Manual</a></td></tr>
<tr><th>Amplifier Chip</th><td><a href="/assets/Tripath TA2020-020.pdf">Tripath TA2020-020</a></td></tr>
<tr><th>Availability</th><td><a href="https://amzn.to/2k4JAqx">~$40 on Amazon</a></td></tr>
<tr><th>Face Text</th><td>Kinter<sup>&reg;</sup> LIMITED EDITION TRIPATH K2020A+</td></tr>
<tr><th>Board Text</th><td>KINTER<sup>&reg;</sup> K2020A+ China 2017/10/8</td></tr>
<tr><th>Right Channel</th><td>Top White Jack</td></tr>
<tr><th>Left Channel</th><td>Bottom Red Jack</td></tr>
<tr><th>Input Power Label</th><td>DC12V5A</td></tr>
<tr><th>Included Power Supply</th><td>TH-120500 12V/5A</td></tr>
<tr><th>Front</th><td><img src="/assets/Kinter K2020A+ - Naked Front.png"></td></tr>
<tr><th>Top</th><td><img src="/assets/Kinter K2020A+ - Naked Top.png"></td></tr>
<tr><th>Back</th><td><img src="/assets/Kinter K2020A+ - Naked Back.png"></td></tr>
</table>
