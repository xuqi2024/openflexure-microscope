use <./libs/illumination.scad>
use <./libs/microscope_parameters.scad>
use <./libs/utilities.scad>

params = default_params();
translate_z(-illumination_dovetail_z(params)){
    illumination_dovetail(params, h = 60);
}
