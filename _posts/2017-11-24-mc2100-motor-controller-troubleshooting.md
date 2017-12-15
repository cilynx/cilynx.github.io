---
layout: post
title:  "MC2100 Motor Controller Troubleshooting"
date:   2017-11-24 17:20:40 -0800
tags: mc2100 motor controller troubleshooting orac lathe pwm dc power reverse_engineering cnc
---
<span style="color:red">_Very little of the content on this page is mine.  My additions and comments are in red italics.  So far as I can tell, this is the official interface specification for this family of motor controllers.  You can find the original PDF hundreds of places online with a quick google search, but it never includes copyright or attribution information.  At this point, I'm assuming the below information is in the public domain.  If I am incorrect and you either hold copyright on this content or know who does, please leave a comment below or contact me directly._</span>

## Troubleshooting LED

The MC-2100 has a single troubleshooting LED.  Unlike earlier motor controllers, which had several LEDs monitoring different conditions, the MC-2100's LED can give multiple signales.  Each LED state and its meaning is given below:

* **OFF** - The controller is NOT receiving AC voltage
* **ON (Solid)** - The controller is receiving AC voltage, but is not receiving a speed signal.
* **ON (Blinking rapidly)** - The controller is receiving a PWM signal and is sending voltage to the drive motor (**A+** and **A-**).
* **ON (Blinking on and off once per second)** - The controller is operating near its current limit.  This indicates the controller is working harder than it should to maintain treadmill speed.  Check for friction problems between the board and belt, an over tightened belt, or check the roller bearings.
* **ON (Blinking VERY slowly, on one second, off one second)** - The controller has entered its 'fold-back' mode.  This means the controller is working as hard as it can to turn the drive motor without success.  It then 'folds back,' or reduces, the voltage and amp draw of the drive motor to prevent overheating.

The state of the troubleshooting LED is also shown on the treadmill console when in calibration mode.  To view this information, enter calibration mode by inserting the safety key while holding the _Stop_ and _Speed Up_ buttons.  Release the buttons, and then press _Stop_ four times to advance to level 5 of calibration mode.  Press and hold the two _Speed_ buttons for two seconds to display the alternate calibration screen.  The speed window will now display the status of the LED.  This is given as a numerical value:

* **0** - The controller is not running (idle state)
* **1** - Controller is in the RESET state.  The drive motor will not be running.  _Equivalent to +12V lighting on the MC-60._
* **2** - The high voltage buss is charged.
* **4** - The high voltage buss is charging.
* **6** - The high voltage buss is charged and the unit is running.  _Equivalent to SPD CNTL and SCR TRIG lighting on the MC-60._
* **14** - Current Limit is active.  _Equivalent to CUR LIM lighting on the MC-60._
* **30** - Controller is in fold-back.  To prvent overheating, if the controller remains near its current limit for an extended time, it will reduce, or 'fold back,' the amount of current allowed.  The controller will return to normal operating levels once the high current condition is corrected. 

## Troubleshooting Workflow

### <span style="color:red">_No Light,_</span> No Power

After making sure the On/Off switch is turned on, check for 110-120 VAC at the wall outlet.
- **No** - Switch to a working outlet.  Check fuse / circuit breaker.
- **Yes** - Continue below.

Check for 110-120 VAC at the AC inputs on the motor controller.
- **No** - Check circuit breaker.  Reset or replace as necessary.  Check power cord and On/Off switch for continuity.
- **Yes** - Continue below.

Check for 8-12 VDC from the motor controller to the console.  Check at both locations.
- **No** - If no voltage at power supply, replace power supply.  If no voltage at console, replace wire.
- **Yes** - Replace the console.

### Light, No Power

Check the troubleshooting LED on the motor controller.  Does it flicker when speed is set above 0.0 MPH?
- **No** - Replace the wire harness or console.
- **Yes** - Continue below.

Set speed to maximum and check for DC voltage to the drive Motor.
- **No** - Verify speed, motor connections, and voltages on the controller, then replace controller.
- **Yes** - Replace the drive motor.

### No Speed Reading

Check function and position of the reed switch.  Reed switch spacing is 1/8" to 1/4" from magnet.
- **No** - Replace or reposition the switch as necessary.
- **Yes** - Continue below.

Check for 5 VDC pulse from controller to console on the GREEN wire.  Check both ends.
- **No** - Replace the controller or wire harness.
- **Yes** - Replace the console or wire harness.

### No Incline Adjustment

Check for 5 VDC from the Console to the motor controller while adjusting incline from console (ORANGE or YELLOW wires).
- **No** - Replace the console after checking the wire harness for continuity.
- **Yes** - Continue below.

Check for 110-120 VAC from the motor controller to the incline motor while adjusting incline.
- **No** - Replace the motor controller after verifying all wire connections.
- **Yes** - Replace the incline motor.

NOTE: If the motor hums and runs slowly, then take either the RED or BLACK wire off and try again.  If it works, then replace the controller.  It is sending voltage to the motor on both the up and down wires.
