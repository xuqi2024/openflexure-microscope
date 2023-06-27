use <./utilities.scad>
use <./microscope_parameters.scad>
use <./compact_nut_seat.scad>
use <./main_body_structure.scad>
use <./libdict.scad>
use <./libfeet.scad>

params= replace_value("include_motor_lugs",false,default_params());
hole_pos = base_mounting_holes(params,type="all");
foot_height= key_lookup("foot_height",params);

post_height = foot_height;
wall_height = 10;


for (n = [0:len(hole_pos)-1]){
    hole = hole_pos[n];
    angle = lug_angles(params)[n];
    difference(){ // difference to cut off the leg parts from xy lugs
        
            translate(hole){
                cylinder(d1=20, d2=10, h=post_height+2, $fn=32);
                if (hole.y<0) { // cable ties on back posts only
                    cable_tie_point_x = (hole.x)>0? -7 : 7 ;
                    translate([cable_tie_point_x,0,7]){
                        rotate([90,0,0]){
                            tube(ro=8.5/2, ri=6/2, h=3, $fn=32);
                        }
                    }
                }
            }
        
        
        translate(hole){
            translate_z(post_height){
                m3_lug([0,0,0], angle, holes=false);
            }
            translate_z(post_height-9){
                m3_nut_trap_with_shaft(angle+180);
            }
        }
        if (hole.y>0) { // cut out on front posts only
            translate(x_actuator_pos(params)+[0,0,post_height]){
                rotate_z(-45){
                    hull(){
                        outer_foot(params,lie_flat=false,letter="");
                    }
                }
            }
            translate(y_actuator_pos(params)+[0,0,post_height]){
                rotate_z(45){
                    hull(){
                        outer_foot(params,lie_flat=false,letter="");
                    }
                }
            }
        }
    }
}
// wall to prevent toppling
back_hole_pos = base_mounting_holes(params,type="back");
difference(){
    cylinder(d=80, h=wall_height, $fn=64);
    translate_z(-tiny()){
        cylinder(d1=70, d2=78.5, h=wall_height+2*tiny(), $fn=64);
    }
    translate([-99/2,-5,-99/2]){
        cube(99);
    }
    // remember the nut clearances
    for (n = [0:len(hole_pos)-1]){
        hole = hole_pos[n];
        angle = lug_angles(params)[n];
        translate(hole){
            translate_z(post_height){
                m3_lug([0,0,0], angle, holes=false);
            }
            translate_z(post_height-9){
                m3_nut_trap_with_shaft(angle+180);
            }
        }
    }
}