use <../libs/illumination.scad>
use <../libs/double_dove_illumination.scad>
use <../libs/microscope_parameters.scad>

params = default_params();
translate([0,0,-illumination_dovetail_z(params)]){
    doubledove_illumination_mount(params, h = 60);
}
