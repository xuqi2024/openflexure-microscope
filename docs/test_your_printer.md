# Test your printer

If you have bought the plastic parts you can skip this step!

{{BOM}}

[PLA filament]: parts/materials/pla_filament.md "{cat:material}"
[Black PLA filament]: parts/materials/pla_filament.md "{cat:material}"
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
|Brim           |Recommended for all part except main body.|

---
**Do not print with supports**. The microscope has been designed to print without supports. Supports will damage the mechanism.

**NOTE:** The microscope body has a custom brim included in the STL. This may require [custom print settings].

[custom print settings]: smart_brim.md

## Testing your printer {pagestep}

Now we will test whether your printer can print the bridges in the microscope. Download and print the leg test file this will only use about [5 grams of PLA][PLA filament]{qty: 5g}:

![leg_test.stl](models/leg_test.stl)

The result should look like this (this has been printed with a brim):

![](images/just_leg_test.jpg)
