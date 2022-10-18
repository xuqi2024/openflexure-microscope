

use <libs/microscope_parameters.scad>
use <libs/main_body_transforms.scad>
use <libs/utilities.scad>
use <libs/wall.scad>
use <libs/z_axis.scad>


module cable_tidy_body_back(h, curve_both=false){
    //This is the back edge of the cable tidy.
    // it will be hulled with the font where the lugs are to make
    // the final structure. The +x direction always has a radius of
    // 8. To have a radius on both sizes (for the z_motor) use
    // `curve_both=true`. For the x-motor this shape must be mirrored.
    translate([11,-11,0]){
        cylinder(d=8, h=h);
    }
    if (curve_both){
        translate([-11,-11,0]){
        cylinder(d=8, h=h);
    }
    }
    else{
        translate([-16,-14.5,0]){
            cylinder(d=1, h=h);
        }
    }
}


module cable_tidy_body(h, curve_both=false){
    hull(){
        for(x_tr = [-.5, .5]*motor_screw_separation()){
            translate([x_tr,12,0]){
                cylinder(d=8, h=h);
            }
        }
        cable_tidy_body_back(h, curve_both);
    }
}


module cable_tidy_body_cutouts(h, front=false){
    translate([-22,3.7,1.5]){
        cube([44,100,100]);    // The motor lugs
    }
    translate([0,12,-1]){
        cylinder(d=29, h=21);  // The motor body
    }
    translate([-10,-6,-1]){
        cube([20,100,21]);     // The connector
    }
    // Void for the cable
    if (front){  // front means we are rendering the Z cable tidy
        translate([-10,-12,1]){
            cube([20,6.1,h-3]);
        }
        hull(){
            translate([-10,-12,1]){
                cube([20,6.1,h-3.75]);
            }
            rotate_z(-10){
                translate([-20,-7,1]){
                    cube([11,5.1,h-3.75]);
                }
            }
        }
        rotate_z(-10){
            translate([-20,-7,-1]){
                cube([11,5.1,h-1.75]);
            }
        }
    }
    else{  // side cable tidies
        // the wires where they exit the connector
        // NB this needs to touch the edge of the 
        // cut-out for the connector on one side,
        // in order to make bridging work
        // (that's the +2 in width and -2 in x)
        translate([-8-2,-12,1]){
            cube([16+2,6.1,h-3]); 
        }
        // connection to the vertical shaft in the body
        // NB this is intentionally slightly lower, so that
        // the part will print correctly - it needs to bridge
        // here first.
        translate([-20,-12,1]){
            cube([20,6.1,h-3.75]); 
        }
        // angled slot going through the bottom, so the cable
        // can be inserted
        rotate_z(-148){
            translate([0,-5.1,-1]){
                cube([25,5.1,h-1.75]);
            }
        }
    }

    for(x_tr = [-.5, .5]*motor_screw_separation()){
        translate([x_tr,12,0]){
            cylinder(d=4.5, h=h, center=true);
        }
    }
}

// Linear extrusion, with the top edges chamfered with a radius
// of roc
module linear_extrude_with_rounded_top(h, roc=1.5){
    // The bottom is simple enough: extrude up to the curved part
    linear_extrude(h - roc){
        children();
    }
    // The curved top is achieved by insetting the 2D shape, then
    // convolving it with a sphere
    minkowski(){
        sphere(r=roc);
        translate_z(h - roc){
            linear_extrude(tiny()){
                offset(-roc){
                    children();
                }
            }
        }
    }
}

// Project along Z, then extrude with a chamfered top edge
module thick_projection_with_rounded_top(h, roc=1.5, $fn=16){
    linear_extrude_with_rounded_top(h=h, roc=roc){
        projection(){
            children();
        }
    }
}

module side_cable_tidy(params, h=7){
    difference(){
        thick_projection_with_rounded_top(h=h){
            union(){
                y_actuator_frame(params){
                
                    cable_tidy_body(h);
                
                }
                side_housing(params, h=h,cavity_h=0, attach=false);
            }
        }
        y_actuator_frame(params){
            cable_tidy_body_cutouts(h);
        }
        side_housing_cutout(params, h-2.75);
    }
}

// Module: front_cable_tidy(params, h=7)
// Description: 
//   The cable tidy at the front of the microscope (i.e. for the Z motor)
//   NB this renders in-place and will need to be transformed to put it
//   in printable position, using 
//   z_cable_tidy_frame_undo(params, z_extra=motor_bracket_h())
module front_cable_tidy(params, h=7){
    cutout_h = z_motor_z_pos(params) + motor_bracket_h() + h - 2.75;
    difference(){
        z_cable_tidy_frame(params, z_extra=motor_bracket_h()){
            // thick_projection needs the bottom to be flat and the
            // sides to be vertical, so we must work in the 
            // cable tidy's frame of reference
            thick_projection_with_rounded_top(h=h){
                cable_tidy_body(h, curve_both=true);
                // In order to get the Z cable housing transformed
                // correctly, we need to apply the inverse transform,
                // so this is the cable housing as seen from the cable
                // tidy's frame of reference.
                z_cable_tidy_frame_undo(params, z_extra=motor_bracket_h()){
                    hull(){
                        z_cable_housing_top(params, h);
                        z_cable_tidy_frame(params, z_extra=motor_bracket_h()){
                            cable_tidy_body_back(h, curve_both=true);
                        }
                    }
                }
            }
        }
        z_cable_tidy_frame(params, z_extra=motor_bracket_h()){
            cable_tidy_body_cutouts(h, front=true);
        }
        z_cable_housing_cutout(params, cutout_h, top=true);
    }
}

module cable_tidies(params){

    z_cable_tidy_frame_undo(params, z_extra=motor_bracket_h()){
        translate([0,40,-18]){
            front_cable_tidy(params);
        }
    }
    reflect_x(){
        translate([20,-20,0]){
            side_cable_tidy(params);
        }
    }
}


module cable_tidies_stl(){
    params = default_params();
    cable_tidies(params);
}

cable_tidies_stl();
