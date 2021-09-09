use <./libs/microscope_parameters.scad>
use <./libs/lib_microscope_stand.scad>

pi_stand_stl();
module pi_stand_stl(){
    params = default_params();
    pi_stand(params);
}