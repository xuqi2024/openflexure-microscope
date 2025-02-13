/******************************************************************
*                                                                 *
* OpenFlexure Microscope: Logitech C270 screw-on-from-bottm mount *
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


module c270_cutout(beam_r=4.3, beam_h=4.5){
    //cut-out to fit Logitech C270 webcam
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

        difference(){
            union(){
                // component clearance, cable end
                hull(){
                    translate([0,22.5,0+4]){
                        cube([19.5,28,15],center=true);
                    }
                    translate([0,34,0+4]){
                        cube([10,9.5*2,15],center=true);
                    }
                }
                // component clearance, sensor end
                hull(){
                    translate([0,10,0+4]){
                        cube([19.5,28,15],center=true);
                    }
                    translate([0,-4,0+4]){
                        cube([9,9.5*2,15],center=true);
                    }
                }
            }
            union(){
                // add cube at third mounting hole, cable end
                translate(c270_far_third_hole_pos()-[0,0,10]){
                    cylinder(d=5, h=10);
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
    }
}

function c270_dims() = [21, 58];
function c270_y_offset() = -13;
//extra room for cable
function c270_mount_y_excess() = 12;

function c270_backshell_screw_positions(flip_x=false) = let(
    h = c270_dims().y,
    w = c270_dims().x,
    y_offset = c270_y_offset(),
    y_excess = c270_mount_y_excess(),
    sign = flip_x ? 1 : -1
) [[sign*(-w/2+4), h+y_offset+y_excess-4, 3], [sign*(w-4), h+y_offset-4, 3]];

module c270_camera_mount(screwhole=true){
    // A mount for the Logitech C270 webcam
    // This should finish at z=0+tiny(), with a surface that can be
    // hull-ed onto the lens assembly.

    // camera dims
    h = c270_dims().y;
    w = c270_dims().x;
    //wider_ section around lens
    h_w = 26;
    w_w = 23.5;

    y_offset = c270_y_offset();
    //extra room for cable
    y_excess = c270_mount_y_excess();

    mounting_hole_x = c270_camera_hole_spacing();

    mount_height = key_lookup("mount_height", c270_camera_dict());
    rotate(-45){
        difference(){
            union(){
                translate([-w_w/2, y_offset, -mount_height]){
                    cube([w_w, h_w, mount_height]);
                }
                translate([-w/2, y_offset+y_excess, -mount_height]){
                    cube([w, h, mount_height-2*tiny()]);
                }
                translate([-w, y_offset+h-10, -mount_height]){
                    cube([w*1.5, y_excess+10, mount_height-2*tiny()]);
                }
            }
            translate_z(-mount_height){
                c270_cutout();
                if(screwhole){
                    // mounting holes
                    reflect_x(){
                        translate_x(mounting_hole_x){
                            no1_selftap_hole(h=6);
                            // chamfer in base to overcome overextrusion
                            translate_z(-0.5){
                                cylinder(r1=2,h=2,r2=0,$fn=12);
                            }
                        }
                    }
                    // third mounting hole, cable end
                    translate(c270_far_third_hole_pos()){
                        no1_selftap_hole(h=6);
                        // chamfer in base to overcome overextrusion
                        translate_z(-0.5){
                            cylinder(r1=2,h=2,r2=0,$fn=12);
                        }
                    }
                }
            }
            translate(c270_far_third_hole_pos()-[0,0,mount_height+1]){
                no1_selftap_hole(h=mount_height);
            }
            translate([-w, h+y_offset+y_excess/2, -mount_height]){
                c270_cable_exit();
            }
            translate(c270_backshell_screw_positions()[0]){
                translate_z(-mount_height-5.5){
                    no2_selftap_hole(h=6);
                }
            }
            translate(c270_backshell_screw_positions()[1]){
                translate_z(-mount_height-5.5){
                    no2_selftap_hole(h=6);
                }
            }
        }
    }
}

module c270_backshell(){
    height = 6;
    h = c270_dims().y;
    w = c270_dims().x;

    y_offset = c270_y_offset();
    //extra room for cable
    y_excess = c270_mount_y_excess();

    difference(){
        union(){
            translate([-w/2, -y_offset]){
                cube([w, h+2*y_offset+y_excess, height]);
            }
            translate([-w/2, y_offset+h-10]){
                cube([w*1.5, y_excess+10, height]);
            }
        }
        translate([-(w+1)/2, y_offset, -tiny()]){
            cube([w+1, h, 1+tiny()]);
        }
        translate([w, h+y_offset+y_excess/2, 0]){
            mirror([1,0,0]){
                c270_cable_exit();
            }
        }
        difference(){
            translate([-(w-3)/2, -y_offset-tiny(), -1.5]){
                cube([w-3, h+2*y_offset+y_excess-2, height]);
            }
            translate([-w/2, h+y_offset+y_excess-8, -2.5]){
                cube([8, 8, 2*height]);
            }
        }
        translate(c270_backshell_screw_positions(flip_x=true)[0]){
            mirror([0,0,1]){
                no2_selftap_counterbore(flip_z=true);
            }
        }
        translate(c270_backshell_screw_positions(flip_x=true)[1]){
            mirror([0,0,1]){
                no2_selftap_counterbore(flip_z=true);
            }
        }
    }
}


module c270_cable_exit(){
    translate_y(-5/2){
        cube([14, 5, 6.5], center=true);
    }
    rotate_y(90){
        cylinder(d=6.5, h=14, center=true);
    }
    translate_x(3){
        cube([1, 10, 10], center=true);
    }
    cube([25, 4, 4], center=true);
}

module c270_counterbore(){
    translate_z(c270_camera_bottom_z()-1){
        at_c270_hole_pattern(){
            cylinder(r=1.1, h=9, $fn=12);
        }
    }
    translate_z(c270_camera_bottom_z()+1){
        at_c270_hole_pattern(){
            cylinder(r=2.1, h=9, $fn=12);
        }
    }
}

module c270_camera_bottom_mounting_posts(optics_config, outers=true, cutouts=true, bottom_slice=false){
    if (bottom_slice){
        //if we want the bottom slice intersect with the bottom of the whole
        //post found by recalling the function
        intersection(){
            cylinder(h=tiny(), r=99);
            c270_camera_bottom_mounting_posts(optics_config, outers=outers, cutouts=cutouts);
        }
    }
    else{
        // posts to mount to Logitech C270 camera from below
        r1=3;
        r2=2.5;
        h = key_lookup("mounting_post_height", optics_config);
        at_c270_hole_pattern(){
            difference(){
                if(outers){
                    cylinder(r1=r1, r2=r2, h=h, $fn=12);
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

module at_c270_hole_pattern(){
    // posts to mount to Logitech C270 camera from below

    screw_x = c270_camera_hole_spacing();
    // Third hole position at the far end of the board [-6,42.3,0] is too far away and makes 
    // the camera platform too big for mounting from above.
    //c270_third_hole_pos = [5,-9.5,0];
    rotate_z(-45){
        reflect_x(){
            translate([screw_x, 0, 0]){
                children();
            }
        }
        translate(c270_near_third_hole_pos()){
            children();
        }
    }
}
