---
layout: post
title:  "USPpt USB-HID button board - LED colors"
tags: automotive truckputer reverse_engineering
redirect_from: "/projects/truckputer/led/"
---
## Overview

The [USB HID button board](https://rover.ebay.com/rover/1/711-53200-19255-0/1?icep_id=114&ipn=icep&toolid=20004&campid=5337311312&mpre=https%3A%2F%2Fwww.ebay.com%2Fitm%2FUSB-HID-BUTTON-BOARD-FOR-7-2-DIN-BEZEL-CASE-integrated-MIC-%2F112289690185) that I picked up on eBay has nifty colored backlights and a [really crappy Windows GUI](http://www.8838.com/soft/usb_hid_new.rar) to select Red, Blue, or Green/White.  (More on that grouping later.)  If you know me at all, you know that I'm sure not going to run Windows on my truck computer and I generally refuse to accept the Windows way of doing things, so I set out to make das blinkinlights working effectively under linux.

## Define the Data

I started by looking into the files that the Windows GUI saves. To isolate the variables, I disabled all of the keymapping cruft also availble in the utility and saved off files with the light color set to green/white, red, and blue:

```
rcw@initiative:~/Projects/ButtonBoard$ xxd green.bin 
0000000: 0000 0000 0000 0000 0000 0000 0000 0000  ................
0000010: 0000 0000 0000 0000 0000 0000 0000 0000  ................
0000020: 0000 0000 0000 0000 0000 0000 0000 0000  ................
0000030: aa01                                     ..
rcw@initiative:~/Projects/ButtonBoard$ xxd red.bin 
0000000: 0000 0000 0000 0000 0000 0000 0000 0000  ................
0000010: 0000 0000 0000 0000 0000 0000 0000 0000  ................
0000020: 0000 0000 0000 0000 0000 0000 0000 0000  ................
0000030: aa02                                     ..
rcw@initiative:~/Projects/ButtonBoard$ xxd blue.bin 
0000000: 0000 0000 0000 0000 0000 0000 0000 0000  ................
0000010: 0000 0000 0000 0000 0000 0000 0000 0000  ................
0000020: 0000 0000 0000 0000 0000 0000 0000 0000  ................
0000030: aa04                                     ..
rcw@initiative:~/Projects/ButtonBoard$
```

Well, that's pretty obvious, now isn't it? Playing with the jumper on the board, I quickly discovered that when set to "green/white" with the jumper "up", I got white lights, with it "down", I got green lights and with it off, I got no lights. More on that later. So far so good.

Next, I fired up [SniffUsb 2.0](http://www.pcausa.com/Utilities/UsbSnoop/). It claims it doesn't work on anything newer than XP, but it works fine on my AMD64 Windows 7 box. At any rate, I captured the traffic while the Windows GUI was uploading the configuration to the board's EEPROM, ran it through [usbsnoop2libusb.pl](http://lindi.iki.fi/lindi/usb/usbsnoop.txt), grepped out the data preparation statements and I got something like this:

```
rcw@initiative:~/Projects/ButtonBoard/Logs$ grep memcpy red.c 
   memcpy(buf, "\xc1\x32\x00\x00\x00\x00\x00\x00", 0x0000008);
   memcpy(buf, "\xc1\x32\x00\x00\x00\x00\x00\x00", 0x0000008);
   memcpy(buf, "\xc1\x2c\x00\x00\x00\x00\x00\x00", 0x0000008);
   memcpy(buf, "\xc1\x2c\x00\x00\x00\x00\x00\x00", 0x0000008);
   memcpy(buf, "\xc1\x26\x00\x00\x00\x00\x00\x00", 0x0000008);
   memcpy(buf, "\xc1\x26\x00\x00\x00\x00\x00\x00", 0x0000008);
   memcpy(buf, "\xc1\x20\x00\x00\x00\x00\x00\x00", 0x0000008);
   memcpy(buf, "\xc1\x20\x00\x00\x00\x00\x00\x00", 0x0000008);
   memcpy(buf, "\xc1\x1a\x00\x00\x00\x00\x00\x00", 0x0000008);
   memcpy(buf, "\xc1\x1a\x00\x00\x00\x00\x00\x00", 0x0000008);
   memcpy(buf, "\xc1\x14\x00\x00\x00\x00\x00\x00", 0x0000008);
   memcpy(buf, "\xc1\x14\x00\x00\x00\x00\x00\x00", 0x0000008);
   memcpy(buf, "\xc1\x0e\x00\x00\x00\x00\x00\x00", 0x0000008);
   memcpy(buf, "\xc1\x0e\x00\x00\x00\x00\x00\x00", 0x0000008);
   memcpy(buf, "\xc1\x08\x00\x00\x00\x00\x00\x00", 0x0000008);
   memcpy(buf, "\xc1\x08\x00\x00\x00\x00\x00\x00", 0x0000008);
   memcpy(buf, "\xc1\x02\xaa\x02\x00\x00\x00\x00", 0x0000008);
   memcpy(buf, "\xc1\x02\xaa\x02\x00\x00\x00\x00", 0x0000008);
rcw@initiative:~/Projects/ButtonBoard/Logs$
```

You should already be able to see some interesting trends. It turned out that the doubling up was an artifact of USB's tree structure and since we only care about the data and not the c-syntax, we're down to:

```
"\xc1\x32\x00\x00\x00\x00\x00\x00"
"\xc1\x2c\x00\x00\x00\x00\x00\x00"
"\xc1\x26\x00\x00\x00\x00\x00\x00"
"\xc1\x20\x00\x00\x00\x00\x00\x00"
"\xc1\x1a\x00\x00\x00\x00\x00\x00"
"\xc1\x14\x00\x00\x00\x00\x00\x00"
"\xc1\x0e\x00\x00\x00\x00\x00\x00"
"\xc1\x08\x00\x00\x00\x00\x00\x00"
"\xc1\x02\xaa\x02\x00\x00\x00\x00"
```

It should now be readily apparent that we're looking at 8-byte packets with a single byte prefix/instruction (0xC1), an address that decriments by 6-bytes on each write (0x32, 0x2C, 0x26, etc..), and 6-bytes per write worth of payload which is identical to our .bin file from the Windows GUI.

## Talking to the Device

I put together a little perl script that writes data to the button board, set the board to red using the Windows GUI, then ran the script with the data for green/white. Amazingly, the board flipped from red to white. If I moved the jumper "down", I got green as expected.

```
#!/usr/bin/env perl

use strict;
use warnings;

use Device::USB;

my $VENDOR = 0x13ec;
my $PRODUCT = 0xf2f8;
my $INTERFACE = 0;
my $ENDPOINT = 0x02;

my $usb = Device::USB->new();

my $dev = $usb->find_device($VENDOR,$PRODUCT);

$dev->open or die "Unable to open device: $!";

if($dev->get_driver_np($INTERFACE))
{
   $dev->detach_kernel_driver_np($INTERFACE);
}
$dev->claim_interface($INTERFACE) and die $!;

print "Wrote ", $dev->bulk_write($ENDPOINT, "\xc1\x32\x00\x00\x00\x00\x00\x00", 10), " blocks\n";
print "Wrote ", $dev->bulk_write($ENDPOINT, "\xc1\x2c\x00\x00\x00\x00\x00\x00", 10), " blocks\n";
print "Wrote ", $dev->bulk_write($ENDPOINT, "\xc1\x26\x00\x00\x00\x00\x00\x00", 10), " blocks\n";
print "Wrote ", $dev->bulk_write($ENDPOINT, "\xc1\x20\x00\x00\x00\x00\x00\x00", 10), " blocks\n";
print "Wrote ", $dev->bulk_write($ENDPOINT, "\xc1\x1a\x00\x00\x00\x00\x00\x00", 10), " blocks\n";
print "Wrote ", $dev->bulk_write($ENDPOINT, "\xc1\x14\x00\x00\x00\x00\x00\x00", 10), " blocks\n";
print "Wrote ", $dev->bulk_write($ENDPOINT, "\xc1\x0e\x00\x00\x00\x00\x00\x00", 10), " blocks\n";
print "Wrote ", $dev->bulk_write($ENDPOINT, "\xc1\x08\x00\x00\x00\x00\x00\x00", 10), " blocks\n";
print "Wrote ", $dev->bulk_write($ENDPOINT, "\xc1\x02\xaa\x01\x00\x00\x00\x00", 10), " blocks\n";

$dev->release_interface($INTERFACE);
```

## Taking Things Further

I tried setting blue and red as well as they also worked as expected. Cool, we have communication. That's great and all, but something was bugging me. Green/White is 1, red is 2, blue is 4. So, what's 3? (Those of you versed in binary already know where this is going.)

I configured the script for 0x03, fired it over to the board, and....Pink! Yeah, pink! Pink wasn't an option in the Windows GUI. Taking the jumper off, I got red. Moving the jumper "down", I got yellow. Interesting. Have you figured it out yet? I started testing numbers, going up by one each time and came up with the following table:

| Byte | Up | Off   | Down |
|:----:|:--:|:-----:|:----:|
|0x00  | Off    |Off    |Off|
|0x01  | White  |Off    |Green|
|0x02  | Red    |Red    |Red|
|0x03  | Pink   |Red    |Yellow|
|0x04  | Blue   |Blue   |Blue|
|0x05  | Light Blue|     Blue|    Cyan|
|0x06  | Purple |Purple |Purple|
|0x07  | Light Purple|   Purple| White|
|0x08  | Off    |Off    |Off|
|0x09  | White  |Off    |Green|
|0x0a  | Red    |Red    |Red|
|0x0b  | Pink   |Red    |Yellow|
|0x0c  | Blue   |Blue   |Blue|
|0x0d  | Light Blue|     Blue|   Cyan|
|0x0e  | Purple |Purple |Purple|
|0x0f  | Light Purple|   Purple| White|

We can see that the cycle repeats, so all we really care about is:

|Byte  | Up     |Off    |Down|
|:----:|:------:|:-----:|:---|
|0x00  | Off    |Off    |Off|
|0x01  | White  |Off    |Green|
|0x02  | Red    |Red    |Red|
|0x03  | Pink   |Red    |Yellow|
|0x04  | Blue   |Blue   |Blue|
|0x05  | Light Blue|     Blue  | Cyan|
|0x06  | Purple |Purple |Purple|
|0x07  | Light Purple|   Purple| White|

The trick should be getting obvious by this point. The pattern restarts after 8. The first 4 rows don't contain blue, but the last 4 do. Rows containing red come in pairs. Every other row contains green. Looks like a binary table to me. Let's break out our data byte and write our colors by component and see how things line up:

|Byte          |Blue |  Red  |  White/Green |   Up    | Off  |  Down|
|:------------:|:---:|:-----:|:------------:|:-------:|:----:|:----:|
|0x00 = 0b000  | 0   |   0   |   0   |   Off   | Off  |  Off|
|0x01 = 0b001  | 0   |   0   |   1   |   White | Off  |  Green|
|0x02 = 0b010  | 0   |   1   |   0   |   Red   | Red  |  Red|
|0x03 = 0b011  | 0   |   1   |   1   |   Red + White  |  Red |   Red + Green |
|0x04 = 0b100  | 1   |   0   |   0   |   Blue  | Blue    Blue|
|0x05 = 0b101  | 1   |   0   |   1   |   Blue + White |  Blue |  Blue + Green |
|0x06 = 0b110  | 1   |   1   |   0   |   Blue + Red   |  Blue + Red  |   Blue + Red|
|0x07 = 0b111  | 1   |   1   |   1   |   Blue + Red + White   |  Blue + Red  |   Blue + Red + Green|

So now, it's obvious. The most significant bit controls the blue LED, the middle bit controls the red LED, and the least significant bit controls the middle pin of the white/green jumper set. The top pin of the jumper set is the white LED and the bottom pin of the jumper set is the green LED.

By tying all three pins from the jumper set together, you can also make Light Cyan, Light Yellow, and Bright White, but I'll leave that as an exercise for the reader.

## What about all those zeros in the data?

You had to ask. They're the keymap configuration. I haven't reversed engineered it yet, but I played around a little bit with the Windows GUI and it looks like it'll be pretty easy to figure out if it ever matters. For now, I'm just mapping button functions in software given their default firmware mapping. Happy hacking!
