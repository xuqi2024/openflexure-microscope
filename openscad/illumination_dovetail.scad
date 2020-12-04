use <./libs/illumination.scad>
use <./libs/microscope_parameters.scad>

params = default_params();
translate([0,0,-illumination_dovetail_z(params)]){
    illumination_dovetail(params, h = 50);
}
