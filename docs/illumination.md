# Assemble the illumination

In this section we are assembling the transmission illuminator.  This mounts the LED and condenser lens above the sample, so the transmitted light can be imaged by the microscope objective.

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

## Mount the dovetail {pagestep}

![](renders/mount_illumination_{{var_optics, default:rms}}1.png)
![](renders/mount_illumination_{{var_optics, default:rms}}2.png)


* Place the [illumination dovetail][Illumination dovetail](fromstep){qty:1, cat:printedpart} onto the stage above the z-actuator of the main body.
* Secure in place with two [M3x10 cap head screws]{qty:2} and 2 [M3 Washers][M3 stainless steel washers]{qty: 2} (using [2.5mm Ball-end Allen key]{qty:1})


## Push-fit the lens {pagestep}


* Place the [condenser lens](parts/optics/condenser_lens.md){qty:1, cat:optical} on the [lens tool][Lens tool](fromstep){qty:1, cat:printedtool} flat side down
* Take the [condenser arm][Condenser arm](fromstep){qty:1, cat:printedpart} and align the opening over the lens
* Push down until the lens clicks into place.
* Visually inspect the positioning of the lens. It should be flat, not seated at an angle. If necessary, push against the [lens tool][Lens tool](fromstep){qty:1, cat:printedtool} to align properly.

![](renders/optics_assembly_condenser_lens.png)

## Add the condenser retaining screw {pagestep}

![](renders/assemble_condenser_thumbscrew1.png)
![](renders/assemble_condenser_thumbscrew2.png)
![](renders/assemble_condenser_thumbscrew3.png)


* Place an [M3x25mm stainless steel hex bolt]{qty:1} through the [Illumination thumbscrew](fromstep){qty:1, cat:printedpart}
* Drop an [M3 nut]{qty:1} into the nut slot on the condenser arm dovetail
* Start to screw the thumbscrew into the nut from the outside of the dovetail 
* Screw the thumbscrew by hand until it almost touches the dovetail. **Do not tighten further at this stage**

## Cut out the diffuser {pagestep}

* Take a small sheet of [0.5mm polypropylene]{qty: 4cm^2} [i](info_pages/illumination_optics_explanation.md).
* Cut out a circle, approximately 14mm in diameter, using a [utility knife]{qty:1}.  It is better to be slightly smaller than required, rather than slightly larger.
* Using the [condenser board spacer](fromstep) as a guide, make two small holes for the screws that mount the illumination.
* The diffuser is shown in white in the next step.

[0.5mm polypropylene]: parts/materials/white_polypropylene_sheet.md "{cat:material}"
[utility knife]: parts/tools/utility-knife.md "{cat: tool}"

## Mount the diffuser and LED board {pagestep}

![](renders/mount_led_board1.png)
![](renders/mount_led_board2.png)
![](renders/mount_led_board3.png)
![](renders/mount_led_board4.png)

* Turn the condenser over, so the flat side is on top.
* Place the diffuser on the condenser, then the [condenser board spacer][Condenser board spacer](fromstep){qty:1, cat:printedpart}, then the [illumination PCB]{qty:1}.
* Fix in place with two [No 2 6.5mm self tapping screws]{qty:2} using a [#1 pozidrive screwdriver]{qty:1}.

## Assemble the illumination wiring harness {pagestep}
* Take a [red pre-crimped female-female jumper cable (30 cm)][Pre-crimped Female-Female jumper cable (30 cm), Red]{qty:1} and a [black pre-crimped female-female jumper cable (30 cm)][Pre-crimped Female-Female jumper cable (30 cm), Black]{qty:1}.
* Attach a [2 pin Du Pont connector female housing]{qty:2} to each end.
* This is the illumination wiring harness.

[2 pin Du Pont connector female housing]: parts/electronics.yml#DuPont_Housing_1x2 "{cat:electronic}"
[Pre-crimped Female-Female jumper cable (30 cm), Red]: parts/electronics.yml#JumperCable_FF_300mm_Red "{cat:electronic}"
[Pre-crimped Female-Female jumper cable (30 cm), Black]: parts/electronics.yml#JumperCable_FF_300mm_Black "{cat:electronic}"

## Attach the illumination cable {pagestep}

![](renders/mount_led_cable1.png)
![](renders/mount_led_cable2.png)

* Attach the illumination wiring harness to the [illumination PCB]

<form class="qaqc">
<h3>QA/QC check</h3>
<label for="condenser-board-pic">Before attaching the cover. Take a photo of the illumination board and cable mounted to the condenser.</label><br>
<input type="file" id="condenser-board-pic" accept="image/*" ><br>
<button class="qaqc-complete">Checks complete</button>
</form>

## Attach the illumination cover {pagestep}

![](renders/mount_condenser_lid1.png)
![](renders/mount_condenser_lid2.png)
![](renders/mount_condenser_lid3.png)
![](renders/mount_condenser_lid4.png)

* Place the [condenser lid][Condenser lid](fromstep){qty:1, cat:printedpart} on top of the condenser assembly.
* Secure in place with two [No 2 6.5mm self tapping screws]{qty:2} using a [#1 pozidrive screwdriver]{qty:1}.

## Insert the illumination wiring {pagestep}

![](renders/mount_illumination_{{var_optics, default:rms}}3.png)

* Pass the illumination wiring harness from the top to the bottom of the cable guide in the illumination dovetail.
* Pass the illumination wiring harness from the top to the bottom of the cable guide in the main body, between the Z gear and the Y gear.

## Mount the condenser arm {pagestep}

![](renders/mount_illumination_{{var_optics, default:rms}}4.png)
![](renders/mount_illumination_{{var_optics, default:rms}}5.png)
![](renders/mount_illumination_{{var_optics, default:rms}}6.png)

* Slide the condenser arm into the illumination dovetail until it is approximately flush with the top
* Tighten the thumbscrew by hand to lock the arm in place.
* Do not worry about the exact position, this will be adjusted on first use.

<form class="qaqc">
<h3>QA/QC check</h3>
<label for="mount-illumination-comment">(Optional) Please provide any extra feedback on mounting the illumination.</label><br><br>
<textarea id="mount-illumination-comment" name="mount-illumination-comment" rows="4" cols="50"></textarea><br>
<button class="qaqc-complete">Checks complete</button>
</form>
