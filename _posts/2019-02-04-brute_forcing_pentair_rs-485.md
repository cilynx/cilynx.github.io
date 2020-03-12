---
layout: post
title:  Brute Forcing Pentair RS-485
date:   2019-02-04 09:18:49 -0800
tags:   reverse_engineering pool raspberry_pi rs-485
last_modified_at: 2019-02-05
---
Several open source projects have implemented portion of Pentair's RS-485 protocol over the years, but none of them mesh with my setup and way of thinking.  On the setup side, I only have a Pentair pump -- I do not have any of the magic controllers or anything else that's generally found on the RS-485 bus.  For this project, I have a Raspberry Pi with an RS-485 adapter wired up directly to the pump.  On the way-of-thinking side, most of the projects out there implement the minimum viable functionality and have magic bytes scattered around the code with the hows and whys buried in years of forum posts and chat logs.  My goal is to publish a map of my pump's complete [API]({% post_url 2019-02-05-pentair_pump_rs-485_api %}) and implement [a straight-forward class](https://github.com/cilynx/pypentair) to interface with it.

## Getting Started

In general, Pentair packets look like this:

`[ [PACKET_HEADER], PAYLOAD_HEADER, VERSION, DESTINATION, SOURCE, ACTION, DATA_LENGTH, [DATA], [CHECKSUM] ]`

* `[PACKET_HEADER]` is always `0xFF, 0x00, 0xFF`.  
* `PAYLOAD_HEADER` is always `0xA5`.  
* There's some discussion around what `VERSION` is all about, but I've found that for my use case, it's safe to always have it be `0x00`.
* `DESTINATION` is the address of the receiver.  RS-485 is a broadcast bus and is not routed.  That means that every packet will go to every device connected to the bus.  The `DESTINATION` address tells the receiver that they should care about that packet.
* `SOURCE` is the address of the sender.  When the receiver responds, it will reverse `SOURCE` and `DESTINATION`.  If you lie about the `SOURCE`, the receiver will happily set the response `DESTINATION` to whatever `SOURCE` you passed in the request.
* `ACTION` is the basic action or class of actions you want to perform.  This will make more sense later on.
* `DATA_LENGTH` is the number of bytes in `[DATA]`.  It can be 0.
* `[DATA]` contains different things depending on the `ACTION`:
   * If the `ACTION` does not take any parameters, `DATA_LENGTH` will be `0` and will be followed directly by the `[CHECKSUM]`.  For example, to request pump status, `ACTION` is `0x07` ([get pump status]({% post_url 2019-02-05-pentair_pump_rs-485_api %}#0x07-pump-status)), `DATA_LENGTH` is `0x00` and `[DATA]` doesn't exist in the packet at all.
   ```
   Request:  [255, 0, 255, 165, 0, 96, 33, 7, 0, 1, 45]
   ```
   * If the `ACTION` takes a single byte argument, `DATA_LENGTH` will be `1` and `[DATA]` will contain the relevant argument.  For example, to ready the pump for remote control, `ACTION` is `0x04` ([set remote control]({% post_url 2019-02-05-pentair_pump_rs-485_api %}#0x04-remote-control)), `DATA_LENGTH` is `1` and `[DATA]` is `0xFF` (on).
   ```
   Request:  [255, 0, 255, 165, 0, 96, 33, 4, 1, 255, 2, 42]
   ```
   * Going on down the rabbit hole, some `ACTIONS` have sub-actions which are defined in `[data]`.  For example, to ask the pump to run at 1500 rpm, `ACTION` is `0x01` ([set settings]({% post_url 2019-02-05-pentair_pump_rs-485_api %}#0x01-set-settings)) and `[DATA]` is `0x02, 0xC4, 0x05, 0xDC` where `0x02, 0xC4` is (set rpm) and `0x05, 0xDC` is the hex byte representation of 1500.
   ```
   Request:  [255, 0, 255, 165, 0, 96, 33, 1, 4, 2, 196, 5, 220, 2, 210]
   ```
* `[CHECKSUM]` is a 2-byte (big-endian) representation of the sum of bytes beginning with and including `PAYLOAD_HEADER` and ending and including the last byte in `[DATA]`.

## Responses

As a general rule, response packets start out similar to the request but swap `SOURCE` and `DESTINATION`.  Depending on the situation the response `[DATA]` could take a few forms:
* If the request asked for data, those data will be returned.  For example, if the request `ACTION` is `0x07` (get pump status), the response `ACTION` will stay `0x07` but its `[DATA]` will be an array of bytes representing various status elements.  
```
Request:  [255, 0, 255, 165, 0, 96, 33, 7, 0, 1, 45]  
Response: [255, 0, 255, 165, 0, 33, 96, 7, 15, 10, 0, 0, 1, 25, 5, 220, 0, 0, 0, 0, 0, 1, 16, 52, 2, 134]
```
* If the request was a setter, the data that were set will be returned.  For example, if the request `ACTION` is `0x04` (set remote control) and `[DATA]` is `0xFF`, the response `ACTION` will stay `0x04` and its `[DATA]` will be `0xFF` as well, confirming the value set.
```
Request:  [255, 0, 255, 165, 0, 96, 33, 4, 1, 255, 2, 42]
Response: [255, 0, 255, 165, 0, 33, 96, 4, 1, 255, 2, 42]
```
* If the request `[DATA]` includes sub-actions / routing, only the final bytes of data actually set will be returned.  For example, when the pump is set to 1500 rpm as above, the response `ACTION` will be `0x01` (set mode) but `[DATA]` will contain only `0x05, 0xDC` representing 1500 with no reference to the `0x02, 0xC4` (set rpm) sub-action / route.
```
Request:  [255, 0, 255, 165, 0, 96, 33, 1, 4, 2, 196, 5, 220, 2, 210]
Response: [255, 0, 255, 165, 0, 33, 96, 1, 2, 5, 220, 2, 10]
```

## Trying to Break Things

From previous research, we already have some good leads:
```
ACTIONS = {
   'ACK':               0x00,
   'PROGRAM':           0x01,
   'REMOTE_CONTROL':    0x04,
   'SPEED':             0x05,
   'POWER':             0x06,
   'STATUS':            0x07,
   'UNKNOWN':           0xFF
}
```
Since `ACTION` is only one byte, let's try throwing every possible `ACTION` with no `[DATA]` and see what we get back.  (Note: While often effective, this sort of brute force testing can have lots of unintended consequences -- like setting parameters, running functions, bricking the device you're talking to, etc.  Do this sort of thing at your own risk and preferably on equipment you don't need in production.)
```
Req Action | Req Data | Res Action | Res Data
0x0 | | 0x0 | None
0x1 | | 0xff | [8]
0x2 | | 0xff | [8]
0x3 | | 0x3 | [13, 38]
0x4 | | 0x4 | [1]
0x5 | | 0x5 | [1]
0x6 | | 0x6 | [1]
0x7 | | 0x7 | [10, 0, 0, 2, 72, 7, 208, 0, 0, 0, 0, 4, 22, 13, 38]
0x8 | | 0xff | [8]
0x9 | | 0xff | [1]
...
0xff | | 0xff | [1]
```
That `...` isn't actually in the output, but I didn't figure anyone wanted to scroll through ~200 lines that are all `0xff | [1]`.  Trust me, everything snipped out is uninteresting.

Our leads tell us that `0x01` should be a valid `ACTION`, but we get back `0xff`.  If we look over the rest of the tests, we can see that `0xff` occasionally comes along with `[DATA]` being `8`, but usually it's `1`.  To my eyes, `0xff` means `ERROR` with `1` being `Command Not Found` and `8` being `Invalid Parameters`.

Let's run through the tests and see if this pans out comparing with the leads above:
* Sending an `ACTION` of `0x00` gets us `0x00` with no `[DATA]` back.  This does indeed feel like an Acknowledgment and nothing more.
* Sending an `ACTION` of `0x01` gets us `Invalid Parameters`, which makes sense because setting up pump programs requires additional parameters.
* Sending an `ACTION` of `0x02` gets us `Invalid Parameters`.  We don't know anything about `0x02` yet, so `¯\_(ツ)_/¯`.
* Sending an `ACTION` of `0x03` gets us 2-bytes of `[DATA]`.  We don't know anything about `0x03` yet either, so more `¯\_(ツ)_/¯`.
* Sending an `ACTION` of `0x04` gets us a `1`.  Not sure yet what this is telling us, but we got the `0x04` back, so probably not an error.
* Sending an `ACTION` of `0x05` gets us a `1`.  Not sure yet what this is telling us, but we got the `0x05` back, so probably not an error.
* Sending an `ACTION` of `0x06` gets us a `1`.  Not sure yet what this is telling us, but we got the `0x06` back, so probably not an error.
* Sending an `ACTION` of `0x07` gets us back a bunch of `[DATA]` as would be expected for a status report.  Haven't we seen `[13, 38]` before?  Interesting.
* Sending an `ACTION` of `0x08` gets us `Invalid Parameters`.  We don't know anything about `0x08` yet, so `¯\_(ツ)_/¯`.
* Sending anything else for `ACTION` gets us `0xff` and `1` which I think has to mean `Command Not Found`.  This means that moving forward we can reduce our brute force blast radius to `0x00` - `0x08` which should cut down on time considerably.

## Get Time

Going back to previous research, we know that the pump status fields look like this:
```
PUMP_STATUS_FIELDS = {
   'RUN':                  0,
   'MODE':                 1,
   'DRIVE_STATE':          2,
   'WATTS_H':              3,
   'WATTS_L':              4,
   'RPM_H':                5,
   'RPM_L':                6,
   'GPM':                  7,
   'PPC':                  8,
   'UNKNOWN':              9,
   'ERROR':                10,
   'REMAINING_TIME_H':     11,
   'REMAINING_TIME_M':     12,
   'CLOCK_TIME_H':         13,
   'CLOCK_TIME_M':         14
}
```
That means those last two bytes -- `[13, 38]` in our example -- are the time.  It seems pretty clear that an `ACTION` of `0x03` with no `[DATA]` gives us back the current clock time.  We'll have to poke around more to see if parameters do anything.

## Progress

This gives us:
 ```
ACTIONS = {
   'ACK_MESSAGE':       0x00,
   'PROGRAM':           0x01,
   'UNKNOWN_2':         0x02,
   'TIME':              0x03,
   'REMOTE_CONTROL':    0x04,
   'SPEED':             0x05,
   'POWER':             0x06,
   'STATUS':            0x07,
   'UNKNOWN_8':         0x08,
   'ERROR':             0xFF
}

ERROR_CODES = {
   1: 'Unknown Command',
   8: 'Invalid Parameters'
}
```

## Add Some Data

Let's try throwing some data at each of our viable `ACTIONS`:
```
0x0 | 0x0 | 0x0 | None
...
0x0 | 0xff | 0x0 | None
0x1 | 0x0 | 0xff | [8]
...
0x1 | 0xff | 0xff | [8]
0x2 | 0x0 | 0xff | [8]
...
0x2 | 0xff | 0xff | [8]
0x3 | 0x0 | 0xff | [7]
...
0x3 | 0xff | 0xff | [7]
0x4 | 0x0 | 0x4 | [0]
0x4 | 0x1 | 0x4 | [1]
...
0x4 | 0xfe | 0x4 | [254]
0x4 | 0xff | 0x4 | [255]
0x5 | 0x0 | 0x5 | [0]
0x5 | 0x1 | 0x5 | [1]
...
0x5 | 0xfe | 0x5 | [254]
0x5 | 0xff | 0x5 | [255]
0x6 | 0x0 | 0x6 | [0]
0x6 | 0x1 | 0x6 | [1]
...
0x6 | 0xfe | 0x6 | [254]
0x6 | 0xff | 0x6 | [255]
0x7 | 0x0 | 0x7 | [10, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 59, 18, 53]
...
0x7 | 0xff | 0x7 | [10, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 59, 18, 53]
0x8 | 0x0 | 0xff | [8]
...
0x8 | 0xff | 0xff | [8]
```
Looking at the output, the first thing I notice is that `0x00` (acknowledgment) and `0x07` (get pump status) both acted exactly the same as before.  This tells me that at least for simple `ACTIONS`, the pump is just throwing away extraneous bytes.  Given that we know pretty well what `0x00` and `0x07` `ACTIONS` do, I think we can stop testing them moving forward.

The next interesting thing is that `0x03` is now throwing a `0xff` and `7` is an error code we haven't seen before.  Being that `0x00` and `0x07` didn't throw errors, it's probably not "Got arguments but wasn't expecting any", but it's likely something similar.  Add it to the `¯\_(ツ)_/¯` list.

`0x01`, `0x02`, and `0x08` all threw error code `8` across the board, so we probably need more parameters.

Now, for the interesting stuff.  `0x04`, `0x05`, and `0x06` all gave me back the `[DATA]` byte I gave them.  As for real life data, somewhere in `0x05` I heard the pump turn on and right at the beginning of `0x05`, the pump turned off.

## Speed

Let's play with `0x05` (speed)
```
Req Action | Req Data | Res Action | Res Data | RPM
0x5 | 0x0 | 0x5 | [0] | 0
0x5 | 0x1 | 0x5 | [1] | 0
0x5 | 0x2 | 0x5 | [2] | 450
0x5 | 0x3 | 0x5 | [3] | 1150
0x5 | 0x4 | 0x5 | [4] | 1800
0x5 | 0x5 | 0x5 | [5] | 1800
0x5 | 0x6 | 0x5 | [6] | 1800
0x5 | 0x7 | 0x5 | [7] | 1800
0x5 | 0x8 | 0x5 | [8] | 1800
0x5 | 0x9 | 0x5 | [9] | 1800
0x5 | 0xa | 0x5 | [10] | 1800
0x5 | 0xb | 0x5 | [11] | 1800
0x5 | 0xc | 0x5 | [12] | 1800
0x5 | 0xd | 0x5 | [13] | 1800
0x5 | 0xe | 0x5 | [14] | 2180
0x5 | 0xf | 0x5 | [15] | 2880
0x5 | 0x10 | 0x5 | [16] | 3450
...
0x5 | 0x4e | 0x5 | [78] | 3450
0x5 | 0x4f | 0x5 | [79] | 0
...
0x5 | 0xff | 0x5 | [255] | 0
```
Trolling around the forums and such, I've found several bytes that could potentially be useful:
```
SPEED = {
   'FILTER':       0x00,
   'MANUAL':       0x01,
   'SPEED_1':      0x02, # Backwash on some pumps?
   'SPEED_2':      0x03,
   'SPEED_3':      0x04,
   'SPEED_4':      0x05,
   'FEATURE_1':    0x06,
   'EXTERNAL_1':   0x09,
   'EXTERNAL_2':   0x0a,
   'EXTERNAL_3':   0x0b,
   'EXTERNAL_4':   0x0c,
}
```
Testing a little more deliberately, I find the following:
* `0x00` has no effect
* `0x01` has no effect
* `0x02` sets the RPM to 1100 (min) and the timer to 24-hours
* `0x03` sets the RPM to 2000 and the timer to 24-hours
* `0x04` sets the RPM to 2350 and the timer to 24-hours
* `0x05` sets the RPM to 3110 and the timer to 24-hours
* `0x06` has no effect -- likely Speed 5 which is not set by default
* `0x07` has no effect -- likely Speed 6 which is not set by default
* `0x08` has no effect -- likely Speed 7 which is not set by default
* `0x09` has no effect -- likely Speed 8 which is not set by default
* `0x0a` sets the RPM to 3450 (max) and the timer to 24-hours.  This may be the documented Quick Clean feature?
* `0x0b` sets the RPM to 0 and the timer to 3-hours.  This state also seems to block the pump from being remotely turned off or setting RPM manually until `0x02` - `0x05` are run.  This may be the documented Time Out feature?
* `0x0c` has no effect
* Passing extra `[DATA]` bytes have no effect.  Everything acts the same as with the single byte, similar to `[0x00]` and `[0x07]` when they received extra bytes.

This leaves us at:
```
SPEED = {
   'SPEED_1':     0x02,
   'SPEED_2':     0x03,
   'SPEED_3':     0x04,
   'SPEED_4':     0x05,
   'QUICK_CLEAN': 0x0b,
   'TIME_OUT':    0x0c,
}
```
