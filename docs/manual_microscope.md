# Manual microscope

>! This version of the OpenFlexure Microscope does not include motors. There is no autofocus or slide scanning.

It is the simplest version of the microscope, and is suitable for manual operation using a web-cam like the Logitech C270, to produce a microscope with field of view about 750μm, similar to using a 20x objective. 

If you use this microscope for research please consider citing [our paper in Optics Express](https://doi.org/10.1364/BOE.385729).

Before you start building the microscope you will need to source all the components listed our [bill of materials]{bom}.


The assembly is broken up into several steps:

1. [.](test_your_printer.md){step}
1. [.](printing.md){step, var_type: c270, var_body: _manual}
1. [.](prepare_main_body.md){step, var_body: _manual}
1. [.](prepare_stand.md){step, var_body: _manual}
1. [.](actuator_assembly.md){step, var_body: _manual, var_n_actuators:3}
1. [.](usb_cameras/c270_preparation.md){step, var_body: _manual}
1. [.](basic_optics_module.md){step, var_body: _manual, var_lens: c270_lens}
1. [.](mount_optics_and_microscope.md){step, var_optics: c270, var_body: _manual}
1. [.](illumination.md){step, var_optics: c270, var_body: _manual}
1. [.](mount_illumination.md){step, var_optics: c270, var_body: _manual}
1. [.](attach_clips.md){step, var_optics: c270, var_body: _manual}
1. [.](wiring_manual.md){step, var_optics: c270, var_body: _manual}
1. [.](finished.md){step, var_optics: c270, var_body: _manual}

![A render of the completed manual microscope, using a Logitech C270 camera.](renders/complete_microscope_c270_manual1.png)

There is also an [interactive 3D view](interactive_3d_view_c270_manual.md) of the finished microscope.