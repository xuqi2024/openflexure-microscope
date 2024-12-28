---
Details:
    thumbnail: images/just_leg_test.jpg
    time: 40 minutes
    difficulty: Easy
    skills:
      - 3D printing
---


# Test your printer

>i If you have bought the plastic parts you can skip this step!

{{BOM}}

[PLA filament]: parts/materials/pla_filament.md "{cat:material}"
[RepRap-style printer]: parts/tools/rep-rap.md
[utility knife]: parts/tools/utility-knife.md


## Set your printer settings {pagestep}


All microscope parts can be printed out of [PLA filament] on most [RepRap-style printers][RepRap-style printer]{Qty:1,cat:tool}.

We recommend the following printer settings:

|Setting        |Value          |
|------------   |--             |
|Material       |PLA            |
|Layer height   |0.2mm or less  |
|Supports       |None           |
|Infill         |Printer default|
|Brim           |Recommended for all parts except main body|
|[Slice gap closing radius] |0.001mm |

>! **Do not print with supports**.
>!
>! The microscope has been designed to print without supports. Supports will damage the mechanism.

>i The microscope body has a custom brim included in the STL, and the condenser lens and optics module also contain small gaps. This may require you to set the [slice gap closing radius].

[Slice gap closing radius]: ./set_slice_gap_closing_radius.md

As a general rule, strength is more important than surface finish, so very thin layers (less than 0.15mm or so) are unlikely to result in a microscope that performs any better, though it may approve the appearance.

## Testing your printer {pagestep}

Now test whether your printer can print the bridges in the microscope and the custom brim on the main body.  
Download and print the leg test file, do not add brim in your slicer. This will only use about [5 grams of PLA][PLA filament]{qty: 5g}:

![leg_test.stl](models/leg_test.stl)

The result should look like this:

![](images/just_leg_test.jpg)

The brim should have printed as a separate object around the leg, and should be easy to remove. If it is difficult to remove, [check that it has not been joined to the leg when sliced](./set_slice_gap_closing_radius.md#checking-the-bottom-layer).