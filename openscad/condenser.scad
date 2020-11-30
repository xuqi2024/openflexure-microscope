use <./microscope_parameters.scad>
use <./illumination.scad>

params = default_params();
condenser(params, lens_d=13, lens_t=1, lens_assembly_z= 30);
