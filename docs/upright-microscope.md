# Upright microscope

This configuration of the microscope has the objective above the sample rather than below. It is newer and less well tested than other versions of the microscope.

If you use this microscope for research please consider citing [our paper in Optics Express](https://doi.org/10.1364/BOE.385729).

>? If you have problems building this, please let us know on GitLab or on our forum.

Before you start building the microscope you will need to source all the components listed in the [bill of materials]{bom}.

The assembly is broken up into several steps:

1. [.](test_your_printer.md){step}
1. [.](printing.md){step, var_type: upright}
1. [.](solder_led.md){step}
1. [.](prepare_main_body.md){step}
1. [.](prepare_upright_z-axis.md){step}
1. [.](prepare_stand.md){step}
1. [.](actuator_assembly.md){step, var_type: upright, var_n_actuators:4, var_n_washers:8}
1. [.](basic_optics_module.md){step, var_ribbon_len: 300mm, var_upright: upright}
1. [.](upright_illumination.md){step}
1. [.](upright_mount_optics_and_microscope.md){step}
1. [.](motors.md){step, var_type: upright}
1. [.](attach_clips.md){step}
1. [.](wiring.md){step}

>i These instructions assume you will build the microscope with a basic optics module. If you have an RMS objective you can put [high resolution optics](high_res_optics_module.md) in this microscope.
>i
>i If using the high resolution optics module, a 400mm Raspberry Pi ribbon cable is preferable due to the additional height.