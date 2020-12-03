//Simple test object to test the nut trap prints correctly

use <../libs/compact_nut_seat.scad>

cube_h = 10;
difference()
{
    translate([0,0,cube_h/2]){
        cube([12,12,cube_h], center=true);
    }
    m3_nut_trap_with_shaft(0,0);
}