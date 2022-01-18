# Assemble the illumination

In this section we are assembling the sample illumination. This is for transmission illumination.

{{BOM}}

[M3 nut]: parts/mechanical.yml#Nut_M3_SS
[M3x25mm stainless steel hex bolt]: parts/mechanical.yml#HexBolt_M3x25mm_SS
[M3 stainless steel washers]: parts/mechanical.yml#Washer_M3_SS
[2.5mm Ball-end Allen key]: parts/tools/2.5mmBallEndAllenKey.md

[150 Ohm Resistor]: parts/electronics.yml#Resistor_150R
[Warm white 5mm LED]: parts/electronics.yml#LED_WarmWhite
[2 pin Du Pont connector female housing]: parts/electronics.yml#DuPont_Housing_1x2
[Red pre-crimped Female-Female jumper cable (30 cm)]: parts/electronics.yml#JumperCable_FF_300mm_Red
[Black pre-crimped Female-Female jumper cable (30 cm)]: parts/electronics.yml#JumperCable_FF_300mm_Black
[Black heatshrink - 4.8mm ID]: parts/electronics.yml#Heatshrink_4.8mm_Black
[Red heatshrink - 2.4mm ID]: parts/electronics.yml#Heatshrink_2.4mm_Red

## Solder the LED {pagestep}


*If you have purchased a kit you may already have an assembled soldered LED cable*

* Tun on your [soldering iron]{cat:tool, qty:1} so it can heat up
* Take the [LED][Warm white 5mm LED]{qty:1, cat:electronic}
* Cut the longest leg down to about 5mm long using [precision wire cutters](parts/tools/precision-wire-cutters.md){qty:1, cat:tool}
* Tin this leg with [solder]{qty: a little, cat:consumable}
* Take a [150 Ohm Resistor]{qty:1, note:"- The exact value will depend on the current rating of your LED.", cat:electronic} and cut each leg down to about 5mm long. ([why?](why_led_resistor.md))
* Tin both legs with solder
* Solder one side of the resistor to the cut leg of the LED.
* Cut the other leg of the LED to be the same height as the end of the resistor.
* Tin the end of this leg
* Take the [red][Red pre-crimped Female-Female jumper cable (30 cm)]{qty:1, cat:electronic} and [black][Black pre-crimped Female-Female jumper cable (30 cm)]{qty:1, cat:electronic} precrimped jumper cables and cut off one end with [wire strippers]{qty:1, cat:tool}
* Strip about 5mm of cable on each, and tin the cable with [wire strippers]{qty:1, cat:tool}
* Solder the red wire to the leg with the resistor
* Solder the black wire to the other leg
* Take the [red heatshrink][Red heatshrink - 2.4mm ID]{qty:35mm, cat:electronic} and slide it over the red cable up to the LED.
* Use a [heatgun]{qty:1, cat:tool, note: "If you don't have a heatgun the soldering iron can be used"} to shrink the heatshrink
* Take the [black heatshrink][Black heatshrink - 4.8mm ID]{qty:40mm, cat:electronic} and slide it over both cables up to the LED.
* Use a [heatgun]{qty:1} to shrink the heatshrink



## Add the connector {pagestep}

* Take the [DuPont housing][2 pin Du Pont connector female housing]{qty:1, cat:electronic}
* Push both connectors from the LED cable into the connector


## Mount the dovetail {pagestep}

![](renders/mount_illumination1.png)
![](renders/mount_illumination2.png)


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

![](renders/mount_illumination3.png)
![](renders/mount_illumination4.png)
![](renders/mount_illumination5.png)

* Slide the condenser arm into the illumination dovetail until it is approximately flush with the top
* Tighten the thumbscrew by hand to lock the arm in place.
* Do not worry about the exact position, this will be adjusted on first use.


## Push-fit the LED {pagestep}

* Bend the LED cable to 90 degrees from the LED
* Push the LED into the top of the condenser

