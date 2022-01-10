use <./libs/microscope_parameters.scad>
use <./libs/illumination.scad>

condenser_stl();

module condenser_stl(){
    params = default_params();
    condenser(params, lens_d=13, lens_t=1, lens_assembly_z= 30);
}