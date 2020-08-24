---
layout: post
title:  Kurzweil K1000 Power Supply
date:   2020-08-21 07:56:17 -0700
tags:   kurzweil k1000 synth
---
* TOC
{:toc}

# Battery

|ID|Type|+|-|Function|
|-|
|<abbr title="Not actually labeled on the board">B1</abbr>|BR-2/3A 3V|R9(B)|Digital Ground|Configuration Memory Backup|

# Capacitors

|ID|Type|+|-|Function|
|-|-|-|
|C1|22000uF Electrolytic|+8V Unregulated|Digital Ground|Smooth Input to +5V Regulator|
|C2|F104Z 25V Ceramic parallel with C1|+8V Unregulated|Digital Ground|Smooth Input to +5V Regulator|
|C3|10uF 16V|+5V Rail|Digital Ground|Smooth Output from +5V Regulator|
|C4|F104Z 25V Ceramic parallel with C3|+5V Rail|Digital Ground|Smooth Output from +5V Regulator|
|C5|2200uF 25V|+15V Unregulated|Analog Ground|Smooth Input to +12V Regulator|
|C6|F104Z 25V Ceramic parallel with C5|+15V Unregulated|Analog Ground|Smooth Input to +12V Regulator|
|C7|10uF 16V|+12V Rail|Analog Ground|Smooth Output from +12V Regulator|
|C8|F104Z 25V Ceramic parallel with C7|+12V Rail|Analog Ground|Smooth Output from +12V Regulator|
|C9|2200uF 25V|Analog Ground|-15V Unregulated|Smooth Input to -12V Regulator|
|C10|F104Z 25V Ceramic parallel with C9|Analog Ground|-15V Unregulated|Smooth Input to -12V Regulator|
|C11|10uF 16V|Analog Ground|-12V Rail|Smooth Output from -12V Regulator|
|<abbr title="Mislabeled as another C9 on the board">C12</abbr>|F104Z 25V Ceramic parallel with C11|Analog Ground|-12V Rail|Smooth Output from -12V Regulator|
|C13|10uF 16V|R11(A)|Digital Ground|Smooth R11 Input to Buffer Network|
|C14|F104Z 25V Ceramic|+5V Rail at U1(14)|Digital Ground|Smooth +5V Input to Buffer Network|

# Diodes

|ID|Type|K|A|Function|
|-|
|D1|C4P03Q|K1:J1(1), K2:J1(3)|+8V Unregulated|+5V Rectifier|
|D2|Black, T85 8-B|+15V Unregulated|J1(4)|+12V Rectifier|
|D3|Black, T85 8-B|+15V Unregulated|J1(6)|+12V Rectifier|
|D4|Black, T85 8-B|J1(6)|-15V Unregulated|-12V Rectifier|
|D5|Black, T85 8-B|J1(4)|-15V Unregulated|-12V Rectifier|
|D6|Orange Glass, Yellow Stripe|R1(B), R2(B), R7(B)|D7(A)||
|D7|Red Glass, Black Stripe, 6B|+8V Unregulated|D6(A)||
|D8|Orange Glass, Yellow Stripe|D9(K), Q4(C)|+5V Rail||
|D9|Clear Glass, Red Stripe|D8(K), Q4(C)|R9(A)|||

# Fuses

|ID|Type|Function|
|-|
|F1|5A 125V Fuse|Protect +5V Rail|
|F2|500mA 125V Fuse|Protect +12V Rail|
|F3|500mA 125V Fuse|Protect -12V Rail|

# Headers

|ID|Type|Function|
|-|
|J1|6-Pin Molex KK-396|AC Input from Transformer|
|J2|10-Pin Molex KK-396|Connection to CPU Board|
|J4|13-Pin Molex KK-254|Connection to Audio Board|

|J1 Pin|Function|
|-|
|1|8 Vac (0-deg)|
|2|Digital Ground|
|3|8 Vac (180-deg)|
|4|15 Vac (0-deg)|
|5|Analog Ground|
|6|15 Vac (180-deg)|

|J2 Pin(s)|J4 Pin(s)|Function|
|-|
|1|1|Backup Battery|
|2|2|Power OK|
|3|3|Reset|
|4,5|4,5|Digital Ground|
|6,7|6,7|+5V|
|8|8,9|+12V|
|9|10,11|Analog Ground|
|10|12,13|-12V|

# Integrated Circuits

|ID|Type|Function|
|-|
|U1|74HCU04|Hex Inverter used as buffer array|
|U2|3052V|+5V Regulator|
|U3|7812|+12V Regulator|
|U4|7912|-12V Regulator|

## +5V Regulator (3052V)

|Pin|Connection|
|-|
|Input|+8V Unregulated|
|Output|+5V Rail|
|Ground|Digital Ground|

## +12V Regulator (7812)

|Pin|Connection|
|-|
|Input|+15V Unregulated|
|Output|+12V Rail|
|Ground|Analog Ground|

## -12V Regulator (7912)

|Pin|Connection|
|-|
|Input|-15V Unregulated|
|Output|-12V Rail|
|Ground|Analog Ground|

## Hex Inverter / Buffer Array (74HCU04)

The hex inverter is used as a buffer array with a voltage divider (R5 & R6) providing hysteresis to avoid flapping the reset signal as the analog voltage input comes online.  

You can find a good explanation of the concept [on StackExchange](https://electronics.stackexchange.com/questions/430912/what-is-the-purpose-of-a-resistor-in-parallel-with-a-buffer-gate).

Only five of the six inverters are used.  Pins 12 & 13 are not part of the buffer array.

|Pin|Connection|Function|Hypothetical Value|
|-|
|U1(1)|C13(+), R11(A)|Input for Pin 2 (1A)|1 (System Input)|
|U1(2)|R5(B)|Invert Pin 1 (1Y)|0 (Invert P1)|
|U1(3)|R6(B), R5(T)|Input for Pin 4 (2A)|0 (Same as P2 through R5)|
|U1(4)|Pin 5|Invert Pin 3 (2Y)|1 (Invert P3)|
|U1(5)|Pin 4|Input for Pin 6 (3A)|1 (Same as P4)|
|U1(6)|Pin 11, R6(T)|Invert Pin 5 (3Y)|0 (Invert P5, Same as P3 through R6)|
|U1(7)|Digital Ground|GND|
|U1(8)|Reset Signal Output|Invert Pin 9 (4Y)|0 (Invert P9, System Output)|
|U1(9)|Pin 10|Input for Pin 8 (4A)|1 (Same as P10)|
|U1(10)|Pin 9|Invert Pin 11 (5Y)|1 (Invert P11)|
|U1(11)|Pin 6, R6(T)|Input for Pin 10 (5A)|0 (Same as P6, Same as P3 through R6)|
|U1(12)|[None]|Invert Pin 13 (6Y)|
|U1(13)|+5V Rail|Input for Pin 12 (6A)|
|U1(14)|+5V Rail|Vcc|

# Resistors

|ID|A|B|Function|
|-|
|R1|Digital Ground|R2(B), R7(B), D6(K)|
|R2|Q1(B)|R1(B), R7(B), D6(K)|
|R3|Q1(C), Q2(B)|+8V Unregulated, D7(K)|
|R4|R11(B), Q2(C)|+5V Rail|
|R5|||Voltage Divider to add hysteresis to buffer network|
|R6|||Voltage Divider to add hysteresis to buffer network|
|R7|Q3(B)|R1(B), R2(B), D6(K)|
|R8|Q3(C)|Q4(B)|
|R9|D9(A)|B1(+)|
|R10|Analog Ground|Digital Ground|
|R11|C13(+), U1(1)|R4(A), Q2(C)|

# Transistors

|ID|Type|B|C|E|
|-|
|Q1|C1815 NPN|R2(A)|R3(A),Q2(B)|Digital Ground|
|Q2|C1815 NPN|R3(A),Q1(C)|R4(A),R11(B)|Digital Ground|
|Q3|C1815 NPN|R7(A)|R8(A), Power OK Signal|Digital Ground|
|Q4|A1015 PNP|R8(B)|D8(K), D9(K)|+5V Rail|
