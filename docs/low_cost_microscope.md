# Low-cost microscope

This is a lower cost version of the OpenFlexure Microscope. It supports uses the lens from the Raspberry Pi Camera to produce a microscope with field of view about 750μm, similar to using a 20x objective. It is motorised, but you can also build it as a manual microscope.

If you use this microscope for research please consider citing [our paper in Optics Express](https://doi.org/10.1364/BOE.385729).

>? For known bugs, building tips, and advice, please use our [Forum](https://openflexure.discourse.group/). If you find any problems with the build, please let us know on [GitLab](https://gitlab.com/openflexure/openflexure-microscope/-/issues) or on the Forum.

Before you start building the microscope you will need to source all of the components listed in the [bill of materials]{bom}.


The assembly is broken up into several steps:

1. [.](test_your_printer.md){step}
1. [.](printing.md){step, var_type: low_cost}
1. [.](prepare_main_body.md){step}
1. [.](prepare_stand.md){step}
1. [.](actuator_assembly.md){step, var_n_actuators:3}
1. [.](basic_optics_module.md){step, var_lens: pi_lens}
1. [.](mount_optics_and_microscope.md){step, var_optics: low_cost}
1. [.](illumination.md){step, var_type: low_cost}
1. [.](mount_illumination.md){step, var_optics: low_cost}
1. [.](motors.md){step, var_optics: low_cost}
1. [.](attach_clips.md){step, var_optics: low_cost}
1. [.](prepare_pi_and_sangaboard.md){step}
1. [.](wiring.md){step, var_optics: low_cost}
1. [.](finished.md){step, var_optics: low_cost}

![A render of the completed microscope using the Raspberry Pi camera module's lens.](renders/complete_microscope_low_cost1.png)

There is also an [interactive 3D view](interactive_3d_view_low_cost.md) of the finished microscope.