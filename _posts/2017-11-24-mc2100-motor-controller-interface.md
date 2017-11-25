---
layout: post
title:  "MC2100 Motor Controller Interface"
date:   2017-11-24 13:29:40 -0800
tags: mc2100 motor controller interface orac lathe pwm dc power
---
<span style="color:red">_Very little of the content on this page is mine.  My additions and comments are in red italics.  So far as I can tell, this is the official interface specification for this family of motor controllers.  You can find the original PDF hundreds of places online with a quick google search, but it never includes copyright or attribution information.  At this point, I'm assuming the below information is in the public domain.  If I am incorrect and you either hold copyright on this content or know who does, please leave a comment below or contact me directly._</span>

## MC-2100/MC-2100E Motor Controller

The MC-2100 combines a PWM motor controller with a power board.  It is designed to replace the combination of an MC-60 or MC-2000 with a PB-12i (or other) power board.  The controller uses the same eight wire harness that has been used on Icon treadmills for the past several years.  The wire colors and voltage signals are identical.  A European version, the MC-2100E, functions identically, except the input voltage is 230 VAC 50 Hz.  A specialized version of the MC-2100E, the MC-2100ENI, does not include any incline circuitry.  Only the first four wires in the wire harness connect it to the console.

One difference between the MC-2100 and earlier controllers is that the on/off circuit breaker has its own connection directly on the board.  On some MC-2100's, the switch will be hard-mounted directly on the circuit board.  These controllers will mount directly to the belly pan.  Other MC-2100's will have two spade connectors allowing the on/off cincuit breaker to be mounted in another location.  The switch is then connected to the controller with two jumper wires.  <span style="color:red">_Still other MC-2100's will have the circuit breaker terminals hard jumpered together, defeating the circuit breaker functionality altogether.  In this case, the thermal switch from the motor will be wired serially inline with the black AC power connection to the board._</span>


The MC-2100 has its own processor and software, which allows it to communicate with the console.  This is done by a small digital signal carried by the GREEN tach wire.  By entering calibration mode on the console, two alternate screens can be accessed which give information on the controller, including the status of the troubleshooting LED, motor voltage, and motor amperage.  This greatly increases the amount of troubleshooting that can be done without removing the treadmill's motor hood.

Some MC-2100 controllers will have the transformer mounted on the circuit board as shown above.  Other versions will have a larger transformer mounted directly to the treadmill frame with jumper wires connecting it to the controller.  This allows a higher amp draw from consoles with many LEDs/LCDs.  All MC-2100E controllers will have a separate transformer.

### Controller Voltages

#### <span style="color:red">_Board / Drive Motor Power (High Voltage)_</span>

**CB1**, **CB1A** - These connctions are for the two terminal of the on/off circuit breaker.  The on/off breaker may be soldered directly onto the circuit toard or attached by wires <span style="color:red">_or be missing entirely, replaced by a jumper wire soldered between the two terminals_</span>.  When soldered <span style="color:red">_or replaced by a jumper wire_</span>, the incoming AC Hot wire (BLACK) will be routed through the thermal switch on the drive motor.  When attached by wires, one wire will be routed through the thermal switch.  120 VAC will be measured across the open switch when power is applied.  0 VAC will be measured when the switch is closed.  _NOTE: These connections are not present on the MC-2100E._

**LG1** - Labeled **AC HOT**, this spade connector receives the incoming 120 VAC (BLACK) from the power cord (or BLUE) from the thermal switch if the on/off circuit breaker is hardwired to the MC-2100).  This voltage will be present whenever the treadmill is plugged in.

**LG2** - Labeled **AC NEUT**, this spade connect is where the AC Common <span style="color:red">_Neutral_</span> (WHITE) wire is attached from the power cord.

**LG3** - Labeled **A+**, this terminal is the positive connection for the RED drive motor wire.  Voltage between this connection and **LG4** will measure 0 VDC when the treadmill is at rest to approximately 100 VDC when the treadmill is running at full speed.

**LG4** - Labeled **A-**, this connection is for the BLACK drive motor wire.  This is the negative terminal for the motor wires.

#### HD2 <span style="color:red">_- Console_</span>

This eight wire connection attaches the controller to the console.  Each wire carries the following voltage signal:

**BLACK** - (Two wires) These are the ground wires for the console.  All other voltages taken on the 8-wire harness are in reference to either of these wires.  _Note: On the MC-2100SDI, the second Black wire (the one next to Violet) carries a very small pulsing voltage the console monitors to count the number of steps taken by the user._

**RED** - This wire supplies the console with 9 VDC.  <span style="color:red">_This can be as high as 12-13V based on my own testing and anecdotes from around the web.  Use a regulator if you use this to power anything._</span>

**GREEN** - This wire brings the speed signal to the console.  This is a pulsing 0, 5 VDC signal as the treadmill is running.  When the treadmill is a rest, this voltage may measure either 0 VDC or 5 VDC.  <span style="color:red">_Remember from above that this line also carries "a small digital signal" between the MC-2100 and the console to assist with troubleshooting without accessing the motor and controller directly._</span>

**BLUE** - This wire carries the square wave speed control signal from the console to the power board.  The duty cycle of this 5 VDC signal is used to set the speed of the treadmill.  At the maximum duty cycle of 85% (meaning the 5 VDC is being sent 85% of the time and not being sent 15% of the time), approximately 4 VDC can be measured.  At lower speeds, a lower voltage will be measured.  _NOTE: Many digital multimeters have difficulty measuring this square wave signal.  They may only show a maximum of 1.5 VDC when the treadmill is set to its maximum speed.  What is important to see in this instance is that the voltage goes up as the treadmill speed is increased._

**ORANGE** - This wire carries a 3.5-5 VDC signal to the power board to cause the power board to send 120 VAC to the incline motor to increase the incline setting of the treadmill.  This voltage should only be present when the incline is being increased.

**YELLOW** - This wire carries a 3.5-5 VDC signal to the power board to cause the power board to send 120 VAC to the incline motor to decrease the incline setting of the treadmill.  This voltage should only be present when the incline is being decreased.

**VIOLET** - This wire carries the incline sensor signal to the console.  This is a pulsing 0, 5 VDC signal as the incline is moving.  When the incline is at rest, this voltage may measure either 0 VDC or 5 VDC.

#### HD5 <span style="color:red">_- Incline Motor (High Voltage)_</span>

This connection is for the incline motor wire harness.  The RED (down) and BLACK (up) wires are separated by a WHITE (AC Common <span style="color:red">_Neutral_</span>) wire.  The an _Incline_ button is pressed on the console, the controller receives the incline signal and sends 120 VAC to the incline motor to turn it in the appropriate direction.

#### TACH <span style="color:red">_- Reed Switch Tachometer_</span>

This connection is for the reed switch wire.  This allows the tach signal to be received by the controller and passed to the console wire harness, where it is sent up the GREEN wire.  Voltage is a pulsing 5 VDC when the treadmill is running.  When the treadmill is at rest, this voltage may be 0 VDC or 5 VDC, depending on whether the magnet is closing the reed switch or not.

#### INS <span style="color:red">_- Incline Sensor_</span>

This connection is for the incline sensor.  While it will usually be a reed switch, an optic switch can also be connected.  5 VDC will be present across the open switch.  Whenever the switch closes, 0 VDC will be measured.  As the incline motor turns, this voltage will pulse on and off.  The number of pulses is used by the console to determine how far it has changed the incline.  When the incline is at rest, this voltage may measure 0 VDC or 5 VDC, depending on the position of the switch in relation to the magnet (or optic disk).
