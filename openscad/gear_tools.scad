use <libs/utilities.scad>
use <libs/gears.scad>
translate_y(20){
    nut_spinner();
}
gear_holder();

module nut_spinner(){
    h=16;
    difference()
    {
        hull(){
            cylinder(r = 5, h=h, $fn=6);
            reflect_x(){
                translate([6,0,10]){
                    rotate_x(90){
                        cylinder(r=6, h=3, $fn=16, center=true);
                    }
                }
            }
        }
        translate_z(13){
            m3_nut_hole(h=99, shaft=true, tight=true);
        }
    }
}


module gear_holder(){
    dims = [40, 14, 10];
    translate_z(dims.z/2){
        difference(){
            cube(dims, center=true);
                large_gear_profile(10, tweak_pitch=true);
            reflect_x(){
                translate_x(dims.x/2+15-2){
                    cylinder(h=dims.z+1, r=15, center=true, $fn=20);
                }
            }
        }
    }
}