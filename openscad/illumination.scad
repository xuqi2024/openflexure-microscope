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
front_dovetail_y = 35; // position of the main dovetail
front_dovetail_w = 30; // width of the main dovetail

function illumination_dovetail_height() = leg_height-2;
function right_illumination_screw_pos() = [20, z_nut_y, illumination_dovetail_height()];
function left_illumination_screw_pos() = [-20, z_nut_y, illumination_dovetail_height()];
function illumination_back_corner_pos() = [0, (leg_r + leg_outer_w)/sqrt(2) + 4, illumination_dovetail_height()];

module each_illumination_screw(middle=true){
    // A transform to repeat objects at each screw hole
    screws = [right_illumination_screw_pos(), left_illumination_screw_pos()];
    for(pos=screws){
        translate(pos){
            children();
        }
    }
}

module each_illumination_corner(middle=true){
    // A transform to repeat objects at each corner of the illumination mount
    corners = [right_illumination_screw_pos(), left_illumination_screw_pos(), illumination_back_corner_pos()];
    for(pos=corner){
        translate(pos){
            children();
        }
    }
}

module cyl_slot(r=1, h=1, dy=2, center=false){
    hull() repeat([0,dy,0],2,center=true) cylinder(r=r, h=h, center=center);
}

/* THE ILLUMINATION DOVETAIL */
//Note that this is not built from here. it is built in illumination_dovetail.scad

module illumination_dovetail(){
    // The dovetail on which we mount the condenser for the illumination
    bottom_z = illumination_dovetail_height(); // z position where we mount it
    h = 50;
    smooth_h = 15;
    dt_z = leg_height + 12; // z position and height of the dovetail
    dt_h = h + bottom_z - dt_z;

    //top and bottom of y position of the sloped back
    bot_y = right_illumination_screw_pos().y+4+1;
    top_y = front_dovetail_y+10;
    back_angle = atan((top_y-bot_y)/(h-3));
    logo_z = bottom_z+3+h/2;
    logo_y = (top_y+bot_y)/2;

    translate([-11,logo_y,logo_z])rotate([90-back_angle,0,0])openflexure_emblem(scale_factor=.1);
    translate([0,front_dovetail_y,dt_z]) mirror([0,1,0]) dovetail_m([front_dovetail_w, 10, h-smooth_h]);

    difference(){
        sequential_hull(){
            translate([-front_dovetail_w/2,front_dovetail_y-2,dt_z]) cube([front_dovetail_w, 15+2, 1]);
            hull(){
                each_illumination_screw() cyl_slot(r=4, h=3+tiny(), dy=3);
                translate(illumination_back_corner_pos())scale([1,0.5,1]) cylinder(r=4, h=tiny());
            }
            translate([-front_dovetail_w/2,front_dovetail_y+2,dt_z]) cube([front_dovetail_w, 10-2, dt_h]);
        }

        // slots for the mounting screws (to allow adjustment of position)
        each_illumination_screw() cyl_slot(r=3/2*1.33, h=999, dy=3, center=true);
        each_illumination_screw() translate([0,0,3]) cyl_slot(r=6, h=999, dy=3);

        // clearance for the motor
        translate([0,-2,0]) z_motor_clearance();
    }
}

//TODO proect these somehow.
/*   THE CONDENSER **/


// parameters of the lens
pedestal_h = 5.5;
lens_r = 13/2; // for flanged plastic condenser
//lens_r = 16/2; // for 16mm plastic condenser
aperture_r = lens_r-1.1;
lens_t = 1;
base_r = lens_r+2;

lens_assembly_z = 30;
dt_clip = [front_dovetail_w, 16, lens_assembly_z]; //size of the dovetail clip
dovetail_end_y = front_dovetail_y-dt_clip.y-4;


module condenser_lens_gripper(){
    // the lens holder on the end or the condenser
    h = pedestal_h+lens_t+1.5;
    translate([0, 0, lens_assembly_z]) {
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
}

module condenser_cutout(bottom_height=10){
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

module tall_condenser(bottom=true){
    // Note that this is the shape before it is is rotated, and cut for printing.
    // This module is useful because the optical path is vertical
    // In this module the lens is at the top of the structure.
    // The the back of the LED hole is at z=0

     // the bottom is an extra bit that is sliced off when the condenser is rotated and cut before printing
    bottom_height = 10; 

    // the dovetail clip
    translate([0,front_dovetail_y, 0]){
        mirror([0,1,0]){
            //Note: the solid bottom is a roof not a bottom when the STL is in the assembly orientation
            dovetail_clip(dt_clip, slope_front=2, solid_bottom=bottom ? 0.2 : 0);
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

        condenser_cutout(bottom_height=bottom_height);
     }
     //finally add the lens gripper
     condenser_lens_gripper();
}

module condenser(){
    //This is the condenser that is printed.
    difference(){
        rotate([-15,0,0]){
            tall_condenser();
        }
        mirror([0,0,1]){
            cylinder(r=999,h=999,$fn=4);
        }
    }
}

