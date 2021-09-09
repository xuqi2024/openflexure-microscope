use <./libs/lib_microscope_stand.scad>
use <./libs/utilities.scad>
use <./libs/microscope_parameters.scad>



module microscope_stand_no_pi_stl(){
    params = default_params();
    microscope_stand_no_pi(params, 8);
}

microscope_stand_no_pi_stl();
