# Upright microscope

This configuration of the microscope has the objective above the sample rather than below. It is newer and less well tested than other versions of the microscope.

If you use this microscope for research please consider citing [our paper in Optics Express](https://doi.org/10.1364/BOE.385729).

>? If you have problems building this, please let us know on [GitLab](https://gitlab.com/openflexure/openflexure-microscope/-/issues) or on our [forum](https://openflexure.discourse.group/).

Before you start building the microscope you will need to source all the components listed in the [bill of materials]{bom}.

The assembly is broken up into several steps:

1. [.](test_your_printer.md){step}
1. [.](printing.md){step, var_type: upright}
1. [.](solder_led.md){step}
1. [.](prepare_main_body.md){step, var_illum_nuts_words : three, var_illum_nuts : 3}
1. [.](prepare_upright_z-axis.md){step}
1. [.](prepare_stand.md){step}
1. [.](actuator_assembly.md){step, var_type: upright, var_n_actuators:4, var_n_washers:8}
1. [.](basic_optics_module.md){step, var_ribbon_len: 300mm, var_upright: upright}
1. [.](upright_illumination.md){step}
1. [.](upright_mount_optics_and_microscope.md){step}
1. [.](motors.md){step, var_type: upright}
1. [.](attach_clips.md){step}
1. [.](wiring.md){step}

{{include: upright_optics_note.md}}