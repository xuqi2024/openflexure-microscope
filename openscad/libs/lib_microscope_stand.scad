
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

module stand_lugs(params, h, pi_stand_h){
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
                            microscope_stand_shell(params, h, pi_stand_h);
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
module microscope_stand_shell(params, h, pi_stand_h){

    inner_offset_r = 1.5;
    outer_offset_r = inner_offset_r + stand_wall_thickness();
    assert(h-pi_stand_h-10>15, "Stand is too short to print. Either increase height or reduce height of the pi stand");

    difference(){
        sequential_hull(){
            microscope_stand_base_section(params, outer_offset_r);

            translate_z(pi_stand_h+5){
                microscope_stand_base_section(params, outer_offset_r);
            }
            translate_z(pi_stand_h+10){
                thick_bottom_section(params, h-pi_stand_h-10, outer_offset_r);
            }
        }

        sequential_hull(){
            translate_z(stand_base_thickness()){
                microscope_stand_base_section(params, inner_offset_r);
            }

            translate_z(pi_stand_h+5){
                microscope_stand_base_section(params, inner_offset_r);
            }
            translate_z(pi_stand_h+10+tiny()){
                thick_bottom_section(params, h-pi_stand_h-10, inner_offset_r);
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


// TODO: split me
module microscope_stand(params, pi_stand_h){
    h=73;

    stand_lugs(params, h, pi_stand_h);

    pi_base_size = pi_stand_base_size();
    extra_space = [1, 1, 1.5];
    tr_for_extra_space = [-extra_space.x/2, -extra_space.y/2, 0];
    pi_space = [pi_base_size.x, pi_base_size.y, pi_stand_h];
    front_wall_space = [pi_base_size.x, pi_stand_front_width(), pi_stand_h];
    //Cut out a further 99mm in x to make hole in front
    pi_cutout_size = pi_space + extra_space + [99, 0, 0];

    front_wall_cutout_size = front_wall_space + extra_space + [99, 0, 0];
    difference(){

        microscope_stand_shell(params, h, pi_stand_h);

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
        translate_z(h-microscope_depth()){
            reflection_illuminator_cutout();
        }
    }
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
                hull(){
                    for(z_tr = [0, 20]){
                        translate([-10,0,z_tr]){
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



function pi_board_dims() = [85, 56, 19];
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

function pi_stand_side_screw_pos() = [10, -3, 35];

function pi_stand_block_hole_pos() = let(
    block_pos = pi_stand_mount_block_pos(),
    block_size = pi_stand_mount_block_size(),
    wall_size = [pi_stand_wall_t(), 0, 0],
    block_cent = block_pos + block_size/2 - wall_size/2
) [block_cent.x, block_cent.y, block_size.z-6];

function pi_stand_standoff_h() = 5.5;

module pi_stand(h=50){
    pi_stand_base();
    pi_stand_walls(h);
}

function pi_hole_pos() = let(
    hole_inset = [3.5, 3.5, 0],
    board_inset = pi_stand_board_inset(),
    h1 = [0, 0, 0]+hole_inset+board_inset,
    h2 = [58, 0, 0]+hole_inset+board_inset,
    h3 = [0, 49, 0]+hole_inset+board_inset,
    h4 = [58, 49, 0]+hole_inset+board_inset
) [h1, h2, h3, h4];

module pi_tap_holes(){
    for (hole = pi_hole_pos()){
        translate(hole){
            cylinder(d=2.7, h=99, center=true, $fn=3);
        }
    }
}

module pi_stand_base(){
    hole_inset = [3.5, 3.5, 0];

    standoff_h = pi_stand_standoff_h();
    base_size = pi_stand_base_size();

    difference(){
        union(){
            cube(base_size);
            for (hole = pi_hole_pos()){
                translate(hole){
                    cylinder(d=5.5, h=standoff_h, $fn=12);
                }
            }
        }
        pi_tap_holes();
        translate_y(base_size.y/2){
            cube(25, center=true);
        }
    }
}

// TODO: split me
module pi_stand_walls(h){
    board_inset = pi_stand_board_inset();
    base_size = pi_stand_base_size();
    standoff_h = pi_stand_standoff_h();
    side_screw_pos = pi_stand_side_screw_pos();
    wall_t = pi_stand_wall_t();
    nut_block_depth = 5;
    nut_tr_pos = [side_screw_pos.x, wall_t+nut_block_depth/2 ,side_screw_pos.z];
    difference(){
        union(){
            cube([base_size.x, wall_t, h]);
            translate(pi_stand_front_pos()){
                cube([wall_t, pi_stand_front_width(), h]);
            }
            translate(pi_stand_mount_block_pos()){
                cube(pi_stand_mount_block_size());
            }
            translate(nut_tr_pos){
                hull(){
                    cube([8, nut_block_depth+tiny(), 6], center=true);
                    translate([0, -nut_block_depth/2, -nut_block_depth]){
                        cube([8, tiny(), 6], center=true);
                    }
                }
            }
        }

        hull(){
            for(z_tr = [0, 20]){
                translate(nut_tr_pos + [0, 1, z_tr]){
                    rotate_z(-90){
                        rotate_y(90){
                            nut(3, 2.6);
                        }
                    }
                }
            }
        }

        translate(pi_stand_front_screw_pos()){
            rotate_y(90){
                m3_cap_counterbore(10, 10);
            }
        }
        translate(side_screw_pos){
            rotate_x(90){
                //Change to through holes
                m3_cap_counterbore(1, 999);
            }
        }

        translate(pi_stand_block_hole_pos()){
            cylinder(d=2.7, h=99, $fn=3);
        }


        //Cutouts for the pi connectors
        translate(board_inset + [0, 0, standoff_h+1]){
            translate_y(45.75-17/2){
                cube([200, 17, 14.5]);
            }
            translate_y(27-15.5/2){
                cube([200, 15.5, 17]);
            }
            translate_y(9-15.5/2){
                cube([200, 15.5, 17]);
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
        translate(board_inset + [11.2-12/2, -100, sanga_stand_height()]){
            cube([12, 200, 7.5]);
        }
    }
    side_holes = [pi_hole_pos()[0], pi_hole_pos()[1]];
    difference(){
        translate_z(sanga_stand_height()-5){
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
        }
        pi_tap_holes();
    }
}


module pi_side_connectors(){

    translate_x(11.2-10/2){
        cube([10, 200, 4.5]);
    }
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
