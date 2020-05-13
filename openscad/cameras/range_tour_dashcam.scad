/******************************************************************
*                                                                 *
* OpenFlexure Microscope: USB camera push-fit mount               *
*                                                                 *
* This is part of the OpenFlexure microscope, an open-source      *
* microscope and 3-axis translation stage.  It gets really good   *
* precision over a ~10mm range, by using plastic flexure          *
* mechanisms.                                                     *
*                                                                 *
* This file defines one useful function, usbcam_push_fit().  It's *
* designed to be subtracted from a solid block, with the bottom   *
* of the block at z=0.  It grips the plastic camera housing with  *
* a "trylinder" gripper, holding it in securely.  It might be     *
* that you need a cover or something to secure the camera fully.  *
*                                                                 *
* (c) Richard Bowman, January 2016                                *
* Released under the CERN Open Hardware License                   *
*                                                                 *
******************************************************************/


use <../utilities.scad>;
d = 0.05; // a small distance, to get rid of ambiguities

function range_tour_camera_mount_height() = 4.5;
bottom = range_tour_camera_mount_height() * -1;

function range_tour_camera_sensor_height() = 2; //Height of the sensor above the PCB


module range_tour_led(){
    // components on the PCB to cut out - may be vestigial (left over from pi camera)
    translate([5,10]) square([3.5,2]);
    translate([6,8]) square([3.5,2]);
}
    
module range_tour_cutout( beam_length=15){
    // This module is designed to be subtracted from the bottom of a shape.
    // The z=0 plane should be the print bed.
    // It includes cut-outs for the components on the PCB, so the board sits flush with the bottom of the mount.
    cw = 8.5 + 1.0 + 6; //size of camera box sides (NB deliberately loose fitting)
    ch=2.9; //height of camera box (including foam support)
    camera = [cw,cw,ch]; //size of camera box
    hole_r = 4.3; //size of camera aperture
	union(){
        sequential_hull(){
            //cut-out for camera
            translate([0,0,ch/2]) cube(camera,center=true);//cut-out for sensor
            cylinder(r=hole_r, h=2*range_tour_camera_mount_height(), center=true);
        }
            
        //clearance for the ribbon cable at top of camera
        fh=2.5; // the height of the flex
        dz = range_tour_camera_mount_height()-fh-0.75; // extra height above the flex for the sloping "roof"
        //clearance for the LED/resistor (I am not sure this is needed any more)
        hull(){
            translate([0,0,-d]) linear_extrude(fh) range_tour_led();
            translate([0,0,-d]) linear_extrude(fh+dz) offset(-dz) range_tour_led();
        }
        
        //beam clearance
        cylinder(r=hole_r, h=beam_length);
        
        // screw holes for mounting (should match the screw holes in range_tour_bottom_mounting_posts)
        translate([9,-6,0]) cylinder(r1=3.1, r2=1.1, h=6, $fn=3, center=true);
        translate([-9.5,5.5,0]) cylinder(r1=3.1, r2=1.1, h=6, $fn=3, center=true);   
	}
}
//range_tour_cutout();

module range_tour_board(h=d){
    // a rounded rectangle with the dimensions of the picamera board v2
    // centred on the origin
    b = 24;
    w = 25;
    roc = 2;
    linear_extrude(h) hull(){
        reflect([1,0]) reflect([0,1]) translate([w/2-roc, b/2-roc]) circle(r=roc,$fn=12);
    }
}

module range_tour_camera_mount(counterbore=false){
    // A mount for the pi camera v2
    // This should finish at z=0+d, with a surface that can be
    // hull-ed onto the lens assembly.
    b = 24;
    w = 25;
    difference(){
        rotate(45) translate([0,2.4,0]) sequential_hull(){
            translate([0,0,bottom]) range_tour_board(h=d);
            translate([0,0,-1]) range_tour_board(h=d);
            translate([0,0,0]) cube([w-(-1.5-bottom)*2,b,d],center=true);
        }
        rotate(45) translate([0,0,bottom]) range_tour_cutout();
        if(counterbore){
            translate([0,0,bottom-1]) range_tour_bottom_mounting_posts(height=999, radius=1, cutouts=false);
            translate([0,0,bottom+1])  range_tour_bottom_mounting_posts(height=999, radius=2.7, cutouts=false);
        }
    }
}

module range_tour_bottom_mounting_posts(height=-1, radius=-1, outers=true, cutouts=true){
    // posts to mount to pi camera from below
    r = radius > 0 ? radius : 2;
    h = height > 0 ? height : 4;
    rotate(45)
    for(pos=[[19/2, 10/2, 0], [-19/2, -10/2, 0]]) translate(pos) difference(){
        if(outers) cylinder(r=r, h=h, $fn=12);
        if(cutouts) intersection(){
            cylinder(h=13, d=2*1.7, center=true, $fn=3);
            rotate(60) cylinder(h=999, d=2*1.7*1.4, center=true, $fn=3);
        }
    }
}

//range_tour_bottom_mounting_posts();