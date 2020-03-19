# Motor controller boards

Currently, the standard microscope software supports motor controller boards running the [Sangabord firmware](https://gitlab.com/bath_open_instrumentation_group/sangaboard/tree/master/arduino_code).

Three "official" designs for the Sangaboard exist, and these are described below.

## Board designs

### Simple controller using Arduino Nano

Most recommended [motors](./5_motors.md) will come packaged with a simple driver board. These can be connected to an Arduino Nano and a power supply following the diagram below.

![Simple motor controller with Arduino](./images/sangaboard_simple.png)

Then, use the Arduino IDE to flash the [Sangabord firmware](https://gitlab.com/bath_open_instrumentation_group/sangaboard/tree/master/arduino_code), and connect the Arduino to your microscope's Raspberry Pi via it's USB port.

> **Warning:** Do not attempt to power the motors from the Raspberry Pi's pins. They can draw far more than the maximum current the Pi will safely supply. Always use a separate power supply for the motors.

The microscope software should recognise a supported Sangaboard is connected, and enable motorised control of the microscope stage.


### PCB + Arduino Nano (Sangaboard v0.2)

This option aims to be a super-simple motor controller board, based on an Arduino Nano and a couple of Darlington pair ICs. It owes quite a bit to [Fergus Riche's motor board](https://github.com/fr293/motor_board), the hardware developed by [OpenScope](http://2015.igem.org/Team:Cambridge-JIC) and the Arduino-based motor controller used by a number of summer students working with Richard Bowman in Cambridge, particularly James Sharkey.

The PCB design, bill of materials, and purchase links for both are available via [Kitspace](https://kitspace.org/boards/github.com/rwb27/openflexure_nano_motor_controller/).

A circuit schematic can be found [here](./images/sangaboard_v2_schematic.png ':ignore')


### Fully integrated board (Sangaboard v0.3)

A fully-custom, Arduino-like board can also be used to drive the microscope motors. The Sangabord v0.3 design integrates everything onto a single PCB, removing the need to plug in a separate Arduino.

The PCB design, bill of materials, and purchase links for both are also available via [Kitspace](https://kitspace.org/boards/gitlab.com/bath_open_instrumentation_group/sangaboard/).

If building or ordering your own custom board, you will first need to [burn the bootloader to the board](https://gitlab.com/bath_open_instrumentation_group/sangaboard/blob/master/Bootloader/README.md), before [flashing the Sangabord firmware](https://gitlab.com/bath_open_instrumentation_group/sangaboard/blob/master/arduino_code/README.md).


## Arduino code

All board options share a common Arduino "firmware".

The Arduino code can be downloaded [here](https://gitlab.com/bath_open_instrumentation_group/sangaboard/tree/master/arduino_code).

Instructions for flashing the firmware can be found [here](https://gitlab.com/bath_open_instrumentation_group/sangaboard/blob/master/arduino_code/README.md).
