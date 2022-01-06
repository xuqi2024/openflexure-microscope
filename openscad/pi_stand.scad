use <./libs/lib_microscope_stand.scad>

pi_stand_stl();
module pi_stand_stl(){
    stand_params = default_stand_params();
    pi_stand(stand_params);
}