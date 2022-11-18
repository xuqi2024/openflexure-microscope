/******************************************************************
*                                                                 *
* OpenFlexure Microscope: Logitech c270 screw-on-from-bottm mount *
*                                                                 *
* This is part of the OpenFlexure microscope, an open-source      *
* microscope and 3-axis translation stage.  It gets really good   *
* precision over a ~10mm range, by using plastic flexure          *
* mechanisms.                                                     *
*                                                                 *
* This file defines a camera mount (together with functions that  *
* return the mount height and sensor position) for the Logitech   *
* c270 webcam.                                                    *
*                                                                 *
*                                                                 *
* (c) Richard Bowman, January 2016                                *
* Released under the CERN Open Hardware License                   *
*                                                                 *
******************************************************************/


use <../utilities.scad>
use <../libdict.scad>

$fn=48;

function c270_camera_dict() = [["mount_height", 4.5],
                               ["sensor_height", 0.2]];//Height of the sensor above the PCB

function c270_camera_bottom_z() = -key_lookup("mount_height", c270_camera_dict());

// spacing of the lens mount holes at the sensor
function c270_camera_hole_spacing() = 8.25;
// position of camera board hole near the sensor
function c270_near_third_hole_pos() = [5,-9.5,0];
// position of camera board hole at the cable end 
function c270_far_third_hole_pos() = [-6,42.3,0];

// Countersunk hole. countersink from the top
module mounting_hole(){
    translate_z(-5){
        cylinder(r=0.8*1.2,h=999,$fn=12);
    }
    translate_z(-0.5){
        cylinder(r1=0.8*1.2,h=1,r2=0.8*1.2+1,$fn=12);
    }
}

module c270(beam_r=4.3, beam_h=4.5){
    //cut-out to fit logitech c270 webcam
    //optical axis at (0,0)
    //top of PCB at (0,0,0)
    
    mirror([0,0,1]){ //parts cut out of the mount are z<0
        //beam clearance
        hull(){
            cube([8,8,6],center=true);
            translate_z(-beam_h){
                cylinder(r=beam_r,h=2*tiny(),center=true);
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

        difference(){
            union(){
                // component clearance, cable end
                hull(){
                    translate([0,22.5,0+4]){
                        cube([20.5,28,15],center=true);
                    }
                    translate([0,34,0+4]){
                        cube([10,9.5*2,15],center=true);
                    }
                }
                // component clearance, sensor end
                hull(){
                    translate([0,10,0+4]){
                        cube([20.5,28,15],center=true);
                    }
                    translate([0,-4,0+4]){
                        cube([9,9.5*2,15],center=true);
                    }
                }
            }
            union(){
                // add cube at third mounting hole, cable end
                translate([-3.5,36,-10]){
                    mirror([1,0,0]){
                        cube([10,10,10]);
                    }
                }
                // add a pillar at the 'near third hole' place
                translate(c270_near_third_hole_pos()){
                    translate_z(-50){
                        cylinder(r=3, h=99, center = false);
                    }
                }
                // add mount around the camera sensor,
                // the same shape as the supplied lens mount
                cube([14,14,99], center = true);
                cube([21,5,99], center = true);
            }
        }


        //exit for cable
        translate([4,20,0]){
            rotate_x(-90){
                cylinder(r=3,h=99);
            }
        }
    }
}

//c270_camera_mount();
c270();

module c270_camera_mount(screwhole=true, counterbore=false){
    // A mount for the Logitech c270 webcam
    // This should finish at z=0+tiny(), with a surface that can be
    // hull-ed onto the lens assembly.
    h = 58;
    w = 23.5;
    mounting_hole_x = c270_camera_hole_spacing();

    mount_height = key_lookup("mount_height", c270_camera_dict());
    rotate(-45){
        difference(){
            translate([-w/2, -13, -mount_height]){
                cube([w, h, mount_height]);
            }
            translate_z(-mount_height){
                c270();
                if(screwhole){
                    //mounting holes
                    reflect_x(){
                        translate_x(mounting_hole_x){
                            rotate_x(180){
                                mounting_hole();
                            }
                        }
                    }
                    // third mounting hole, cable end
                    translate(c270_far_third_hole_pos()){
                        rotate_x(180){
                            mounting_hole();
                        }
                    }
                }
            }
        }
    }
}

module c270_counterbore(){
    translate_z(c270_camera_bottom_z()-1){
        c270_camera_bottom_mounting_posts(height=9, radius=1.1, cutouts=false);
    }
    translate_z(c270_camera_bottom_z()+1){
        c270_camera_bottom_mounting_posts(height=9, radius=2.1, cutouts=false);
    }
}

module c270_camera_bottom_mounting_posts(height=-1, radius=-1, outers=true, cutouts=true){
    // posts to mount to Logitech c270 camera from below
    r = radius > 0 ? radius : 2.5;
    h = height > 0 ? height : 4;
    screw_x = c270_camera_hole_spacing();
    // Third hole position at the far end of the board [-6,42.3,0] is too far away and makes the camera platform too big
    //c270_third_hole_pos = [5,-9.5,0];
    rotate_z(-45){
        reflect_x(){
            translate([screw_x, 0, 0]){
                difference(){
                    if(outers){
                        cylinder(r=r, h=h, $fn=12);
                    }
                    if(cutouts){
                        translate_z(h-6+tiny()){
                            // The C270 board holes are smaller than #2 screws
                            no1_selftap_hole(h=6);
                        }
                    }
                }
            }
            
        }
        translate(c270_near_third_hole_pos()){
                difference(){
                    if(outers){
                        cylinder(r=r, h=h, $fn=12);
                    }
                    if(cutouts){
                        translate_z(h-6+tiny()){
                            // The C270 board holes are smaller than #2 screws
                            no1_selftap_hole(h=6);
                        }
                    }
                }
        }
    }
}
