use <./libs/simple_leg_lib.scad>
use <./libs/microscope_parameters.scad>

simple_leg_stand_stl();

module simple_leg_stand_stl(){
    params= default_params();
    simple_leg_stand(params, type="back", wall_height=10);
}
