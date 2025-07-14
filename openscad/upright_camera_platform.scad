/*
 * This is the platform to hold the low cost optics module with a pi cam
 * and its own lens.
 *
 * This is the variant for the upright microscope
 */

use <./libs/microscope_parameters.scad>
use <./libs/lib_optics.scad>
use <./libs/optics_configurations.scad>

camera_platform_stl();

module camera_platform_stl(){
    params = default_params();
    optics_config = pilens_config();
    camera_platform(params, optics_config, base_r=5, camera_rotation=90, text_="upright");
}
