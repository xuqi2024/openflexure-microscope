use <libs/lib_swappable_optics.scad>;
use <libs/microscope_parameters.scad>;
use <libs/optics_configurations.scad>;


// Optics module for the upright microscope configuration with swappable kinematic mount for objectives and positioning a 50mm lens 2f from the objective. 
// Intended to have collimated illumination entering externally from normal camera position focused to the sample plane.
difference() {
    optics_module_swappable_rms(default_params(), rms_f50d13_galvo_config());
    translate([0, 0, -100]) {
        cube([100, 100, 20], center = true);
    }
}

