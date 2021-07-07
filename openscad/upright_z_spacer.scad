use <./illumination_dovetail.scad>
use <./libs/microscope_parameters.scad> 
use <./libs/main_body_structure.scad>
use <./libs/utilities.scad>
use <./libs/libdict.scad>
use <./libs/z_axis.scad>
use <./libs/wall.scad>
use <./libs/z_axis.scad>
use <./libs/illumination.scad>
use <./libs/compact_nut_seat.scad>
use <./libs/main_body_transforms.scad>
use <./libs/gears.scad>
$fn = 32;
params = default_params();
spacer_height = 25;

render(6)   spacer(params);        
        
module spacer(params){
    difference(){
        // Spacer main body
        spacer_body(params);
        // Screw thread holes
        translate([0,0,-illumination_dovetail_z(params)]) translate(right_illumination_screw_pos(params))  cylinder(r = 2, h = 4);
        translate([0,0,-illumination_dovetail_z(params)]) translate(left_illumination_screw_pos(params))  cylinder(r = 2, h = 4);
        translate([0,0,-illumination_dovetail_z(params)]) translate(illumination_back_corner_pos(params))  cylinder(r = 2, h = 4);
        // Screw head boring holes
        translate([0,0,-illumination_dovetail_z(params)]) translate(right_illumination_screw_pos(params))  rotate_z(90)    boring_holes(boring_radius = 5);
        translate([0,0,-illumination_dovetail_z(params)]) translate(right_illumination_screw_pos(params))   cylinder(r = 2, h = 4);
        translate([0,0,-illumination_dovetail_z(params)]) translate(left_illumination_screw_pos(params))  rotate_z(180)    boring_holes(boring_radius = 5);
        translate([0,0,4-illumination_dovetail_z(params)]) translate(left_illumination_screw_pos(params))  cylinder(r = 2, h = 4);
        translate([0,0,2.8-illumination_dovetail_z(params)]) translate(illumination_back_corner_pos(params))  cylinder(r = 4, h = 40);
        // Inserting the nut traps at the top of the spacer
        translate([0,0,-44])    spacer_top_screw_holes();
    }
}

module spacer_body(params){
    hull(){
        // Making the height of the spacer 3cm
        translate([0,0,spacer_height-illumination_dovetail_z(params)])    spacer_top();
        spacer_base(params);
    }
}

module spacer_top(){
    hull(){
        translate(right_illumination_screw_pos(params)) cylinder(r=6,h=2);
        translate(left_illumination_screw_pos(params))  cylinder(r=6,h=2);
        translate(right_back_corner_pos(params))    cylinder(r=6,h=2);
        translate(left_back_corner_pos(params)) cylinder(r=6,h=2);
    }
}

module spacer_base(){
    translate([0,0,-62]){
        hull(){
            each_illumination_corner(params){
                mirror([0,0,1]){
                    cylinder(r=5,h=upright_z_spacer_height);
                }
            }
        }
    }
}

module spacer_top_screw_holes(){
    translate(right_illumination_screw_pos(params))    m3_nut_trap_with_shaft(0,0);
    translate(left_illumination_screw_pos(params))    m3_nut_trap_with_shaft(0,0);
    translate(right_back_corner_pos(params))    rotate([0,0,225])    m3_nut_trap_with_shaft(0,0);
    translate(left_back_corner_pos(params))     rotate([0,0,135])   m3_nut_trap_with_shaft(0,0);
}

