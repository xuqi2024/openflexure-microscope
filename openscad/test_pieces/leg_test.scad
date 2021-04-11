use <../libs/main_body_structure.scad>
use <../libs/microscope_parameters.scad>
use <../libs/libdict.scad>

leg_test_object();
/**
* This is for printing a shorter version of the leg just
* to check the bridging works.
*/
module leg_test_object(){
    params = default_params();
    short_leg_params = replace_value("sample_z", 50, params);
    leg(short_leg_params);
}