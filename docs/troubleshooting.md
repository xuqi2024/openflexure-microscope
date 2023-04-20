# Troubleshooting

>i The [forum](https://openflexure.discourse.group) is a great place to get help, advice, solutions and work-arounds from the OpenFlexure Community.

### My Raspberry Pi Camera did not come with the lens removal tools

If your Raspberry Pi camera did not come with the tool for removing the lens you can print this tool: 
[picamera_2_lens_gripper.stl](models/picamera_2_lens_gripper.stl){previewpage}. It is a reasonable alternative to the official tool.


### The screw on the main gear wont go in actuator column

This is probably due to the hole in the actuator not being large enough due to your printer over extruding. The best fix is to re-print the main body with adjusted settings. A work around is to print this jig:

* [actuator_drilling_jig.stl](models/accessories/actuator_drilling_jig.stl){previewpage}

You can push this jig inside the actuator column (where the feet go). This will hold the internal column still so that it can be drilled out carefully with a 3mm drill bit.

### Feet will not fit the into main body.

This is likely due to the first layer of the main body over extruding slightly.

Very carefully run a utility knife around the inside of the oval space where the feet mount.

>! Be careful not to cut into the flexure mechanism.

### Some STL files slice incorrectly

In the past we have seen some STL files slice in very strange ways particularly in older versions of Prusa Slicer. We recommend using version 2.3.3 or newer of Prusa Slicer.

For other slicing issues make sure your slicer is up to date. If this doesn't help we recommend [visiting our user forum](https://openflexure.discourse.group/).