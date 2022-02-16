# Assemble the illumination

In this section we are assembling the sample illumination. This is for transmission illumination.

{{BOM}}

[M3 nut]: parts/mechanical.yml#Nut_M3_SS
[M3x25mm stainless steel hex bolt]: parts/mechanical.yml#HexBolt_M3x25mm_SS
[M3 stainless steel washers]: parts/mechanical.yml#Washer_M3_SS
[2.5mm Ball-end Allen key]: parts/tools/2.5mmBallEndAllenKey.md

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


## Mount the condenser arm {pagestep}

![](renders/mount_illumination_{{var_optics, default:rms}}3.png)
![](renders/mount_illumination_{{var_optics, default:rms}}4.png)
![](renders/mount_illumination_{{var_optics, default:rms}}5.png)

* Slide the condenser arm into the illumination dovetail until it is approximately flush with the top
* Tighten the thumbscrew by hand to lock the arm in place.
* Do not worry about the exact position, this will be adjusted on first use.


## Push-fit the LED {pagestep}

* Get the [LED][LED assembly](fromstep){qty:1, cat:subassembly} you soldered earlier
* Bend the LED cable to 90 degrees from the LED
* Push the LED into the top of the condenser

