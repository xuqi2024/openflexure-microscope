# Complete the wiring



{{BOM}}


[Raspberry Pi]: parts/electronics.yml#RaspberryPi "{cat:electronic}"
[Sangaboard]: parts/electronics/sangaboard.md "{cat:electronic, note: 'If you cannot get a Sangaboard try building [compatible arduino nano circuit](nano_sangaboard.md)'}"

[No 2 6.5mm self tapping screws]: parts/mechanical.yml#SelfTap_PoziPan_No2x6.5_SS "{cat:mech}"
[M3 nut]: parts/mechanical.yml#Nut_M3_SS "{cat:mech}"
[M3x10 cap head screws]: parts/mechanical.yml#CapScrew_M3x10mm_SS "{cat:mech}"

## Assembly video

![](https://www.youtube.com/watch?v=1YZMbfL6M7E)

## Connect the Raspberry Pi {pagestep}

* Take the [Pi stand](fromstep){qty:1, cat:printedpart} you printed earlier and push the [Raspberry Pi]{qty:1} into place so the connectors show through the holes.
* Secure the Raspberry Pi in place with two [self tapping screws][No 2 6.5mm self tapping screws]{qty:2}
* Insert the ribbon cable from the optics module into the camera port of the Rasberry Pi, ensuring the contacts are on the opposite side from the clasp.

## Connect the Sangaboard {pagestep}

* Mount the [Sangaboard]{qty:1} onto the Raspberry Pi GPIO pins, ensuring that the ribbon cable goes through the slot.
* Secure the Sangaboard in place with two [self tapping screws][No 2 6.5mm self tapping screws]{qty:2}
* Push the motor cables into their labelled connectors. Make sure the motor from the correct axis on the microscope goes to the correct port.

## Connect the LED to the Sangaboard {pagestep}

* Insert the 2-pin male connector into the 4x2 way female header on the [Sangaboard].
* If you are not using a Sangaboard v4, you can also [connect the LED to the Raspberry Pi](workaround_raspberry_pi_gpio_led.md)

![Connect the LED to the Sangaboard](diagrams/illumination_to_sangaboard_wiring.png)

## Mount the electronics drawer {pagestep}

* Place an [M3 nut]{qty:1, cat:mech} into the slot just inside the hole in the front of the microscope base.
* Place another [M3 nut]{qty:1} into the slot above the Sangaboard power connector on the Pi stand.
* Slide the Pi stand into the microscope base making sure not to pinch any wires.
* Hold the Pi stand in place with two [M3x10 cap head screws]{qty: 2} which should screw into the two nuts.


To power up your microscope you will need a [power supply][Raspberry Pi Power Supply](parts/electronics.yml#RaspberryPi_PowerSupply){qty:1, cat:electronic}.
