# Customisations and alternatives

For each version of the microscope we have specified a specific bill of materials to make the microscope simple to build for non-microscopists. One of the key advantage of the OpenFlexure Microscope is that is can be customised for different applications and modified if certain parts are not available.

Here are some of the most common customisations. This page may not be as detailed as the core instructions, please consider helping us to improve it.

The [OpenFlexure forum](https://openflexure.discourse.group/) also has many customisations and alternatives suggested by the community.

>i You can [download every STL from here](all-stls.zip).

___

## No access to the Sangaboard

Our custom motor board, the Sangaboard, can be hard to get hold of. We are working on this.

**[Follow this guide to build a Sangaboard-compatible motor controller](workaround_motor_electronics/workaround_motor_electronics.md)** using an Arudino nano, and the driver boards that come with each stepper motor.

___

## No  access to the illumination PCB

If you are unable to use the illumination PCB, you can substitute a 5mm LED, wired in series with a resistor.

**[Follow this guide to build the LED workaround][LED workaround].**

[LED workaround]: workaround_5mm_led/workaround_5mm_led.md

___

## Electronics drawers for alternative electronics versions

As standard the OpenFlexure microscope uses a Raspberry Pi v4 and a Sangaboard v0.5. If you have a different Raspberry Pi or Sangaboard you will need a different electronics drawer.

**[See this explanation of the electronics drawer options.](customisations/drawer_options.md)**

___

## Alternative Optics

There are numerous ways to customise the optics of the microscope.

**[See this explanation of the customised optics options.](customisations/optics_options.md)**
___

## Alternative Stands

If using tall optics such as an infinity corrected objective you need a taller version of the stand:

[microscope_stand_tall.stl](models/microscope_stand_tall.stl){previewpage}

If you have built a custom microscope without a rasberry Raspberry Pi, you can print a smaller stand to  hold only the microscope.

[microscope_stand_no_pi.stl](models/microscope_stand_no_pi.stl){previewpage}

If you have built a manual microscope but you still want a Pi (for example for a Pi Camera) you can print a stand without an electronics drawer to hold a Pi without a Sangaboard motor controller. This stand has thin walls and is less strong, but uses less material and prints more quickly.

[microscope_stand_manual_with_pi3.stl](models/microscope_stand_manual_with_pi3.stl){previewpage}  
[microscope_stand_manual_with_pi4.stl](models/microscope_stand_manual_with_pi4.stl){previewpage}