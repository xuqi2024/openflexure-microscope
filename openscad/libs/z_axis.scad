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
use <./main_body_transforms.scad>
use <./wall.scad>
use <./gears.scad>
use <./illumination.scad>
include <./microscope_parameters.scad>
use <./libdict.scad>
module each_om_contact_plane(){
    // This transform puts y=0 in the plane of contact between the
    // optics module and the mount for it, with the origin at the
    // nominal corner of the wedge.
    reflect([1,0,0]) translate([-objective_mount_nose_w/2,objective_mount_y,0])
                rotate(135) children();
}

module objective_mount(params){
    // The fitting to which the optics module is attached
    h = z_flexures_z2(params) + 4*sqrt(2);
    overlap = 4; // we have this much contact between
                 // the mount and the wedge on the optics module.
    roc=1.5; // radius of curvature of the arms
    w = objective_mount_nose_w + 2*overlap + 4;//+2*roc; //overall width

    difference(){
        hull(){
            // the back of the mount
            translate([-w/2,objective_mount_back_y+5,0]) cube([w,tiny(),h]);
            // the front of the mount (this makes contact with the optics module)
            each_om_contact_plane() translate([0,overlap-tiny(),0]) cube([2*roc,tiny(),h]);
        }

        // bolt slot to mount objective
        hull(){
            translate([0,0,z_flexures_z1+8]) rotate([-90,0,0]) cylinder(d=3.5, h=999);
            translate([0,0,z_flexures_z2(params)-5]) rotate([-90,0,0]) cylinder(d=3.5, h=999);
        }
        // make the bolt slot keyhole-shaped to allow the screw to be easily inserted
        translate([0,0,z_flexures_z1+6]) rotate([-90,0,0]) cylinder(d=6.5, h=999);


        objective_fitting_wedge(params, h=999,nose_shift=-0.25,center=true);

        // cut-outs for flexures to attach
        hull(){
            reflect([1,0,0]){
                translate([1, tiny(), -4]){
                    z_axis_flexures(params, h=5+8);
                }
            }
        }

        // cut out the back so it fits in the available space
        reflect([1,0,0]) translate([-lug_x_pos(params),0,-99]) rotate(45) cube(999);
    }
    // Nice rounded fronts either side
    each_om_contact_plane() translate([roc,overlap,0]) cylinder(r=roc,h=h);
}


//TODO find out what these are and whther they are still needed!
function objective_mount_screw_pos(params) = [0, objective_mount_back_y, (z_flexures_z2(params) + z_flexures_z1)/2];

module objective_mount_screw(params){
    translate(objective_mount_screw_pos(params)) rotate([-90,0,0]){
        cylinder(r=3, h=2.5);
        mirror([0,0,1]) cylinder(d=3, h=12);
    }
}

module objective_fitting_wedge(params, h=undef, nose_shift=0.2, center=false){
    // A trapezoidal wedge that clamps onto the objective mount.
    // NB you must subtract the objective_fitting_cutout from this to allow
    // the screw and nut to be attached.
    // NB nose_shift moves the tip of the wedge in the -y direction (i.e. increases
    // the gap at the tip, if we are making the optics module).  If subtracting this
    // to make a mount for the optics module, use nose_shift < 0

    let(h = is_undef(h) ? z_flexures_z2(params)+4 : h){
        nw = objective_mount_nose_w; //width of the pointy end
        translate([0,objective_mount_y,0]) mirror([0,1,0]) hull(){
            translate([-nw/2-nose_shift,nose_shift,center?-h/2:0]) cube([nw+2*nose_shift,tiny(),h]);
            reflect([1,0,0]) translate([-nw/2-5+sqrt(2), 5+sqrt(2), 0])
                    cylinder(r=2, h=h, $fn=16, center=center);
        }
    }
}

module ofc_nut(shaft=false, max_screw=12){
    // For convenience, this is the nut that we use to hold the optics module on.
    // it is used from objective_fitting_cutout only.
    nut_y(3, h=2.5, extra_height=0, shaft=shaft, shaft_length=shaft?max_screw-4:0);
}

module objective_fitting_cutout(params, max_screw=12, y_stop=false, nose_shift=0.2){
    // Subtract this from the optics module, to cut out a hole for the nut
    // that anchors it to the objective mount.
    // TODO: also relieve the faces of the mount in case there are protrusions
    oms = objective_mount_screw_pos(params);
    translate([oms.x, objective_mount_y - 1.2 - 2.5, oms.z]){
        ofc_nut(shaft=true, max_screw=max_screw);
        sequential_hull(){
            ofc_nut();
            translate([0,0,7]) ofc_nut();
            translate([0,10,7]) repeat([0,0,10],2) ofc_nut();
        }
    }
    if(y_stop) translate([-10,objective_mount_y-nose_shift,-99])cube([20,999,999]);
}

module z_axis_flexure(h=flex_dims().z, z=0){
    // The parts that bend as the Z axis is moved
    union(){
        reflect([1,0,0]) hull(){
            translate([-flex_dims().x-1,objective_mount_back_y-tiny(),z]) cube([flex_dims().x,tiny(),h]);
            translate([-z_anchor_w/2,z_anchor_y,z]) cube([flex_dims().x,tiny(),h]);
        }
    }
}
module z_axis_flexures(params, h=flex_dims().z){
    // The parts that bend as the Z axis is moved
    for(z=[z_flexures_z1, z_flexures_z2(params)]){
        z_axis_flexure(h=h, z=z);
    }
}

module z_axis_struts(params){
    // The parts that tilt as the Z axis is moved, including the lever that
    // connects to the actuator column (but not the column itself).
    intersection(){ // The two horizontal parts
        for(z=[z_flexures_z1, z_flexures_z2(params)]) hull(){
            translate([-99,objective_mount_back_y+flex_dims().y,z+dz]) cube([999,z_strut_l,1]);
            translate([-99,objective_mount_back_y+flex_dims().y+3,z+dz]) cube([999,z_strut_l-6,5]);
        }
        hull() z_axis_flexures(params, h=999);
    }
    // The link to the actuator
    w = column_base_radius() * 2;
    lever_h = 6;
    difference(){
        sequential_hull(){
            translate([0, z_nut_y(params), 0]) cylinder(d=w, h=lever_h);
            translate([0, z_anchor_y + w/2 + 2, 0]) cylinder(d=w, h=z_flexures_z1+2*dz);
            translate([-w/2, z_anchor_y - flex_dims().x - tiny(), z_flexures_z1 + dz]) cube([w,tiny(), 5-tiny()]);
        }
        translate([0, z_nut_y(params), 0]) actuator_end_cutout();
    }
}

module pivot_z_axis(angle){
    // Pivot the children around the point where the Z axis pivots
    // The Y value for the pivot is z_anchor_y
    // Because the rotation is small we can approximate with
    // shear; this means the whole axis moves as intended rather
    // than rotating about a particular height (i.e. both flexures
    // pivot about the right y value).
    smatrix(zy=sin(angle), zt=-sin(angle)*z_anchor_y) children();
}

module z_axis_clearance(params){
    // Clearance for the moving part of the Z axis
    for(a=[-6,0,6]) pivot_z_axis(a) minkowski(){
        cylinder(r=1, h=4, center=true, $fn=8);
        z_axis_struts(params);
    }
}

module objective_mounting_screw_access(params){
    // access hole for the objective mounting screw

    translate([0,objective_mount_back_y, z_flexures_z2(params)/2]) hull(){
        rotate([-90,0,15]) cylinder(h=999, d=8, $fn=16);
        translate([0,0,6]) rotate([-90,0,0]) cylinder(h=tiny(), d=4, $fn=16);
    }
}

module z_motor_clearance(params, motor_h=999){
    // clearance for the motor and gears, to be subtracted from the condenser mount
    // This also labels it as "Z"
    actuator_h = key_lookup("actuator_h", params);
    translate([0,z_nut_y(params),0]) rotate([z_actuator_tilt(params),0,0]) {
        translate([0,0,actuator_h+z_actuator_travel(params)+2-1]) rotate(180){
            motor_and_gear_clearance(gear_h=11, h=motor_h);
            linear_extrude(1, center=true) translate([0,15]) {
                text("Z", size=10, font="Sans", halign="center", valign="baseline");
            }
        }
    }
}

module top_of_z_axis_casing(params){
    actuator_h = key_lookup("actuator_h", params);
    // The top of the Z axis casing, in case you want to join things onto it
    translate([-z_anchor_w/2-1.5, z_anchor_y - 1, z_flexures_z2(params)]){
        cube([z_anchor_w+3, tiny(), tiny()]);
    }
    translate([0,z_nut_y(params),0]){
        rotate(180){
            motor_lugs(h=actuator_h + z_actuator_travel(params), angle=180, tilt=-z_actuator_tilt(params));
        }
    }
}

module z_axis_casing(params, condenser_mount=false){
    // Casing for the Z axis - needs to have the axis subtracted from it
    intersection(){
        linear_extrude(height=999) minkowski(){
            circle(r=wall_t+1);
            hull() projection() z_axis_struts(params);
        }
        hull(){
            reflect([1,0,0]) z_bridge_wall_vertex(params);
            translate([-99,z_anchor_y,0]) cube([999,4,z_flexures_z2(params)+2]);
            translate([0,z_nut_y(params),0]) cylinder(d=10,h=20);
        }
    }
    if(condenser_mount) hull(){
        // At the bottom, connect to the top of the housing and the motor lugs
        top_of_z_axis_casing(params);
        // The top is a flat shape that the illumination arm screws onto.
        each_illumination_corner(params) mirror([0,0,1]) cylinder(r=5,h=7);
    }

}

module z_axis_casing_cutouts(params){
    // The Z axis casing is a solid shape, we need to cut out clearance for the moving bits
    // This module contains all the bits we need to cut out.
    z_axis_clearance(params);
    objective_mounting_screw_access(params);
    z_actuator_cutout(params);
    z_motor_clearance(params);
    reflect([1,0,0]) translate(right_illumination_screw_pos(params)){
        rotate(-20) translate([0,0,-9]) m3_nut_trap_with_shaft(0,0);
    }
}

////////////// These modules define the actuator column and housing (where the screw/nut/band go)

module z_actuator_column(params, ties_only=false){
    ties = key_lookup("print_ties", params);
    actuator_h = key_lookup("actuator_h", params);
    tilt = z_actuator_tilt(params);
    translate([0,z_nut_y(params),0]){
        if (! ties_only){
                actuator_column(actuator_h, tilt=tilt, join_to_casing=ties);
        }
        else{
            actuator_ties(tilt);
        }
    }
}

module z_actuator_housing(params, motor_lugs=motor_lugs){
    // This houses the actuator column and provides screw seat/motor lugs
    h = key_lookup("actuator_h", params);
    translate([0,z_nut_y(params),0]){
        screw_seat(h,
                   tilt=z_actuator_tilt(params),
                   travel=z_actuator_travel(params),
                   motor_lugs=motor_lugs,
                   lug_angle=180);
    }
}

module z_actuator_cutout(params){
    // This chops out a void for the actuator column
    translate([0,z_nut_y(params),0]){
        screw_seat_outline(h=999,
                           adjustment=-tiny(),
                           center=true,
                           tilt=z_actuator_tilt(params));
    }
}


module z_actuator_assembly(params){
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
