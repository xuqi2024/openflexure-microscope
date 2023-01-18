/*
*
* The optics module holds the camera and whatever lens you are
* using as an objective - current options are either the lens
* from the Raspberry Pi camera module, or an RMS objective lens
* and a second "tube length conversion" lens (usually 40mm).
*/


use <./libs/microscope_parameters.scad>
use <./libs/lib_optics.scad>
use <./libs/optics_configurations.scad>

//These parameters can be overwritten here or from command line with -D
OPTICS = "rms_f50d13";
BEAMSPLITTER = false;
CAMERA = "picamera_2";
PARFOCAL_DISTANCE = 45;

configurable_optics_module(OPTICS, CAMERA, BEAMSPLITTER, PARFOCAL_DISTANCE);

module configurable_optics_module(optics, camera_type, beamsplitter, parfocal_distance){
    params = default_params();
    // 45mm is the default parfocal distance.
    // If this setting is changed, it would normally be to 35mm.
    // The code below will print a warning if it is changed.
    if (parfocal_distance!=45){
        if (parfocal_distance==35){
            echo("Generating an optics module for older, 35mm parfocal, objectives.  Please check carefully, this option is not tested.");
        }
        else {
            echo("WARNING: parfocal_distance is neither 35mm nor 45mm, this may be an error.");
        }
    }

    // Note calling the optics module rms inside each if statment
    // to avoid nested ternaries
    if (optics=="rms_f50d13"){
        optics_config = rms_f50d13_config(
            camera_type=camera_type, 
            beamsplitter=beamsplitter, 
            parfocal_distance=parfocal_distance
        );
        optics_module_rms(params, optics_config);
    }
    else if(optics=="rms_infinity_f50d13"){
        optics_config = rms_infinity_f50d13_config(
            camera_type=camera_type, 
            beamsplitter=beamsplitter, 
            parfocal_distance=parfocal_distance
        );
        optics_module_rms(params, optics_config);
    }
    else{
        assert(false, "Unknown optics configuration specified");
    }

}
