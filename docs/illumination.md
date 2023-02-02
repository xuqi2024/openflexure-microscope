# Assemble the illumination

In this section we are assembling the transmission illuminator.  This mounts the LED and condenser lens above the sample, so the transmitted light can be imaged by the microscope objective.

{{BOM}}

[M3 nut]: parts/mechanical.yml#Nut_M3_SS "{cat:mech}"
[M3 stainless steel washers]: parts/mechanical.yml#Washer_M3_SS "{cat:mech}"
[M3x10 cap head screws]: parts/mechanical.yml#CapScrew_M3x10mm_SS "{cat:mech}"
[No 2 6.5mm self tapping screws]: parts/mechanical.yml#SelfTap_PoziPan_No2x6.5_SS "{cat:mech}"
[2.5mm Ball-end Allen key]: parts/tools/2.5mmBallEndAllenKey.md "{cat:tool}"
[#1 pozidrive screwdriver]: parts/tools/pozidrive_1_screwdriver.md "{cat:tool}"
[illumination PCB]: ./parts/electronics/illumination_pcb.md "{cat:electronic, note: 'A 5mm LED can be used instead, if you follow the [LED workaround](./workaround_5mm_led/workaround_5mm_led.md).'}"

[LED workaround]: ./workaround_5mm_led/workaround_5mm_led.md

>i If the illumination PCB is not available, you can use a 5mm LED instead, by following the [LED workaround].

## Push-fit the lens {pagestep}

![](renders/{{var_upright_n, default:}}optics_assembly_condenser_lens.png)

* Place the [condenser lens](parts/optics/condenser_lens.md){qty:1, cat:optical} on the [lens tool][Lens tool](fromstep){qty:1, cat:printedtool} flat side down
* Take the [condenser arm][Condenser arm](fromstep){qty:1, cat:printedpart} and align the opening over the lens
* Push down until the lens clicks into place.
* Visually inspect the positioning of the lens. It should be flat, not seated at an angle. If necessary, push against the [lens tool][Lens tool](fromstep){qty:1, cat:printedtool} to align properly.

{{include: illumination_thumbscrew.md, if: var_upright_n is not upright_}}

## Cut out the diffuser {pagestep}

* Take a small sheet of [0.5mm polypropylene]{qty: 4cm^2} [i](info_pages/illumination_optics_explanation.md).
* Cut out a circle, approximately 14mm in diameter, using a [utility knife]{qty:1}.  It is better to be slightly smaller than required, rather than slightly larger.
* Using the [condenser board spacer](fromstep) as a guide, make two small holes for the screws that mount the illumination.
* The diffuser is shown in white in the next step.

[0.5mm polypropylene]: parts/materials/white_polypropylene_sheet.md "{cat:material}"
[utility knife]: parts/tools/utility-knife.md "{cat: tool}"

## Mount the diffuser and LED board {pagestep}

![](renders/{{var_upright_n, default:}}mount_led_board1.png)
![](renders/{{var_upright_n, default:}}mount_led_board2.png)
![](renders/{{var_upright_n, default:}}mount_led_board3.png)
![](renders/{{var_upright_n, default:}}mount_led_board4.png)

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

![](renders/{{var_upright_n, default:}}mount_led_cable1.png)
![](renders/{{var_upright_n, default:}}mount_led_cable2.png)

* Attach the illumination wiring harness to the [illumination PCB]

## Attach the illumination cover {pagestep}

![](renders/{{var_upright_n, default:}}mount_condenser_lid1.png)
![](renders/{{var_upright_n, default:}}mount_condenser_lid2.png)
![](renders/{{var_upright_n, default:}}mount_condenser_lid3.png)
![](renders/{{var_upright_n, default:}}mount_condenser_lid4.png)

* Place the [condenser lid][Condenser lid](fromstep){qty:1, cat:printedpart} on top of the condenser assembly.
* Secure in place with two [No 2 6.5mm self tapping screws]{qty:2} using a [#1 pozidrive screwdriver]{qty:1}.

{{include: {{var_upright_n, default:}}illumination_mount.md}}
