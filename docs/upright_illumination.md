# Assemble the illumination

In this section we are assembling the transmission illuminator for an upright microscope.  This mounts the LED and condenser lens below the sample, so the transmitted light can be imaged by the microscope optics above the sample.

{{BOM}}

[M3 nut]: parts/mechanical.yml#Nut_M3_SS "{cat:mech}"
[M3x25mm stainless steel hex bolt]: parts/mechanical.yml#HexBolt_M3x25mm_SS "{cat:mech}"
[M3 stainless steel washers]: parts/mechanical.yml#Washer_M3_SS "{cat:mech}"
[M3x10 cap head screws]: parts/mechanical.yml#CapScrew_M3x10mm_SS "{cat:mech}"
[No 2 6.5mm self tapping screws]: parts/mechanical.yml#SelfTap_PoziPan_No2x6.5_SS "{cat:mech}"
[2.5mm Ball-end Allen key]: parts/tools/2.5mmBallEndAllenKey.md "{cat:tool}"
[#1 pozidrive screwdriver]: parts/tools/pozidrive_1_screwdriver.md "{cat:tool}"
[illumination PCB]: ./parts/electronics/illumination_pcb.md "{cat:electronic, note: 'A 5mm LED can be used instead, if you follow the [LED workaround](./workaround_5mm_led/workaround_5mm_led.md).'}"

[LED workaround]: ./workaround_5mm_led/workaround_5mm_led.md

>i If the illumination PCB is not available, you can use a 5mm LED instead, by following the [LED workaround].


## Push-fit the lens {pagestep}

![](renders/upright_optics_assembly_condenser_lens.png)

* Place the [condenser lens](parts/optics/condenser_lens.md){qty:1, cat:optical} on the [lens tool][Lens tool](fromstep){qty:1, cat:printedtool} flat side down
* Take the [upright condenser][upright condenser](fromstep){qty:1, cat:printedpart} and align the opening over the lens
* Push down until the lens clicks into place.

## Cut out the diffuser {pagestep}

* Take a small sheet of [0.5mm polypropylene]{qty: 4cm^2}.
* Cut out a circle, approximately 14mm in diameter, using a [utility knife]{qty:1}.  It is better to be slightly smaller than required, rather than slightly larger.
* Using the [condenser board spacer](fromstep) as a guide, make two small holes for the screws that mount the illumination.
* The diffuser is shown in white in the next step.

[0.5mm polypropylene]: parts/materials/white_polypropylene_sheet.md "{cat:material}"
[utility knife]: parts/tools/utility-knife.md "{cat: tool}"

## Mount the diffuser and LED board {pagestep}

![](renders/upright_mount_led_board1.png)
![](renders/upright_mount_led_board2.png)
![](renders/upright_mount_led_board3.png)
![](renders/upright_mount_led_board4.png)

* Turn the condenser over, so the flat side is on top. 
* Note the position of the small slot in the side.
* Place the diffuser on the condenser, then the [condenser board spacer][Condenser board spacer](fromstep){qty:1, cat:printedpart}.
* Place the [illumination PCB]{qty:1} with the pins towards the slot.
* Fix in place with two [No 2 6.5mm self tapping screws]{qty:2} using a [#1 pozidrive screwdriver]{qty:1}.

## Assemble the illumination cable {pagestep}
* Take a [Red pre-crimped Female-Female jumper cable (30 cm)] and a [Black pre-crimped Female-Female jumper cable (30 cm)].
* Attach a [2 pin Du Pont connector female housing]{qty:2} to each end.
* This is the illumination cable.

[2 pin Du Pont connector female housing]: parts/electronics.yml#DuPont_Housing_1x2 "{cat:electronic}"
[Red pre-crimped Female-Female jumper cable (30 cm)]: parts/electronics.yml#JumperCable_FF_300mm_Red "{cat:electronic}"
[Black pre-crimped Female-Female jumper cable (30 cm)]: parts/electronics.yml#JumperCable_FF_300mm_Black "{cat:electronic}"

## Attach the illumination cable {pagestep}

![](renders/upright_mount_led_cable1.png)
![](renders/upright_mount_led_cable2.png)

* Attach the illumination cable to the [illumination PCB]
* Make sure that the red wire is attached to the terminal labelled '+'

## Attach the condenser to the condenser platform {pagestep}

![](renders/upright_mount_condenser_lid1.png)
![](renders/upright_mount_condenser_lid2.png)
![](renders/upright_mount_condenser_lid3.png)
![](renders/upright_mount_condenser_lid4.png)

* Place the assembled condenser on the [upright condenser platform][upright condenser platform](fromstep){qty:1, cat:printedpart}.
>i Check that the illumination wiring and the small slot in the condenser body are both pointing away from the mounting dovetail.
* Secure in place with two [No 2 6.5mm self tapping screws]{qty:2} using a [#1 pozidrive screwdriver]{qty:1}.

## Add the condenser mounting screw {pagestep}

* Take an [M3 nut]{qty:1, cat:mech} and push it into the nut trap in the condenser platform from the top
* Take an [M3x10 cap head screws](parts/mechanical.yml#CapScrew_M3x10mm_SS){qty:1, cat:mech} and screw it into the nut, only screw a couple of turns about **5mm of thread should still be visible at this stage** 


## Mount the upright condenser onto the main body {pagestep}

* Take the complete upright condenser and pass it through the bottom of the main body until the top of the condenser is a little below the stage.
* Insert the exposed mounting screw into the screw hole in the z-actuator of the main body.
* Insert the [2.5mm Ball-end Allen key]{qty:1, cat:tool} through the teardrop shaped hole on the front of the microscope. Until it engages with the mounting screw.
* Slide the upright condenser up the keyhole until the top of the condenser is 2-4mm below the top of the stage while keeping the Allen key engaged with the screw. 
* Tighten the screw with the Allen key to lock the condenser in place.
