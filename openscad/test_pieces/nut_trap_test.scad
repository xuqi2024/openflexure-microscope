
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
        union(){
            holding_block(dims=[35, 14, 8]);
            cylinder(d=11, h=10, $fn=32);
        }
        m3_nut_trap_with_shaft(slot_angle=0,tilt=0,deep_shaft=extra_bore,chamfer_offset=4);
    }
}

// A block with rounded corners and a dimple to make it nice to hold when turning
module holding_block(dims=[40, 14, 10]){
    corner_r = 3;
    translate_z(dims.z/2){
        difference(){
            //cube with rounded sides
            hull(){
                x_shift = (dims.x/2-corner_r);
                y_shift = (dims.y/2-corner_r);
                for (x_tr = [-1, 1]*x_shift, y_tr = [-1, 1]*y_shift){
                    translate([x_tr, y_tr]){
                        cylinder(r=corner_r, h=dims.z, center=true, $fn=12);
                    }
                }
            }
            reflect_x(){
                translate_x(dims.x/2+15-.5){
                    cylinder(h=dims.z+1, r=15, center=true, $fn=36);
                }
            }
        }
    }
}