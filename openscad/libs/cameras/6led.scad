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


use <../utilities.scad>
use <./m12.scad>


$fn=32;

//Same as the M12 camera
function 6led_camera_dict() = m12_camera_dict();


module 6led_camera_mount(){ //this is the same as the M12 mount
    m12_camera_mount();
}


module 6led_bottom_mounting_posts(height=-1, radius=-1, outers=true, cutouts=true){
    //holes are (28-2.25*2)=23.5mm apart in Y and (33-4.45*2)=24.1mm apart in X
    r = radius > 0 ? radius : 2;
    h = height > 0 ? height : 4;
    rotate(45){
        reflect_x(){
            reflect_y(){
                translate([24.1/2, 23.5/2, 0]){
                    difference(){
                        if(outers){
                            cylinder(r=r, h=h, $fn=12);
                        }
                        if(cutouts){
                            translate_z(-2){
                                rotate(75){
                                    trylinder_selftap(2, h=h+3);
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

