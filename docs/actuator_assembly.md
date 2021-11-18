# Assemble the actuators

There is one "actuator column" for each of the three axes of the OpenFlexure Microscope stage. These allow you to move the sample in X and Y, or focus the microscope by moving in Z. 


{{BOM}}

[M3x25mm stainless steel hex bolt]: parts/mechanical.yml#HexBolt_M3x25mm_SS
[M3 brass nut]: parts/mechanical.yml#Nut_M3_Brass
[M3 stainless steel washers]: parts/mechanical.yml#Washer_M3_SS
[Viton O-ring (30mmx2mm)]: parts/mechanical.yml#O-Ring_30x2_Viton

![Parts required for actuator assembly](renders/actuator_assembly_parts.png)

## Insert the nut {pagestep}

![Inset the nut the actuator column](renders/actuator_assembly_nut.png)
![Check nut seated flat](diagrams/NutSitFlat.png)

* Insert a [brass nut][M3 brass nut]{qty: 3, cat:mech} into the x actuator through the hole in the front of the [main body][prepared main body](fromstep){qty:1, cat:subassembly}.
* Looking through the hole you should see the side of the nut. If it is tilted so you can see the top can tap the microscope until it sits flat.

## Attach the gear {pagestep}

![Washer direction](diagrams/washer-direction.png)
![Gear attachment exploded](renders/actuator_assembly_gear.png)
![Gear attachment](renders/actuator_assembly_gear2.png)

* Line up two [washers][M3 stainless steel washers]{qty:6, cat:mech} so that the slightly curved sides are facing each other.
* Take one of the [hex bolts][M3x25mm stainless steel hex bolt]{qty:3, cat:mech}
* Push it through one of the [large gears](fromstep){qty:3, cat:printedpart} and then the two washers.
* Push the screw through the hole at the top of the x actuator until it reaches the nut
* Screw the bolt into the nut until the nut is completely lifted up. (If the nut turns hold it in place with the [nut tool](fromstep){qty:1, cat:printedtool})

## Oil the lead screw {pagestep}

* Lift the gear so you can see about 5mm of screw thread underneath
* Add one drop of [light oil]{qty:3 drops, cat:consumable, Note: " - Don't skip this or you will damage the screws"} onto the screw thread

![oil lead screw](renders/actuator_assembly_oil.png)

## Prepare the actuator {pagestep}

![Check actuator position](diagrams/ActuatorPosition.png)

* Look through the hole you inserted the nut into
* You should be able to see the screw thread of the hex bolt
* Rotate the gear until the screw is clearly visible through this hole
* Push the [nut tool]{qty:1} into the hole to hold the internal actuator in place

## Attaching the viton bands and foot {pagestep}
This is the trickiest part of the microscope build. In this step we will clip bands onto hooks inside each actuator.

![Actuator cutaway](renders/band_instruction.png)

* Take the [foot][feet](fromstep){qty:3, note:" - Each actuator has its own labelled foot.", cat:printedpart} for the x actuator
* Loop a [viton band][Viton O-ring (30mmx2mm)]{qty:3, note: '"Viton band"', cat:mech} through the foot
* Push the [band tool](fromstep){qty:1, cat:printedtool} through the foot hook the band onto the tool on each side.
* Push the [band tool cover](fromstep){qty:1, cat:printedtool} onto the bottom of the band tool
* Align the foot under the microscope so that the letter faces outwards
* Check that the nut tool is still blocking the actuator column.
* Push the band tool into the microscope until it clicks
* Remove the band tool.

![attach actuator foot](renders/actuator_assembly_x.png)

If you had problems with this step see [troubleshooting actuator assembly].

## Seat the foot {pagestep}

* If the foot did not click into place during actuator assembly align it and push it into place
* The foot should sit flush with the base of the microscope
* The front of the foot should align with the front of the actuator


## Repeat this process for Y and Z {pagestep}

Follow the same procedure for the Y and Z axes. Once complete the [microscope with assembled actuators]{output, qty:1} should look like this:

![Actuators assembled](renders/actuators_assembled.png)
