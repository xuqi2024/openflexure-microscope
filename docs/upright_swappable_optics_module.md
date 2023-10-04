# Assemble the high-resolution upright swappable optics module

The imaging optics for this version of the microscope consist of an RMS objective, a tube lens[i](info_pages/imaging_optics_explanation.md) and the Raspberry pi camera arranged as shown below (with the illumination optics)

![Optics cutaway](renders/optics_assembled.png)


{{BOM}}

[M3 nut]: parts/mechanical.yml#Nut_M3_SS
[No 2 6.5mm self tapping screws]: parts/mechanical.yml#SelfTap_PoziPan_No2x6.5_SS
[#1 pozidrive screwdriver]: parts/tools/pozidrive_1_screwdriver.md "{cat:tool}"
[Pi Camera lens tool]: parts/tools/pi_camera_lens_tool.md "{cat:tool, note: 'This should come with the [Raspberry Pi Camera Module v2].  If it is missing, you can 3D print a [workaround lens remover].'}"
[workaround lens remover]: workaround_lens_remover.md

[Raspberry Pi Camera Module v2]: parts/electronics.yml#PiCamera_2 "{cat:electronic}"
[200mm Pi Camera ribbon cable]: parts/electronics.yml#PiCamera_RibbonCable_200mm "{cat:electronic, note: 'This is longer than the standard ribbon cable the Pi Camera is sold with!'}"

## Visually inspect the optics module {pagestep}

Take the [swappable optics module][swappable optics module](fromstep){qty:1, cat:printedpart} and confirm that:

* It has been printed in black [i](info_pages/why_optics_black.md)
* It is dust free (You can blow air through to clean it)
* The central shaft is not obstructed by strings of plastic.


## Insert the tube lens {pagestep}

* Place the [lens tool][lens tool](fromstep){qty:1, cat:printedtool} on a steady surface
* Place the [12.7 mm achromatic lens](parts/optics/tube_lens.md){qty:1, cat:optical} on the lens tool
* Check the lens has the more curved side facing down
* Take the optics module and place carefully over lens
* Push down hard to seat the lens in the optics module

![Insert tube lens](renders/optics_assembly_tube_lens.png)

## Remove Pi Camera Lens {pagestep}


>! **Caution!**
>!
>! The camera board is static sensitive.

* Before touching the Pi Camera touch a metal earthed object. If you own one, consider wearing an anti-static strap.
* Take the [Pi Camera][Raspberry Pi Camera Module v2]{Qty:1} out of the package. Make sure to **hold it only by the sides of the board**.
* Take the protective film off the lens.
* Take the [Pi Camera lens tool]{qty: 1} and place it over the lens
* Slowly unscrew the lens (About 4 full turns of the tool)
* Carefully lift off the lens. We do not use the lens in this version of the microscope.

![](renders/picam1.png)
![](renders/picam2.png)
![](renders/picam3.png)

## Attach the Pi Camera {pagestep}

* Take the Pi Camera and place it on the back of the swappable optics module.
* Place the [pi camera cover](fromstep){qty:1, cat:printedpart} over the back of the Pi Camera.
* Use two [No 2 6.5mm self tapping screws]{qty:6, cat:mech} to secure the camera using a [#1 pozidrive screwdriver]{qty:1, cat:tool}
* Take care to not over-torque the screws.

![Attach pi camera](renders/optics_assembly_camera.png)

## Assemble objective lens mount and optics module {pagestep}

* Turning the [objective lens mount]{qty:1, cat:printedpart} on each side, insert one [3x20mm stainless steel dowel]{qty:6, cat:mech} into each of the exterior six holes on the mount, being careful not to allow the dowels to protrude into the interior of the mount as this will block the objective lens. Each pair of dowels should be visible through the three surface holes on the mount.

>i  **Note**
>i 
>i Tolerances on the mount are deliberately tight so that the dowels are secured. It is recommended to use a [rubber mallet]{qty:1, cat:tool} or similar to drive the dowels into place without warping or damaging the part. 

* Take the [objective lens mount] and insert one [5x2.5mm disc magnet]{qty:2, cat:mech} into each of the two sockets so that they lie flush with the mount surface.
* Place the [swappable optics module] lens-up, such that the Pi Camera is on a flat surface. 
* Place the assembled [objective lens mount] magnet-side down over the optics module. The four screw-holes should align.
* Use four [No 2 6.5mm self tapping screws] to secure the mount to the optics module using a  [#1 pozidrive screwdriver].
* Take care not to over-torque the screws.

## Assemble the objective lens carrier {pagestep}

**One objective lens carrier should be assembled per objective lens to be used**.

* Place the [carrier jig]{qty:1, cat:printedtool} on a hard surface with three [5mm diameter stainless steel ball bearings]{qty:3, cat:mech}, each sitting on a hole in the jig.
* Take an [objective lens carrier]{qty:1, cat:printedpart, note: "One carrier should be printed and assembled per objective lens to be used."} and place it facing down atop the jig, with each ball bearing aligning with its socket on the carrier.
* Using a [rubber mallet] or similar, gently hammer the back of the [objective lens carrier] such that the ball bearings are evenly seated into their sockets in the carrier.
* Turning the carrier over, insert a [5x2.5mm disc magnet]{qty:2, cat:mech} into each of the remaining holes on the carrier so that they lie flush with the carrier surface.
>! **Caution**
>!
>! Check that the polarity of the carrier magnets matches that of the surface of the magnets on the mount such that they are attracted.
>! If the carrier does not seat evenly when inserted into the assembled optics module while facing the mount, the magnets can be ejected via a thin object (like a paperclip) inserted through the small hole in the back of the magnet insertion points, flipped, and reinserted.

* Repeat the above steps for each additional objective lens carrier.


## Attach objective lenses to carrier {pagestep}

* Take a [microscope objective](parts/optics/microscope-objective.md){qty:1, note:"This page provides more information on choosing an objective.", cat:optical} and an assembled objective lens carrier.
* Place objective on top of objective lens carrier, magnets facing upwards.
* **Check that the objective is not tilted!**
* Carefully and slowly screw the objective into the carrier, taking care to ensure it does not tilt.

![Attach the objective](renders/optics_assembly_objective.png)


## Attach the mounting screw {pagestep}

* Take an [M3 nut]{qty:1, cat:mech} and push it into the optics module's nut trap from the top.
* Take an [M3x10 cap head screws](parts/mechanical.yml#CapScrew_M3x10mm_SS){qty: 1, cat:mech} and screw it into the nut.
* Only screw it in a couple of turns. About 5 mm of thread should still be visible.

![Attach mounting screw](renders/optics_assembly_screw.png)

## Connect ribbon cable {pagestep}

* Take the [200mm Pi Camera ribbon cable]{qty:1}
* Pull the catch forward on the exposed Pi Camera connector
* Insert the ribbon cable with the contacts towards the board
* Close the catch on the connector

![Attach ribbon cable](renders/optics_assembly_ribbon.png)

## Set the complete module aside {pagestep}

Set the [complete optics module]{output, qty:1} aside in a safe place.
