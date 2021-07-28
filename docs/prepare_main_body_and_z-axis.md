# Prepare the main body and rectangular z-axis

{{BOM}}

[utility knife]: parts/tools/utility-knife.md
[precision wire cutters]: parts/tools/precision-wire-cutters.md
[M3 nut]: parts/mechanical.yml#Nut_M3_SS

## Removing brim and supports {pagestep}

The [main body][Main body](fromstep){cat: PrintedPart, qty:1} and [Rectangular z-axis](fromstep){cat: PrintedPart, qty:1} have some custom supports and a custom brim to remove.

* Outer smart brim - Remove with [utility knife]{qty:1,cat:tool}
* Inner smart brim - Remove with [utility knife]{qty:1}
* Ties inside actuator column (6 total) - Remove with [precision wire cutters]{qty:1,cat:tool,note:" - Can use a utility knife if these are unavailable."}
* Ties for rear legs (4 total) - Remove with [precision wire cutters]{qty:1}

These are highlighted in red in the following images.

![](images/upright/rectangular_z_axis_with_smart_brim.jpg)
![](images/upright/preparing_rectangular_z_axis.jpg)
![](renders/brim_and_ties1.png)
![](renders/brim_and_ties2.png)

## Embed mounting nuts in the stage {pagestep}

* Place an [M3 nut]{qty:4} one of the slots at the side of the stage
* Put an [M3x8 cap head screw][extra M3x8 cap screw](parts/mechanical.yml#CapScrew_M3x8mm_SS){qty: 1, cat:tool, note:" - For mounting trapped nuts"} into the hole above the nut
* Tighten with a [2.5mm Allen key]{qty:1, cat:tool} until you feel reasonable resistance.
* Unscrew and remove the screw. The nut should stay mounted.
* Repeat for the other three holes in the stage.


## Embed mounting nuts illumination platform {pagestep}

* Repeat the steps used above to add three [M3 nuts][M3 nut]{qty:3, cat:mech} into the platform above the z-axis of the main body.

The [prepared main body]{output, qty:1} is now ready for assembly.