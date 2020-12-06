
use <./illumination.scad>
use <./microscope_parameters.scad>
use <./compact_nut_seat.scad>
use <./utilities.scad>
use <./z_axis.scad>
use <./logo.scad>

double_dove_mount_y = 35; // position of the main dovetail
double_dove_mount_w = 38; // width of the main dovetail

module doubledove_illumination_mount_branding(params, h, bottom_z){
    // The open flexure logo for the back of the illumination fovetail

    //lug height
    lug_h = 4+2*tiny();
    //height of the slobed back
    slope_h = h-lug_h ;
    //top and bottom of y position of the sloped back
    bot_y = right_illumination_screw_pos(params).y+5;
    top_y = double_dove_mount_y+15;
    back_angle = atan((top_y-bot_y)/slope_h);
    logo_z = bottom_z+lug_h +slope_h/2;
    logo_y = (top_y+bot_y)/2+.5;

    translate([-11,logo_y,logo_z]){
        rotate([90-back_angle,0,0]){
            openflexure_emblem(scale_factor=.1);
        }
    }
}

module doubledove_illumination_mount_structure(params, h, dt_z, dt_h){
    //this is the outer structure that forms the illumination mount.

    //nominal postion of the corner of the cubes that form this  structure
    cube_corner = [-double_dove_mount_w/2, double_dove_mount_y, dt_z];
    //distance cubes are moved forward and backward in y respectivly
    delta_y = 2;
    sequential_hull(){
        //Cube jsut below the actual dovetail
        translate(cube_corner - [0, delta_y, 0]){
            cube([double_dove_mount_w, 15+delta_y, 1]);
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
        //cube behind double dove
        translate(cube_corner + [0, 15-tiny(), 0]){
            cube([double_dove_mount_w, tiny(), dt_h]);
        }
        
    }
    translate(cube_corner + [0, -delta_y, 0]){
        cube([double_dove_mount_w, 15+delta_y, dt_h]);
    }
}

module doubledove_illumination_mount(params, h=50){
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

    difference(){
        doubledove_illumination_mount_structure(params, h, dt_z, dt_h);
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
        translate([0,-2,0]) z_motor_clearance(params);

        translate([0,double_dove_mount_y-3,bottom_z+15]){
            double_dove_cutout(h);
        }
    }
    doubledove_illumination_mount_branding(params, h, bottom_z);
}

module double_dove_cutout(h){
    cube_w = 10;
    y_tr = cube_w/sqrt(2);
    translate([0, y_tr, 0]){
        double_dove(h=999, cube_w=cube_w, truncated=false);
    }
    hull(){
        for (z_tr = [5, h-20]){
            translate([0, y_tr, z_tr]){
                rotate([0,90,0]){
                    cylinder(d=3.5, h=100, center=true);
                }
            }
        }
    }

}

module double_dove(h=10, cube_w=10, x_offset=10, truncated=true){
    if (!truncated){
        hull(){
            for (x_tr = [x_offset,-x_offset]){
                translate([x_tr, 0, h/2]){
                    rotate([0, 0, 45]){
                        cube([cube_w, cube_w, h],center=true);
                    }
                }
            }
        }
    }
    else{
        // To truncate intersect with a non-truncated one.
        x_trunc_pos = cube_w/sqrt(2)+x_offset-3;
        intersection(){
            cube([2*x_trunc_pos, 3*cube_w, 3*h], center=true);
        double_dove(h=h, cube_w=cube_w, x_offset=x_offset, truncated=false);
        }
    }
}


module illumination_filter_holder(){
    h = 8;
    union(){
        double_dove_with_nuts(h);
        optics_holder_inch(h);
        translate([0, -26, h/2]){
            cube([18, 15, h], center=true);
        }
    }
}

module optics_holder_inch(h=8){
    bump_rad = 2;
    hole_rad = 12.7 + bump_rad;
    difference(){
        translate([0, 0, h/2]){
            difference(){
                octagonal_prism(w=40, h=h, center=true);
                cylinder(r=hole_rad, h=3*h, center=true);
            }
        }
        translate([-20+10, 0, h/2]){
            rotate([0,0,-90]){
                m3_nut_trap_with_shaft(tilt=90,shaft_below=false);
            }
        }
    }
    for (angle = [-60, 60]){
        rotate([0, 0, angle]){
            translate([hole_rad, 0, 0]){
                cylinder(r=bump_rad, h=h, $fn=12);
            }
        }
    }
    
}

module octagonal_prism(w, h, center){
    intersection(){
        cube([w, w, h], center=center);
        rotate([0,0,45]){
            cube([w, w, h], center=center);
        }
    }
}

module double_dove_with_nuts(h=8){
    translate([0,-40,0]){
        difference(){
            
            x_offset = 10;
            double_dove(h=h, cube_w=9.5, x_offset=10);

            reflect([1,0,0]){
                translate([x_offset-6, 0, h/2]){
                    rotate([0,0,90]){
                        m3_nut_trap_with_shaft(tilt=90,shaft_below=true);
                    }
                }
            }
        }
    }
}