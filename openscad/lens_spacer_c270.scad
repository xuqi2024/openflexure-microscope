/**
* This is an alternative optics module (optics.scad) that is to
* be used together with the camera platform, to make a cheap
* optics module that uses the webcam lens.  New in this version
* is compatibility with the taller stage (because the sensor is
* no longer required to sit below the microscope body).
*/


use <./libs/microscope_parameters.scad>
use <./libs/lib_optics.scad>
use <./libs/optics_configurations.scad>
use <./libs/utilities.scad>
use <./libs/libdict.scad>

lens_spacer_stl();

// The Logitech C270 webcam mount has gaps at the edges, 
// so is filled in with normal brim on a slicer.
// render on the x-y plane rather than in place and add brim
module lens_spacer_stl(){
    params = default_params();
    smart_brim_r = key_lookup("smart_brim_r", params);
    optics_config = c270lens_config();
    exterior_brim(r=smart_brim_r, smooth_r=5){
        translate_z(-lens_spacer_z(params, optics_config)){
            lens_spacer(params, optics_config);
        }
    }
}
