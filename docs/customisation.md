# Customisations and alternatives

For each version of the microscope we have specified a specific bill of materials to make the microscope simple to build for non-microscopists. One of the key advantage of the OpenFlexure Microscope is that is can be customised for different applications and modified if certain parts are not available.

Here are some of the most common customisations. This page may not be as detailed as the core instructions, please consider helping us to improve it.

>i You can [download every STL from here](all-stls.zip).

## Electronics

### No access to the Sangaboard

Our custom motor board, the Sangaboard can be hard to get hold of. We are working on this. A workaround is to build a [Sangaboard-compatible motor controller](workaround_motor_electronics/workaround_motor_electronics.md) using an Arudino nano, and the driver boards that come with each stepper motor.  This uses the standard `electronics_drawer` STL for the electronics drawer but adds printed adapters to fit in the alternative boards.


### Using a Raspberry Pi version 3, or a Sangaboard v0.3

If you don't have access to a Raspberry Pi version 4 or a Sangaboard v0.4, but have an older board, you can use one of these modified electronics drawers:

* [electronics_drawer-pi3_sangav0.3.stl](models/electronics_drawer-pi3_sangav0.3.stl){previewpage}
* [electronics_drawer-pi3_sangav0.4.stl](models/electronics_drawer-pi3_sangav0.4.stl){previewpage}
* [electronics_drawer-pi4_sangav0.3.stl](models/electronics_drawer-pi4_sangav0.3.stl){previewpage}

### No illumination PCB

If you are unable to use the illumination PCB, you can substitute a 5mm LED, wired in series with a resistor, described in the [LED workaround].

[LED workaround]: workaround_5mm_led/workaround_5mm_led.md

## Optics

### Using the microscope for epi-florescence or epi-illumination

You will need to print a version of the optics module with "beamsplitter" in the name (all optics modules listed below). 

You will also need to print:

* [fl_cube.stl](models/fl_cube.stl){previewpage}
* [reflection_illuminator.stl](models/reflection_illuminator.stl){previewpage}

These instruction need completing. For now please consult the [OpenFlexure Delta Stage Instructions](https://build.openflexure.org/openflexure-delta-stage/v1.2.0/pages/reflection_illumination.html)

### Using an infinity corrected objective

The standard optics module is designed for a finite conjugate objective. If you wish to use an infinite conjugate objective print a version of the optics module with "infinity" in the name.

>i If you are using an infinity corrected objective you will need the tall stand (see below).

### Using a different camera

For the low cost microscope (without an objective), we currently only support the Raspberry Pi camera. The 3D printed parts work with both v1 and v2, but **only v2 is supported by the standard software.**

For the RMS objective optics we also generate optics modules for an M12 camera. The **M12 camera is not supported in the standard software**. Our OpenSCAD can also generate optics modules for other cameras, however these have not been tested or used for a long time and might not function as expected.

The following optics modules are available:

* [optics_m12_rms_f50d13_beamsplitter.stl](models/optics_m12_rms_f50d13_beamsplitter.stl){previewpage}
* [optics_m12_rms_f50d13.stl](models/optics_m12_rms_f50d13.stl){previewpage}
* [optics_m12_rms_infinity_f50d13_beamsplitter.stl](models/optics_m12_rms_infinity_f50d13_beamsplitter.stl){previewpage}
* [optics_m12_rms_infinity_f50d13.stl](models/optics_m12_rms_infinity_f50d13.stl){previewpage}
* [optics_picamera_2_rms_f50d13_beamsplitter.stl](models/optics_picamera_2_rms_f50d13_beamsplitter.stl){previewpage}
* [optics_picamera_2_rms_f50d13.stl](models/optics_picamera_2_rms_f50d13.stl){previewpage}
* [optics_picamera_2_rms_infinity_f50d13_beamsplitter.stl](models/optics_picamera_2_rms_infinity_f50d13_beamsplitter.stl){previewpage}
* [optics_picamera_2_rms_infinity_f50d13.stl](models/optics_picamera_2_rms_infinity_f50d13.stl){previewpage}

## Stands

If using tall optics such as an infinity corrected objective you need a taller version of the stand:

[microscope_stand_tall.stl](models/microscope_stand_tall.stl){previewpage}

In addition to the standard stand and the tall stand, there is a smaller stand which only holds the microscope, there is no space for the Raspberry Pi:

[microscope_stand_no_pi.stl](models/microscope_stand_no_pi.stl){previewpage}
