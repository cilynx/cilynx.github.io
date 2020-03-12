---
layout: post
title:  Pentair RS-485 Manual RPM
date:   2019-02-05 18:07:02 -0800
tags:   reverse_engineering pool raspberry_pi rs-485
---
Given how the other areas went, I expected sorting out manual RPM to be pretty straightforward.  However, this page wouldn't exist if that were the case.  I started out by diffing a couple brute dumps after setting the RPM using my trusty `[0x02, 0xC4]` that I've been using for some time.  I expected the diff to show me a change in `[2, 6]` (current rpm), `[2, 10]` (current watts), `[1, 254]` (dunno), and `[2, 196]` (`[0x02, 0xC4]`).  Here's what I got:
```
--- output-manual-1500	2019-02-05 18:00:48.114299893 -0800
+++ output-manual-1600	2019-02-05 18:01:21.434039422 -0800
@@ -46,3 +46,3 @@
-0x2 | [1, 254] | ['0x1', '0xfe'] | 0x2 | [219, 0] | ['0xdb', '0x0'] | 56064
-0x2 | [2, 6] | ['0x2', '0x6'] | 0x2 | [5, 220] | ['0x5', '0xdc'] | 1500
-0x2 | [2, 10] | ['0x2', '0xa'] | 0x2 | [0, 229] | ['0x0', '0xe5'] | 229
+0x2 | [1, 254] | ['0x1', '0xfe'] | 0x2 | [220, 0] | ['0xdc', '0x0'] | 56320
+0x2 | [2, 6] | ['0x2', '0x6'] | 0x2 | [6, 64] | ['0x6', '0x40'] | 1600
+0x2 | [2, 10] | ['0x2', '0xa'] | 0x2 | [1, 19] | ['0x1', '0x13'] | 275
@@ -62 +62 @@
-0x2 | [2, 196] | ['0x2', '0xc4'] | 0x2 | [5, 220] | ['0x5', '0xdc'] | 1500
+0x2 | [2, 196] | ['0x2', '0xc4'] | 0x2 | [6, 64] | ['0x6', '0x40'] | 1600
@@ -80 +80 @@
-0x2 | [3, 39] | ['0x3', '0x27'] | 0x2 | [5, 220] | ['0x5', '0xdc'] | 1500
+0x2 | [3, 39] | ['0x3', '0x27'] | 0x2 | [6, 64] | ['0x6', '0x40'] | 1600
@@ -155 +155 @@
-0x2 | [3, 187] | ['0x3', '0xbb'] | 0x2 | [5, 220] | ['0x5', '0xdc'] | 1500
+0x2 | [3, 187] | ['0x3', '0xbb'] | 0x2 | [6, 64] | ['0x6', '0x40'] | 1600
```
In the real world, the pump spooled up to 1500 and then 1600 rpm as expected.  What I didn't expect is that it also updated the RPM value for [Program 1]({% post_url 2019-02-05-pentair_rs-485_external_programs %}#getting-and-setting-program-rpm).  Maybe it clobbers the last run Program?  Nope, I last ran Program 3.

Given what seems to work with other parameters if `[2, 6]` is the read address for current RPM, it's probably the set address as well, so let's try that and run another diff:
