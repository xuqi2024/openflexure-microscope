use <libs/utilities.scad>
use <libs/gears.scad>
use <libs/lib_actuator_assembly_tools.scad>

translate_y(20){
    nut_spinner();
}
gear_holder();

module nut_spinner(){
    h = 16;
    difference()
    {
        union(){
            hull(){
                cylinder(r=5, h=h, $fn=6);
                reflect_x(){
                    translate([6,0,10]){
                        rotate_x(90){
                            cylinder(r=6, h=3, $fn=16, center=true);
                        }
                    }
                }
            }
            cylinder(r1=6, r2=3, h=8, $fn=16);
        }
        translate_z(13){
            m3_nut_hole(h=99, shaft=true, tight=true);
        }
    }
}


module gear_holder(){
    dims = [40, 14, 10];
    difference(){
        holding_block(dims);
        translate_z(dims.z/2){
            large_gear_profile(height=10, tweak_pitch=true);
        }
    }
}
