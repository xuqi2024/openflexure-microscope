

use <./libs/microscope_parameters.scad>
use <./libs/lib_optics.scad>
use <./libs/optics_configurations.scad>

params = default_params();
optics_config = pilens_picamera();

camera_platform(params, optics_config, 5);