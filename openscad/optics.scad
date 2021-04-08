/*
*
* The optics module holds the camera and whatever lens you are
* using as an objective - current options are either the lens
* from the Raspberry Pi camera module, or an RMS objective lens
* and a second "tube length conversion" lens (usually 40mm).
*/


include <./libs/microscope_parameters.scad>
include <./libs/lib_optics.scad>
include <./libs/optics_configurations.scad>

params = default_params();
opics_config = rms_f50d13_picamera();

optics_module_rms(params, opics_config);


