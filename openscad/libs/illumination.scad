/******************************************************************
*                                                                 *
* OpenFlexure Microscope: Illumination                            *
*                                                                 *
* The illumination module includes the condenser lens mounts and  *
* the dovetail that it attaches to.                               *
*                                                                 *
* (c) Richard Bowman, April 2018                                  *
* Released under the CERN Open Hardware License                   *
*                                                                 *
******************************************************************/


// Note that no geometry is output in this file. The condenser and the illumination
// dovetail are created in condenser.scad and illumination_dovetail.scad

use <./utilities.scad>
use <./logo.scad>
use <./microscope_parameters.scad>
use <./locking_dovetail.scad>
use <./z_axis.scad>
use <./libdict.scad>

function illumination_dovetail_w() = 30; // width of the dovetail
function illumination_dovetail_y() = 35; // position of the mating surface
function illumination_dovetail_z(params) = leg_height(params)-2;
function illumination_dovetail_blockdepth() = 12; // depth of the block containing the dovetail

// Set the dovetail parameters dictionary based on the above settings:
function illumination_dt_params() = dovetail_params(
    width = illumination_dovetail_w(),
    block_depth = illumination_dovetail_blockdepth(),
    height = 99
);

// Note: Front is the side towards the motors, Back is the side towards the stage
function illumination_back_corner_y(params) = (key_lookup("leg_r", params)+ leg_outer_w(params))/sqrt(2) + 4;
function right_illumination_screw_pos(params) = [20, z_nut_y(params), illumination_dovetail_z(params)];
function left_illumination_screw_pos(params) = vector_mirror_x(right_illumination_screw_pos(params));
function illumination_back_corner_pos(params) = [0, illumination_back_corner_y(params), illumination_dovetail_z(params)];
// Defining the positions of the back corners of the rectangle for the top of the spacer
// The triangular top of the spacer fits onto the triangular face of the z-axis in the main body. 
// The rectangular top of the spacer is atached to the rectangular face of the separate z-actuator, a rectangular face is used here for stability.
function right_back_sq_illum_corner_pos(params) = [20, illumination_back_corner_y(params), illumination_dovetail_z(params)];
function left_back_sq_illum_corner_pos(params) = vector_mirror_x(right_back_sq_illum_corner_pos(params));

function right_illumination_screw_rotation() = -20;
function left_illumination_screw_rotation() = -right_illumination_screw_rotation();

module each_front_illumination_screw(params){
    // A transform to repeat objects at each screw hole
    screws = [right_illumination_screw_pos(params), left_illumination_screw_pos(params)];
    for(pos=screws){
        translate(pos){
            children();
        }
    }
}

module each_illumination_corner(params, rectangular=false){
    // A transform to repeat objects at each corner of the illumination mount for a triangular top
    tri_corners = [right_illumination_screw_pos(params),
                   left_illumination_screw_pos(params),
                   illumination_back_corner_pos(params)];
    rect_corners = [right_illumination_screw_pos(params),
                    left_illumination_screw_pos(params),
                    right_back_sq_illum_corner_pos(params),
                    left_back_sq_illum_corner_pos(params)];
    corners = rectangular ? rect_corners : tri_corners;
    for(pos=corners){
        translate(pos){
            children();
        }
    }
}

/* THE ILLUMINATION DOVETAIL */
//Note that this is not built from here. it is built in illumination_dovetail.scad

function illumination_dovetail_lug_height() = 3;

module illumination_dovetail_branding(params, h, bottom_z){
    // The open flexure logo for the back of the illumination fovetail

    //lug height
    lug_h = illumination_dovetail_lug_height();
    //height of the slobed back
    slope_h = h-lug_h ;
    //top and bottom of y position of the sloped back
    bot_y = right_illumination_screw_pos(params).y+5;
    top_y = illumination_dovetail_y()+illumination_dovetail_blockdepth();
    back_angle = atan((top_y-bot_y)/slope_h);
    logo_z = bottom_z+lug_h +slope_h/2;
    logo_y = (top_y+bot_y)/2+.5;

    translate([-11,logo_y,logo_z]){
        rotate_x(90-back_angle){
            openflexure_emblem(scale_factor=.1);
        }
    }
}

module illumination_dovetail_structure(params, dt_z, dt_h){
    //this is the outer structure that forms the illumination mount.
    dt_y = illumination_dovetail_y();

    hull(){
        translate([0, dt_y, dt_z]){
            mirror([0,1,0]){
                dovetail_block(illumination_dt_params(), height=dt_h);
            }
        }

        //trilobular structure with "corners" at the 2 screws and a back corner position
        hull(){
            each_front_illumination_screw(params){
                cyl_slot(r=4, h=3+tiny(), dy=3);
            }
            translate(illumination_back_corner_pos(params)){
                scale([1,0.5,1]){
                    cylinder(r=4, h=tiny());
                }
            }
        }
    }
}

module illumination_dovetail(params, h=50){
    // The dovetail on which we mount the condenser for the illumination
    // This is built in place in the microscope coordinates.

    // z position where we mount it
    bottom_z = illumination_dovetail_z(params);
    dt_y = illumination_dovetail_y();
    // Where the dovetail itself starts (relative to the bottom of the structure)
    start_z = 14;
    // z position of the dovetail, in microscope referecne frame
    dt_z = bottom_z + start_z;
    //height of the dovetail
    dt_h = h - start_z;

    lug_h = illumination_dovetail_lug_height();

    difference(){
        illumination_dovetail_structure(params, dt_z, dt_h);
        // slots for the mounting screws (to allow adjustment of position)
        each_front_illumination_screw(params){
            // wider than normal M3 clearance hole to ease adjustment of illumination
            m3_clear_loose = 3/2*1.33;
            cyl_slot(r=m3_clear_loose, h=999, dy=3, center=true);
            translate_z(lug_h){
                cyl_slot(r=6, h=999, dy=3);
            }
        }

        // cutout to make the dovetail
        translate([0,dt_y,dt_z]){
            mirror([0,1,0]){
                dovetail_f_cutout(illumination_dt_params(), height=99);
            }
        }
        // clearance for the motor
        translate_y(-2){
            z_motor_clearance(params);
        }
    }
    illumination_dovetail_branding(params, h, bottom_z);
}

/*
* This is the difference between the lens radius and the aperture radius
* used in both condenser_lens_gripper and condenser_cutout
*/
function condenser_aperture_difference() = 1.1;

module condenser_lens_gripper(lens_r, lens_t, base_r){
    // the lens holder on the end or the condenser
    pedestal_h = 5.5;
    h = pedestal_h+lens_t+1.5;
    aperture_r = lens_r-condenser_aperture_difference();

    difference() {
        union() {
            trylinder_gripper(inner_r=lens_r,
                                grip_h=pedestal_h + lens_t/3,
                                h=h,
                                base_r=base_r,
                                flare=0.5);
            // pedestal to raise the lens up within the gripper
            cylinder(r=aperture_r+0.8, h=pedestal_h);
        }
        // hole through pedestal for the beam passing through the lens
        translate_z(-tiny()){
            cylinder(r=aperture_r, h=h);
        }
    }
}

module condenser_cutout(led_r, lens_r, lens_assembly_z, bottom_height=10){
    // This is the cutout for the beam to pass through the condenser. It contains a light trap
    // and a pressfit hole for the LED. In thr reference frame module the LED would be pointing upwards.
    // Not that the LED countersink is at z=0 because the `tall_condenser` module that uses this
    // is cut to make the condenser.
    // The LED gripper hole continues bellow z=0 because the final plane of the top of the condenser is
    // angled, and so that the tall condenser has a hole all the way through for debugging.

    // the led brim rests against the countersink
    led_countersink = 1;
    // how much space is reserved for the body of the led
    led_height = 8;
    lighttrap_offset = led_height+led_countersink;
    lighttrap_h = lens_assembly_z-lighttrap_offset+tiny();
    led_trilinder_h = bottom_height+lighttrap_offset+2*tiny();
    aperture_r = lens_r-condenser_aperture_difference();

    //Light trap to reduce stray reflectins
    translate_z(lighttrap_offset){
        lighttrap_cylinder(r1=led_r+1.5, r2=aperture_r, h=lighttrap_h);
    }

    // pressfit hole for the LED
    translate_z(-bottom_height-tiny()){
        deformable_hole_trylinder(led_r, led_r+0.7, h=led_trilinder_h);
    }

    // Then next two are a cutout to allow the led to be pushed down to the pressfit hole
    translate_z(led_countersink-tiny()){
        cylinder(r1=led_r+1, r2=led_r, h=2);
    }
    translate_z(-led_countersink){
        cylinder(r=led_r+1, h=2*led_countersink+tiny());
    }
}

module tall_condenser(led_r, lens_d, lens_t, lens_assembly_z, include_mounting=true){
    // Note that this is the shape before it is is rotated, and cut for printing.
    // This module is useful because the optical path is vertical
    // In this module the lens is at the top of the structure.
    // The the back of the LED hole is at z=0

    lens_r = lens_d/2;
    base_r = lens_r+2;
     // the bottom is an extra bit that is sliced off when the condenser is rotated and cut before printing
    bottom_height = 10;
    dt_block_depth = 16;
    dt_height = 20;
    dt_params = dovetail_params(
        width=illumination_dovetail_w(),
        height=dt_height,  // do we want to keep this so tall?  It would probably be fine if we made it shorter.
        block_depth = dt_block_depth,
        taper_block = true
    );

    // the dovetail clip
    if (include_mounting){
        translate_y(illumination_dovetail_y()){
            dovetail_clamp_m(dt_params);
        }
    }

    difference() {
        //this hull is the outer shape of the body of the condenser
        sequential_hull(){
            translate_z(lens_assembly_z){
                cylinder(r=base_r, h=tiny());
            }
            translate_z(-bottom_height){
                cylinder(r=base_r, h=dt_height + bottom_height);
            }
            if (include_mounting){
                translate_y(illumination_dovetail_y()){
                    linear_extrude(dt_height){
                        back_of_block_2d(dt_params);
                    }
                }
            }
        }

        condenser_cutout(led_r, lens_r, lens_assembly_z, bottom_height=bottom_height);
     }
     //finally add the lens gripper
     translate_z(lens_assembly_z){
        condenser_lens_gripper(lens_r, lens_t, base_r);
     }
}

//TODO the lens_assembly_z should be adjusted to a focal length parameter
module condenser(params, led_r=4.5/2, lens_d=13, lens_t=1, lens_assembly_z= 30, include_mounting=true){
    //This is the condenser that is printed.
    condenser_angle = key_lookup("condenser_angle", params);
    difference(){
        rotate_x(-condenser_angle){
            tall_condenser(led_r, lens_d, lens_t, lens_assembly_z, include_mounting=include_mounting);
        }
        mirror([0,0,1]){
            cylinder(r=999,h=999,$fn=4);
        }
    }
}

