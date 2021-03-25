# Assemble the illumination

In this section we are assembling the sample illumination. This is for transmission illumination.

{{BOM}}


# Requirements
## Parts
*   1 [Illumination dovetail](./parts/printed/illumination_dovetail.md)
*   1 [condenser arm](./parts/printed/condenser.md)
*   1 [5mm LED](./parts/electronics/white_led.md) ideally wired up to a 2-way female header
*   2 [M3x8 cap head screws](./parts/fixings/m3x8mm_caphead_screw.md)
*   2 [M3 Washers](./parts/fixings/m3_washer.md)
*   1 [Condenser lens](./parts/optics/condenser_lens.md) (optional)

## Tools
* 2.5mm hex key
* [Lens tool](fromstep){qty:1, cat:printedtool}




## Solder the LED {pagestep}

*If you have purchased a kit you may already have an assembled soldered LED cable*

* Take the [LED][5mm LED](./parts/electronics/white_led.md){qty:1}
* Cut the longest leg down to about 5mm long using [precision wire cutters](parts/tools/precision-wire-cutters.md){qty:1, cat:tool}
* Tin this leg with solder
* Take a [150 Ohm Resistor]{qty:1, note:"- The exact value will depend on the current rating of your LED."} and cut each leg down to about 5mm long
* Tin both legs with solder
* Solder one side of the resistor to the cut leg of the LED.
* Cut the other leg of the LED to be the same height as the end of the resistor.
* Tin the end of this leg
* Take the [red][Red pre-crimped Female-Female jumper cable (30 cm)]{qty:1} and [black][Black pre-crimped Female-Female jumper cable (30 cm)]{qty:1} precrimped jumper cables and cut off one end with [wire strippers]{qty:1, cat:tool}
* Strip about 5mm of cable on each, and tin the cable with [wire strippers]{qty:1, cat:tool}
* Solder the red wire to the leg with the resistor
* Solder the black wire to the other leg
* Take the [red heatshrink][Red heatshrink. 2.4mm ID, 35mm long]{qty:1} and slide it over the red cable up to the LED.
* Use a [heatgun]{qty:1, cat:tool, note: "If you don't have a heatgun the soldering iron can be used"} to shrink the heatshrink
* Take the [black heatshrink][Black heatshrink. 4.8mm ID, 40mm long]{qty:1} and slide it over both cables up to the LED.
* Use a [heatgun]{qty:1} to shrink the heatshrink



## Add the connector {pagestep}

* Take the [DuPont housing][2 pin Du Pont connector female housing]{qty:1}
* Push both connectors from the LED cable into the connector


## Mount the dovetail {pagestep}

* Place the [illumination dovetail][Illumination dovetail](fromstep){qty:1, cat:printedpart} onto the stage above the z-actuator of the main body.
* Secure in place with two [M3x8 cap head screws](parts/fixings/m3x8mm_caphead_screw.md){qty:2} and 2 [M3 Washers](./parts/fixings/m3_washer.md){qty:2} (using [2.5mm Allen key]{qty:1, cat:tool})


## Push-fit the lens {pagestep}


* Place the [condenser lens](./parts/optics/condenser_lens.md){qty:1} on the [lens tool][Lens tool](fromstep){qty:1, cat:printedtool} flat side down
* Take the [condenser arm][Condenser arm](fromstep){qty:1, cat:printedpart} and align the opening over the len
* Push down until the lens clicks into place.

![](./renders/optics_assembly_condenser_lens.png)

## Add the condenser retaining screw {pagestep}

* Place an [M3x25mm stainless steel hex bolt]{qty:1} through the [Illumination thumbscrew](fromstep){qty:1, cat:printedpart}
* Drop an [M3 nut]{qty:1} into the nut slot on the condenser arm dovetail
* Start to screw the thumbscrew into the nut from the outside of the dovetail 
* Screw the thumbscrew by hand until it almost touches the dovetail. **Do not tighten further at this stage**


## Mount the condenser arm {pagestep}

* Slide the condenser arm into the illumination dovetail until it is approximately flush with the top
* Tighten the thumbscrew by hand to lock the arm in place.
* Do not worry about the exact position, this will be adjusted on first use.


## Push-fit the LED {pagestep}

* Bend the LED cable to 90 degrees from the LED
* Push the LED into the top of the condenser

