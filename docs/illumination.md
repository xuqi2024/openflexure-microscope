# Assemble the illumination

In this section we are assembling the transmission illuminator.  This mounts the LED and condenser lens above the sample, so the transmitted light can be imaged by the microscope objective.

{{BOM}}

[M3 nut]: parts/mechanical.yml#Nut_M3_SS
[M3x25mm stainless steel hex bolt]: parts/mechanical.yml#HexBolt_M3x25mm_SS
[M3 stainless steel washers]: parts/mechanical.yml#Washer_M3_SS
[No 2 6.5mm self tapping screws]: parts/mechanical.yml#SelfTap_PoziPan_No2x6.5_SS
[2.5mm Ball-end Allen key]: parts/tools/2.5mmBallEndAllenKey.md
[#1 pozidrive screwdriver]: missing

## Mount the dovetail {pagestep}

![](renders/mount_illumination_{{var_optics, default:rms}}1.png)
![](renders/mount_illumination_{{var_optics, default:rms}}2.png)


* Place the [illumination dovetail][Illumination dovetail](fromstep){qty:1, cat:printedpart} onto the stage above the z-actuator of the main body.
* Secure in place with two [M3x10 cap head screws](parts/mechanical.yml#CapScrew_M3x10mm_SS){qty:2, cat:mech} and 2 [M3 Washers][M3 stainless steel washers]{qty:2, cat:mech} (using [2.5mm Ball-end Allen key]{qty:1, cat:tool})


## Push-fit the lens {pagestep}


* Place the [condenser lens](parts/optics.yml#CondenserLens){qty:1, cat:optical} on the [lens tool][Lens tool](fromstep){qty:1, cat:printedtool} flat side down
* Take the [condenser arm][Condenser arm](fromstep){qty:1, cat:printedpart} and align the opening over the lens
* Push down until the lens clicks into place.

![](renders/optics_assembly_condenser_lens.png)

## Add the condenser retaining screw {pagestep}

![](renders/assemble_condenser_thumbscrew1.png)
![](renders/assemble_condenser_thumbscrew2.png)
![](renders/assemble_condenser_thumbscrew3.png)


* Place an [M3x25mm stainless steel hex bolt]{qty:1, cat:mech} through the [Illumination thumbscrew](fromstep){qty:1, cat:printedpart}
* Drop an [M3 nut]{qty:1, cat:mech} into the nut slot on the condenser arm dovetail
* Start to screw the thumbscrew into the nut from the outside of the dovetail 
* Screw the thumbscrew by hand until it almost touches the dovetail. **Do not tighten further at this stage**

## Cut out the diffuser {pagestep}

* Take a small sheet of [0.5mm polypropyline]{qty: 4cm^2}.
* Cut out a circle, approximately 14mm in diameter, using a [utility knife]{qty:1}.  It is better to be slightly smaller than required, rather than slightly larger.
* Using the [condenser board spacer](fromstep) as a guide, make two small holes for the screws that mount the illumination.
* The diffuser is shown in white in the next step.

[0.5mm polypropyline]: parts/materials/white_polypropyline_sheet.md "{cat:material}"
[utility knife]: parts/tools/utility-knife.md "{cat: tool}"

## Mount the diffuser and LED board {pagestep}

![](renders/mount_led_board1.png)
![](renders/mount_led_board2.png)
![](renders/mount_led_board3.png)
![](renders/mount_led_board4.png)

* Turn the condenser over, so the flat side is on top.
* Place the [diffuser]{qty: 1} on the condenser, then the [condenser board spacer][Condenser board spacer](fromstep){qty:1}, then the [illumination PCB]{qty:1}.
* Fix in place with two [No 2 6.5mm self tapping screws]{qty:2, cat:mech} using a [#1 pozidrive screwdriver]{cat:tool, qty:1}.

## Attach the illumination cable {pagestep}

![](renders/mount_led_cable1.png)
![](renders/mount_led_cable2.png)

* Attach the [illumination wiring harness]{qty:1} to the [illumination PCB]

## Attach the illumination cover {pagestep}

![](renders/mount_condenser_lid1.png)
![](renders/mount_condenser_lid2.png)
![](renders/mount_condenser_lid3.png)
![](renders/mount_condenser_lid4.png)

* Place the [condenser lid][Condenser lid](fromstep){qty:1} on top of the condenser assembly.
* Secure in place with two [No 2 6.5mm self tapping screws]{qty:2, cat:mech} using a [#1 pozidrive screwdriver]{cat:tool, qty:1}.

## Insert the illumination wiring {pagestep}

![](renders/mount_illumination_{{var_optics, default:rms}}3.png)

* Pass the [illumination wiring harness] from the top to the bottom of the cable guide in the illumination dovetail.
* Pass the [illumination wiring harness] from the top to the bottom of the cable guide in the main body, between the Z gear and the Y gear.

## Mount the condenser arm {pagestep}

![](renders/mount_illumination_{{var_optics, default:rms}}4.png)
![](renders/mount_illumination_{{var_optics, default:rms}}5.png)
![](renders/mount_illumination_{{var_optics, default:rms}}6.png)

* Slide the condenser arm into the illumination dovetail until it is approximately flush with the top
* Tighten the thumbscrew by hand to lock the arm in place.
* Do not worry about the exact position, this will be adjusted on first use.

