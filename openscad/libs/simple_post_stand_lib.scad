use <./utilities.scad>
use <./microscope_parameters.scad>
use <./compact_nut_seat.scad>
use <./main_body_transforms.scad>
use <./main_body_structure.scad>
use <./libdict.scad>


// Module: simple_post_stand()
// Usage: simple_post_stand(params, type="back", wall_height=10);
// Description: 
//   Builds posts to fit under main body mointing points, to use instead of a complete base.
//   Cable tie loops are included on the legs under the stage.
//
//   optional parameters
//   type: which of the mounting holes to make posts for. The posts are the same height as the actuator feet so
//         it is recommended to build posts only for the feet under the stage (type="back") and rest on the actuator feet.
//   wall_height: the height of a wall that runs between the "back" legs, around stage, to stop tipping.
module simple_post_stand(params, type="back", wall_height=10){
    hole_pos = base_mounting_holes(params,type=type);
    foot_height= key_lookup("foot_height",params);
    post_height = foot_height;

    // a post at each mounting foot position
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
                reflect_x(){
                    y_actuator_frame(params){
                        screw_seat_outline(h=999,adjustment=+tiny(),center=true);
                    }
                }
            }
        }
    }
    // wall around stage base to prevent toppling, joining teh two "back" posts
    back_hole_pos = base_mounting_holes(params,type="back");
    difference(){
        wall_radius = sqrt((back_hole_pos[1].x)^2+(back_hole_pos[1].y)^2);
        wall_d = wall_radius*2 + 3;
        echo(wall_d);
        cylinder(d=wall_d, h=wall_height, $fn=64);
        translate_z(-tiny()){
            cylinder(d1=wall_d-10, d2=wall_d-1.5, h=wall_height+2*tiny(), $fn=64);
        }
        translate([-99/2,-5,-99/2]){
            cube(99);
        }
        // remember the nut clearances through the wall as well
        for (n = [0:len(back_hole_pos)-1]){
            back_hole = back_hole_pos[n];
            angle = lug_angles(params)[n];
            translate(back_hole){
                translate_z(post_height){
                    m3_lug([0,0,0], angle, holes=false);
                }
                translate_z(post_height-9){
                    m3_nut_trap_with_shaft(angle+180);
                }
            }
        }
    }
}
