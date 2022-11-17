use <./libs/microscope_parameters.scad>
use <./libs/libdict.scad>
use <./libs/utilities.scad>
use <./libs/illumination.scad>

condenser_stl();

module condenser_stl(){
    params = default_params();
    smart_brim_r = key_lookup("smart_brim_r", params);
    exterior_brim(r=smart_brim_r){
        // NB the module is called in the renders with default arguments.  If
        // non-default arguments are used here, it will mean the STL doesn't
        // match the renders.
        condenser();
    }
}