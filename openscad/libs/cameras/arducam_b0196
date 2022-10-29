/******************************************************************
*                                                                 *
* OpenFlexure Microscope: Arducam B0196 screw-on-from-bottm mount *
*         Sony IMX219 sensor, USB 'UVC' compliant                 *
*                                                                 *
* This is part of the OpenFlexure microscope, an open-source      *
* microscope and 3-axis translation stage.  It gets really good   *
* precision over a ~10mm range, by using plastic flexure          *
* mechanisms.                                                     *
*                                                                 *
* This file defines a camera mount (together with functions that  *
* return the mount height and sensor position) for the Logitech   *
* C270 webcam.                                                    *
*                                                                 *
*                                                                 *
* (c) Richard Bowman, January 2016                                *
* Released under the CERN Open Hardware License                   *
*                                                                 *
******************************************************************/


use <../utilities.scad>
use <../libdict.scad>
use <./logitech_c270.scad>

$fn=48;

function arducam_b0196_camera_dict() = [["mount_height", 4.5],
                               ["sensor_height", 0.2]];//Height of the sensor above the PCB

function arducam_b0196_camera_bottom_z() = -key_lookup("mount_height", arducam_b0196_camera_dict());

function arducam_b0196_camera_hole_spacing() = 28/2;


module b0196(beam_r=5, beam_h=6){
    //cut-out to fit Arducam B0196 webcam
    //optical axis at (0,0)
    //top of PCB at (0,0,0)
    mounting_hole_xy = arducam_b0196_camera_hole_spacing();
    mirror([0,0,1]){ //parts cut out of the mount are z<0
        //beam clearance
        hull(){
            cube([8,8,6],center=true);
            translate_z(-beam_h){
                cylinder(r=beam_r,h=2*tiny(),center=true);
            }
        }

        //mounting holes
        reflect_x(){
            translate_x(mounting_hole_xy){
                mounting_hole();
            }
        }

        //clearance for PCB
        hull(){
            translate([-10/2,-13.5,0]){
                cube([10,tiny(),8]);
                }
            translate([-21.5/2,-4,0]){
                cube([21.5,41,8]);
                }
            translate([-10/2,45,0]){
                cube([10,tiny(),8]);
                }
        }
    }
}

module arducam_b0196_camera_mount(){
    // A mount for the Arducam B0196 USB camera
    // This should finish at z=0+tiny(), with a surface that can be
    // hull-ed onto the lens assembly.
    h = 58;
    w = 23;

    mount_height = key_lookup("mount_height", arducam_b0196_camera_dict());
    rotate(-45){
        difference(){
            translate([-w/2, -13, -mount_height]){
                cube([w, h, mount_height]);
            }
            translate_z(-mount_height){
                b0196();
            }
        }
    }
}

// this is just the picamera counterbore for now
module b0196_counterbore(){
    translate_z(arducam_b0196_camera_bottom_z()-1){
        b0196_camera_bottom_mounting_posts(height=9, radius=1.25, cutouts=false);
    }
    translate_z(arducam_b0196_camera_bottom_z()+1){
        b0196_camera_bottom_mounting_posts(height=9, radius=2.8, cutouts=false);
    }
}

module b0196_camera_bottom_mounting_posts(height=-1, radius=-1, outers=true, cutouts=true){
    // posts to mount to pi camera from below
    r = radius > 0 ? radius : 2;
    h = height > 0 ? height : 4;
    screw_xy = arducam_b0196_camera_hole_spacing();
    rotate(-45){
        reflect_x(){
            reflect_y(){
                translate([screw_xy, screw_xy, 0]){
                    difference(){
                        if(outers){
                            cylinder(r=r, h=h, $fn=12);
                        }
                        if(cutouts){
                            translate_z(h-6+tiny()){
                                no2_selftap_hole(h=6);
                            }
                        }
                    }
                }
            }
        }
    }
}

