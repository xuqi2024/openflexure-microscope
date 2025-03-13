use <./libs/lib_microscope_stand.scad>
use <./libs/microscope_parameters.scad>

PI_VERSION = 4;

module microscope_stand_manual_with_pi_stl(pi_version=4){
    stand_params = default_stand_params(pi_version=pi_version);
    microscope_stand_manual_with_pi(stand_params=default_stand_params(pi_version=4));
}

microscope_stand_manual_with_pi_stl(PI_VERSION);

