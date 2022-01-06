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
* Tin this leg with [solder]{qty: A little, cat:consumable}
* Take a [150 Ohm Resistor]{qty:1, note:"- The exact value will depend on the current rating of your LED.", cat:electronic} and cut each leg down to about 5mm long
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

## Push-fit the lens {pagestep}

* Place the [Condenser lens](parts/optics.yml#CondenserLens){qty:1, cat:optical} on the [lens tool][Lens tool](fromstep){qty:1, cat:printedtool} flat side down
* Take the [upright condenser][Upright condenser](fromstep){qty:1, cat:printedpart} and align the opening over the lens
* Push down until the lens clicks into place

![](images/upright/lens_tool_with_lens.jpg)
![](images/upright/push_fit_lens_apparatus.jpg)
![](images/upright/push_fit_lens.jpg)

## Push-fit the LED {pagestep}

* Push the LED as far as possible up the hole in the side of mount of the condenser, it should fit securely

## Add the condenser mounting screw {pagestep}

* Take an [M3 nut]{qty:1, cat:mech} and push it into the nut trap in the condenser mount from the top
* Take an [M3x10 cap head screws](parts/mechanical.yml#CapScrew_M3x10mm_SS){qty:1, cat:mech} and screw it into the nut, only screw a couple of turns about **5mm of thread should still be visible at this stage** 


## Mount the upright condenser onto the main body {pagestep}

* Take the complete upright condenser and pass is through the bottom of the main body until the top of the condenser is in line with the stage.
* Insert the exposed mounting screw into the screw hole in the z-actuator of the main body.
* Insert the [2.5mm Ball-end Allen key]{qty:1, cat:tool} through the teardrop shaped hole on the front of the microscope. Until it engages with the mounting screw.
* Slide the upright condenser up the keyhole until the top of the condenser is 2-4mm below the top of the stage while keeping the Allen key engaged with the screw. 
* Tighten the screw with the Allen key to lock the optics in place.
