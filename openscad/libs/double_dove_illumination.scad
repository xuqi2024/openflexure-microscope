
use <./illumination.scad>
use <./microscope_parameters.scad>
use <./compact_nut_seat.scad>
use <./utilities.scad>
use <./z_axis.scad>
use <./logo.scad>

function double_dove_cube_w() = 10;
function inner_dove_cube_w() = double_dove_cube_w()-.5;
// position of the main dovetail
function double_dove_mount_y() = 40;
function double_dove_mount_front_y() = let(
    cutout_w = 2*double_dove_cube_w()/sqrt(2),
    front_wall_t = 2
)    double_dove_mount_y() - .5*cutout_w - front_wall_t;

// width of the main dovetail
function double_dove_mount_w() = 42;
function double_dove_nut_offset() = 6;


module doubledove_illumination_mount_branding(params, h, bottom_z){
    // The open flexure logo for the back of the illumination fovetail

    //lug height
    lug_h = 4+2*tiny();
    //height of the slobed back
    slope_h = h-lug_h ;
    //top and bottom of y position of the sloped back
    bot_y = right_illumination_screw_pos(params).y+5;
    top_y = double_dove_mount_front_y()+2*double_dove_cube_w();
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
    cube_corner = [-double_dove_mount_w()/2, double_dove_mount_front_y(), dt_z];
    //distance cubes are moved forward and backward in y respectivly
    sequential_hull(){
        //Cube just below the actual dovetail
        translate(cube_corner){
            cube([double_dove_mount_w(), 20, 1]);
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
        translate(cube_corner + [0, 20-tiny(), 0]){
            cube([double_dove_mount_w(), tiny(), dt_h]);
        }
    }
    translate(cube_corner){
        cube([double_dove_mount_w(), 20, dt_h]);
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
    cutout_z = 15;

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

        translate([0,double_dove_mount_y(),bottom_z+cutout_z]){
            double_dove_cutout(h-cutout_z);
        }
    }
    doubledove_illumination_mount_branding(params, h, bottom_z);
}

module double_dove_cutout(h){
    front_opening_w = 14;
    cube_w =  double_dove_cube_w();
    double_dove(h=h+1, cube_w=cube_w, truncated=false);
    translate([-front_opening_w/2, -100, 0]){
        cube([front_opening_w, 100, h+1]);
    }
    hull(){
        for (z_tr = [5, h-10]){
            translate([0, 0, z_tr]){
                rotate([0,90,0]){
                    cylinder(d=3.3, h=100, $fn=24, center=true);
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
    dove_pos = [0, double_dove_mount_y(), 0];
    union(){
        translate(dove_pos){
            sprung_double_dove(h);
        }
        optics_holder_inch(h);
        hull(){
            translate(dove_pos){
                sprung_double_dove_face(h);
            }
            optics_holder_inch_back_face(h);
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
                m3_nut_trap_with_shaft(tilt=90,shaft_below=false, squeeze=.99);
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

module optics_holder_inch_back_face(h=8){
    w = 40/(1+sqrt(2));
    translate([-w/2, 20-tiny(), 0]){
        cube([w, tiny(), h]);
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

module double_dove_with_nuts(h=8, nut_z=-1){
    x_offset = 10;
    nut_z_pos = (nut_z<0)? h/2 : nut_z;
    nut_trap_pos = [double_dove_nut_offset()-4, 0, nut_z_pos];
    difference(){
        double_dove(h=h, cube_w=inner_dove_cube_w(), x_offset=10);

        reflect([1,0,0]){
            translate(nut_trap_pos){
                rotate([0,0,90]){
                    //Squeeze sets the fraction of the nut site at the top of the trap
                    // inceased to 0.9 for vertical nuts to prevent layer seperation
                    m3_nut_trap_with_shaft(tilt=90,shaft_below=true, squeeze=.99);
                }
            }
        }
    }
}

module sprung_double_dove(h=8, nut_z=-1){

    difference(){
        double_dove_with_nuts(h=h, nut_z=nut_z);
        cube([2*double_dove_nut_offset(), 3*double_dove_cube_w(), 3*h], center=true);
        double_reflect(){
            translate([double_dove_nut_offset() - tiny(), inner_dove_cube_w()/sqrt(2)-2, -h]){
                sequential_hull(){
                    cube([tiny(), 1, 3*h]);
                    translate([4,0,0]){
                        cube([tiny(), 1, 3*h]);
                    }
                    translate([7,-2,0]){
                        cube([tiny(), tiny(), 3*h]);
                    }
                }
            }
        }
    }


    sequential_hull(){
        sprung_double_dove_face(h);
        translate([0, -2, h/2]){
            cube([3,tiny(),h], center=true);
        }
        translate([0, 2-tiny(), h/2]){
            cube([3,tiny(),h], center=true);
        }
        sprung_double_dove_face(h, front=false);
    }

    double_reflect(){
        sequential_hull(){
            translate([double_dove_nut_offset(), -inner_dove_cube_w()/sqrt(2), 0]){
                cube([tiny(), 1, h]);
            }
            translate([1.5-tiny(), -1.5, 0]){
                cube([tiny(), 1, h]);
            }

        }
    }
}

module sprung_double_dove_face(h=8, front=true){
    if (front){
        translate([0, -inner_dove_cube_w()/sqrt(2)+tiny(), h/2]){
            cube([2*(double_dove_nut_offset()-1), 2*tiny() ,h], center=true);
        }
    }
    else{
        mirror([0,1,0]){
             sprung_double_dove_face(h);
        }
    }
}


module double_dove_condenser(lens_d, lens_t, lens_assembly_z){
    //the main body of the condenser
    lens_r = lens_d/2;
    base_r = lens_r+1;
    dove_pos = [0, double_dove_mount_y(), 0];
    double_dove_height = lens_assembly_z-4;
    nut_z = double_dove_height -6;
    difference() {
        union(){
            //this hull is the outer shape of the body of the condenser
            hull() reflect([1, 0, 0]) {
                cylinder(r=base_r+.3, h=lens_assembly_z+tiny());
                translate(dove_pos){
                    sprung_double_dove_face(double_dove_height);
                }
            }
            translate(dove_pos){
                sprung_double_dove(double_dove_height, nut_z);

            }
            //add the lens gripper
            translate([0, 0, lens_assembly_z]){
                condenser_lens_gripper(lens_r, lens_t, base_r);
            }
        }
        condenser_cutout(lens_r, lens_assembly_z, bottom_height=0);
    }
}
