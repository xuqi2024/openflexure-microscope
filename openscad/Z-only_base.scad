use <./illumination_dovetail.scad>
use <./libs/microscope_parameters.scad> 
use <./libs/main_body_structure.scad>
use <./libs/utilities.scad>
use <./libs/libdict.scad>
use <./libs/z_axis.scad>
use <./libs/wall.scad>
use <./libs/illumination.scad>

params = default_params();

function illumination_back_corner_pos(params) = [0, (key_lookup("leg_r", params)+ leg_outer_w(params))/sqrt(2) + 4, illumination_dovetail_z(params)];
position =illumination_back_corner_pos(params);

translate(position){
    children();
}
//z_axis_casing(params, condenser_mount = true, cable_housing = false);
