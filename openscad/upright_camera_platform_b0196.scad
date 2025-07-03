/*
 * This is the platform to hold an optics module with a Arducam B0196 camera
 * and its own lens
 *
 * This is the variant for the upright microscope
 */

use <./libs/microscope_parameters.scad>
use <./libs/lib_optics.scad>
use <./libs/optics_configurations.scad>

camera_platform_stl();

module camera_platform_stl(){
    params = default_params();
    optics_config = b0196lens_config();
    camera_platform(params, optics_config, base_r=5, camera_rotation=270);
}
