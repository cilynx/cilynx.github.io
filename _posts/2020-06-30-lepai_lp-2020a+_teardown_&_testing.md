---
layout: post
title:  Lepai LP-2020A+ Teardown & Testing
date:   2020-06-30 16:31:47 -0700
tags:   lepai hifi tripath
---
<iframe width="560" height="315" src="https://www.youtube.com/embed/goyDYsjpTYo" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

This is the amp that started the "cheap and tiny but actually hi-fi" amp craze.  Parts Express [claims](https://youtu.be/haBAMl22x88) (through one *very serious* spokesdude, I might add) that they discontinued the model due to the difficulty of acquiring the Tripath chips.  This is a fairly legitimate argument considering Tripath went bankrupt in 2007.  As for durability, I have a three of the original Lepai LP-2020A+ that I picked up back in 2014 that are all still going strong in 2020.  The LED on one has started flaking out, but that's about it.

## 1% THD @ 40Hz, JBL LX-22 Speakers

|Input Voltage|Input Current|Input Power|Volume|Output Voltage|
|---|
|12V|1.12A|13.44W|69.8dB|6.67V|
|13V|1.22A|15.86W|70.4dB|7.37V|
|14V|1.30A|18.20W|72.0dB|7.95V|

## 1% THD @ 1kHz, JBL LX-22 Speakers

|Input Voltage|Input Current|Input Power|Volume|Output Voltage|
|---|
|12V|0.71A|8.52W|112dB|7.51V|
|13V|0.77A|10.01W|113dB|8.13V|
|14V|0.82A|11.48W|113dB|8.69V|

<script>
const getCellValue = (tr, idx) => tr.children[idx].innerText || tr.children[idx].textContent;

const comparer = (idx, asc) => (a, b) => ((v1, v2) =>
    v1 !== '' && v2 !== '' && !isNaN(v1) && !isNaN(v2) ? v1 - v2 : v1.toString().localeCompare(v2)
    )(getCellValue(asc ? a : b, idx), getCellValue(asc ? b : a, idx));

// do the work...
document.querySelectorAll('th').forEach(th => th.addEventListener('click', (() => {
    const table = th.closest('table');
    Array.from(table.querySelectorAll('tr:nth-child(n+2)'))
        .sort(comparer(Array.from(th.parentNode.children).indexOf(th), this.asc = !this.asc))
        .forEach(tr => table.appendChild(tr) );
})));
</script>

## Specifications
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
</table>
