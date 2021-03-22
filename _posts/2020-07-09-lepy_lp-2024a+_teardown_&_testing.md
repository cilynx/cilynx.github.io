---
layout: post
title:  Lepy LP-2024A+ Teardown & Testing
date:   2020-07-09 07:46:15 -0700
tags:   lepy tripath hifi
---
<iframe width="560" height="315" src="https://www.youtube.com/embed/60FsNFW-lU" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

Considering the model number, I expected this one would have a Tripath [TA2024](/assets/pdfs/Tripath TA2024.pdf), but it turns to have a [TAA2008](/assets/pdfs/Tripath TAA2008.pdf).  Overall, the performance is just barely below the [Lepai LP-2020A+]({% post_url 2020-06-30-lepai_lp-2020a+_teardown_&_testing %}), but honestly it's within the margin of error.

## 1% THD @ 40Hz, JBL LX-22 Speakers

|Input Voltage|Input Current|Input Power|Volume|Output Voltage|
|---|
|12V|1.15A|13.80W|70.0dB|6.92V|
|13V|1.22A|15.86W|70.3dB|7.51V|
|14V|1.30A|18.20W|71.0dB|8.07V|

## 1% THD @ 1kHz, JBL LX-22 Speakers

|Input Voltage|Input Current|Input Power|Volume|Output Voltage|
|---|
|12V|0.73A|8.76W|109dB|7.81V|
|13V|0.79A|10.27W|110dB|8.37V|
|14V|0.85A|11.90W|109dB|9.91V|

## Specifications

|Brand|Model|Chipset|Avaliability|Claimed Input Power|
|---|
|Lepy|LP-2024A+|[Tripath TAA2008](/assets/pdfs/Tripath TAA2008.pdf)|[No longer available](https://amzn.to/2ZIDAYY)|DC12V3A|
