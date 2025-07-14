/*
*
* The optics module holds the camera and whatever lens you are
* using as an objective - current options are either the lens
* from the Raspberry Pi camera module, or an RMS objective lens
* and a second "tube length conversion" lens (usually 50mm).
*/

use <./libs/lib_optics.scad>

//These parameters can be overwritten here or from command line with -D
OPTICS = "rms_f50d13";
BEAMSPLITTER = false;
CAMERA = "picamera_2";
PARFOCAL_DISTANCE = 45;

configurable_optics_module(OPTICS, CAMERA, BEAMSPLITTER, PARFOCAL_DISTANCE, 0, 0);
