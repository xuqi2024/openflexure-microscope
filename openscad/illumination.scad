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


module each_illumination_dovetail_screw(middle=true){
    // A transform to repeat objects at each mounting point
    for(p=illumination_dovetail_screws) if(p.x!=0 || middle) translate(p) children();
}
module right_illumination_dovetail_screw(){
    // A transform to position objects at the x>0 mounting point
    for(p=illumination_dovetail_screws) if(p.x>0) translate(p) children();
}

module middle_illumination_dovetail_screw(){
    for(p=illumination_dovetail_screws) if(p.x==0) translate(p) children();
}

module cyl_slot(r=1, h=1, dy=2, center=false){
    hull() repeat([0,dy,0],2,center=true) cylinder(r=r, h=h, center=center);
}

/* THE ILLUMINATION DOVETAIL */
//Note that this is not built from here. it is built in illumination_dovetail.scad

module illumination_dovetail(){
    // The dovetail on which we mount the condenser for the illumination
    bottom_z = illumination_dovetail_screws[0].z; // z position where we mount it
    h = 50;
    smooth_h = 15;
    dt_z = leg_height + 12; // z position and height of the dovetail
    dt_h = h + bottom_z - dt_z;

    //top and bottom of y position of the sloped back
    bot_y = illumination_dovetail_screws[0].y+4+1;
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
                each_illumination_dovetail_screw(middle=false) cyl_slot(r=4, h=3+tiny(), dy=3);
                middle_illumination_dovetail_screw() scale([1,0.5,1]) cylinder(r=4, h=tiny());
            }
            translate([-front_dovetail_w/2,front_dovetail_y+2,dt_z]) cube([front_dovetail_w, 10-2, dt_h]);
        }

        // slots for the mounting screws (to allow adjustment of position)
        each_illumination_dovetail_screw(middle=false) cyl_slot(r=3/2*1.33, h=999, dy=3, center=true);
        each_illumination_dovetail_screw(middle=false) translate([0,0,3]) cyl_slot(r=6, h=999, dy=3);

        // clearance for the motor
        translate([0,-2,0]) z_motor_clearance();
    }
}


/*   THE CONDENSER **/
//Note that this condenser is rotated, cut, and then printed in condenser.scad

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

module tall_condenser_new(bottom=true){

    // mount for the dovetail clip
    translate([-dt_clip.x/2, dovetail_end_y, 0])
        cube([dt_clip.x, 4, dt_clip.z]);
    // the dovetail clip
    translate([0,front_dovetail_y, 0])
        mirror([0,1,0])
            dovetail_clip(dt_clip, slope_front=2, solid_bottom=bottom ? 0.2 : 0);

    // the lens holder
    translate([0, 0, lens_assembly_z]) {
        difference() {
            h = pedestal_h+lens_t+1.5;
            union() {
                trylinder_gripper(inner_r=lens_r, grip_h=pedestal_h + lens_t/3, h=h, base_r=base_r, flare=0.5);
                // pedestal to raise the lens up within the gripper
                cylinder(r=aperture_r+0.8, h=pedestal_h);
            }
            // hole for the beam passing through the lens
            translate([0, 0, -tiny()])
                cylinder(r=aperture_r, h=h+tiny());
        }
    }

    bottom_height = 10; // the bottom is an extra bit that is sliced off when the condenser is rotated and cut before printing
    led_countersink = 1;// the led brim rests against the countersink
    led_height = 8;     // how much space is reserved for the body of the led
    difference() {
        hull() reflect([1, 0, 0]) {
            translate([0, 0, -bottom_height])
                cylinder(r=base_r, h=lens_assembly_z+bottom_height+tiny());
            translate([-dt_clip.x/2, dovetail_end_y, 0])
                cube([dt_clip.x, 2, lens_assembly_z]);
        }

        lighttrap_offset = led_height+led_countersink;
        translate([0, 0, lighttrap_offset])
            lighttrap_cylinder(r1=led_r+1.5, r2=aperture_r, h=lens_assembly_z-lighttrap_offset+tiny());

        // pressfit hole for the LED
        deformable_hole_trylinder(led_r, led_r+0.7, h=2*bottom_height+tiny(), center=true);

        // cutout to allow the led to be pushed down to the pressfit hole
        translate([0, 0, led_countersink-tiny()])
            cylinder(r1=led_r+1, r2=led_r, h=2);
        translate([0, 0, -led_countersink])
            cylinder(r=led_r+1, h=2*led_countersink+tiny());
     }
}

