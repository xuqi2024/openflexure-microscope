use <./illumination_dovetail.scad>
use <./libs/microscope_parameters.scad> 
use <./libs/main_body_structure.scad>
use <./libs/utilities.scad>
use <./libs/libdict.scad>
use <./libs/z_axis.scad>
use <./libs/wall.scad>
use <./Z-only.scad>

params = default_params();

render(6) z_only(params, cable_guides = true);