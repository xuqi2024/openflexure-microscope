# Prepare the main body

{{BOM}}

[utility knife]: parts/tools/utility-knife.md
[precision wire cutters]: parts/tools/precision-wire-cutters.md "{cat:tool, note:'Can use a utility knife if these are unavailable.'}"
[M3 nut]: parts/mechanical.yml#Nut_M3_SS
[2.5mm Ball-end Allen key]: parts/tools/2.5mmBallEndAllenKey.md

## Removing brim and supports {pagestep}

The [main body][Main body](fromstep){cat: PrintedPart, qty:1} has some custom supports and a custom brim to remove. These are highlighted in red in the following images.

![](renders/brim_and_ties1.png)
![](renders/brim_and_ties2.png)

* Remove the brim with [utility knife]{qty:1,cat:tool} and [precision wire cutters]{qty:1}.
* Cut the ties inside actuator column (6 total) with the [precision wire cutters]{qty:1}
* Cut the ties for the rear legs (4 total) with the [precision wire cutters]{qty:1}

## Check the body printed correctly{pagestep}

**xy-stage**

![](renders/check_main_body_stage.png)

* Check that top of the xy-stage is flat
* Check the quality of the underside of the xy-stage. Slight drooping is normal and acceptable. Any loose filament strands should be trimmed off. Large numbers of loose filaments dangling beneath is a sign of low print quality.

**Top Flexures**

![](renders/check_main_body_top_flex.png)

* Check that the top of each 4 legs are aligned correctly
* Each leg should have 4 thin unsupported flexure (blue)
* The tops of the legs (green), and the the central leg block (green) should be in line with a flexure in between.

## Embed mounting nuts in the stage {pagestep}

![](renders/prepare_main_body1.png)
![](renders/prepare_main_body2.png)
![](renders/prepare_main_body3.png)


* Place an [M3 nut]{qty:4} one of the slots at the side of the stage
* Put an [M3x10 cap head screw][extra M3x10 cap screw](parts/mechanical.yml#CapScrew_M3x10mm_SS){qty: 1, cat:tool, note:"For mounting trapped nuts"} into the hole above the nut
* Tighten with a [2.5mm Ball-end Allen key]{qty:1, cat:tool} until you feel reasonable resistance.
* Unscrew and remove the screw. The nut should stay mounted.
* Repeat for the other three holes in the stage.

![](renders/prepare_main_body4.png)
![](renders/prepare_main_body5.png)
![](renders/prepare_main_body6.png)

## Embed mounting nuts illumination platform {pagestep}

![](renders/prepare_main_body7.png)
![](renders/prepare_main_body8.png)
![](renders/prepare_main_body9.png)

* Repeat the steps used above to add {{var_illum_nuts_words, default:two}} [M3 nuts][M3 nut]{qty:{{var_illum_nuts, default:2}}, cat:mech} into the platform above the z-axis

The [prepared main body]{output, qty:1} is now ready for assembly.