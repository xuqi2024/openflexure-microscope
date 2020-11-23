include <./microscope_parameters.scad>;
use <./illumination.scad>;

translate([0,0,-illumination_dovetail_screws[0].z]) illumination_dovetail();
