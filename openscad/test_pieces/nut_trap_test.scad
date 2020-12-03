//Simple test object to test the nut trap prints correctly

use <../compact_nut_seat.scad>
include <../microscope_parameters.scad>
use <../libs/utilities.scad>


c_h = 10;
difference()
{
    translate([0,0,c_h/2])cube([12,12,c_h], center=true);
    m3_nut_trap_with_shaft(0,0);
}