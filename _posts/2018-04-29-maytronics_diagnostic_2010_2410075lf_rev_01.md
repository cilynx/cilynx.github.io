---
layout: post
title:  Maytronics Diagnostic 2010 2410075LF Rev 01
date:   2018-04-29 11:47:17 -0700
tags:   maytronics pool embedded_systems reverse_engineering atmel jtag
---
## Test Points

|TP2||
|TP3||
|TP4||
|TP5|Power In (J5) No Connection|
|TP6|Power In (J5) Ground (Black)|
|TP7|Power In (J5) Floating (Red)|
|TP8|Power In (J5) +30V (White)|
|TP9|Impeller Motor Ground|
|TP10|Impeller Motor Ground|

## Connectors

|J1|JTAG|
|J2|SPI|
|J3|Impeller Motor|
|J4|Drive Motor|
|J5|Power In|


### SPI (ISP / ISCP)

|MISO|1|&#9632;|&#9679;|2|VCC|
|SCK|3|&#9679;|&#9679;|4|MOSI|
|RST|5|&#9679;|&#9679;|6|GND|

### AVR JTAG 

|TCK|1|&#9632;|&#9679;|2|GND|
|TDO|3|&#9679;|&#9679;|4|VTG|
|TMS|5|&#9679;|&#9679;|6|nSRST|
|VTG|7|&#9679;|&#9679;|8|nTRST|
|TDI|9|&#9679;|&#9679;|10|GND|

[The source of truth](https://www.microchip.com/webdoc/GUID-DDB0017E-84E3-4E77-AAE9-7AC4290E5E8B/index.html?GUID-27BF3A3E-B61E-485F-8816-EBB7F5642827)

## Integrated Circuits

|U1|HC14AG|[Hex Schmitt-Trigger Inverter](https://www.onsemi.com/pub/Collateral/MC74HC14A-D.PDF)|
|U2|HC02AG|[Quad 2-Input NOR Gate](https://www.onsemi.com/pub/Collateral/MC74HC02A-D.PDF)|
|U3|ATmega16A|[8-bit Microcontroller](http://ww1.microchip.com/downloads/en/DeviceDoc/Atmel-8154-8-bit-AVR-ATmega16A_Datasheet.pdf)|
|U4|737MT|Unknown 6-pin. Looks like a clock.|
|U5|GZSD625|Unknown 14-pin|
|U6|TS34063|[DC to DC Converter Controller](http://www.taiwansemi.com/products/datasheet/TS34063_B13.pdf)|
|U7|F XG15B|Unknown 8-pin|
|U8|BTM7710G|[Quad D-MOS Switch Driver](https://www.infineon.com/dgdl/Infineon-BTM7710G-DS-v01_00-en.pdf?fileId=db3a30431add1d95011aedf960bb0349)|
|U9|HC02AG|[Quad 2-Input NOR Gate](https://www.onsemi.com/pub/Collateral/MC74HC02A-D.PDF)|
|U10||Not Populated|
|U11|2545 33DE M53BM|Unknown 16-pin|
|U14|R336|Unknown 3-pin|

## Transistors

|Q3|3N10L26|[N-channel 100V 35A Power Transistor](https://www.infineon.com/dgdl/Infineon-IPP_B_I70N10S3L_12-DS-01_02-en.pdf?fileId=db3a30431a5c32f2011a9085629c594b)|
|Q8|088N06N|[N-channel 60V 50A Power Transistor](https://www.infineon.com/dgdl/Infineon-IPD088N06N3-DS-v02_00-en.pdf?fileId=db3a30431ddc9372011e2b2351db4d5c)|
|Q9|088N06N|[N-channel 60V 50A Power Transistor](https://www.infineon.com/dgdl/Infineon-IPD088N06N3-DS-v02_00-en.pdf?fileId=db3a30431ddc9372011e2b2351db4d5c)|
|Q10|088N06N|[N-channel 60V 50A Power Transistor](https://www.infineon.com/dgdl/Infineon-IPD088N06N3-DS-v02_00-en.pdf?fileId=db3a30431ddc9372011e2b2351db4d5c)|

*[SPI]: Serial Peripheral Interface
*[ISP]: In-System Porgamming
*[ISCP]: In-Circuit Serial Programming
*[MOSI]: Master Out Slave In
*[MISO]: Master In Slave Out
*[SCK]: Clock signal from Master to Slave
*[TDI]: Test Data In
*[TDO]: Test Data Out
*[TCK]: Test Clock
*[TMS]: Test Mode Select
*[VTG]: Target Voltage Reference
