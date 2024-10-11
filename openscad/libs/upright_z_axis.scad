use <./microscope_parameters.scad>
use <./main_body_structure.scad>
use <./utilities.scad>
use <./libdict.scad>
use <./z_axis.scad>
use <./wall.scad>
use <./z_axis.scad>
use <./illumination.scad>
use <./compact_nut_seat.scad>


module separate_z_actuator(params, cable_guides = false, cable_housing = false, rectangular = false){
    //This is the z-axis of the main body 
    // The cable_housing variable allows cable guides to be included or omitted
    difference(){
        union(){
            add_hull_base(microscope_base_t());
            // The wings have been removed from this design of the z-axis as they are not required 
            z_axis_casing(params, condenser_mount=true, cable_housing=cable_housing, rectangular=rectangular);
        }
        mounting_hole_lugs(params);
        // This cuts the screw holes and/or nut traps (depending on whether it is for rectangular or triangular) into the z-axis
        z_axis_casing_cutouts(params, rectangular=rectangular);
        xy_actuator_cut_outs(params);
        central_optics_cut_out(params);
        z_axis_clearance(params);
        z_motor_clearance(params);
        if (cable_guides){
            // Cable guide cutouts to allow the cables to be threaded through 
            z_cable_housing_cutout(params, h=99, top=false);
        }
    }

    // Adding the z actuator
    difference(){
        complete_z_actuator(params);
        // Removing the extruding cylinders from the actuator
        translate([-50,0,-100]){
            cube(size = 100);
        }
    }
}

// Thickness of the vertical straight top section of the upright z spacerpart
function upright_z_spacer_top_thickness() = 3;
// Overall height of the upright z-spacer 
function upright_z_spacer_height(params, upright_sample_thickness) = (key_lookup("sample_z", params) - illumination_dovetail_z(params)) *2 + upright_sample_thickness;

module upright_z_spacer(params, upright_sample_thickness){
    $fn=32;
    difference(){
        // Spacer main body
        upright_z_spacer_body(params, upright_sample_thickness);
        // Screw clearance holes
        translate([0,0,-illumination_dovetail_z(params)-tiny()]){
            translate(right_illumination_screw_pos(params)){
                cylinder(r = 2, h = 4);
            }
        }
        translate([0,0,-illumination_dovetail_z(params)-tiny()]){
            translate(left_illumination_screw_pos(params)){
                cylinder(r = 2, h = 4);
            }
        }
        translate([0,0,-illumination_dovetail_z(params)-tiny()]){
            translate(illumination_back_corner_pos(params)){
                cylinder(r = 2, h = 4);
            }
        }
        // Screw head boring holes
        translate([0,0,-illumination_dovetail_z(params)]){
            translate(right_illumination_screw_pos(params)){
                rotate_z(90-25){
                    z_axis_boring_holes(boring_radius = 5.1, taper=0.5);
                }
            }
        }
        translate([0,0,-illumination_dovetail_z(params)]){
            translate(left_illumination_screw_pos(params)){
                rotate_z(180+25){
                    z_axis_boring_holes(boring_radius = 5.1, taper=0.5);
                }
            }
        }
        translate([0,0,3-illumination_dovetail_z(params)]){
            translate(illumination_back_corner_pos(params)){
                cylinder(r = 4, h = 70);
            }
        }
        // Inserting the nut traps at the top of the spacer
        // (note nut trap module base sits 9mm below mounting face to give a 1.5mm thick top plate)
        spacer_nut_trap_base = upright_z_spacer_height(params, upright_sample_thickness) - illumination_dovetail_z(params) - 9 ; 
        translate([0,0,spacer_nut_trap_base]){
            upright_z_spacer_top_screw_holes(params);
        }
        // Cut-out for motor
        translate([0,66,-tiny()]){
            cylinder(r = 12.5, h = 70);
        }
    }
}

module upright_z_spacer_body(params, upright_sample_thickness){
    hull(){
        // The translation needed for height of the spacer, including the fact that the spacer top part has thickness
        top_translate_z = upright_z_spacer_height(params, upright_sample_thickness)-illumination_dovetail_z(params)-upright_z_spacer_top_thickness();
        translate([0,0,top_translate_z]){
            upright_z_spacer_top(params);
        }
        upright_z_spacer_base(params);
    }
}

module upright_z_spacer_top(params){
    top_h = upright_z_spacer_top_thickness();
    hull(){
        // Creating the rectangular top of the spacer
        translate(right_illumination_screw_pos(params)){
            cylinder(r=6,h=top_h);
        }
        translate(left_illumination_screw_pos(params)){
            cylinder(r=6,h=top_h);
        }
        translate(right_back_sq_illum_corner_pos(params)){
            cylinder(r=6,h=top_h);
        }
        translate(left_back_sq_illum_corner_pos(params)){
            cylinder(r=6,h=top_h);
        }
    }
}

module upright_z_spacer_base(params){
    translate([0,0,-illumination_dovetail_z(params)]){
        hull(){
            // Creating the triangular bottom of the spacer using the position of the corners as previously defined
            each_illumination_corner(params){
                cylinder(r=5,h=tiny());
            }
        }
    }
}

module upright_z_spacer_top_screw_holes(params){
    // Inserting the nut traps and screw holes into the spacer
    translate(right_illumination_screw_pos(params)){
        m3_nut_trap_with_shaft(0,0);
    }
    translate(left_illumination_screw_pos(params)){
        m3_nut_trap_with_shaft(0,0);
    }
    // Rotating the back nut traps to minimise "threading" 
    translate(right_back_sq_illum_corner_pos(params)){
        m3_nut_trap_with_shaft(225,0);
    }
    translate(left_back_sq_illum_corner_pos(params)){
        m3_nut_trap_with_shaft(135,0);
    }
}

