use <libs/lib_swappable_optics.scad>;
use <libs/microscope_parameters.scad>;

// all-plastic version of the swappable RMS carrier, to act as a control vs. metallic version
// We add plastic printed substitutes for the ball bearings
// This is not intended as a substitute for the metallic version, but to compare the two!

difference(){
    union() {
    swappable_rms_carrier(default_params());
    swappable_rms_carrier_balls();
    };

}