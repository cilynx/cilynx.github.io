---
layout: post
title:  Pentair Pump RS-485 API
date:   2019-02-05 09:25:03 -0800
tags:   reverse_engineering pool raspberry_pi rs-485
---
## Table of Contents

* [0x01: Set](#0x01-set)
   * [0x03, 0x27: Program 1](#0x03-0x27-program-1)
   * [0x03, 0x28: Program 2](#0x03-0x28-program-2)
   * [0x03, 0x29: Program 3](#0x03-0x29-program-3)
   * [0x03, 0x2a: Program 4](#0x03-0x2a-program-4)
* [0x02: Get](#0x02-get)
   * [0x02, 0x27: Program 1](#0x02-0x27-program-1)
   * [0x02, 0x28: Program 2](#0x02-0x28-program-2)
   * [0x02, 0x29: Program 3](#0x02-0x29-program-3)
   * [0x02, 0x2a: Program 4](#0x02-0x2a-program-4)
* [0x03: Get Time](#0x04-get-time)
* [0x04: Remote Control](#0x04-remote-control)
* [0x07: Pump Status](#0x07-pump-status)

## 0x01: Set

Sets settings, speeds, programs, etc.  Has many sub-routes.

### [0x03, 0x27]: Program 1

#### Example Packets

Set Program 1 to 750 RPM:

|Request|`[255, 0, 255, 165, 0, 96, 33, 1, 4, 3, 39, 2, 238, 2, 69]`|
|Response|`[255, 0, 255, 165, 0, 33, 96, 1, 2, 2, 238, 2, 25]`|

#### Arguments

Requires 2-bytes representing the RPM to set.

#### Response Data

Returns 2-bytes representing the RPM that was set.

### [0x03, 0x28]: Program 2

#### Example Packets

Set Program 2 to 1500 RPM:

|Request|`[255, 0, 255, 165, 0, 96, 33, 1, 4, 3, 40, 5, 220, 2, 55]`|
|Response|`[255, 0, 255, 165, 0, 33, 96, 1, 2, 5, 220, 2, 10]`|

#### Arguments

Requires 2-bytes representing the RPM to set.

#### Response Data

Returns 2-bytes representing the RPM that was set.

### [0x03, 0x29]: Program 3

#### Example Packets

Set Program 1 to 2350 RPM:

|Request|`[255, 0, 255, 165, 0, 96, 33, 1, 4, 3, 41, 9, 46, 1, 142]`|
|Response|`[255, 0, 255, 165, 0, 33, 96, 1, 2, 9, 46, 1, 96]`|

#### Arguments

Requires 2-bytes representing the RPM to set.

#### Response Data

Returns 2-bytes representing the RPM that was set.

### [0x03, 0x2a]: Program 4

#### Example Packets

Set Program 1 to 750 RPM:

|Request|`[255, 0, 255, 165, 0, 96, 33, 1, 4, 3, 42, 12, 38, 1, 138]`|
|Response|`[255, 0, 255, 165, 0, 33, 96, 1, 2, 12, 38, 1, 91]`|

#### Arguments

Requires 2-bytes representing the RPM to set.

#### Response Data

Returns 2-bytes representing the RPM that was set.

## 0x02: Get

## 0x04: Remote Control

Sets remote control status.  Remote control must be enabled for the pump to accept any other requests.  Remote control must be disabled to interact with the physical Operator Control Panel.  I've found it generally works best to enable-send-disable for each desired request.

### Example Packets
Enable:

|Request|`[255, 0, 255, 165, 0, 96, 33, 4, 1, 255, 2, 42]`|
|Response|`[255, 0, 255, 165, 0, 33, 96, 4, 1, 255, 2, 42]`|

Disable:

|Request|`[255, 0, 255, 165, 0, 96, 33, 4, 1, 0, 1, 43]`|
|Response|`[255, 0, 255, 165, 0, 33, 96, 4, 1, 0, 1, 43]`|

### Arguments
Requires 1-byte:

|`0xff`|Enable remote control|
|`0x00`|Disable remote control|

### Response Data
Returns 1-byte

|`0xff`|Remote control has been enabled|
|`0x00`|Remote control has been disabled|

## 0x07: Pump Status

Returns current status information.

### Example Packets

|Request|`[255, 0, 255, 165, 0, 96, 33, 7, 0, 1, 45]`
|Response|`[255, 0, 255, 165, 0, 33, 96, 7, 15, 10, 0, 0, 2, 62, 7, 208, 0, 0, 0, 0, 2, 49, 15, 11, 2, 170]`|

### Arguments

None required.  Silently ignores any arguments sent.

### Response Data

Returns 15-bytes:
```
[RUN, MODE, DRIVE_STATE, WATTS_H, WATTS_L, RPM_H, RPM_L, TIMER_H, TIMER_M, CLOCK_H, CLOCK_M]
```

|RUN|`0x0a`: Running<br>`0x04`: Not Running|
|MODE|Theoretically, this reports the current mode.  On my pump, this always returns `0x00`|
|DRIVE_STATE|Theoretically, this reports the current drive state.  On my pump, this always returns `0x00`|
|WATTS_H|High byte of electric consumption in Watts|
|WATTS_L|Low byte of electric consumption in Watts|
|RPM_H|High byte of current RPM|
|RPM_L|Low byte of current RPM|
|TIMER_H|Hours component of running timer|
|TIMER_M|Minutes component of running timer|
|CLOCK_H|Hours component of current time|
|CLOCK_M|Minutes component of current time|
