# Complete the wiring

[customisation]: customisation.md "Customisation and work-around options for the microscope."
[motor electronics workaround]: workaround_motor_electronics/workaround_motor_electronics.md "Solutions to drive the motors without a Sangaboard PCB."

{{BOM}}

>! **Note on Sangaboard v0.5**
>!
>! The Sangaboard v0.5 from our preferred supplier has 11mm tall header connectors. If you purchase a board from another supplier and they use standard 8.5mm headers you will need to print a [different electronics drawer](customisations/drawer_options.md)

>i **Alternative electronics options**
>i 
>i
>i If you are using a version of the Raspberry Pi other than v4, or Sangaboard other than v0.5, you [may need a different electronics drawer](customisations/drawer_options.md).
>i
>i If you do not have a Sangaboard, you can make up a compatible solution from a microcontroller and separate driver boards.  This is described in the [motor electronics workaround] page.


[Raspberry Pi v4]: parts/electronics.yml#RaspberryPi "{cat:electronic}"
[Sangaboard v0.5]: parts/electronics/sangaboard.md "{cat:electronic, note: 'If you cannot get a Sangaboard, you can put together [workaround motor electronics](workaround_motor_electronics/workaround_motor_electronics.md) instead.'}"

[No 2 6.5mm self tapping screws]: parts/mechanical.yml#SelfTap_PoziPan_No2x6.5_SS "{cat:mech}"
[M3 nut]: parts/mechanical.yml#Nut_M3_SS "{cat:mech}"
[M3x10 cap head screws]: parts/mechanical.yml#CapScrew_M3x10mm_SS "{cat:mech}"
[#1 pozidrive screwdriver]: parts/tools/pozidrive_1_screwdriver.md "{cat:tool}"
[2.5mm Ball-end Allen key]: parts/tools/2.5mmBallEndAllenKey.md "{cat:tool}"

## Assembly video

![](https://www.youtube.com/watch?v=1YZMbfL6M7E)

## Prepare nuts for the electronics drawer {pagestep}

![](renders/prepare_stand7.png)
![](renders/prepare_stand8.png)
![](renders/mount_electronics1.png)
![](renders/mount_electronics2.png)

* Place an [M3 nut]{qty:1, cat:mech} into the slot just inside the hole in the front of the microscope stand.
* Place another [M3 nut]{qty:1} into the slot above the Sangaboard power connector on the [electronics drawer][Electronics drawer](fromstep){qty:1, cat:printedpart} you printed earlier .

## Fit the Raspberry Pi {pagestep}
![](renders/mount_electronics3.png)
![](renders/mount_electronics4.png)
![](renders/mount_electronics5.png)

* Take the [electronics drawer] and push the [Raspberry Pi v4]{qty:1} into place so the connectors show through the holes.
* Secure the Raspberry Pi in place with two [No 2 self tapping screws][No 2 6.5mm self tapping screws]{qty:2}, using a [screwdriver][#1 pozidrive screwdriver].

## Attach the camera ribbon cable {pagestep}
![](renders/mount_electronics6.png)
![](renders/mount_electronics7.png)

* Insert the ribbon cable from the optics module into the camera port of the Rasberry Pi, ensuring the contacts are on the opposite side from the clasp. There are [detailed instructions on the Rasbperry Pi website](https://projects.raspberrypi.org/en/projects/getting-started-with-picamera/2).

## Fit the Sangaboard {pagestep}

>i Your Sangaboard requires firmware in order to work. If you have purchased the board pre-flashed with firmware, it will already be installed. If you have made the board yourself, you may need to obtain and upload the firmware. Details of how to do this are given in the [Sangaboard v0.5] page.

![](renders/mount_electronics8.png)
![](renders/mount_electronics9.png)

* Mount the [Sangaboard v0.5]{qty:1} onto the Raspberry Pi GPIO pins, ensuring that the ribbon cable from the optics module passes through the slot.
* Check that the connector is aligned so that it covers all of the pins on the 40-pin connector on the Raspberry Pi, and that the Sangaboard mounting holes line up with the mounting points.
* Secure the Sangaboard in place with two  [No 2 self tapping screws][No 2 6.5mm self tapping screws]{qty:2}, using a [screwdriver][#1 pozidrive screwdriver]

## Connect the motors to the Sangaboard {pagestep}

![](renders/mount_electronics10.png)
![](renders/mount_electronics11.png)
![](renders/mount_electronics12.png)

* Push the x motor cable into its labelled connector
* Push the y and z motor cables into their labelled connectors. Make sure the motor from the correct axis on the microscope goes to the correct port.

## Connect the LED to the Sangaboard {pagestep}

![Connect the LED to the Sangaboard](diagrams/illumination_to_sangaboard_wiring.png)

Connect the wires to the Sangaboard v0.5

* Plug the 2-pin female connector onto the 2 way male header labelled "**CC**".

>i "CC" stands for Constant Current, it is the best way to reliably drive the LED.


## Mount the electronics drawer {pagestep}

![](renders/mount_electronics13.png)
![](renders/mount_electronics14.png)
![](renders/mount_electronics15.png)
![](renders/mount_electronics16.png)

* Slide the [electronics drawer] into the microscope base, making sure not to pinch any wires.
* Hold the [electronics drawer] in place with two [M3x10 cap head screws]{qty: 2} using a [2.5mm Allen key][2.5mm Ball-end Allen key]. The screws should screw into the two nuts inserted in Step 1.

## Wiring Complete {pagestep}

To power up your microscope you will need a [power supply][Raspberry Pi Power Supply](parts/electronics.yml#RaspberryPi_PowerSupply){qty:1, cat:electronic}. The microscope is powered through the Sangaboard v0.5 USB-C socket.

