// Stand for the standard microscope configuration. The microscope screws
// onto this base, and a drawer houses the electronics.

// (c) Richard Bowman 2021
// Released under the CERN Open Hardware License

use <./libs/microscope_parameters.scad>
use <./libs/lib_microscope_stand.scad>


microscope_cover_stl();
module microscope_cover_stl(){
    params = default_params();
    linear_extrude(6){
        difference(){
            microscope_stand_base_projection(params, ex_rad=10);
            microscope_stand_base_projection(params, ex_rad=3);
        }
    }
}
