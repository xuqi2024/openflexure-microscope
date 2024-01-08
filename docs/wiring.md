# Complete the wiring

The microscope must be completed by mounting the motor driver electronics and the Raspberry Pi, connecting the motors to the motor driver, and connecting the illumination to a power source.  These instructions assume you are using a Raspberry Pi v4 and a Sangaboard v0.4 or v0.5.  See the box below if you are not using these electronics.

>i **Alternative electronics options**
>i
>i If you are using a version of the Raspberry Pi other than v4, or Sangaboard other than version 0.4 or 0.5, you will need a different electronics drawer.  The options are described in the [customisation] page.
>i If you do not have a Sangaboard, you can make up a compatible solution from a microcontroller and separate driver boards.  This is described in the [motor electronics workaround] page.

[customisation]: customisation.md "Customisation and work-around options for the microscope."
[motor electronics workaround]: workaround_motor_electronics/workaround_motor_electronics.md "Solutions to drive the motors without a Sangaboard PCB."

{{BOM}}


[Raspberry Pi]: parts/electronics.yml#RaspberryPi "{cat:electronic}"
[Sangaboard]: parts/electronics/sangaboard.md "{cat:electronic, note: 'If you cannot get a Sangaboard, you can put together [workaround motor electronics](workaround_motor_electronics/workaround_motor_electronics.md) instead.'}"

[No 2 6.5mm self tapping screws]: parts/mechanical.yml#SelfTap_PoziPan_No2x6.5_SS "{cat:mech}"
[M3 nut]: parts/mechanical.yml#Nut_M3_SS "{cat:mech}"
[M3x10 cap head screws]: parts/mechanical.yml#CapScrew_M3x10mm_SS "{cat:mech}"
[electronics drawer]: fromstep "{cat:printedpart}"

## Assembly video

![](https://www.youtube.com/watch?v=1YZMbfL6M7E)

## Prepare the electronics drawer {pagestep}

* Place an [M3 nut]{qty:1, cat:mech} into the slot just inside the hole in the front of the microscope base.
* Place another [M3 nut]{qty:1} into the slot above the Sangaboard power connector on the [electronics drawer].

## Connect the Raspberry Pi {pagestep}

* Take the [electronics drawer]{qty:1} you printed earlier and push the [Raspberry Pi]{qty:1} into place so the connectors show through the holes.
* Secure the Raspberry Pi in place with two [self tapping screws][No 2 6.5mm self tapping screws]{qty:2}
* Insert the ribbon cable from the optics module into the camera port of the Rasberry Pi, ensuring the contacts are on the opposite side from the clasp. There are [detailed instructions on the Rasbperry Pi website](https://projects.raspberrypi.org/en/projects/getting-started-with-picamera/2).

## Upload the Sangaboard firmware {pagestep}

You will need to ensure the Sangaboard has the correct firmware and bootloader before it can be used. This is often easier to do before mounting it. 

>i Sangaboard v3 and v4 have two micro-USB ports.  One is for power only, the other is for data only.  You must upload the firmware using the "data" port.

* Plug the Sangaboard into a computer, using the "data" micro-USB port.  If it shows up as a Sangaboard (or as a USB serial port) when plugged into a computer, this means you already have a bootloader and can skip the next bullet point and go straight to uploading the firmware.
* For home-made Sangaboard v3 and v4 you need to follow the [instructions in the repository to burn the bootloader](https://gitlab.com/bath_open_instrumentation_group/sangaboard/-/tree/master/Bootloader).
* Once you have the correct bootloader, you must follow the [instructions in the repository to upload the firmware](https://gitlab.com/bath_open_instrumentation_group/sangaboard/-/tree/master/arduino_code).

## Connect the Sangaboard {pagestep}

* Mount the [Sangaboard]{qty:1} onto the Raspberry Pi GPIO pins, ensuring that the ribbon cable from the optics module passes through the slot.
* Secure the Sangaboard in place with two [self tapping screws][No 2 6.5mm self tapping screws]{qty:2}
* Push the motor cables into their labelled connectors. Make sure the motor from the correct axis on the microscope goes to the correct port.

## Connect the LED to the Sangaboard {pagestep}

* Insert the 2-pin male connector into the 4x2 way female header on the [Sangaboard].
* If you are not using a Sangaboard v4, you can also [connect the LED to the Raspberry Pi](workaround_raspberry_pi_gpio_led.md)

![Connect the LED to the Sangaboard](diagrams/illumination_to_sangaboard_wiring.png)

## Mount the electronics drawer {pagestep}

* Slide the [electronics drawer] into the microscope base making sure not to pinch any wires.
* Hold the [electronics drawer] in place with two [M3x10 cap head screws]{qty: 2} which should screw into the two nuts.

## Wiring Complete {pagestep}

To power up your microscope you will need a [power supply][Raspberry Pi Power Supply](parts/electronics.yml#RaspberryPi_PowerSupply){qty:1, cat:electronic}.  

>i The power supply may change if you have used a different option for the motor electronics, so check what is required by your motor driver board.  Some motor electronics options (Sangaboard v4 and v5) will power the Raspberry Pi, others may require separate power supplies for the Raspberry Pi and the motors.
