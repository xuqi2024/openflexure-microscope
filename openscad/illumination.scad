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
include <./microscope_parameters.scad>
use <./dovetail.scad>
use <./z_axis.scad>
use <libs/libdict.scad>
front_dovetail_y = 35; // position of the main dovetail
front_dovetail_w = 30; // width of the main dovetail

function illumination_dovetail_z(params) = leg_height(params)-2;
function right_illumination_screw_pos(params) = [20, z_nut_y, illumination_dovetail_z(params)];
function left_illumination_screw_pos(params) = [-20, z_nut_y, illumination_dovetail_z(params)];
function illumination_back_corner_pos(params) = [0, (key_lookup("leg_r", params)+ leg_outer_w(params))/sqrt(2) + 4, illumination_dovetail_z(params)];

module each_illumination_screw(params){
    // A transform to repeat objects at each screw hole
    screws = [right_illumination_screw_pos(params), left_illumination_screw_pos(params)];
    for(pos=screws){
        translate(pos){
            children();
        }
    }
}

module each_illumination_corner(params){
    // A transform to repeat objects at each corner of the illumination mount
    corners = [right_illumination_screw_pos(params), left_illumination_screw_pos(params), illumination_back_corner_pos(params)];
    for(pos=corners){
        translate(pos){
            children();
        }
    }
}

/* THE ILLUMINATION DOVETAIL */
//Note that this is not built from here. it is built in illumination_dovetail.scad


module illumination_dovetail_branding(h, bottom_z){
    // The open flexure logo for the back of the illumination fovetail

    //lug height
    lug_h = 4+2*tiny();
    //height of the slobed back
    slope_h = h-lug_h ;
    //top and bottom of y position of the sloped back
    bot_y = right_illumination_screw_pos().y+5;
    top_y = front_dovetail_y+10;
    back_angle = atan((top_y-bot_y)/slope_h);
    logo_z = bottom_z+lug_h +slope_h/2;
    logo_y = (top_y+bot_y)/2+.5;

    translate([-11,logo_y,logo_z]){
        rotate([90-back_angle,0,0]){
            openflexure_emblem(scale_factor=.1);
        }
    }
}

module illumination_dovetail_structure(params, h, dt_z, dt_h){
    //this is the outer structure that forms the illumination mount.

    //nominal postion of the corner of the cubes that form this  structure
    cube_corner = [-front_dovetail_w/2, front_dovetail_y, dt_z];
    //distance cubes are moved forward and backward in y respectivly
    delta_y = 2;
    sequential_hull(){
        //Cube jsut below the actual dovetail
        translate(cube_corner - [0, delta_y, 0]){
            cube([front_dovetail_w, 15+delta_y, 1]);
        }
        //trulobular structure with "corners" at the 2 screws and a back corner position
        hull(){
            each_illumination_screw(params){
                cyl_slot(r=4, h=3+tiny(), dy=3);
            }
            translate(illumination_back_corner_pos(params)){
                scale([1,0.5,1]){
                    cylinder(r=4, h=tiny());
                }
            }
        }
        //cube behind dovetail
        translate(cube_corner + [0, delta_y, 0]){
            cube([front_dovetail_w, 10-delta_y, dt_h]);
        }
    }
}

module illumination_dovetail(params, h=50){
    // The dovetail on which we mount the condenser for the illumination
    // This is built in place in the microscope coordinates.

    // z position where we mount it
    bottom_z = illumination_dovetail_z(params);
    // Where the dovetail itself starts (relative to the bottom of the structure)
    start_z = 14;
    // z position of the dovetail, in microscope referecne frame
    dt_z = bottom_z + start_z;
    //height of the dovetail
    dt_h = h - start_z;

    translate([0,front_dovetail_y,dt_z]) mirror([0,1,0]) dovetail_m([front_dovetail_w, 10, dt_h]);
    difference(){
        illumination_dovetail_structure(params, h, dt_z, dt_h);
        // slots for the mounting screws (to allow adjustment of position)
        each_illumination_screw(params){
            // wider than normal M3 clearance hole to ease adjustment of illumination
            m3_clear_loose = 3/2*1.33;
            cyl_slot(r=m3_clear_loose, h=999, dy=3, center=true);
            translate([0,0,3]){
                cyl_slot(r=6, h=999, dy=3);
            }
        }
        // clearance for the motor
        translate([0,-2,0]) z_motor_clearance();
    }
    illumination_dovetail_branding(h, bottom_z);
}


// This is the difference between the lens radius and the aperture radius
// used in both condenser_lens_gripper and condenser_cutout
_aperture_difference = 1.1;

module condenser_lens_gripper(lens_r, lens_t, base_r){
    // the lens holder on the end or the condenser
    pedestal_h = 5.5;
    h = pedestal_h+lens_t+1.5;
    aperture_r = lens_r-_aperture_difference;

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
        translate([0, 0, -tiny()]){
            cylinder(r=aperture_r, h=h);
        }
    }
}

module condenser_cutout(lens_r, lens_assembly_z, bottom_height=10){
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
    aperture_r = lens_r-_aperture_difference;

    //Light trap to reduce stray reflectins
    translate([0, 0, lighttrap_offset]){
        lighttrap_cylinder(r1=led_r+1.5, r2=aperture_r, h=lighttrap_h);
    }

    // pressfit hole for the LED
    translate([0, 0, -bottom_height-tiny()]){
        deformable_hole_trylinder(led_r, led_r+0.7, h=led_trilinder_h);
    }

    // Then next two are a cutout to allow the led to be pushed down to the pressfit hole
    translate([0, 0, led_countersink-tiny()]){
        cylinder(r1=led_r+1, r2=led_r, h=2);
    }
    translate([0, 0, -led_countersink]){
        cylinder(r=led_r+1, h=2*led_countersink+tiny());
    }
}

module tall_condenser(lens_d, lens_t, lens_assembly_z){
    // Note that this is the shape before it is is rotated, and cut for printing.
    // This module is useful because the optical path is vertical
    // In this module the lens is at the top of the structure.
    // The the back of the LED hole is at z=0

    lens_r = lens_d/2;
    base_r = lens_r+2;
     // the bottom is an extra bit that is sliced off when the condenser is rotated and cut before printing
    bottom_height = 10;
    dt_clip = [front_dovetail_w, 16, lens_assembly_z]; //size of the dovetail clip
    dovetail_end_y = front_dovetail_y-dt_clip.y-4;

    // the dovetail clip
    translate([0,front_dovetail_y, 0]){
        mirror([0,1,0]){
            //Note: the solid bottom is a roof not a bottom when the STL is in the assembly orientation
            dovetail_clip(dt_clip, slope_front=2);
        }
    }

    // This cube suts between the body of the condernser and the dovetail clip
    translate([-dt_clip.x/2, dovetail_end_y, 0]){
        cube([dt_clip.x, 4, dt_clip.z]);
    }

    difference() {
        //this hull is the outer shape of the body of the condenser
        hull() reflect([1, 0, 0]) {
            translate([0, 0, -bottom_height])
                cylinder(r=base_r, h=lens_assembly_z+bottom_height+tiny());
            translate([-dt_clip.x/2, dovetail_end_y, 0])
                cube([dt_clip.x, 2, lens_assembly_z]);
        }

        condenser_cutout(lens_r, lens_assembly_z, bottom_height=bottom_height);
     }
     //finally add the lens gripper
     translate([0, 0, lens_assembly_z]){
        condenser_lens_gripper(lens_r, lens_t, base_r);
     }
}

//TODO the lens_assembly_z should be adjusted to a focal length parameter
module condenser(lens_d=13, lens_t=1, lens_assembly_z= 30){
    //This is the condenser that is printed.
    difference(){
        rotate([-15,0,0]){
            tall_condenser(lens_d, lens_t, lens_assembly_z);
        }
        mirror([0,0,1]){
            cylinder(r=999,h=999,$fn=4);
        }
    }
}

