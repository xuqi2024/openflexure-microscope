
use <../libs/compact_nut_seat.scad>
use <../libs/utilities.scad>

nut_trap_test_object();

/**
* Simple test object to test the nut trap prints correctly
*/
module nut_trap_test_object(){
    cube_h = 10;
    extra_bore = 3;
    difference()
    {
        translate_z(cube_h/2){
            cube([12,12,cube_h], center=true);
        }
        m3_nut_trap_with_shaft(slot_angle=0,tilt=0,deep_shaft=extra_bore);
    }
}