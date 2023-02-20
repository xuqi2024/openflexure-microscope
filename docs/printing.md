# Print the plastic parts

>i If you have bought the plastic parts you can skip this step!

{{BOM}}

[PLA filament]: parts/materials/pla_filament.md "{cat:material}"
[RepRap-style printer]: parts/tools/rep-rap.md
[utility knife]: parts/tools/utility-knife.md
[custom print settings]: ./set_slice_gap_closing_radius.md

## Set your printer settings {pagestep}

>i These are the settings from [Test your printer](test_your_printer.md#set-your-printer-settings-pagestep), but may be useful to refer to here.

All microscope parts can be printed out of [PLA filament] on most [RepRap-style printers][RepRap-style printer]{Qty:1,cat:tool}.

We recommend the following printer settings:

|Setting        |Value          |
|------------   |--             |
|Material       |PLA            |
|Layer height   |0.2mm or less  |
|Supports       |None           |
|Infill         |Printer default|
|Brim           |Recommended for all parts except main body.|
|[Slice gap closing radius] |0.001mm |

>! **Do not print with supports**.
>!
>! The microscope has been designed to print without supports. Supports will damage the mechanism.

>i The microscope body has a custom brim included in the STL, and the condenser lens and optics module also contain small gaps. This may require you to set the [slice gap closing radius].

[Slice gap closing radius]: ./set_slice_gap_closing_radius.md

As a general rule, strength is more important than surface finish, so very thin layers (less than 0.15mm or so) are unlikely to result in a microscope that performs any better, though it may approve the appearance.

## Printing {pagestep}

>i The microscope body has a custom brim included in the STL. This may require [custom print settings].

Now you have tested your [printer][RepRap-style printer]{qty:1,cat:tool} and [filament][PLA filament]{Qty: 200g, note:"Of any colour you want. Two contrasting colours may look best."} you can print the following parts:

* Actuator assembly tools ([nut tool]{output,qty:1}, [band tool]{output,qty:1}, and [band tool cover]{output,qty:1}):  [actuator_assembly_tools.stl](models/actuator_assembly_tools.stl){previewpage}
* [Lens tool]{output,qty:1}: [lens_tool.stl](models/lens_tool.stl){previewpage}
* [Main body]{output,qty:1}: [main_body.stl](models/main_body.stl){previewpage} - The smart brim may require [custom print settings].
* 3 [cable tidy caps]{output,qty:3}: [cable_tidies.stl](models/cable_tidies.stl){previewpage}
* [Sample clips]{output,qty:2}: [sample_clips.stl](models/sample_clips.stl){previewpage}
* [Microscope stand]{output, qty:1}: [microscope_stand.stl](models/microscope_stand.stl){previewpage}
* [Electronics drawer]{output, qty:1}: [electronics_drawer.stl](models/electronics_drawer.stl){previewpage} - **This electronics drawer is for a Pi 4 and Sangaboard v0.4. For all other combinations of electronics, refer to the [customisation page](customisation.md)**
* 3 [small gears]{output,qty:3}: [small_gears.stl](models/small_gears.stl){previewpage}
{{include: {{var_type}}_only_printing.md}}


## Clean-up of printed parts {pagestep}

>!! **Be careful when removing brim**
>!!
>!! To avoid injury first remove the bulk of the brim without a knife. Remove the remaining brim with a peeling action as described below.

Carefully remove the printing brim from all parts (except the main body).

To remove brim:

1. Use [precision wire cutters](parts/tools/precision-wire-cutters.md){qty:1, cat:tool} to remove most of the brim from the part.
2. Clean up remaining brim with a [utility knife]{qty: 1, cat: tool, note: "Not a scalpel!"}:
    * Hold the knife in your dominant hand with 4 fingers curled around the handle, leaving thumb free.
    * Hold the part in your other hand, as far away from the surface to be cut as possible.
    * Support the part with the thumb of your dominant hand.
    * Place blade on surface to be cut, and carefully close your dominant hand moving the blade, under control, towards your thumb.

![](diagrams/BrimRemoval.png)