
use <./utilities.scad>
use <./microscope_parameters.scad>
use <./compact_nut_seat.scad>
use <./main_body_transforms.scad>
use <./main_body_structure.scad>
use <./wall.scad>
use <./z_axis.scad>
use <../feet.scad>
use <./libdict.scad>


//TODO re-implement this
function stand_wall_thickness() = 2.5;
function stand_base_thickness() = 2;
function microscope_depth() = 3;
function microscope_stand_height(vert_h) = vert_h + 31;


module foot_footprint(tilt=0){
    // the footprint of one foot/actuator column
    projection(cut=true){
        translate_z(-1){
            screw_seat_shell(tilt=tilt);
        }
    }
}

module hull_from(){
    // take the convex hull betwen one object and all subsequent objects
    for(i=[1:$children-1]){
        hull(){
            children(0);
            children(i);
        }
    }
}

module microscope_bottom(params, enlarge_legs=1.5, lugs=true, feet=true, legs=true){
    // a 2D representation of the bottom of the microscope
    hull(){
        projection(cut=true){
            translate_z(-tiny()){
                wall_inside_xy_stage(params);
            }
        }
    }

    hull(){
        reflect_x(){
            projection(cut=true){
                translate_z(-tiny()){
                    wall_outside_xy_actuators(params);
                    wall_between_actuators(params);
                }
            }
        }
    }

    projection(cut=true){
        translate_z(-tiny()){
            z_axis_casing(params);
            reflect_x(){
                hull(){
                    side_housing(params);
                }
            }
        }
    }

    if(feet){
        each_actuator(params){
            translate([0, actuating_nut_r(params)]){
                foot_footprint();
            }
        }
        translate([0, z_nut_y(params)]){
            foot_footprint(tilt=z_actuator_tilt(params));
        }
    }

    if(lugs){
        projection(cut=true){
            translate_z(-tiny()){
                mounting_hole_lugs(params, holes=false);
            }
        }
    }

    if(legs){
        offset(enlarge_legs){
            microscope_legs(params);
        }
    }
}

module microscope_legs(params){
    difference(){
        each_leg(params){
            union(){
                projection(cut=true){
                    translate_z(-tiny()){
                        leg(params);
                    }
                }
                projection(cut=true){
                    translate([0,-5,-tiny()]){
                        leg(params);
                    }
                }
            }
        }
        translate([-999,0]){
            square(999*2);
        }
    }
}


module thick_bottom_section(params, h, offset_r, center=false){
    hull(){
        linear_extrude(h, center=center){
            offset(offset_r){
                microscope_bottom(params, feet=true);
            }
        }
    }
}

module stand_lugs(params, h, vert_h){
    lug_body_h = 9;
    lug_h = 20;
    lug_z = h-lug_h-microscope_depth();

    hole_pos = base_mounting_holes(params);
    for (n = [0:len(hole_pos)-1]){
        hole = hole_pos[n];
        angle = lug_angles()[n];
        translate_z(lug_z){
            difference(){
                hull(){
                    intersection(){
                        translate(hole+[0,0,lug_h/2]){
                            rotate(angle){
                                cube([10,50,lug_h], center=true);
                            }
                        }
                        translate_z(-lug_z){
                            microscope_stand_shell(params, h, vert_h);
                        }
                    }

                    translate(hole + [0, 0, lug_h-lug_body_h]){
                        cylinder(r=5, h=lug_body_h);
                    }
                }
                translate(hole+[0,0,lug_h-9]){
                    m3_nut_trap_with_shaft(angle+180);
                }
            }
        }
    }
}


//The outer shell of the microscope stand
module microscope_stand_shell(params, h, vert_h){

    inner_offset_r = 1.5;
    outer_offset_r = inner_offset_r + stand_wall_thickness();
    assert(h-vert_h-10>15, "Stand is too short to print. Either increase height or reduce height of the pi stand");

    difference(){
        sequential_hull(){
            microscope_stand_base_section(params, outer_offset_r);

            translate_z(vert_h+5){
                microscope_stand_base_section(params, outer_offset_r);
            }
            translate_z(vert_h+10){
                thick_bottom_section(params, h-vert_h-10, outer_offset_r);
            }
        }

        sequential_hull(){
            translate_z(stand_base_thickness()){
                microscope_stand_base_section(params, inner_offset_r);
            }

            translate_z(vert_h+5){
                microscope_stand_base_section(params, inner_offset_r);
            }
            translate_z(vert_h+10+tiny()){
                thick_bottom_section(params, h-vert_h-10, inner_offset_r);
            }
        }
    }

}


module pi_stand_frame_xy(params, for_base_section=false){
    initial_pos = for_base_section ? [0,0,0] : [5,0,2];
    translate([34, -38, 0]){
        rotate(-y_wall_angle(params)){
            translate(initial_pos){
                children();
            }
        }
    }
}


module microscope_stand_base_section(params, ex_rad=3){
    pi_base_size = pi_stand_base_size();
    pi_block_size = [pi_base_size.x, pi_stand_front_width(), tiny()];
    extra_front_space = 2;
    extra_back_space = 6;
    extra_x_space = extra_front_space + extra_back_space;
    block_size = pi_block_size + [extra_x_space, 8, 0];
    minkowski(){
        hull(){
            reflect_x(){
                pi_stand_frame_xy(params, for_base_section=true){
                    translate_x(-extra_back_space){
                        cube(block_size);
                    }
                }
            }
        }
        cylinder(r=ex_rad, h=tiny());
    }
}

module microscope_stand_no_pi(params, vert_h, reflection_extra_depth=0){
    h = microscope_stand_height(vert_h);
    stand_lugs(params, h, vert_h);
    difference(){
        microscope_stand_shell(params, h, vert_h);
        translate_z(h-microscope_depth()){
            reflection_illuminator_cutout(reflection_extra_depth);
        }
    }
}

module microscope_stand(params, tall_bucket_base=false){
    pi_stand_h = key_lookup("pi_stand_h", params);
    extra_h = tall_bucket_base ? 17 : 0;
    vert_h = pi_stand_h + extra_h;
    difference(){
        microscope_stand_no_pi(params, vert_h, extra_h);
        pi_drawer_cutout(params);

    }
    pi_drawer_runner_and_mount(params);
}

module pi_drawer_cutout(params){
    pi_stand_h = key_lookup("pi_stand_h", params);
    pi_base_size = pi_stand_base_size();
    extra_space = [1, 1, 1.5];
    tr_for_extra_space = [-extra_space.x/2, -extra_space.y/2, 0];
    pi_space = [pi_base_size.x, pi_base_size.y, pi_stand_h];
    front_wall_space = [pi_base_size.x, pi_stand_front_width(), pi_stand_h];
    //Cut out a further 99mm in x to make hole in front
    pi_cutout_size = pi_space + extra_space + [99, 0, 0];
    front_wall_cutout_size = front_wall_space + extra_space + [99, 0, 0];
    pi_stand_frame_xy(params){
        translate(tr_for_extra_space){
            cube(pi_cutout_size);
            translate(pi_stand_front_pos()){
                cube(front_wall_cutout_size);
            }
        }
        //Cutout for the side connectors
        translate([5, -50, 2]){
            cube([60, 100, 25]);
        }
        translate(pi_stand_side_screw_pos()){
            rotate_x(90){
                m3_cap_counterbore(10, 10);
            }
        }
    }
}

module pi_drawer_runner_and_mount(params){
    pi_stand_frame_xy(params){
        stand_base_size = pi_stand_base_size();
        stand_block_size = pi_stand_mount_block_size();
        position = pi_stand_mount_block_pos() + [0, 1, 0];
        side_len = stand_base_size.x-stand_block_size.x;
        difference(){
            union(){
                translate(position){
                    translate_x(-10){
                        cube([10, stand_block_size.y-1, 10]);
                    }
                    translate_x(-side_len){
                        cube([side_len, 2, 5]);
                    }
                }
            }
            translate(pi_stand_front_screw_pos()){
                rotate_y(90){
                    m3_cap_counterbore(10, 99);
                }
            }
            translate(pi_stand_front_nut_trap_pos()){
                hull(){
                    for(z_tr = [0, 20]){
                        translate_z(z_tr){
                            rotate_y(90){
                                nut(3, 2.6);
                            }
                        }
                    }
                }
            }
        }
    }
}

function pi_board_dims() = [85, 56, 1.5];
function pi_stand_board_inset() = [3, 3, 0];
function pi_stand_wall_t() = pi_stand_board_inset().x - 0.5;
function pi_stand_thickness() = 2;
function pi_stand_base_size() = let(
    t = pi_stand_thickness(),
    board_size = [pi_board_dims().x, pi_board_dims().y, t]
) board_size + 2 * pi_stand_board_inset();
function pi_stand_front_width() = pi_stand_base_size().y+10;

//Position in the frame of the pi_stand
function pi_stand_front_pos() = let(
    x_tr = pi_stand_base_size().x - pi_stand_wall_t()
) [x_tr, 0, 0];

function sanga_stand_height() = pi_stand_standoff_h() + 12.5;

function pi_stand_mount_block_size() = let(
    height = sanga_stand_height(),
    width = pi_stand_front_width()-pi_stand_base_size().y
) [10, width, height];

function pi_stand_mount_block_pos() = let(
    block_depth = pi_stand_wall_t()-pi_stand_mount_block_size().x
) pi_stand_front_pos() + [block_depth, pi_stand_base_size().y, 0];

function pi_stand_front_screw_pos() = let(
    block_pos = pi_stand_mount_block_pos()
) [block_pos.x+3, block_pos.y+6, 5];

function pi_stand_front_screw_pos() = let(
    block_pos = pi_stand_mount_block_pos()
) [block_pos.x+3, block_pos.y+6, 5];

function pi_stand_front_nut_trap_pos() = pi_stand_front_screw_pos() - [7, 0, 0];

function pi_stand_side_screw_pos() = [14, -3, 35];

function pi_stand_nut_block_depth() = 5;

function pi_stand_side_nut_trap_pos() = let(
    wall_t = pi_stand_wall_t(),
    nut_block_depth = pi_stand_nut_block_depth(),
    side_screw_pos = pi_stand_side_screw_pos()
) [side_screw_pos.x, wall_t+nut_block_depth/2 ,side_screw_pos.z];

function pi_stand_block_hole_pos() = let(
    block_pos = pi_stand_mount_block_pos(),
    block_size = pi_stand_mount_block_size(),
    wall_size = [pi_stand_wall_t(), 0, 0],
    block_cent = block_pos + block_size/2 - wall_size/2
) [block_cent.x, block_cent.y, block_size.z-6];

function pi_stand_standoff_h() = 5.5;

module pi_stand(params){
    pi_stand_h = key_lookup("pi_stand_h", params);
    pi_stand_base();
    pi_stand_walls(pi_stand_h);
}

function pi_hole_pos(inset_for_stand=false) = let(
    hole_inset = [3.5, 3.5, 0],
    board_inset = inset_for_stand ?  pi_stand_board_inset() : [0, 0, 0],
    h1 = [0, 0, 0]+hole_inset+board_inset,
    h2 = [58, 0, 0]+hole_inset+board_inset,
    h3 = [0, 49, 0]+hole_inset+board_inset,
    h4 = [58, 49, 0]+hole_inset+board_inset
) [h1, h2, h3, h4];

module pi_tap_holes(connector_side=true, inside=true){
    all_holes = pi_hole_pos(true);
    connector_holes = connector_side ? [0, 1] : [];
    inside_holes = inside ? [2, 3] : [];
    //only create tap holes for selected holes
    tap_holes = concat(connector_holes, inside_holes);
    for (hole_num = tap_holes){
        hole = all_holes[hole_num];
        translate(hole){
            cylinder(d=2.7, h=99, center=true, $fn=3);
        }
    }
}

module pi_stand_base(){
    hole_inset = [3.5, 3.5, 0];

    standoff_h = pi_stand_standoff_h();
    base_size = pi_stand_base_size();
    hole_pos = pi_hole_pos(true);
    difference(){
        union(){
            cube(base_size);
            for (hole = hole_pos){
                translate(hole){
                    cylinder(d=5.5, h=standoff_h, $fn=12);
                }
            }
            for (hole = [hole_pos[0], hole_pos[1]]){
                translate(hole + [0, 0, standoff_h-.8]){
                    sphere(d=2.6, $fn=10);
                }
            }
        }
        pi_tap_holes(connector_side=false);
        translate_y(base_size.y/2){
            cube(25, center=true);
        }
    }
}


module pi_stand_walls(h, block_usbc=true){

    base_size = pi_stand_base_size();
    wall_t = pi_stand_wall_t();
    
    difference(){
        union(){
            cube([base_size.x, wall_t, h]);
            translate(pi_stand_front_pos()){
                cube([wall_t, pi_stand_front_width(), h]);
            }
            translate(pi_stand_mount_block_pos()){
                cube(pi_stand_mount_block_size());
            }
            pi_stand_nut_trap();
            sanga_lugs();
        }

        pi_connector_holes();
        sanga_connector_holes();

        translate(pi_stand_front_screw_pos()){
            rotate_y(90){
                m3_cap_counterbore(999, 999);
            }
        }
        translate(pi_stand_side_screw_pos()){
            rotate_x(90){
                //Change to through holes
                m3_cap_counterbore(1, 999);
            }
        }
        translate(pi_stand_block_hole_pos()){
            cylinder(d=2.7, h=99, $fn=3);
        }
        
    }
    if (block_usbc){
        usb_c_blocker();
    }
}

function sanga_connector_x() = 11.2;

module sanga_connector_holes(){
    wall_t = pi_stand_wall_t();
    board_inset = pi_stand_board_inset();
    connector_z = sanga_stand_height()+tiny()+3;
    connector_x = sanga_connector_x() + board_inset.x;
    sanga_connector_pos = [connector_x, 0, connector_z];
    translate(sanga_connector_pos){
        translate_y((wall_t-10)/2){
            cube([12, 10, 8], center=true);
            cube([10, 200, 4.5], center=true);
        }
    }
}

module sanga_lugs(){
    side_holes = [pi_hole_pos(true)[0], pi_hole_pos(true)[1]];
    
    translate_z(sanga_stand_height()-5){
        difference(){
            union(){
                for (hole = side_holes){
                    hull(){
                        translate(hole){
                            cylinder(d=5.5, h=5, $fn=12);
                        }
                        translate([hole.x, .1, 0]){
                            cube([5.5, 0.1, 10], center=true);
                        }
                    }
                }
            }
            pi_tap_holes(inside=false);
        }
    }
}

module pi_stand_nut_trap(){
    side_screw_pos = pi_stand_side_screw_pos();
    wall_t = pi_stand_wall_t();
    nut_block_depth = pi_stand_nut_block_depth();
    nut_tr_pos = pi_stand_side_nut_trap_pos();
    translate(nut_tr_pos){
        difference(){
            hull(){
                cube([8, nut_block_depth+tiny(), 6], center=true);
                translate([0, -nut_block_depth/2, -nut_block_depth]){
                    cube([8, tiny(), 6], center=true);
                }
            }
            hull(){
                for(z_tr = [0, 20]){
                    translate([0, 0.1, z_tr]){
                        rotate_z(-90){
                            rotate_y(90){
                                nut(3, 2.6);
                            }
                        }
                    }
                }
            }
        }
    }
        
}

module pi_connector_holes(){
    board_inset = pi_stand_board_inset();
    standoff_h = pi_stand_standoff_h();
    translate(board_inset + [0, 0, standoff_h+1]){
        translate_x(pi_stand_base_size().x-10){
            translate_y(45.75-17/2){
                cube([200, 17, 14.5]);
            }
            translate_y(27-15.5/2){
                cube([200, 15.5, 17]);
            }
            translate_y(9-15.5/2){
                cube([200, 15.5, 17]);
            }
        }

        translate_y(-board_inset.y-tiny()){
            pi_side_connectors();
        }
        hull(){
            translate_y(-(board_inset.y-1.5)){
                pi_side_connectors();
            }
        }
    }
}

module pi_side_connectors(){

    translate_x(11.2-10/2){
        cube([10, 200, 4.5]);
    }
    translate_x(26-8/2){
        cube([8, 200, 4.5]);
    }
    translate_x(39.5-8/2){
        cube([8, 200, 4.5]);
    }
    translate_x(54-7/2){
        translate([3.5, 0, 3.5]){
            rotate_x(-90){
                cylinder(d1=7, d2=8, h=5);
            }
        }
    }

}

module usb_c_blocker(){
    standoff_h = pi_stand_standoff_h();
    usb_c_x_pos = 11.2 + pi_stand_board_inset().x;
    //Translate to bottom centre of hole
    translate([usb_c_x_pos, 0, standoff_h+1]){
        translate([-8/2, 0, .75]){
            cube([8, 1, 3]);
        }
        translate([-12/2, 0, .75]){
            cube([12, 1, 1]);
        }
        translate([-12/2, 0, 2.75]){
            cube([12, 1, 1]);
        }
    }
}
