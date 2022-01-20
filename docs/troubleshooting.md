# Troubleshooting


### My Raspberry Pi Camera did not come with the lens removal tools

If your Raspberry Pi camera did not come with the tool for removing the lens you can print this tool: 
[picamera_2_lens_gripper.stl](models/picamera_2_lens_gripper.stl){previewpage}. It is a reasonable alternative to the official tool.


### The screw on the main gear wont go in actuator column

This is probably due to the hole in the actuator not being large enough due to your printer over extruding. The best fix is to re-print the main body with adjusted settings. A work around is to print this jig:

* [actuator_drilling_jig.stl](models/accessories/actuator_drilling_jig.stl){previewpage}

You can push this jig inside the actuator column (where the feet go). This will hold the internal column still so that it can be drilled out carefully with a 3mm drill bit.