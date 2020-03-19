// This generates the thumbwheels, more finger-friendly alternatives to the gears

use <gears.scad>;
use <utilities.scad>;

repeat([0,thumbwheel_spacing(),0],3,center=true) thumbwheel();