# Assemble the basic optics module

These are the instructions for the basic optics module, however high resolution optics will also work. When using high resolution optics, a 400mm Raspberry Pi ribbon cable or longer is preferable as the additional height of the Raspberry Pi Camera makes adjustments easier. 

The imaging optics for this version of the microscope consist of the Raspberry Pi Camera and the lens from the camera. To create a microscope the wide angle lens is reversed and separated from the camera. This makes quite a good microscope objective with a field of view about 400μm across and a resolution of around 2μm. 

{{BOM}}

[M3 nut]: parts/mechanical.yml#Nut_M3_SS
[No 2 6.5mm self tapping screws]: parts/mechanical.yml#SelfTap_PoziPan_No2x6.5_SS

[Raspberry Pi Camera Module v2]: parts/electronics.yml#PiCamera_2
[Raspberry Pi ribbon cable (30cm)]: parts/electronics.yml#PiCamera_RibbonCable_300mm

## Visually inspect the lens spacer {pagestep}

Take the [lens spacer][Lens spacer](fromstep){qty:1, cat:printedpart} and confirm that:

* It has been printed in black ([why?](why_optics_black.md))
* It is dust free (You can blow air through to clean it)
* The central shaft is not obstructed by strings of plastic.



## Remove Pi Camera Lens {pagestep}

**WARNING!** The camera board is static sensitive.

* Before touching the Pi Camera touch a metal earthed object. If you own one, consider wearing and anti-static strap.
* Take the [Pi Camera][Raspberry Pi Camera Module v2]{Qty:1, cat:electronic} out of the package. Make sure to **hold it only by the sides of the board**.
* Take the protective film off the lens.
* Take the [Pi Camera lens tool]{qty: 1, cat:tool, note: "This should come with the pi camera"} and place it over the lens
* Slowly unscrew the lens (About 4 full turns of the tool)
* Carefully lift off the lens.
* Save the lens and the camera, we use both this version of the microscope.

![](renders/picam1.png)
![](renders/picam2.png)
![](renders/picam3.png)

## Push-fit the lens

* Work out which side of the lens used to be facing the camera sensor (This is the side with more lens visible)
* Place the lens over on the top of the lens spacer, with the side that was next to the camera sensor on top
* Push the lens into the lens spacer with pressure on the very edge of the lens.


## Attach the Pi Camera {pagestep}

* Take the Pi Camera and place it ontop of the [pi camera platform](fromstep){qty:1, cat:printedpart}.
* Place the lens spacer over the picamera
* Use four [No 2 6.5mm self tapping screws]{qty:4, cat:mech} to secure the three parts together using a [#1 pozidrive screwdriver]{qty:1, cat:tool}
* Take care to not over torque the screws.

## Attach the mounting screw {pagestep}

* Take an [M3 nut]{qty:1, cat:mech} and push it into the nut trap from the top
* Take an [M3x10 cap head screws](parts/mechanical.yml#CapScrew_M3x10mm_SS){qty: 1, cat:mech} and screw it into the nut.
* Only screw it in a couple of turns. About 5 mm of thread should still be visible


## Connect ribbon cable {pagestep}

* Take the [Raspberry Pi ribbon cable (30cm)]{qty:1, cat:electronic}
* Pull the catch forward on the exposed Pi Camera connector
* Insert the ribbon cable with the contacts towards the board
* Close the catch on the connector

## Set the complete module aside {pagestep}

Set the [compete optics module]{output, qty:1} aside in a safe place.
