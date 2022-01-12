

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
        cube([44,100,100]);
    }
    translate([0,12,-1]){
        cylinder(d=29, h=21);
    }
    translate([-10,-6,-1]){
        cube([20,100,21]);
    }
    if (front){
        hull(){
            translate([-10,-12,1]){
                cube([20,6.1,h-3]);
            }
            rotate_z(-10){
                translate([-20,-7,1]){
                    cube([11,5.1,h-3]);
                }
            }
        }
        rotate_z(-10){
            translate([-20,-7,-1]){
                cube([11,5.1,h-1]);
            }
        }
    }
    else{
        translate([-28+8,-12,1]){
            cube([28,6.1,h-3]);
        }
        rotate_z(-148){
            translate([0,-5.1,-1]){
                cube([25,5.1,h-1]);
            }
        }
    }

    for(x_tr = [-.5, .5]*motor_screw_separation()){
        translate([x_tr,12,0]){
            cylinder(d=4.5, h=h, center=true);
        }
    }
}

module side_cable_tidy(params, h=7){
    difference(){
        union(){
            y_actuator_frame(params){
                cable_tidy_body(h);
            }
            side_housing(params, h=h,cavity_h=0, attach=false);
        }
        y_actuator_frame(params){
            cable_tidy_body_cutouts(h);
        }
        side_housing_cutout(params, h-2);
    }
}

// Module: front_cable_tidy(params, h=7)
// Description: 
//   The cable tidy at the front of the microscope (i.e. for the Z motor)
module front_cable_tidy(params, h=7){
    cutout_h = z_motor_z_pos(params) + motor_bracket_h() + h - 2;
    difference(){
        union(){
            z_cable_tidy_frame(params, z_extra=motor_bracket_h()){
                cable_tidy_body(h, curve_both=true);
            }
            hull(){
                z_cable_housing_top(params, h);
                z_cable_tidy_frame(params, z_extra=motor_bracket_h()){
                    cable_tidy_body_back(h, curve_both=true);
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
