/******************************************************************
*                                                                 *
* OpenFlexure Microscope: Z axis                                  *
*                                                                 *
* This is the Z axis for the OpenFlexure Microscope.              *
* It also contains the fitting for the optics module to attach    *
* it to the objective mount, as the objective mount is part of    *
* the Z axis assembly.                                            *
*                                                                 *
* (c) Richard Bowman, January 2018                                *
* Released under the CERN Open Hardware License                   *
*                                                                 *
******************************************************************/
/*

The Z axis assembly is a 4-bar mechanism, kept as short as possible
to maximise stiffness.  It's constructed in several parts:
objective_mount() is the wedge-shaped rail to which the optics attach
z_axis_flexures() makes the thin parts that flex as it is moved
z_axis_struts() makes the two connections between the objective_mount()
                and the static part

*/

use <./utilities.scad>
use <./compact_nut_seat.scad>
use <./wall.scad>
use <./gears.scad>
use <./fitting_wedge.scad>
use <./illumination.scad>
use <./microscope_parameters.scad>
use <./libdict.scad>


module objective_mount_internal_wedge_2d(){
    // The fitting wedge with a negative nose shift for clearance.

    projection(){
        objective_fitting_wedge(h=tiny(), nose_shift=-0.25);
    }
}

module objective_mount_body(params, h){

    // overlap set the contact between the mount and the wedge on
    // the optics module.
    overlap = 4;
    //overall width
    w = objective_mount_nose_w() + 2*overlap + 4;

    fillet_r = 1;
    mount_front = objective_mount_y() - overlap*cos(45) - fillet_r;
    mount_size = [w, objective_mount_back_y()-mount_front+5];

    linear_extrude(h){
        // Fillet outer corners
        convex_fillet(1){
            difference(){
                // Outer cross section is a square intersected with
                // the cutout in the centre of the microscope with
                // 1.2mm clearance
                intersection(){
                    translate([-w/2, mount_front, 0]){
                        square(mount_size);
                    }
                    offset(-1.2){
                        central_optics_cut_out_projection(params);
                    }
                }
                //subtracte grove for wedge
                objective_mount_internal_wedge_2d();
            }
        }
    }
}

module objective_mount_chamfer(){
    hull(){
        translate_z(-tiny()){
            linear_extrude(tiny()){
                offset(1){
                    objective_mount_internal_wedge_2d();
                }
            }
        }
        translate_z(1){
            linear_extrude(tiny()){
                objective_mount_internal_wedge_2d();
            }
        }
    }
}

module objective_mount(params){
    $fn=16;
    // The fitting to which the optics module is attached
    h = upper_z_flex_z(params) + 4*sqrt(2);

    difference(){
        objective_mount_body(params, h);

        objective_mount_chamfer();

        // Keyhole
        slot_bottom = lower_z_flex_z() + 6;
        slot_length = objective_mount_screw_pos(params).z - slot_bottom;
        translate_z(slot_bottom){
            rotate_x(-90){
                keyhole(h=99, r_hole=6.5/2, r_slot=3.5/2, l_slot=-slot_length);
            }
        }

        // cut-outs for flexures to attach
        hull(){
            reflect_x(){
                translate([1, tiny(), -4]){
                    z_axis_flexures(params, h=5+8);
                }
            }
        }

    }
}


function objective_mount_screw_pos(params) = [0, objective_mount_back_y(), (upper_z_flex_z(params) + lower_z_flex_z())/2];

module objective_fitting_wedge(h, nose_shift=0.2, center=false){
    // Create the fitting wedge for the optics module.
    // This is is justthe body without the nut trap.

    //width of the pointy end
    nose_width = objective_mount_nose_w();
    translate_y(objective_mount_y()){
        fitting_wedge(h, nose_width, nose_shift, center=center);
    }
}


module objective_fitting_cutout(params, y_stop=false, nose_shift=0.2, max_screw=10){
    // Subtract this from the optics module, to cut out a hole for the nut
    // that anchors it to the objective mount.
    // y_stop if set true will also cut flush the faces of the mount in case something is
    // protruding.
    z_pos = objective_mount_screw_pos(params).z;

    translate_y(objective_mount_y()){
        fitting_wedge_cutout(z_pos, y_stop=y_stop, nose_shift=nose_shift, max_screw=max_screw);
    }
}

module z_axis_flexure(h=flex_dims().z, z=0){
    // The parts that bend as the Z axis is moved
    union(){
        reflect_x(){
            hull(){
                translate([-flex_dims().x-1,objective_mount_back_y()-tiny(),z]){
                    cube([flex_dims().x,tiny(),h]);
                }
                translate([-z_anchor_w()/2,z_anchor_y(),z]){
                    cube([flex_dims().x,tiny(),h]);
                }
            }
        }
    }
}

module z_axis_flexures(params, h=flex_dims().z){
    // The parts that bend as the Z axis is moved
    for(z=[lower_z_flex_z(), upper_z_flex_z(params)]){
        z_axis_flexure(h=h, z=z);
    }
}

module z_axis_struts(params){
    // The parts that tilt as the Z axis is moved, including the lever that
    // connects to the actuator column (but not the column itself).

    //delta_z is 2-3 layers when printed
    delta_z = min_z_feature();
    intersection(){ // The two horizontal parts
        for(z=[lower_z_flex_z(), upper_z_flex_z(params)]){
            hull(){
                translate([-99,objective_mount_back_y()+flex_dims().y,z+delta_z]){
                    cube([999,z_strut_l(),1]);
                }
                translate([-99,objective_mount_back_y()+flex_dims().y+3,z+delta_z]){
                    cube([999,z_strut_l()-6,5]);
                }
            }
        }
        hull(){
            z_axis_flexures(params, h=999);
        }
    }
    // The link to the actuator
    w = column_base_radius() * 2;
    lever_h = 6;
    difference(){
        sequential_hull(){
            translate_y(z_nut_y(params)){
                cylinder(d=w, h=lever_h);
            }
            translate_y(z_anchor_y() + w/2 + 2){
                cylinder(d=w, h=lower_z_flex_z()+2*delta_z);
            }
            translate([-w/2, z_anchor_y() - flex_dims().x - tiny(), lower_z_flex_z() + delta_z]){
                cube([w,tiny(), 5-tiny()]);
            }
        }
        translate_y(z_nut_y(params)){
            actuator_end_cutout();
        }
    }
}

module pivot_z_axis(angle){
    // Pivot the children around the point where the Z axis pivots
    // The Y value for the pivot is z_anchor_y()
    // Because the rotation is small we can approximate with
    // shear; this means the whole axis moves as intended rather
    // than rotating about a particular height (i.e. both flexures
    // pivot about the right y value).
    sparse_matrix_transform(zy=sin(angle), zt=-sin(angle)*z_anchor_y()){
        children();
    }
}

module z_axis_clearance(params){
    // Clearance for the moving part of the Z axis
    for(a=[-6,0,6]){
        pivot_z_axis(a){
            minkowski(){
                cylinder(r=1, h=4, center=true, $fn=8);
                z_axis_struts(params);
            }
        }
    }
}

function objective_mounting_screw_access_angle() = [-93,0,22];

module objective_mounting_screw_access(params){
    // access hole for the objective mounting screw

    hole_angle = objective_mounting_screw_access_angle();

    // The access hole needs to point to the opening in the cap screw
    // This is +3mm in y from the position of the screw.
    translate(objective_mount_screw_pos(params) + [0, 3, 0]){
        hull(){
            rotate(hole_angle){
                cylinder(h=999, d=4, $fn=16);
            }
            translate([-.5, 0, -3]){
                rotate(hole_angle){
                    cylinder(h=999, d=5, $fn=16);
                }
            }
            //translate([-1,0,4]){
            //    rotate_x(-90){
            //        cylinder(h=tiny(), d=4, $fn=16);
            //    }
            //}
        }
    }
}

module z_motor_clearance(params, motor_h=999){
    // clearance for the motor and gears, to be subtracted from the condenser mount
    // This also labels it as "Z"
    actuator_h = key_lookup("actuator_h", params);
    translate_y(z_nut_y(params)){
        rotate_x(z_actuator_tilt(params)){
            translate_z(actuator_h+z_actuator_travel(params)+2-1){
                rotate(180){
                    motor_and_gear_clearance(gear_h=11, h=motor_h);
                    linear_extrude(1, center=true){
                        translate([0,15]){
                            text("Z", size=10, font="Sans", halign="center", valign="baseline");
                        }
                    }
                }
            }
        }
    }
}

module top_of_z_axis_casing(params){
    actuator_h = key_lookup("actuator_h", params);
    // The top of the Z axis casing, in case you want to join things onto it
    translate([-z_anchor_w()/2-1.5, z_anchor_y() - 1, upper_z_flex_z(params)]){
        cube([z_anchor_w()+3, tiny(), tiny()]);
    }
    translate_y(z_nut_y(params)){
        rotate(180){
            motor_lugs(h=actuator_h + z_actuator_travel(params), angle=180, tilt=-z_actuator_tilt(params));
        }
    }
}

module z_axis_casing(params, condenser_mount=false, cable_housing = true, rectangular = false){
    // Casing for the Z axis - needs to have the axis subtracted from it
    intersection(){
        linear_extrude(height=999){
            minkowski(){
                circle(r=microscope_wall_t()+1);
                hull(){
                    projection(){
                        z_axis_struts(params);
                    }
                }
            }
        }
        hull(){
            reflect_x(){
                z_bridge_wall_vertex(params);
            }
            translate([-99,z_anchor_y(),0]){
                cube([999,4,upper_z_flex_z(params)+2]);
            }
            translate_y(z_nut_y(params)){
                cylinder(d=10,h=20);
            }
        }
    }
    if(condenser_mount){
        // Making the corners of rectangular top larger than those on the triangular top by 1mm
        corner_rad = rectangular ? 6 : 5;
        hull(){
            // At the bottom, connect to the top of the housing and the motor lugs
            top_of_z_axis_casing(params);
            // The top is a flat shape that the illumination arm screws onto.
            each_illumination_corner(params, rectangular){
                mirror([0,0,1]){
                    cylinder(r=corner_rad, h=7);
                }
            }
        }
    }
    // conditional statement allows the wings to be removed
    if (cable_housing){
        z_cable_housing(params);
    }
}

// Boring holes for the screws in the spacer and separate z-actuator
module z_axis_boring_holes(boring_radius){
    hull(){
        translate([8,-8,20]){
            cylinder(r = boring_radius + tiny(), h = 0.5);
        }
        translate([0,0,2.8]){
            cylinder(r = boring_radius + tiny(), h = 0.5);
        }
    }
}

// Counterbored holes for the rectangular mount on the Z axis
// These holes are counterbored from the bottom, and can optionally
// be slanted by shifting the lower end along the Y axis.
module z_axis_mount_counterbore(counterbore_r=4.5, shaft_r=2, y_shift=0, h=30){
    // A disc that has the right cross-section for a counterbored hole.
    module counterbore_disc(){
        cylinder(r = counterbore_r, h = tiny());
    }
    intersection(){
        // This is the hole for the screw shaft - it has a large volume above z=0,
        // so we join it to the counterbore by taking an intersection.
        mirror([0,0,1]){
            hole_from_bottom(r=shaft_r, h=999, base_w=999, big_bottom = true);
        }

        // This is the counterbore, i.e. where we insert the screw.
        // The counterbore needs to include the shaft below z=0 as well, because
        // it's joined by an intersection.  See docs on hole_from_bottom.
        sequential_hull(){
            translate_z(-99){
                counterbore_disc();
            }
            translate_z(4){
                counterbore_disc();
            }
            translate([0,y_shift,h]) {
                counterbore_disc();
            }
        }
    }
}

module z_axis_rect_top_counterbores(params){
    // Counterbored holes, from underneath the rectangular mounting platform
    // These are used to screw the Z axis on to the spacer, for the upright
    // microscope.
    z_offset = [0, 0, -2.5];
    reflect_x(){
        translate(right_illumination_screw_pos(params) + z_offset){
            mirror([0,0,1]){
                rotate(-90){
                    z_axis_mount_counterbore(y_shift=17, h=30);
                }
            }
        }
        translate(right_back_sq_illum_corner_pos(params) + z_offset){
            mirror([0,0,1]){
                z_axis_mount_counterbore(counterbore_r=3.5);
            }
        }
    }
}

module z_axis_tri_top_counterbores(params){
    // Nut traps for standard triangular top on the z_axis
    z_offset = -9;
    // Nut trap for back corner
        translate(illumination_back_corner_pos(params)){
            rotate_z(180){
                translate_z(z_offset){
                    m3_nut_trap_with_shaft(0,0);
                }
            }
        }
        reflect_x(){
            translate(right_illumination_screw_pos(params)){
                rotate_z(right_illumination_screw_rotation()){
                    translate_z(z_offset){
                        m3_nut_trap_with_shaft(0,0);
                    }
                }
            }
        }
}

module z_axis_casing_cutouts(params, rectangular = false){
    // The Z axis casing is a solid shape, we need to cut out clearance for the moving bits
    // This module contains all the bits we need to cut out.
    z_axis_clearance(params);
    objective_mounting_screw_access(params);
    z_actuator_cutout(params);
    z_motor_clearance(params);
    if (rectangular){
        z_axis_rect_top_counterbores(params);
    }
    else{
        z_axis_tri_top_counterbores(params);
    }
    // Adding the central screw hole and nut trap
    translate_z(-9){
        translate(illumination_back_corner_pos(params)){
            rotate([0,0,180]){
                m3_nut_trap_with_shaft(0,0);
            }
        }
    }
}

////////////// These modules define the actuator column and housing (where the screw/nut/band go)

module z_actuator_column(params, ties_only=false){
    ties = key_lookup("print_ties", params);
    actuator_h = key_lookup("actuator_h", params);
    tilt = z_actuator_tilt(params);
    translate_y(z_nut_y(params)){
        if (! ties_only){
            actuator_column(actuator_h, tilt=tilt, join_to_casing=ties);
        }
        else{
            actuator_ties(tilt);
        }
    }
}

module z_actuator_housing(params, include_motor_lugs=undef){
    // This houses the actuator column and provides screw seat/motor lugs
    h = key_lookup("actuator_h", params);
    inc_motor_lugs = if_undefined_set_default(include_motor_lugs,
                                              key_lookup("include_motor_lugs", params));
    translate_y(z_nut_y(params)){
        screw_seat(params,
                   h,
                   tilt=z_actuator_tilt(params),
                   travel=z_actuator_travel(params),
                   include_motor_lugs=inc_motor_lugs,
                   lug_angle=180);
    }
}

module z_actuator_cutout(params){
    // This chops out a void for the actuator column
    translate_y(z_nut_y(params)){
        screw_seat_outline(h=999,
                           adjustment=-tiny(),
                           center=true,
                           tilt=z_actuator_tilt(params));
    }
}


module complete_z_actuator(params){
    // This is the z-actuator, objective mount and the z-flexures.
    // The flexure that join the body are not attached to anything on the body-side.

    z_axis_flexures(params);
    z_axis_struts(params);
    objective_mount(params);
    z_actuator_column(params);
    difference(){
        z_actuator_housing(params);
        // Subtract the clearance to make sure the actuator can get in ok.
        // This only makes a very small cutout.
        z_axis_clearance(params);
    }
}



// Module: z_housing_frame(params, y_actuator=false)
// Description: 
//   Transform into the frame of the Z cable housing.
//   The origin will be in the z=0 plane, either to the
//   left or the right of the bottom of the Z actuator 
//   column.  It will be tilted to match the Z actuator,
//   but rotated 15 degrees around z in the same direction
//   as it is translated - if y_actuator is false (default)
//   we will be on the +y side of the Z actuator.
module z_housing_frame(params, y_actuator=false){
    tilt = z_actuator_tilt(params);
    x_tr = y_actuator ? -23 : 23;
    angle = y_actuator ? 15 : -15;
    translate([x_tr, z_nut_y(params), 0]){
        rotate_z(angle){
            rotate_x(tilt){
                children();
            }
        }
    }
}

// Module: z_cable_tidy_frame(params, z_extra=0)
// Description: 
//   Transform children into the frame of the Z cable tidy.
//   This puts the origin at the centre of the Z motor shaft
//   in the plane of the front face of the motor.  It's also
//   rotated 180 degrees about Z such that the y axis points
//   approximately in the opposite direction to y.
module z_cable_tidy_frame(params, z_extra=0){
    tilt = z_actuator_tilt(params);
    z_tr = z_motor_z_pos(params) + z_extra;
    translate_y(z_nut_y(params)){
        rotate_x(tilt){
            translate_z(z_tr){
                rotate_z(180){
                    children();
                }
            }
        }
    }
}

module z_cable_tidy_frame_undo(params, z_extra=0){
    tilt = z_actuator_tilt(params);
    z_tr = z_motor_z_pos(params) + z_extra;
    rotate_z(-180){
        translate_z(-z_tr){
            rotate_x(-tilt){
                translate_y(-z_nut_y(params)){
                    children();
                }
            }
        }
    }
}

// Module: z_cable_housing(params)
// Description: 
//   A solid block that is the right size to contain the cable channels
//   either side of the Z axis.  Its bottom is the z=0 plane, and its top
//   is parallel to the face of the Z motor.
module z_cable_housing(params){
    difference(){
        hull(){
            z_cable_housing_x(params);
            mirror([1,0,0]){
                z_cable_housing_x(params);
            }
        }
        translate_z(-99){
            cylinder(d=999,h=99);
        }
        z_cable_tidy_frame(params, z_extra=motor_bracket_h()){
            cylinder(d=999,h=99);
        }
    }
}

// Module: z_cable_housing_top(params, h)
// Description: 
//   A block of height h that has the same shape as the top of the z
//   cable housing.
module z_cable_housing_top(params, h){
    // Must untilt and trasnlate before cutting. Then undo transforms
    z_cable_tidy_frame(params, z_extra=motor_bracket_h()){
        linear_extrude(h){
            projection(cut=true){
                z_cable_tidy_frame_undo(params, z_extra=motor_bracket_h()-tiny()){
                    z_cable_housing(params);
                }
            }
        }
    }
}


// Module: z_cable_housing_x(params)
// Description: 
//   A solid block big enough to contain the motor cable from the Z axis.
//   Note that the z cable housing includes one of these on each side of
//   the Z axis.
module z_cable_housing_x(params){
    h=z_motor_z_pos(params)+motor_bracket_h();
    housing = [motor_connector_size().y+5, motor_connector_size().x+5, h*3];

    hull(){
        z_housing_frame(params){
            translate([housing.x/2-3, housing.y/2-3, 0]){
                cylinder(r=3,h=housing.z, center=true);
            }
            translate([housing.x/2-3, -(housing.y/2-3), 0]){
                cylinder(r=3,h=housing.z, center=true);
            }
            translate([-(housing.x/2-2), housing.y/2-3, 0]){
                cylinder(r=3,h=housing.z, center=true);
            }
            translate([-(housing.x/2-2), -(housing.y/2-3), 0]){
                cylinder(r=3,h=housing.z, center=true);
            }
        }
        difference(){
            wall_between_actuators(params, y_actuator=false);
            z_axis_casing_cutouts(params);
        }
    }
}

// Module: z_cable_housing_cutout(params, h=99, top=false)
// Description: 
//   A block that can be subtracted from the z_cable_housing
//   to make the channel for the cable.  NB this module renders one
//   on either side of the Z axis, though the one next to the
//   Y actuator is smaller as it's for the illumination cable.
//   
//   If top is true, we shift the cutout slightly in X.
//   For now, we the illumination cable is also extended in -y
//   to cut the side of the cable tidy and allow access to the channel.
//   This will eventually be replaced with something more neatly enclosed.
module z_cable_housing_cutout(params, h=99, top=false){
    cutout_size = [motor_connector_size().y+2, motor_connector_size().x+2, 2*h];
    inset = top ? [2,0,0] : [0,0,0];
    illumination_extra = top ? [0,20,0] : [0,0,0];
    z_housing_frame(params, y_actuator=false){
        translate(-inset){
            cube(cutout_size, center=true);
        }
    }
    z_housing_frame(params, y_actuator=true){
        translate([-4,0,0]+inset-illumination_extra/2){
            cube(cutout_size-[8,0,0]+illumination_extra, center=true);
        }
    }
}
