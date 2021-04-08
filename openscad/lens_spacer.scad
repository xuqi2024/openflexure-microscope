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

params = default_params();
opics_config = pilens_picamera();

lens_spacer(params, opics_config);
