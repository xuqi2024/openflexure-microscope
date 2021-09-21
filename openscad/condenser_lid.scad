use <./libs/microscope_parameters.scad>
use <./libs/illumination.scad>

condenser_lid_stl();

module condenser_lid_stl(){
    condenser_lid(lens_d=13);
}