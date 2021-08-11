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
use <./z_only.scad>
$fn = 32;
params = default_params();
sample_z = key_lookup("sample_z", params);

function spacer_height(upright_sample_thickness) = (sample_z - illumination_dovetail_z(params)) *2 + upright_sample_thickness;

module spacer_stl(params, upright_sample_thickness){
    spacer(params, upright_sample_thickness);
}

module spacer(params, upright_sample_thickness){
    difference(){
        // Spacer main body
        spacer_body(params, upright_sample_thickness);
        // Screw thread holes
        translate([0,0,-illumination_dovetail_z(params)]) translate(right_illumination_screw_pos(params))  cylinder(r = 2, h = 4);
        translate([0,0,-illumination_dovetail_z(params)]) translate(left_illumination_screw_pos(params))  cylinder(r = 2, h = 4);
        translate([0,0,-illumination_dovetail_z(params)]) translate(illumination_back_corner_pos(params))  cylinder(r = 2, h = 4);
        // Screw head boring holes
        translate([0,0,-illumination_dovetail_z(params)]) translate(right_illumination_screw_pos(params))  rotate_z(90)    boring_holes(boring_radius = 5);
        translate([0,0,-illumination_dovetail_z(params)]) translate(right_illumination_screw_pos(params))   cylinder(r = 2, h = 4);
        translate([0,0,-illumination_dovetail_z(params)]) translate(left_illumination_screw_pos(params))  rotate_z(180)    boring_holes(boring_radius = 5);
        translate([0,0,4-illumination_dovetail_z(params)]) translate(left_illumination_screw_pos(params))  cylinder(r = 2, h = 4);
        translate([0,0,2.8-illumination_dovetail_z(params)]) translate(illumination_back_corner_pos(params))  cylinder(r = 4, h = 70);
        // Inserting the nut traps at the top of the spacer
        translate([0,0,spacer_height(upright_sample_thickness)-69])    spacer_top_screw_holes();
        // Cut-out for motor
        translate([0,66,-tiny()])    cylinder(r = 12.5, h = 70);
    }
}

module spacer_body(params, upright_sample_thickness){
    hull(){
        // Making the height of the spacer 25mm
        translate([0,0,spacer_height(upright_sample_thickness)-illumination_dovetail_z(params)])    spacer_top();
        spacer_base(params);
    }
}

module spacer_top(){
    hull(){
        // Creating the rectangular top of the spacer
        translate(right_illumination_screw_pos(params)) cylinder(r=6,h=3);
        translate(left_illumination_screw_pos(params))  cylinder(r=6,h=3);
        translate(right_back_corner_pos(params))    cylinder(r=6,h=3);
        translate(left_back_corner_pos(params)) cylinder(r=6,h=3);
    }
}

module spacer_base(){
    translate([0,0,-62]){
        hull(){
            // Creating the triangular bottom of the spacer using the position of the corners as previously defined
            each_illumination_corner(params){ 
                mirror([0,0,1]){
                    cylinder(r=5,h=tiny());
                }
            }
        }
    }
}

module spacer_top_screw_holes(){
    // Inserting the nut traps and screw holes into the spacer
    translate(right_illumination_screw_pos(params))    m3_nut_trap_with_shaft(0,0);
    translate(left_illumination_screw_pos(params))    m3_nut_trap_with_shaft(0,0);
    // Rotating the back nut traps to minimise "threading" 
    translate(right_back_corner_pos(params))    rotate([0,0,225])    m3_nut_trap_with_shaft(0,0);
    translate(left_back_corner_pos(params))     rotate([0,0,135])   m3_nut_trap_with_shaft(0,0);
}

