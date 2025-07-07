/******************************************************************
*                                                                 *
* OpenFlexure Dissection Microscope: Microscope body              *
*                                                                 *
* This is the chassis of the OpenFlexure microscope, an open      *
* microscope and 3-axis translation stage.  It gets really good   *
* precision over a ~10mm range, by using plastic flexure          *
* mechanisms.                                                     *
*                                                                 *
* (c) Richard Bowman, January 2016                                *
* Released under the CERN Open Hardware License                   *
*                                                                 *
******************************************************************/

use <./utilities.scad>;
use <./dovetail.scad>;
use <./cameras/picamera_2.scad>;
include <./microscope_parameters.scad>;

front_dovetail_y = 35; // position of the main dovetail
front_dovetail_w = 30; // width of the main dovetail

camera_pcb = [25, 25];
wall_t = 2;
w = camera_pcb[0] + 1 + 4;
starty = -camera_pcb[1]/2-2.4; //edge of the PCB
base_h = 5; //thickness of the camera mount plate (lens pokes through this)
dt_clip = [front_dovetail_w, 16, 10]; //size of the dovetail clip
arm_end_y = front_dovetail_y-dt_clip[1]-4;

// parameters of the lens
pedestal_h = 3 + base_h;
lens_r = 13/2; // for flanged plastic condenser
//lens_r = 16/2; // for 16mm plastic condenser
aperture_r = lens_r-1.1;
lens_t = 1;
base_r = lens_r+2;

difference(){
    union(){
        // plate that the camera sits on
        hull(){
            cylinder(r=base_r, h=base_h, $fn=32);
            translate([-base_r-0.5-wall_t,0,0]) cube([2*(base_r+0.5+wall_t),wall_t,base_h]);
            translate([-dt_clip[0]/2, arm_end_y,0]) cube([dt_clip[0], wall_t, base_h]);
        }
        
        // walls either side for stiffness
        reflect([1,0,0]) sequential_hull(){
            translate([-base_r-0.5-wall_t,0,0])  cube([wall_t, wall_t, base_h]);
            translate([-dt_clip[0]/2, arm_end_y,0]) cube([wall_t, wall_t, dt_clip[2]]);
        }
        
        
        // mount for the dovetail clip
        translate([-dt_clip[0]/2,arm_end_y,0]) cube([dt_clip[0], 4, dt_clip[2]]);
        
        // the dovetail clip
        translate([0,front_dovetail_y, 0]) mirror([0,1,0]) dovetail_clip(dt_clip, slope_front=2, solid_bottom=0.2);
        
        // the lens holder
        trylinder_gripper(inner_r=lens_r, grip_h=pedestal_h + lens_t/3,h=pedestal_h+lens_t+1.5, base_r=base_r, flare=0.5);
        // pedestal to raise the lens up within the gripper
        cylinder(r=aperture_r+0.8,h=pedestal_h);
    }
    
    // hole for the beam passing through the lens
    cylinder(r=aperture_r,h=999,center=true);
}