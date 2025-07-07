use <./libs/lib_microscope_stand.scad>
use <./libs/microscope_parameters.scad>

module microscope_stand_no_pi_stl(){
    params = default_params();
    stand_params = default_stand_params(no_pi=true,
                                        removable_plate=true,
                                        cable_tie_points=true
                                       );
    microscope_stand(params, stand_params);
}

microscope_stand_no_pi_stl();
