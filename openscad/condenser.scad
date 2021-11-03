use <./libs/microscope_parameters.scad>
use <./libs/libdict.scad>
use <./libs/utilities.scad>
use <./libs/illumination.scad>

condenser_stl();

module condenser_stl(){
    params = default_params();
    smart_brim_r = key_lookup("smart_brim_r", params);
    exterior_brim(r=smart_brim_r){
        condenser(params, lens_d=13, lens_t=1, lens_assembly_z= 30);
    }
}