# Print the plastic parts

>i If you have bought the plastic parts you can skip this step!

{{BOM}}

[PLA filament]: parts/materials/pla_filament.md "{cat:material}"
[RepRap-style printer]: parts/tools/rep-rap.md
[utility knife]: parts/tools/utility-knife.md
[custom print settings]: smart_brim.md

## Printing {pagestep}

>i The microscope body has a custom brim included in the STL. This may require [custom print settings].

Now you have tested your [printer][RepRap-style printer]{qty:1,cat:tool} and [filament][PLA filament]{Qty: 200g, note:"Of any colour you want. Two contrasting colours may look best."} you can print the following parts:

* Actuator assembly tools ([nut tool]{output,qty:1}, [band tool]{output,qty:1}, and [band tool cover]{output,qty:1}):  [actuator_assembly_tools.stl](models/actuator_assembly_tools.stl){previewpage}
* [Lens tool]{output,qty:1}: [lens_tool.stl](models/lens_tool.stl){previewpage}
* [Main body]{output,qty:1}: [main_body.stl](models/main_body.stl){previewpage} - The smart brim may require [custom print settings].
* 3 [cable tidy caps]{output,qty:3}: [cable_tidies.stl](models/cable_tidies.stl){previewpage}
* [Sample clips]{output,qty:2}: [sample_clips.stl](models/sample_clips.stl){previewpage}
* [Microscope stand]{output, qty:1}: [microscope_stand.stl](models/microscope_stand.stl){previewpage}
* [Pi stand]{output, qty:1}: [pi_stand.stl](models/pi_stand.stl){previewpage}
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