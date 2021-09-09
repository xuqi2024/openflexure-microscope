//Builds a 5mm z-spacer
use <./libs/microscope_parameters.scad> 
use <./upright_z_spacer.scad>

params = default_params();
spacer_stl(params, 5);