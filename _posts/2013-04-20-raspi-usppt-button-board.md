---
layout: post
title:  "Raspberry Pi with USPpt USB-HID button board"
tags: raspberry_pi automotive truckputer reverse_engineering
last_modified_at: 2014-03-01
redirect_from: "/projects/raspi/usppt/"
---
## Overview

As part of the [truckputer project](/truckputer/), I picked up a [double din touchscreen cage](https://rover.ebay.com/rover/1/711-53200-19255-0/1?icep_id=114&ipn=icep&toolid=20004&campid=5337311312&mpre=https%3A%2F%2Fwww.ebay.com%2Fitm%2F121058156106%3FrmvSB%3Dtrue) and a little addon [USB HID button board](https://rover.ebay.com/rover/1/711-53200-19255-0/1?icep_id=114&ipn=icep&toolid=20004&campid=5337311312&mpre=https%3A%2F%2Fwww.ebay.com%2Fitm%2FUSB-HID-BUTTON-BOARD-FOR-7-2-DIN-BEZEL-CASE-integrated-MIC-%2F112289690185) which drives five of the six physical buttons on the left side of the screen. The power button in the upper left is a momentary switch with a header. I haven't really decided what I'm going to do with it as my soft power up and down are going to be triggered by ACC power as opposed to a physical switch. Maybe I'll run it to the reset switch.

![back of board](/assets/0c2e9fec68f8a2ef722e7a6b8e136e3b.png)
![screen](/assets/32d27f56ccfcbd53c1b13f08668ae686.png)

Looking at the back of the board, from left to right we have:

* Power button header
* [Backlight color]({% post_url 2014-03-04-usppt-led-colors %}) selection jumper (1-2 == white, 2-3 == green)
* USB header
* Microphone header

The microphone header is likely connected to the traces on the board, but as you can see in the picture, there actually isn't a microphone. Apparently, the mic sounded like crap here, so they took it out. I was planning on using an external mic anyway, so this isn't a big deal for me.

## Just make it work

So you just want it to work and you don't care why. Make a new file called `/etc/udev/rules.d/99-usppt-usb-touch.rules` and stick the following in it:

```
KERNEL=="hidraw*", ATTRS{idVendor}=="13ec", ATTRS{idProduct}=="f2f8", RUN+="/bin/sh -c 'echo 1 > /dev/%k'"
```

Edit your `~/.config/openbox/lxde-rc.xml` and add the following after all of the rest of the keybindings:

```
<!-- Keybindings for Button Board -->
<keybind key="A-C-n">
  <action name="Execute">
    <command>zenity --timeout=1 --notification --text="Triangle"</command>
  </action>                                                           
</keybind>                                                            
<keybind key="A-C-x">
  <action name="Execute">
    <command>zenity --timeout=1 --notification --text="Square"</command>
  </action>                                                         
</keybind>                                                          
<keybind key="A-C-m">
  <action name="Execute">
    <command>zenity --timeout=1 --notification --text="Cross"</command>
  </action>                                                        
</keybind>                                                         
<keybind key="A-C-2">
  <action name="Execute">
    <command>zenity --timeout=1 --notification --text="Up Arrow"</command>
  </action>                                                           
</keybind>                                                            
<keybind key="XF86AudioMute">
  <action name="Execute">
    <command>zenity --timeout=1 --notification --text="Down Arrow"</command>
  </action>                                                             
</keybind>
```

You will of course want to replace the zenity notifications that I stuck in there with actual useful commands. For example, in my live system, the action for the Triangle button is defined as `<command>navit</command>` with a profile in the background that tells navit to launch full-screen.

After you have everything setup the way you want it, reboot your Pi and you'll be good to go.

## Why does it work?

When I first plugged this thing in, it showed up right away as a USB keyboard, but didn't actually do anything when I pushed the buttons.

```
Apr 20 05:30:04 raspberrypi kernel: [ 4448.765541] usb 1-1.3.4: new low-speed USB device number 12 using dwc_otg
Apr 20 05:30:04 raspberrypi kernel: [ 4448.870737] usb 1-1.3.4: New USB device found, idVendor=13ec, idProduct=f2f8
Apr 20 05:30:04 raspberrypi kernel: [ 4448.870770] usb 1-1.3.4: New USB device strings: Mfr=1, Product=2, SerialNumber=0
Apr 20 05:30:04 raspberrypi kernel: [ 4448.870787] usb 1-1.3.4: Product: USB TOUCH
Apr 20 05:30:04 raspberrypi kernel: [ 4448.870800] usb 1-1.3.4: Manufacturer: USPpt
Apr 20 05:30:04 raspberrypi kernel: [ 4448.888554] input: USPpt USB TOUCH as /devices/platform/bcm2708_usb/usb1/1-1/1-1.3/1-1.3.4/1-1.3.4:1.0/input/input3
Apr 20 05:30:04 raspberrypi kernel: [ 4448.890942] hid-generic 0003:13EC:F2F8.0003: input,hidraw1: USB HID v1.10 Keyboard [USPpt USB TOUCH] on usb-bcm2708_usb-1.3.4/input0
Apr 20 05:30:04 raspberrypi kernel: [ 4448.892070] usbhid 1-1.3.4:1.1: couldn't find an input interrupt endpoint
```

Initially, I thought that `input interrupt endpoint` error was going to be the culpret, but that turned out to be a wild goose chase. Since the Pi has a bunch of known USB issues, I decided to take it out of the equation to start with and plugged the button board into my AMD laptop. My laptop recognized the board immediately and [<code>xev(1)</code>](http://www.xfree86.org/current/xev.1.html) gave me output that showed it was being recognized as a keyboard. Amusingly, my laptop toggled Mute status whenever I pressed the Down Arrow on the button board -- this is explained later. Most importantly, the laptop also had that `input interrupt endpoint` error.

```
usb 4-1: new low-speed USB device number 12 using ohci_hcd
usb 4-1: New USB device found, idVendor=13ec, idProduct=f2f8
usb 4-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 4-1: Product: USB TOUCH
usb 4-1: Manufacturer: USPpt
input: USPpt USB TOUCH as /devices/pci0000:00/0000:00:12.0/usb4/4-1/4-1:1.0/input/input24
generic-usb 0003:13EC:F2F8.001E: input,hidraw1: USB HID v1.10 Keyboard [USPpt USB TOUCH] on usb-0000:00:12.0-1/input0
usbhid 4-1:1.1: couldn't find an input interrupt endpoint
```

The other cool thing I noticed when hooked up to the laptop was that the buttons on the button board lit up brighter when I pressed them. They didn't do that when hooked up to the Pi. Interesting. So, I figured maybe this thing actually does some sort of bidirectional communication. I have no idea why my Laptop would initialize it and the Pi wouldn't, so I checked out the `hidraw` devices and found that `/div/hidraw0` spit out garbage when playing with the touchscreen, but `/dev/hidraw1` didn't do anything no matter what I tried.

From there, I figured I'd start shoving data at the button board to see what it would do. The first thing I tried was `echo 1 > /dev/hidraw1` -- and to my amazement, the buttons started lighting up when I pressed them. Yeah, it was actually that easy.

From there, [<code>xev(1)</code>](http://www.xfree86.org/current/xev.1.html) on the Pi gave me the info I needed to actually act on button presses. I pressed the buttons one after the other, starting at the top:

```
KeyPress event, serial 43, synthetic NO, window 0x1a00001,
    root 0x43, subw 0x0, time 48249420, (167,-14), root:(718,254),
    state 0x0, keycode 37 (keysym 0xffe3, Control_L), same_screen YES,
    XLookupString gives 0 bytes:
    XmbLookupString gives 0 bytes:
    XFilterEvent returns: False

KeyPress event, serial 43, synthetic NO, window 0x1a00001,
    root 0x43, subw 0x0, time 48249420, (167,-14), root:(718,254),
    state 0x4, keycode 64 (keysym 0xffe9, Alt_L), same_screen YES,
    XLookupString gives 0 bytes:
    XmbLookupString gives 0 bytes:
    XFilterEvent returns: False

KeyPress event, serial 43, synthetic NO, window 0x1a00001,
    root 0x43, subw 0x0, time 48249420, (167,-14), root:(718,254),
    state 0xc, keycode 57 (keysym 0x6e, n), same_screen YES,
    XLookupString gives 1 bytes: (0e) "^N"
    XmbLookupString gives 1 bytes: (0e) "^N"
    XFilterEvent returns: False

KeyRelease event, serial 46, synthetic NO, window 0x1a00001,
    root 0x43, subw 0x0, time 48249429, (167,-14), root:(718,254),
    state 0xc, keycode 37 (keysym 0xffe3, Control_L), same_screen YES,
    XLookupString gives 0 bytes:
    XFilterEvent returns: False

KeyRelease event, serial 46, synthetic NO, window 0x1a00001,
    root 0x43, subw 0x0, time 48249429, (167,-14), root:(718,254),
    state 0x8, keycode 64 (keysym 0xffe9, Alt_L), same_screen YES,
    XLookupString gives 0 bytes:
    XFilterEvent returns: False

KeyRelease event, serial 46, synthetic NO, window 0x1a00001,
    root 0x43, subw 0x0, time 48249429, (167,-14), root:(718,254),
    state 0x0, keycode 57 (keysym 0x6e, n), same_screen YES,
    XLookupString gives 1 bytes: (6e) "n"
    XFilterEvent returns: False

KeyPress event, serial 46, synthetic NO, window 0x1a00001,
    root 0x43, subw 0x0, time 48251821, (167,-14), root:(718,254),
    state 0x0, keycode 37 (keysym 0xffe3, Control_L), same_screen YES,
    XLookupString gives 0 bytes:
    XmbLookupString gives 0 bytes:
    XFilterEvent returns: False

KeyPress event, serial 46, synthetic NO, window 0x1a00001,
    root 0x43, subw 0x0, time 48251821, (167,-14), root:(718,254),
    state 0x4, keycode 64 (keysym 0xffe9, Alt_L), same_screen YES,
    XLookupString gives 0 bytes:
    XmbLookupString gives 0 bytes:
    XFilterEvent returns: False

KeyPress event, serial 46, synthetic NO, window 0x1a00001,
    root 0x43, subw 0x0, time 48251821, (167,-14), root:(718,254),
    state 0xc, keycode 53 (keysym 0x78, x), same_screen YES,
    XLookupString gives 1 bytes: (18) "^X"
    XmbLookupString gives 1 bytes: (18) "^X"
    XFilterEvent returns: False

KeyRelease event, serial 46, synthetic NO, window 0x1a00001,
    root 0x43, subw 0x0, time 48251829, (167,-14), root:(718,254),
    state 0xc, keycode 37 (keysym 0xffe3, Control_L), same_screen YES,
    XLookupString gives 0 bytes:
    XFilterEvent returns: False

KeyRelease event, serial 46, synthetic NO, window 0x1a00001,
    root 0x43, subw 0x0, time 48251829, (167,-14), root:(718,254),
    state 0x8, keycode 64 (keysym 0xffe9, Alt_L), same_screen YES,
    XLookupString gives 0 bytes:
    XFilterEvent returns: False

KeyRelease event, serial 46, synthetic NO, window 0x1a00001,
    root 0x43, subw 0x0, time 48251829, (167,-14), root:(718,254),
    state 0x0, keycode 53 (keysym 0x78, x), same_screen YES,
    XLookupString gives 1 bytes: (78) "x"
    XFilterEvent returns: False

KeyPress event, serial 46, synthetic NO, window 0x1a00001,
    root 0x43, subw 0x0, time 48253965, (167,-14), root:(718,254),
    state 0x0, keycode 37 (keysym 0xffe3, Control_L), same_screen YES,
    XLookupString gives 0 bytes:
    XmbLookupString gives 0 bytes:
    XFilterEvent returns: False

KeyPress event, serial 46, synthetic NO, window 0x1a00001,
    root 0x43, subw 0x0, time 48253965, (167,-14), root:(718,254),
    state 0x4, keycode 64 (keysym 0xffe9, Alt_L), same_screen YES,
    XLookupString gives 0 bytes:
    XmbLookupString gives 0 bytes:
    XFilterEvent returns: False

KeyPress event, serial 46, synthetic NO, window 0x1a00001,
    root 0x43, subw 0x0, time 48253965, (167,-14), root:(718,254),
    state 0xc, keycode 58 (keysym 0x6d, m), same_screen YES,
    XLookupString gives 1 bytes: (0d) "^M"
    XmbLookupString gives 1 bytes: (0d) "^M"
    XFilterEvent returns: False

KeyRelease event, serial 46, synthetic NO, window 0x1a00001,
    root 0x43, subw 0x0, time 48253973, (167,-14), root:(718,254),
    state 0xc, keycode 37 (keysym 0xffe3, Control_L), same_screen YES,
    XLookupString gives 0 bytes:
    XFilterEvent returns: False

KeyRelease event, serial 46, synthetic NO, window 0x1a00001,
    root 0x43, subw 0x0, time 48253973, (167,-14), root:(718,254),
    state 0x8, keycode 64 (keysym 0xffe9, Alt_L), same_screen YES,
    XLookupString gives 0 bytes:
    XFilterEvent returns: False

KeyRelease event, serial 46, synthetic NO, window 0x1a00001,
    root 0x43, subw 0x0, time 48253973, (167,-14), root:(718,254),
    state 0x0, keycode 58 (keysym 0x6d, m), same_screen YES,
    XLookupString gives 1 bytes: (6d) "m"
    XFilterEvent returns: False

KeyPress event, serial 46, synthetic NO, window 0x1a00001,
    root 0x43, subw 0x0, time 48256053, (167,-14), root:(718,254),
    state 0x0, keycode 37 (keysym 0xffe3, Control_L), same_screen YES,
    XLookupString gives 0 bytes:
    XmbLookupString gives 0 bytes:
    XFilterEvent returns: False

KeyPress event, serial 46, synthetic NO, window 0x1a00001,
    root 0x43, subw 0x0, time 48256053, (167,-14), root:(718,254),
    state 0x4, keycode 64 (keysym 0xffe9, Alt_L), same_screen YES,
    XLookupString gives 0 bytes:
    XmbLookupString gives 0 bytes:
    XFilterEvent returns: False

KeyPress event, serial 46, synthetic NO, window 0x1a00001,
    root 0x43, subw 0x0, time 48256053, (167,-14), root:(718,254),
    state 0xc, keycode 11 (keysym 0x32, 2), same_screen YES,
    XLookupString gives 1 bytes: (00) ""
    XmbLookupString gives 1 bytes: (00) ""
    XFilterEvent returns: False

KeyRelease event, serial 46, synthetic NO, window 0x1a00001,
    root 0x43, subw 0x0, time 48256061, (167,-14), root:(718,254),
    state 0xc, keycode 37 (keysym 0xffe3, Control_L), same_screen YES,
    XLookupString gives 0 bytes:
    XFilterEvent returns: False

KeyRelease event, serial 46, synthetic NO, window 0x1a00001,
    root 0x43, subw 0x0, time 48256061, (167,-14), root:(718,254),
    state 0x8, keycode 64 (keysym 0xffe9, Alt_L), same_screen YES,
    XLookupString gives 0 bytes:
    XFilterEvent returns: False

KeyRelease event, serial 46, synthetic NO, window 0x1a00001,
    root 0x43, subw 0x0, time 48256061, (167,-14), root:(718,254),
    state 0x0, keycode 11 (keysym 0x32, 2), same_screen YES,
    XLookupString gives 1 bytes: (32) "2"
    XmbLookupString gives 1 bytes: (00) ""
    XFilterEvent returns: False

KeyRelease event, serial 46, synthetic NO, window 0x1a00001,
    root 0x43, subw 0x0, time 48256061, (167,-14), root:(718,254),
    state 0xc, keycode 37 (keysym 0xffe3, Control_L), same_screen YES,
    XLookupString gives 0 bytes:
    XFilterEvent returns: False

KeyRelease event, serial 46, synthetic NO, window 0x1a00001,
    root 0x43, subw 0x0, time 48256061, (167,-14), root:(718,254),
    state 0x8, keycode 64 (keysym 0xffe9, Alt_L), same_screen YES,
    XLookupString gives 0 bytes:
    XFilterEvent returns: False

KeyRelease event, serial 46, synthetic NO, window 0x1a00001,
    root 0x43, subw 0x0, time 48256061, (167,-14), root:(718,254),
    state 0x0, keycode 11 (keysym 0x32, 2), same_screen YES,
    XLookupString gives 1 bytes: (32) "2"
    XFilterEvent returns: False
```

The only thing we really care about out of all that crap is the keysym, so let's focus on that and see if this starts making sense.

```
state 0x0, keycode 37 (keysym 0xffe3, Control_L), same_screen YES,
state 0x4, keycode 64 (keysym 0xffe9, Alt_L), same_screen YES,
state 0xc, keycode 57 (keysym 0x6e, n), same_screen YES,
state 0xc, keycode 37 (keysym 0xffe3, Control_L), same_screen YES,
state 0x8, keycode 64 (keysym 0xffe9, Alt_L), same_screen YES,
state 0x0, keycode 57 (keysym 0x6e, n), same_screen YES,
state 0x0, keycode 37 (keysym 0xffe3, Control_L), same_screen YES,
state 0x4, keycode 64 (keysym 0xffe9, Alt_L), same_screen YES,
state 0xc, keycode 53 (keysym 0x78, x), same_screen YES,
state 0xc, keycode 37 (keysym 0xffe3, Control_L), same_screen YES,
state 0x8, keycode 64 (keysym 0xffe9, Alt_L), same_screen YES,
state 0x0, keycode 53 (keysym 0x78, x), same_screen YES,
state 0x0, keycode 37 (keysym 0xffe3, Control_L), same_screen YES,
state 0x4, keycode 64 (keysym 0xffe9, Alt_L), same_screen YES,
state 0xc, keycode 58 (keysym 0x6d, m), same_screen YES,
state 0xc, keycode 37 (keysym 0xffe3, Control_L), same_screen YES,
state 0x8, keycode 64 (keysym 0xffe9, Alt_L), same_screen YES,
state 0x0, keycode 58 (keysym 0x6d, m), same_screen YES,
state 0x0, keycode 37 (keysym 0xffe3, Control_L), same_screen YES,
state 0x4, keycode 64 (keysym 0xffe9, Alt_L), same_screen YES,
state 0xc, keycode 11 (keysym 0x32, 2), same_screen YES,
state 0xc, keycode 37 (keysym 0xffe3, Control_L), same_screen YES,
state 0x8, keycode 64 (keysym 0xffe9, Alt_L), same_screen YES,
state 0x0, keycode 11 (keysym 0x32, 2), same_screen YES,
state 0x0, keycode 121 (keysym 0x1008ff12, XF86AudioMute), same_screen YES,
```

Awesome! Now we're getting somewhere.

|![Power](/assets/e5302338592987bfed828696d6041292.png)|Power|N/A|
|![Triangle](/assets/aeb1fe21c858b805d78aa0e2269d7f67.png)|Triangle|Control-Alt-n|
|![Square](/assets/489ae8f86d3a0e7193a963ceeb0a6802.png)|Square|Control-Alt-x|
|![Cross](/assets/89f480673e87bc0e464025fad7fe6d4d.png)|Cross|Control-Alt-m|
|![Up](/assets/8490e0628a36e023eced97b3818b495d.png)|Up|Control-Alt-2|
|![Down](/assets/8f9c61504b87796173448d0ca34ffcaa.png)|Down|XF86AudioMute|

Why in the world the developers of this button board decided to go with `n, x, m, 2, Mute` I have absolutely no idea. From here, you can add the buttons to your hotkey configs using your method of choice. For default Raspbian, you've probably already followed the instructions at the top of the page.

It's great that we have this working now, but we probably want to keep it working over reboots and unplugging / replugging the button board into the Pi. To do that, we need a `udev` rule to initialize our button board wherever it happens to land.

To do that, we're going to need to know a little more about our device. Remember the `syslog` entry from when we plugged in the device? Let's look at that again:

```
Apr 20 05:30:04 raspberrypi kernel: [ 4448.765541] usb 1-1.3.4: new low-speed USB device number 12 using dwc_otg
Apr 20 05:30:04 raspberrypi kernel: [ 4448.870737] usb 1-1.3.4: New USB device found, idVendor=13ec, idProduct=f2f8
Apr 20 05:30:04 raspberrypi kernel: [ 4448.870770] usb 1-1.3.4: New USB device strings: Mfr=1, Product=2, SerialNumber=0
Apr 20 05:30:04 raspberrypi kernel: [ 4448.870787] usb 1-1.3.4: Product: USB TOUCH
Apr 20 05:30:04 raspberrypi kernel: [ 4448.870800] usb 1-1.3.4: Manufacturer: USPpt
Apr 20 05:30:04 raspberrypi kernel: [ 4448.888554] input: USPpt USB TOUCH as /devices/platform/bcm2708_usb/usb1/1-1/1-1.3/1-1.3.4/1-1.3.4:1.0/input/input3
Apr 20 05:30:04 raspberrypi kernel: [ 4448.890942] hid-generic 0003:13EC:F2F8.0003: input,hidraw1: USB HID v1.10 Keyboard [USPpt USB TOUCH] on usb-bcm2708_usb-1.3.4/input0
Apr 20 05:30:04 raspberrypi kernel: [ 4448.892070] usbhid 1-1.3.4:1.1: couldn't find an input interrupt endpoint
```

The two highlighted values tell us everything we need to know to fire a udev action when this device is plugged in. We pick a nice high number so the script runs after everything else and use `/bin/sh -c` a) because we have to use complete paths otherwise udev looks under `/lib/` and because udev doesn't handle output redirection ($ command > devicename) on its own.

```
KERNEL=="hidraw*", ATTRS{idVendor}=="13ec", ATTRS{idProduct}=="f2f8", RUN+="/bin/sh -c 'echo 1 > /dev/%k'"
```

Really, that's all there is to it. Once you've got it setup, the button board will initialize when it needs to and can easly launch anything you can think of. Happy hacking!

## References

* [media keys in openbox](http://crunchbang.org/forums/viewtopic.php?id=5114)
* [Openbox Wiki -- Help:Bindings](http://openbox.org/wiki/Help:Bindings)
* [Quering device with udevinfo and udevadm](http://ekuric.wordpress.com/2012/03/25/quering-device-with-udevinfo-and-udeadm/)
* [How to run custom scripts upon USB device plug-in?](http://unix.stackexchange.com/questions/28548/how-to-run-custom-scripts-upon-usb-device-plug-in)
* [<code>udev(8)</code>](http://linux.die.net/man/8/udev)
* [Udev rule is not being used?](http://unix.stackexchange.com/questions/40387/udev-rule-is-not-being-used)

