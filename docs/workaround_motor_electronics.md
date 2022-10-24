# Building a Sangaboard-compatible motor controller


[Sangaboard arduino sketch]: https://gitlab.com/bath_open_instrumentation_group/sangaboard/-/tree/master/arduino_code

The official project uses the [Sangaboard motor controller](parts/electronics/sangaboard.md), but this is currently difficult to get hold of. This guide tells you how to create your own motor controller that is compatible with the Sangaboard firmware. This will allow you to drive the [28BYJ-48] stepper motors used for the microscope.

[28BYJ-48]: parts/electronics.yml#28BYJ-48
[28BYJ-48 driver board]: parts/electronics.yml#28BYJ-48-Driver
[Arduino Nano]: parts/electronics.yml#ArduinoNano
[jumper cables]: parts/electronics.yml#JumperCable
[solder]: parts/consumables/solder.md
[soldering iron]: parts/tools/soldering_iron.md

{{BOM}}

## Wire up the boards {pagestep}

Each of your motors should have come with a [driver board][28BYJ-48 driver board]{qty:3, cat:electronic}. You should wire these up to and [Arduino Nano]{qty:1, cat:electronic} using [jumper cables]{qty: 12, cat:electronic} as shown in the diagram below:

![Simple motor controller with Arduino](images/sangaboard_simple.png)

**The motor order is x-motor, y-motor, z-motor from top to bottom of this diagram.**

## Wire up the power {pagestep}

We use a [soldering iron]{cat:tool, qty:1} to create the power cables. 

To power the boards you need a 5V voltage source. We create this from a USB power supply.

* Tun on the [soldering iron]{cat:tool, qty:1} to the correct temperature for your [solder]{cat:consumable, qty:A little}
* Cut the end off the cable with [wire cutters][precision wire cutters](parts/tools/precision-wire-cutters.md){qty:1, cat:tool}
* Strip back a portion of the outer cable
* Locate the Vcc (usually the red wire) and GND wires (usually the black wire)
* Cut one end off 7 [jumper cables]{qty: 7}. (Preferably 4 black and 3 red)
* Solder 4 of these cables to the GND cable of the power supply
* Solder the other 3 to the Vcc cable of the power supply
* Protect the joints with [electrical tape]{qty: A little, cat: consumable, note:"Heat shrink would be better"} or heat shrink.
* Connect up the power (with the supply off) as shown in the diagram above.

## Load the firmware {pagestep}

Using the Arduno IDE load the [Sangaboard arduino sketch] onto the Arduino nano

[Sangaboard arduino sketch]: https://gitlab.com/bath_open_instrumentation_group/sangaboard/tree/master/arduino_code


---


## Troubleshooting


* **Arduino IDE:** Some users have found issues with old (or very new) versions of the Arduino IDE not working properly.  See the [issue thread on motor boards not working] for more details.
* **Arduino Clones:** Many people use Nano boards not made by Arduino.  These often come with cheaper USB to serial ICs (which require drivers - see the Arduino section at the end of this page) and old bootloaders (which require different options in the Arduino IDE).  This is also discussed in the [issue thread on motor boards not working].

[issue thread on motor boards not working]: https://gitlab.com/openflexure/openflexure-helpdesk/-/issues/12#note_342049911

