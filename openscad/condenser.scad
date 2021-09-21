use <./libs/microscope_parameters.scad>
use <./libs/illumination.scad>

condenser_stl();

module condenser_stl(){
    condenser(lens_d=13, lens_t=1, lens_assembly_z=30);
}