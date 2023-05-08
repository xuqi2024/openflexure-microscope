

use <./libs/microscope_parameters.scad>
use <./libs/lib_optics.scad>
use <./libs/optics_configurations.scad>

camera_platform_stl();

module camera_platform_stl(){
    params = default_params();
    optics_config = pilens_3_config();
    camera_platform(params, optics_config, base_r = 5);
    lens_spacer(params, optics_config);
    translate([30,0,0]){
        camera_platform(params, pilens_config(), base_r = 5);
        lens_spacer(params, pilens_config());

    }
}
