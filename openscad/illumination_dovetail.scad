include <./microscope_parameters.scad>;
use <./illumination.scad>;

translate([0,0,-illumination_dovetail_screws[0][2]]) illumination_dovetail();
