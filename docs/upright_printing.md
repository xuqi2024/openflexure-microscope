# Print the plastic parts

If you have bought the plastic parts you can skip this step!

**You can build an upright microscope using a version 6 body. If you are using a version 6 main body, screw a self-tapping screw into the back screw hole of the rectangular z-axis to secure it in place, this will help stabilise the microscope when holding the additional weight of the lens.**


{{BOM}}

[PLA filament]: parts/materials/pla_filament.md "{cat:material}"
[Black PLA filament]: parts/materials/black_pla_filament.md "{cat:material}"
[RepRap-style printer]: parts/tools/rep-rap.md
[utility knife]: parts/tools/utility-knife.md
[custom print settings]: smart_brim.md

## Printing {pagestep}

Now you have tested your [printer][RepRap-style printer]{qty:1,cat:tool} and [filament][PLA filament]{Qty: 200g, note:"Of any colour you want. Two contrasting colours may look best."}. you can print the following parts:

* Actuator assembly tools ([nut tool]{output,qty:1}, [band tool]{output,qty:1}, and [band tool cover]{output,qty:1}):  [actuator_assembly_tools.stl](models/actuator_assembly_tools.stl){previewpage}
* [Lens tool]{output,qty:1}: [lens_tool.stl](models/lens_tool.stl){previewpage}
* [Main body]{output,qty:1}: [main_body.stl](models/main_body.stl){previewpage} - The smart brim may require [custom print settings].
* [Rectangular z-axis]{output,qty:1}: [seperate_z_actuator.stl](models/seperate_z_actuator.stl){previewpage} - The smart brim may require [custom print settings].
* [z-spacer]{output,qty:1}: [1mm_z_spacer.stl](models/1mm_z_spacer.stl){previewpage} ([5mm_z_spacer.stl](models/5mm_z_spacer.stl){previewpage} and [10mm_z_spacer.stl](models/10mm_z_spacer.stl){previewpage} are also available for thicker samples)
* 4 [feet]{output,qty:4}: [feet.stl](models/feet.stl){previewpage}
* 4 [large gears]{output,qty:4}: [large_gears.stl](models/large_gears.stl){previewpage}
* 3 [small gears]{output,qty:3}: [small_gears.stl](models/small_gears.stl){previewpage}
* 3 [cable tidy caps]{output,qty:3}: [cable_tidies.stl](models/cable_tidies.stl){previewpage}
* [Upright condenser]{output,qty:1}: [upright_condenser.stl](models/upright_condenser.stl){previewpage} - The condenser may require [custom print settings] as used for the smart brim.
* [Sample clips]{output,qty:2}: [sample_clips.stl](models/sample_clips.stl){previewpage}
* [Lens spacer]{output,qty:1}: [lens_spacer_picamera_2_pilens.stl](models/lens_spacer_picamera_2_pilens.stl){previewpage} - **This must be printed in [black][Black PLA filament]{Qty: 50g}!** ([?](why_optics_black.md "why?"))
* [pi camera platform]{output,qty:1}: [camera_platform_picamera_2_pilens.stl](models/camera_platform_picamera_2_pilens.stl){previewpage}
* [Microscope stand]{output, qty:1}: [microscope_stand.stl](models/microscope_stand.stl){previewpage}
* [Microscope stand insert for the Pi]{output,qty:1}: [pi_stand.stl](models/pi_stand.stl){previewpage}
* [Nano converter plate]{output,qty:1}, to hold separate motor drivers instead of a Sangaboard: [nano_converter_plate.stl](models/nano_converter_plate.stl){previewpage}
* [Nano gripper]{output,qty:1}: [nano_converter_plate_gripper.stl](models/nano_converter_plate_gripper.stl){previewpage}



## Clean-up of printed parts {pagestep}

Carefully remove the printing brim from all parts (except the main body and rectangular z-axis) with a [utility knife]{qty: 1, cat: tool}.
