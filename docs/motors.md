# Assemble the motors

{{BOM}}

[M3x10 cap head screws]: parts/mechanical.yml#CapScrew_M3x10mm_SS
[28BYJ-48 micro geared stepper motors]: parts/electronics.yml#28BYJ-48
[2.5mm Ball-end Allen key]: parts/tools/2.5mmBallEndAllenKey.md
[No 2 6.5mm self tapping screws]: parts/mechanical.yml#SelfTap_PoziPan_No2x6.5_SS
[#1 pozidrive screwdriver]: parts/tools/pozidrive_1_screwdriver.md "{cat:tool}"
[M3 nut]: parts/mechanical.yml#Nut_M3_SS

## Attach the small gears {pagestep}


![](renders/motor_assembly1.png)
![](renders/motor_assembly2.png)
![](renders/motor_assembly3.png)

* Take a [stepper motor][28BYJ-48 micro geared stepper motors]{qty:3, cat:electronic} and a [small gear][small gears](fromstep){qty:3, cat:printedpart}.
* Place the motor on the work surface with the shaft pointing up.
* Align the flat sides of the motor shaft with the flat sides of the hole in the gear.
* Push the gear onto the motor with the flanged side downwards (motor side).
* Take two [self tapping screws][No 2 6.5mm self tapping screws]{qty: 6, cat:mech} and drive them fully into the holes on either side of the shaft. [#1 pozidrive screwdriver]{qty:1, cat:tool}
* Check that the gear is fully pushed on to the motor and the screws are fully in, so that the screw heads almost sit on the end of the motor shaft and the top of the heads are barely protruding from the gear. 
* Repeat for the other two motors

>i It is important to keep track of which motor cable corresponds to which axis. You may find it helpful to mark each cable connector with a marker or different-coloured tape before continuing.

## Add nuts into nut traps {pagestep}

![](renders/mount_motor_nuts_{{var_optics, default:rms}}1.png)
![](renders/mount_motor_nuts_{{var_optics, default:rms}}2.png)

Place a [M3 nut]{qty:6, cat:mech} in each nut trap of the motor mounting lugs. This can also be done in pairs and then install the matching motor right away:

## Attach the x and y motors {pagestep}

![](renders/mount_motors_{{var_optics, default:rms}}1.png)
![](renders/mount_motors_{{var_optics, default:rms}}2.png)


Note that each motor has a cable tidy cap that is different. Which cap to use should be apparent from the shape.

* Get a [2.5mm Ball-end Allen key]{qty:1, cat:tool} ready
* Feed the cable from the motor through the rectangular wall in the outer wall by the x-actuator.
* Place the motor on the motor lugs with the small gear towards the outside of the microscope
* Check that the small gear and the large gear are meshed correctly
* Take the x [cable tidy cap][cable tidy caps](fromstep){qty:3, cat:printedpart, note: "Each cap is a different shape"} and place it over the motor
* Check that the motor cable is running through the cable tidy rather than pinched underneath.
* Fasten the motor and cable tidy caps to the motor lugs with two [M3x10 cap head screws]{qty:6, cat:mech}
* Repeat for y-actuator

## Attach the z motor {pagestep}

![](renders/mount_motors_{{var_optics, default:rms}}3.png)
![](renders/mount_motors_{{var_optics, default:rms}}4.png)
  

{{includetext: " 
>i There is no motor attached to the z-actuator on the main body
", if: var_optics is upright}}  

* Attach a motor to the z-actuator {{includetext: "of the separate z-actuator ", if: var_optics is upright}} in the same way as the x and y actuators
* Feed the motor cable down the rectangular slot to the left of the z-actuator {{includetext: "on the main body", if: var_optics is upright}}
