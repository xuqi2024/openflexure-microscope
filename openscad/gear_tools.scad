use <libs/utilities.scad>
use <libs/gears.scad>
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
            large_gear_profile(height=10, tweak_pitch=true);
            reflect_x(){
                translate_x(dims.x/2+15-.5){
                    cylinder(h=dims.z+1, r=15, center=true, $fn=36);
                }
            }
        }
    }
}