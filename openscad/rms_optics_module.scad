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

configurable_optics_module(OPTICS, CAMERA, BEAMSPLITTER);

module configurable_optics_module(optics, camera_type, beamsplitter){
    params = default_params();

    // Note calling the optics module rms inside each if statment
    // to avoid nested ternaries
    if (optics=="rms_f50d13"){
        optics_config = rms_f50d13_config(camera_type=camera_type, beamsplitter=beamsplitter);
        optics_module_rms(params, optics_config);
    }
    else if(optics=="rms_infinity_f50d13"){
        optics_config = rms_infinity_f50d13_config(camera_type=camera_type, beamsplitter=beamsplitter);
        optics_module_rms(params, optics_config);
    }
    else{
        assert(false, "Unknown optics configuration specified");
    }

}


