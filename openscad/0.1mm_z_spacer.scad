//Builds a z-spacer to be used with a sample of negligible thickness
use <./libs/microscope_parameters.scad> 
use <./upright_z_spacer.scad>

params = default_params();
spacer_stl(params, 0.1);