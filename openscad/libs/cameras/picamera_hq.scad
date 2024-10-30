
use <../utilities.scad>
use <../libdict.scad>

function picamera_hq_camera_dict() = [["mount_height", 4.5],
                                     ["sensor_height", 1]]; //Height of the sensor above the PCB

function picamera_hq_bottom_z() = -key_lookup("mount_height", picamera_hq_camera_dict());

function picamera_hq_hole_spacing() = 30;

function picamera_board_size() = [38, 38];

module picamera_hq_cutout(beam_length=15){
    h = key_lookup("mount_height", picamera_hq_camera_dict())+tiny();
    translate_z(-tiny()){
        cylinder(d=5, h=beam_length);
        cylinder(d1=9.5+2*h, d2=9.5, h=h);
    }
}

module picamera_hq_board(h=tiny(), rotated=true, clearance=0){
    // a rounded rectangle with the dimensions of the picamera hq board
    // centred on the origin
    board_dims = picamera_board_size();
    roc = 2+clearance;
    angle = rotated ? 45 : 0;
    rotate_z(angle){
        linear_extrude(h){
            hull(){
                reflect([1,0]){
                    reflect([0,1]){
                        translation = board_dims/2 + [1, 1]*(-roc+clearance);
                        translate(translation){
                            circle(r=roc,$fn=16);
                        }
                    }
                }
            }
        }
    }
}

module picamera_hq_camera_mount(screwhole=true, counterbore=false){
    // A mount for the pi camera hq
    // This should finish at z=0+tiny(), with a surface that can be
    // hull-ed onto the lens assembly.
    board_dims = picamera_board_size();
    difference(){
        rotate(45){
            sequential_hull(){
                translate_z(picamera_hq_bottom_z()){
                    picamera_hq_board(h=tiny(), rotated=false);
                }
                translate_z(-1){
                    picamera_hq_board(h=tiny(), rotated=false);
                }
                x_size = board_dims.x-(-1.5-picamera_hq_bottom_z())*2;
                cube([x_size, board_dims.y, tiny()], center=true);
            }
        }
        rotate(45){
            translate_z(picamera_hq_bottom_z()){
                picamera_hq_cutout();
            }
        }
        if(counterbore){
            picamera_hq_counterbore();
        }
        if(screwhole){
            picamera_hq_screwholes();
        }
    }
}

module picamera_hq_screwholes(){
    //chamfered screw holes for mounting
    translate_z(picamera_hq_bottom_z()){
        at_picamera_hq_hole_pattern(){
            rotate_z(60){
                translate_z(-tiny()){
                    no2_selftap_hole(h=10);
                }
            }
        }
    }
}

module picamera_hq_counterbore(){
    translate_z(picamera_hq_bottom_z()-1){
        at_picamera_hq_hole_pattern(){
            cylinder(r=1.25, h=99, $fn=12);
        }
    }
    translate_z(picamera_hq_bottom_z()+1){
        at_picamera_hq_hole_pattern(){
            cylinder(r=2.8, h=99, $fn=12);
        }
    }
}

module picamera_hq_bottom_mounting_posts(optics_config, outers=true, cutouts=true, bottom_slice=false){
    // posts to mount to pi camera from below

    if (bottom_slice){
        //if we want the bottom slice intersect with the bottom of the whole
        //post found by recalling the function
        intersection(){
            cylinder(h=tiny(), r=99);
            picamera_hq_bottom_mounting_posts(optics_config, outers=outers, cutouts=cutouts);
        }
    }
    else{
        h=key_lookup("mounting_post_height", optics_config);
        r1=3;
        r2=2;
        at_picamera_hq_hole_pattern(){
            difference(){
                if(outers){
                    cylinder(r1=r1, r2=r2, h=h, $fn=12);
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

module at_picamera_hq_hole_pattern(){
    // posts to mount to pi camera from below
    hole_spacing = picamera_hq_hole_spacing();
    rotate(45){
        for(x_tr=[-.5, .5]*hole_spacing){
            for(y_tr=[-.5, .5]*hole_spacing){
                translate([x_tr, y_tr, 0]){
                    children();
                }
            }
        }
    }
}


module picamera_hq_cover_pads(clearance=1){
    //create the pads that make contact with the board
    hole_spacing = picamera_hq_hole_spacing();

    intersection(){
        // use loop to make all 4
        for (angle = [0, 90, 180, 270]){
            rotate(angle){
                translate_x(hole_spacing/2*sqrt(2)){
                    hull(){
                        // cylinder centred on a mounting hole
                        cylinder(d=5.3, h=1.5);
                        // Translate cylinders perpendicular to boards edge
                        // and hull to make a pad that sticks out beyond the board
                        // This will be intersected with the board shape later
                        translate([10,10,0]){
                            cylinder(d=5.3, h=1.5);
                        }
                        translate([10,-10,0]){
                            cylinder(d=5.3, h=1.5);
                        }
                    }
                }
            }
        }
        picamera_hq_board(h=2, clearance=clearance);
    }
}


/////////// Cover for camera board //////////////
module picamera_hq_cover(){
    $fn=16;
    difference(){
        union(){
            translate_z(-2){
                difference(){
                    picamera_hq_board(h=4.5, clearance=1.5);
                    translate_z(-tiny()){
                        picamera_hq_board(h=3.5+tiny(), clearance=.5);
                    }
                }
            }
            picamera_hq_cover_pads(clearance=1);
        }
        at_picamera_hq_hole_pattern(){
            translate_z(.8){
                // mirror z as well as z_flip as these holes need to be printed
                // so they can beidge, but the part is printed upside down
                mirror([0,0,1]){
                    no2_selftap_counterbore(flip_z=true, tight=true);
                }
            }
        }
        rotate_z(45){
            translate_x(picamera_board_size().x/2){
                cube([14, 22, 30], center=true);
            }
        }
    }
}

