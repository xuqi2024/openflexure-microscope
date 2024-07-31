# Custom optics


## Using the microscope for epi-florescence or epi-illumination

You will need to print a version of the optics module with "beamsplitter" in the name (all optics modules listed below). 

You will also need to print:

* [fl_cube.stl](../models/fl_cube.stl){previewpage}
* [reflection_illuminator.stl](../models/reflection_illuminator.stl){previewpage}

These instruction need completing. For now please consult the [OpenFlexure Delta Stage Instructions](https://build.openflexure.org/openflexure-delta-stage/v1.2.0/pages/reflection_illumination.html)

## Using an infinity corrected objective

The standard optics module is designed for a finite conjugate objective. If you wish to use an infinite conjugate objective print a version of the optics module with "infinity" in the name. See the list of available RMS optics modules below for alternative STLs.

>i If you are using an infinity corrected objective you will need the [tall stand](../customisation.md).

___

## Using 35mm parfocal objectives

Since v7, the "sample riser" has been built into the microscope stage, so it is no longer possible to use objectives with a 35mm parfocal distance.  It is possible to print a modified optics module that will fit these older microscope objectives, but this is not currently generated automatically.  If you would like to generate one, you can visit the [repository](https://gitlab.com/openflexure/openflexure-microscope/) and follow the instructions in the `README` to build the OpenSCAD models.  You then need to either open `openscad/rms_optics_module.scad` and use the "customiser" feature to set `PARFOCAL_DISTANCE=35`, or compile it from the command line with:

> ```openscad -D 'OPTICS="rms_f50d13"' -D 'CAMERA="picamera_2"' -D BEAMSPLITTER=false -D PARFOCAL_DISTANCE=35 ./openscad/rms_optics_module.scad -o ./optics_picamera_2_rms_f50d13_35mm_parfocal.stl``` 

If you are using Windows, you may need to escape the `"` quotation marks by replacing them with `\"`.

___

## Using a different camera

For the low cost microscope (without an objective), we currently only support the Raspberry Pi camera. The 3D printed parts work with both v1 and v2, but **only v2 is supported by the standard software.**

For the RMS objective optics we also generate optics modules for an M12 camera, or a Logitech C270 webcam, both of which connect to a computer via USB. **USB cameras are not supported in the standard software**. 

___

## RMS optics modules

The standard OpenFlexure optics modules is the is [optics_picamera_2_rms_f50d13.stl](../models/optics_picamera_2_rms_f50d13.stl){previewpage}. This uses:

* a 45mm parfocal, 160mm tube length, RMS-threaded objective
* a 50mm achromatic lens
* a Raspberry Pi camera module v2. 

This is by far the most well tested optics module

Other optics modules are available. We only regularly test the standard optics module. As the microscope design changes alternative objectives *should* update, but the updated versions may not have been printed and tested.

You can use our **[interactive optics module chooser](interactive_optics_module_picker.md)** or check the full list of possibilities below.

**List of all available optics module STLs:**

* [optics_picamera_2_rms_f50d13.stl](../models/optics_picamera_2_rms_f50d13.stl){previewpage} (default)
* [optics_picamera_2_rms_f50d13_beamsplitter.stl](../models/optics_picamera_2_rms_f50d13_beamsplitter.stl){previewpage}
* [optics_picamera_2_rms_infinity_f50d13_beamsplitter.stl](../models/optics_picamera_2_rms_infinity_f50d13_beamsplitter.stl){previewpage}
* [optics_picamera_2_rms_infinity_f50d13.stl](../models/optics_picamera_2_rms_infinity_f50d13.stl){previewpage}
* [optics_m12_rms_f50d13_beamsplitter.stl](../models/optics_m12_rms_f50d13_beamsplitter.stl){previewpage}
* [optics_m12_rms_f50d13.stl](../models/optics_m12_rms_f50d13.stl){previewpage} 
* [optics_m12_rms_infinity_f50d13_beamsplitter.stl](../models/optics_m12_rms_infinity_f50d13_beamsplitter.stl){previewpage}
* [optics_m12_rms_infinity_f50d13.stl](../models/optics_m12_rms_infinity_f50d13.stl){previewpage}
* [optics_logitech_c270_rms_f50d13_beamsplitter.stl](../models/optics_logitech_c270_rms_f50d13_beamsplitter.stl){previewpage}
* [optics_logitech_c270_rms_f50d13.stl](../models/optics_logitech_c270_rms_f50d13.stl){previewpage}
* [optics_logitech_c270_rms_infinity_f50d13_beamsplitter.stl](../models/optics_logitech_c270_rms_infinity_f50d13_beamsplitter.stl){previewpage}
* [optics_logitech_c270_rms_infinity_f50d13.stl](../models/optics_logitech_c270_rms_infinity_f50d13.stl){previewpage}

>i The infinity corrected optics modules are taller, and require a tall microscope stand [(see "stands" section of customisation page)](../customisation.md).

