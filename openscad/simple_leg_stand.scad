use <./libs/simple_leg_lib.scad>
use <./libs/microscope_parameters.scad>

params= default_params();
simple_leg_stand(params, type="back", wall_height=10);
