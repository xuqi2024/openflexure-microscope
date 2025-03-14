# Assemble the Logitech C270 basic optics module

This section describes how to assemble an optics module consisting of a Logitech C270 webcam and the lens from the camera. To create a microscope the wide angle lens is reversed and separated from the camera. This makes quite a good microscope objective with a field of view about 400μm across and a resolution of around 2μm.

{{BOM}}

[M3 nut]: ../parts/mechanical.yml#Nut_M3_SS
[No 2 6.5mm self tapping screws]: ../parts/mechanical.yml#SelfTap_PoziPan_No2x6.5_SS
[#0 Phillips screwdriver]: ../parts/tools/phillips_0_screwdriver.md "{cat:tool}"

[PLA filament]: ../parts/materials/pla_filament.md "{cat:material}"
[Black PLA filament]: ../parts/materials/black_pla_filament.md "{cat:material}"
[RepRap-style printer]: ../parts/tools/rep-rap.md "{cat:tool}"
[2.5mm Ball-end Allen key]: ../parts/tools/2.5mmBallEndAllenKey.md

[custom print settings]: ../set_slice_gap_closing_radius.md

## Print the lens spacer and camera platform {pagestep}

Using a [RepRap-style printer]{qty:1}, print the following parts using [PLA filament]{qty: 20g}.

* [lens_spacer_logitech_c270.stl](../models/lens_spacer_c270.stl){previewpage} - The lens gripper may require [custom print settings] - **This must be printed in [black][Black PLA filament]{Qty: 20g}!** [i](../info_pages/why_optics_black.md)
* [camera_platform_logitech_c270.stl](../models/camera_platform_c270.stl){previewpage} 


## Visually inspect the lens spacer {pagestep}

Take the lens spacer and confirm that:

* It has been printed in black [i](../info_pages/why_optics_black.md)
* It is dust free (You can blow air through to clean it)
* The central shaft is not obstructed by strings of plastic.


## Push-fit the lens {pagestep}

* Work out which side of the [Logitech C270 camera][prepared Logitech C270 camera](fromstep){qty:1} lens used to be facing the camera sensor (This is the side with more lens visible).
* Place the lens on a clean surface with the side that was next to the camera sensor on the bottom, and the wider knurled ring towards the top.
* Push the printed lens spacer down onto the lens until the lens clicks into place. The lens should be flat in the holder and sticking out a little.

![](../renders/low_cost_optics_assembly_c270_lens.png)

## Attach the Logitech C270 camera {pagestep}

* Take the Logitech C270 camera circuit board and place the assembled lens spacer over the camera sensor at one end of the board. The lens spacer does not cover all of the circuit board.
* Place the camera circuit board and lens spacer together onto the camera platform. Line up the mounting holes in the lens spacer with the posts on the camera platform.
* Use three screws saved from preparing the web cam to secure the three parts together using a [#0 Phillips screwdriver]{qty:1, cat:tool}
* Take care to not over torque the screws.

![](../renders/low_cost_optics_assembly_camera_c270_lens.png)

## Attach the mounting screw {pagestep}

* Take an [M3 nut]{qty:1, cat:mech} and push it into the nut trap in the camera platform from the top
* Take an [M3x10 cap head screws](../parts/mechanical.yml#CapScrew_M3x10mm_SS){qty: 1, cat:mech} and screw it into the nut.
* Only screw it in a couple of turns. About 5 mm of thread should still be visible.

![](../renders/low_cost_optics_assembly_screw_c270_lens.png)

## Mount the optics module in the microscope {pagestep}

(see <a href="../manual_microscope/mount_optics_and_microscope.html">mounting the basic optics module</a> for more details of this method) 

* Insert the complete optics module into the microscope body between the microscope stage legs opposite the illumination platform.
* Fit the M3 screw head into the keyhole slot in the z-actuator .
* Insert a [2.5mm Ball-end Allen key]{qty:1, cat:tool} through the teardrop shaped hole on the front of the microscope until it engages with the mounting screw.
* Slide the optics module up until the base of the camera platform is level with the base of the dovetail. 
* Tighten the M3 screw with the Allen key 