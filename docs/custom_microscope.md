# Custom microscopes

If you are building a customized versions and need to understand all of your options, read on.

**Plastic tools:**

* [band and nut insertion tools, with band tool holder](parts/printed_tools/actuator_assembly_tools.md) ``actuator_assembly_tools.stl``
* [tool to insert](parts/printed_tools/lens_tool.md) the 13mm diameter condenser lens and/or tube lens: ``lens_tool.stl``
* [jig to hold the camera board](parts/printed_tools/picamera_2_tools.md) while you unscrew the lens ``picamera_2_gripper.stl``
* [optional] [tool to unscrew the camera's lens](parts/printed_tools/picamera_2_tools.md) (only needed if your camera didn't come with one) ``picamera_2_lens_gripper.stl``

**Components:**

* [body of the microscope](parts/printed/main_body.md): ``main_body_<stage size><height>[-M].stl``.
* 3 [feet](parts/printed/feet.md): ``feet.stl`` or ``feet_tall.stl`` (contains all 3)
* 3 [large gears](parts/printed/gears.md): ``gears.stl`` (contains all 3)
* illumination:
 - [vertical dovetail](parts/printed/illumination_dovetail.md): ``illumination_dovetail.stl``
 - [condenser arm](parts/printed/condenser.md): ``condenser.stl``
* 2 [sample clips](parts/printed/sample_clips.md): ``sample_clips.stl`` (contains both)
* optics module (you need one of the two options below):
 - old-style [optics module](parts/printed/optics_module_casing.md) (one part, best with RMS objectives): ``optics_<camera>_<lens>_<stage size><height>.stl``
 - platform-style optics module (two parts, best with webcam lenses):
  * [camera platform](parts/printed/camera_platform.md): ``camera_platform_<camera>_<stage size><height>.stl``
  * [lens spacer](parts/printed/lens_spacer.md): ``lens_spacer_<camera>_<lens>_<stage_size><height>.stl``
* [optional] camera cover: ``picamera_2_cover.stl``
* [optional] 3 [small gears](parts/printed/small_gears.md) for motors: ``small_gears.stl`` (contains all 3)
* [optional] [riser for the sample](parts/printed/sample_riser.md): ``sample_riser_<stage size><thickness>.stl``
* [optional] slide holder that works better if using immersion oil: ``slide_riser_LS10.stl``
* [optional] [base to hold a Raspberry Pi](parts/printed/microscope_stand.md): ``microscope_stand.stl``
* [optional] [base to hold the motor driver](parts/printed/motor_driver_case.md) (fits under the base that holds the Pi): ``motor_driver_case.stl``
* [optional] [back foot](parts/printed/back_foot.md), in case you are not using the microscope stand: ``back_foot.stl``

In the filenames above, where there are multiple versions, parameters are included in angle brackets:

* ``<stage size>`` selects the size of the platform - but currently only ``LS`` is supported.
* ``<height>`` is the height from the bottom of the main body to the top of the stage in mm, currently either ``65`` or ``75``.
* Usually the above two parameters occur next to each other, so you will see ``LS65``.  I pretty much only use ``65`` as standard, and if I am using an objective (which is the norm) I add a 10mm riser.
* ``<camera>`` is the camera you are using, either ``picamera_2`` for the Raspberry Pi camera module v2, ``c270`` for the Logitech C270, or ``m12`` for a camera with a screw-on M12 lens mount.
* ``<lens>`` is the lens you are using, either ``pilens``, ``c270_lens``, or ``m12_lens`` if you are using the lens that came with your camera.  To use a finite-conjugate, RMS threaded objective lens, you should specify ``rms_f50d13`` (for a 50mm focal length, 12.7mm diameter tube lens, e.g. ThorLabs ac127-050-a).  You can also specify ``rms_f40d16`` (to use a Comar tube lens, focal length 40mm, diameter 16mm) but this is deprecated as the images weren't as good.
* ``<thickness>`` is the thickness of a stage riser - the amount it adds to the height.  Usually a 10mm riser is used with a 65mm body to allow a 45mm parfocal distance objective to be used, currently only LS10 is reccommended.
Optional bits of filenames are in square brackets above:
* ``-M`` in the body name means it has motor lugs to allow 28BYJ-48 stepper motors to be fitted
* ``_tall`` on the illumination or the feet means the body sits 26mm off the ground rather than 15mm, to give clearance for larger camera modules.  This is only useful if you are not using the microscope stand.

Currently, there are two reccommended versions of the body; ``LS65`` and ``LS65-M``.  The only difference is that the ``-M`` version can be fitted with motors.  To build the high-resolution version of the microscope, use the 10mm thick sample riser ``sample_riser_LS10.stl``, and ``optics_picamera_2_rms_f50d13_LS65.stl``.  To build the low-resolution version, don't use the sample riser, and instead use ``camera_platform_picamera_2_LS65.stl`` and ``lens_spacer_picamera_2_pilens_LS65.stl``.  In both cases, it's best to print the microscope stand, and use the standard-height feet.

**Printable elastic bands**

If you are not able to get hold of Viton O rings, one possible alternative is to print some O rings using flexible TPU filament.  The STL file to use for this is ``actuator_tension_band.stl``.  More details are given in the [part page for O rings](parts/fixings/viton_o_ring_30mm_inner_diameter_2mm_cross_section.md).
