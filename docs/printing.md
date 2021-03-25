# Print the plastic parts

If you have bought the plastic parts you can skip this step!

### For this section you will need:
{{BOM}}

[PLA filament]: parts/materials/pla_filament.md "{cat:material}"
[Black PLA filament]: parts/materials/pla_filament.md "{cat:material}"
[RepRap-style printer]: parts/tools/rep-rap.md
[utility knife]: parts/tools/utility-knife.md


## Set your printer settings {pagestep}


All microscope parts can be printed out of [PLA filament]{Qty: 200g, note:"Of any colour you want. Two contrasting colours may look best."} on most [RepRap-style printers][RepRap-style printer]{Qty:1,cat:tool}. 
We recommend the following printer settings:

|Setting        |Value          |
|------------   |--             |
|Material       |PLA            |
|Layer height   |0.2mm or less  |
|Supports       |None           |
|Infill         |Printer default|
|Brim           |Recommended for all part except main body.|
  

**Do not print with supports**. The microscope has been designed to print without supports. Supports will damage the mechanism.

**NOTE** - The microscope body has a custom brim included in the STL. This may require [custom print settings].

[custom print settings]: smart_brim.md

## Testing your printer {pagestep}

Now we will test whether your printer can print the bridges in the microscope.

[Download and print this file:](models/leg_test.stl)

The result should look like this (this has been printed with a brim):

![](images/just_leg_test.jpg)


## Printing {pagestep}

You will need to print the following parts:

* Actuator assembly tools ([nut tool]{output,qty:1}, [band tool]{output,qty:1}, and [band tool cover]{output,qty:1}) [(STL file)](parts/printed_tools/actuator_assembly_tools.md)
* [Lens tool]{output,qty:1} [(STL file)](parts/printed_tools/lens_tool.md)
* [Main body]{output,qty:1} [(STL file)](parts/printed/main_body.md) - The smart brim may require [custom print settings].
* 3 [feet]{output,qty:3} [(STL file)](parts/printed/feet.md)
* 3 [large gears]{output,qty:3} [(STL file)](parts/printed/gears.md)
* 3 [cable tidy caps]{output,qty:3}
* [Illumination dovetail]{output,qty:1} [(STL file)](parts/printed/illumination_dovetail.md)
* [Condenser arm]{output,qty:1} [(STL file)](parts/printed/condenser.md)
* [Illumination thumbscrew]{output,qty:1} 
* [Sample clips]{output,qty:2} [(STL file)](parts/printed/sample_clips.md)
* [Optics module]{output,qty:1} [(STL file)](parts/printed/optics_module_casing.md) - **This must be printed in [black][Black PLA filament]{Qty: 50g}!** ([?](why_optics_black.md "why?"))
* [pi camera cover]{output,qty:1} [(STL file)](parts/printed/picamera_cover.md)
* [Microscope stand]{output, qty:1} [(STL file)](parts/printed/microscope_stand.md)
* 3 [small gears]{output,qty:3} [(STL file)](parts/printed/small_gears.md)
* [Base to hold the motor driver]{output,qty:1} [(STL file)](parts/printed/motor_driver_case.md)



## Clean-up of printed parts {pagestep}

Carefully remove the printing brim from all parts (except the main body) with a [utility knife]{qty: 1, cat: tool}.