
use <./utilities.scad>
use <./microscope_parameters.scad>
use <./compact_nut_seat.scad>
use <./main_body_transforms.scad>
use <./main_body_structure.scad>
use <./wall.scad>
use <./z_axis.scad>
use <../feet.scad>
use <./libdict.scad>

function stand_bottom_thickness() = 1.0;
function stand_top_indent_depth() = 3.0;

function stand_wall_thickness() = 1.5; //default 1.5 - 2.35 is good for ABS
function pi_standoff_h() = 4.0;

//TODO: move the pi-specific stuff into its own file
function pi_board_dims() = [85, 56, 19];

function sd_card_cutout_top() = 20;

//the y poistion where the base forms a point
function base_corner_y(params) = let(
    leg_r = key_lookup("leg_r", params),
    // calculate the radius that the center of the wall inside the xy stage is on
    // drawing a line from origin through a back leg
    on_rad = leg_r-flex_dims().y-microscope_wall_t()/2+leg_outer_w(params)/2,
    // project this point ont the y axis:
    on_y_ax = -on_rad/sqrt(2)
) on_y_ax - microscope_wall_t()/2 - 15;

module foot_footprint(tilt=0){
    // the footprint of one foot/actuator column
    projection(cut=true){
        translate_z(-1){
            screw_seat_shell(tilt=tilt);
        }
    }
}

module pi_frame(){
    // coordinate system relative to the corner of the pi.
    translate([0,15]){
        rotate(-45){
            translate([-pi_board_dims().x/2, -pi_board_dims().y/2]){
                children();
            }
        }
    }
}

module pi_footprint(){
    // basic space for the Pi (in 2D)
    pi_frame(){
        translate([-1,-1]){
            square([pi_board_dims().x+2,pi_board_dims().y+2]);
        }
    }
}



module pi_connectors(){
    pi_frame(){
        // USB/network ports
        translate([pi_board_dims().x/2,-1,1]){
            cube(pi_board_dims() + [2,2,-1]);
        }

        // micro-USB power and HDMI
        translate([24-(40/2), -100, -2]){
            cube([46,100,14]);
        }

        // micro-SD card cutout
        translate([-25,pi_board_dims().y/2-16,-10]){
            cube([30, sd_card_cutout_top() + 10, 16]);
        }
    }
}

module pi_hole_frame(){
    // This transform repeats objects at each hole in the pi PCB
    pi_frame(){
        translate([3.5,3.5]){
            repeat([58,0,0],2){
                repeat([0,49,0], 2){
                    children();
                }
            }
        }
    }
}

module pi_support_frame(){
    // position supports for each of the pi's mounting screws
    pi_frame(){
        translate([3.5,3.5,stand_bottom_thickness()-tiny()]){
            repeat([58,0,0],2){
                repeat([0,49,0], 2){
                    children();
                }
            }
        }
    }
}

module pi_supports(){
    // pillars into which the pi can be screwed (holes are hollowed out later)
    difference(){
        pi_support_frame(){
            cylinder(h=pi_standoff_h()+tiny(), d=7);
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

module feet_in_place(params, grow_r=1, grow_h=2){
    difference() {
        union(){
            each_actuator(params){
                translate_y(actuating_nut_r(params)){
                    minkowski(){
                        hull(){
                            outer_foot(params, lie_flat=false);
                        }
                        cylinder(r=grow_r, h=grow_h, center=true);
                    }
                }
            }
            translate_y(z_nut_y(params)){
                minkowski(){
                    hull(){
                        middle_foot(params,lie_flat=false);
                    }
                }
                cylinder(r=grow_r, h=grow_h, center=true);
            }
            translate([-9.3,60,0.1]){
                rotate_y(9){
                    rotate_x(-20){
                        cube([17.5,10,8]);
                    }
                }
            }
        }
        translate([-20,52,-15]){
            rotate_x(-25){
                translate_y(-30){
                    cube([40,30,30]);
                }
            }
        }
    }
}

module footprint(params){
    hull(){
        translate([-2, base_corner_y(params)]){
            square(4);
        }
        each_actuator(params){
            translate([0, actuating_nut_r(params)]){
                foot_footprint();
            }
        }
        translate([0, z_nut_y(params)]){
            foot_footprint(tilt=z_actuator_tilt(params));
        }
        offset(stand_wall_thickness()){
            pi_footprint();
        }
    }
}

module footprint_after_pi_cutouts(params){
    hull(){
        difference(){
            footprint(params);
            projection(){
                pi_connectors();
            }
        }
    }
}

module bucket_base_stackable(params, h){
    // The stackable "bucket" before holes and supports
    difference(){
        union(){
            sequential_hull(){
                linear_extrude(tiny()){
                    footprint(params);
                }
                translate_z(h-6){
                    linear_extrude(tiny()){
                        footprint(params);
                    }
                }
                translate_z(h-tiny()){
                    linear_extrude(stand_top_indent_depth()){
                        offset(stand_wall_thickness()){
                            footprint(params);
                        }
                    }
                }
            }

        }

        // hollow out the inside
        sequential_hull(){
            translate_z(stand_bottom_thickness()){
                linear_extrude(tiny()){
                    offset(-stand_wall_thickness()){
                        footprint(params);
                    }
                }
            }
            translate_z(h-10){
                linear_extrude(tiny()){
                    offset(-stand_wall_thickness()){
                        footprint(params);
                    }
                }
            }
            translate_z(h-tiny()){
                linear_extrude(tiny()){
                    difference(){
                        offset(-3.0){
                            footprint(params);
                        }
                        translate([-99, base_corner_y(params)+10-999]){
                            square(999);
                        }
                        each_actuator(params){
                            translate([-99, actuating_nut_r(params)-5]){
                                square(999);
                            }
                        }
                    }
                }
            }
            translate_z(h){
                linear_extrude(999){
                    footprint(params);
                }
            }
        }
    }
}

module top_casing_block(params, h, os=0, legs=true, lugs=true){
    // The "bucket" baseplate before holes and supports (i.e. a solid object)
    bottom = os<0?stand_bottom_thickness():0;
    top_h = os<0?tiny():stand_top_indent_depth();
    foot_height = key_lookup("foot_height", params);
    union(){
        sequential_hull(){
            // The bottom part has a slightly cropped footprint, so the bridge over the SD card
            // can be straight.
            translate_z(bottom){
                linear_extrude(tiny()){
                    offset(os){
                        footprint_after_pi_cutouts(params);
                    }
                }
            }
            translate_z(min(sd_card_cutout_top(), h)){
                linear_extrude(tiny()){
                    offset(os){
                        footprint_after_pi_cutouts(params);
                    }
                }
            }
            translate_z(h){
                linear_extrude(tiny()){
                    offset(os){
                        footprint(params);
                    }
                }
            }
        }
        hull_from(){
            translate_z(h){
                linear_extrude(2*tiny()){
                    offset(os){
                        footprint(params);
                    }
                }
            }
            translate_z(h+foot_height){
                linear_extrude(top_h){
                    offset(os*2+stand_wall_thickness()){
                        microscope_bottom(params, lugs=lugs, feet=false, legs=legs);
                    }
                }
            }
        }
        if (os<0){
            translate_z(h+foot_height){
                linear_extrude(2*stand_top_indent_depth()){
                    microscope_bottom(params, lugs=true);
                }
            }
        }
    }
}

module bucket_base_with_microscope_top(params, h){
    allow_space = 1.5;
    // A bucket base for the microscope, without cut-outs
    foot_height = key_lookup("foot_height", params);
    difference(){
        union(){
            difference(){
                top_casing_block(params, h=h, os=0, legs=true);

                difference(){
                    // we hollow out the casing, but not underneath the legs or lugs.
                    top_casing_block(params, h=h, os=-stand_wall_thickness(), legs=false, lugs=false);
                    for(hole_pos=base_mounting_holes(params)){
                        hull(){
                            // double-subtract under the mounting holes to make attachment points
                            translate(hole_pos+[0,0,h+foot_height-4]){
                                cylinder(r=4,h=4);
                            }
                            translate(hole_pos*1.2 + [0,0,h+foot_height-4-norm(hole_pos)*0.3]){
                                cylinder(r=4,h=4+norm(hole_pos)*0.3);
                            }
                        }
                    }
                }

            }
        }

        // cut-outs so the feet and legs can protrude downwards
        translate_z(h+foot_height){
            feet_in_place(params, grow_r=allow_space, grow_h=allow_space);
        }
        intersection(){
            translate_z(h+foot_height+allow_space){
                feet_in_place(params, grow_r=1.5*allow_space, grow_h=4*allow_space);
            }
            translate_z(h+foot_height){
                cylinder(r=999,h=999,$fn=4);
            }
        }
        translate_z(h+foot_height-allow_space){
            linear_extrude(999){
                offset(1.5){
                    microscope_legs(params);
                }
            }
        }
        for(hole_pos=base_mounting_holes(params)){
            if(hole_pos.x>0){
                reflect_x(){
                    // Note this is reflected so that the triangular holes work for both lugs.
                    // Otherwise the x<0 one snaps when you screw into it
                    translate(hole_pos+[0,0,h+foot_height]){
                        //TODO: Inprove better self-tapping holes or add nut trap.
                        cylinder(r=3/2*1.7,h=20,$fn=3, center=true);
                    }
                }
            }
        }
    }
}

module mounting_holes(params){
    // holes to mount the buckets together (stacking) or to a breadboard

    // holes at 3 corners to allow mounting to something underneath/stacking
    // NB the bottom hole is larger to allow for screwing through it, the top
    // is approximately "self tapping" (a triangular hole, to allow for some
    // space for swarf).
    mirror([1,0,0]){
        leg_frame(params, 45){
            translate_y(actuating_nut_r(params)){
                cylinder(d=4.4, h=20, center=true);
                rotate(90){
                    trylinder_selftap(3, h=999, center=true);
                }
            }
        }
    }
    // this hole is moved out of the way of the sd-card cutout
    leg_frame(params, 45){
        translate([-10, actuating_nut_r(params)-1, 0]){
            cylinder(d=4.4, h=20, center=true);
            rotate(90){
                trylinder_selftap(3, h=999, center=true);
            }
        }
    }
    translate_y(base_corner_y(params)+7){
        cylinder(d=4.4, h=20, center=true);
        rotate(30){
            trylinder_selftap(3, h=999, center=true);
        }
    }
}

module microscope_stand(params, h){
    // A stand for the microscope, with integrated Raspberry Pi

    foot_height = key_lookup("foot_height", params);
    difference(){
        union(){
            bucket_base_with_microscope_top(params, h);

            // supports for the pi circuit board
            pi_supports();
        }

        // shave some of the extra material off to make a nice bridge above sd card cutout
        //This is another ugly kludge, but needed for good bridge.
        //Same issue as the other side of the wall - you do not
        //know precisely the endpoints.  I fixed it the same way.
        //I made it work for my wall size, then interpolated.
        //It should be acceptably close for most sane wall sizes.
        pi_frame() {
            translate([-19.24,pi_board_dims().y/2-15.96,10+stand_bottom_thickness()]){
                rotate_z(-15-0.9*(2.35-stand_wall_thickness())){
                    rotate_y(-7){
                        translate_x(-11.5){
                            cube([11.5, 31.2, 27]);
                        }
                    }
                }
            }
        }

        // space for pi connectors
        translate_z(stand_bottom_thickness() + pi_standoff_h()){
            pi_connectors();
        }

        // holes for the pi go all the way through
        pi_support_frame(){
            trylinder_selftap(2.5, h=60, center=true);
        }

        mounting_holes(params);
        translate_z(h+foot_height){
            rotate_x(90){
                cylinder(d=30,h=999);
            }
        }

    }
}

module sangaboard_connectors(){
    //Create cutouts for sangaboard connectors
    pi_frame(){
        translate([pi_board_dims().x/2,-1,1]){
            cube(pi_board_dims() + [2,2,-1]);
        }
        translate([10, -99, -2]){
            cube([35,100,18]);
        }
    }
}

module sangaboard_support_frame(){
    // position supports for each of the sangaboard's mounting screws
    pi_frame(){
        translate([3.5,3.5,stand_bottom_thickness()-tiny()]){
            repeat([57,0,0],2){
                repeat([0,47,0], 2){
                    children();
                }
            }
        }
    }
}

module sangaboard_supports(){
    // pillars into which the pi can be screwed
    difference(){
        sangaboard_support_frame(){
            cylinder(h=pi_standoff_h()+tiny(), d=7);
        }
        // holes for the sangaboard go all the way through
        sangaboard_support_frame(){
            trylinder_selftap(3, h=999, center=true); //these screws are M2.5, not M3
        }
    }
}

module nano_supports(){

    nano_width = 18.0;
    nano_length = 43.0;
    driver_width = 32.0;
    driver_length = 35.0;
    driver_support = 4.0;


    support_positions=[[2.5,2.5,0],
                       [driver_width-2.5,2.5,0],
                       [driver_width+3.0,12.5,0],
                       [2*driver_width-2.0,12.5,0],
                       [2*driver_width+3.5,2.5,0],
                       [3*driver_width-1.5,2.5,0],
                       [2.5,driver_length-2.5,0],
                       [driver_width-2.5,driver_length-2.5,0],
                       [driver_width+3.0,driver_length+7.5,0],
                       [2*driver_width-2.0,driver_length+7.5,0],
                       [2*driver_width+3.5,driver_length-2.5,0],
                       [3*driver_width-1.5,driver_length-2.5,0]];

    for (pos = support_positions){
        pi_frame(){
            rotate_z(40){
                translate(pos + [5, -6, stand_bottom_thickness()-tiny()]){
                    difference(){
                        cylinder(h=driver_support+tiny(), d=7);
                        trylinder_selftap(3, h=999, center=true);
                    }
                }
            }
        }
    }


    //supports for an arduino nano
    difference(){
        //two posts with rounded tops and a base
        pi_frame(){
            rotate_z(40){
                translate([8.5,-21.5,stand_bottom_thickness()-tiny()]){
                    translate([49.5-nano_length/2,-6.5,0]){
                        cylinder(h=nano_width+2.4+tiny(), d=5);
                    }
                    translate([49.5-nano_length/2,-6.5,nano_width+2.4+tiny()]){
                        sphere(r=2.5);
                    }
                    translate([50.5+nano_length/2,-6.5,0]){
                        cylinder(h=nano_width+tiny()+2.4, d=5);
                    }
                    translate([50.5+nano_length/2,-6.5,nano_width+2.4+tiny()]){
                        sphere(r=2.5);
                    }
                    translate([49.5-nano_length/2,-9.0,0]){
                        cube([nano_length+1,5,2]);
                    }
                }
            }
        }

        pi_frame(){
            rotate_z(40){
                translate([8.5,-21.5,stand_bottom_thickness()-tiny()]) {
                    //carve out for nano board
                    hull(){
                        translate([52.1-nano_length/2,-9.5,2+tiny()]){
                            cube([nano_length-4.2,6,0.1]);
                        }
                        translate([49.8-nano_length/2,-9.5,5+tiny()]){
                            cube([nano_length+0.4,6,nano_width-5.6]);
                        }
                        translate([52.1-nano_length/2,-9.5,nano_width+2.3+tiny()]){
                            cube([nano_length-4.2,6,0.1]);
                        }
                    }
                    //carve out for usb module
                    hull(){
                        translate([39.8-nano_length/2,-12.5-1.7/2,nano_width-0.7+tiny()]){
                            cube([20,4.3,0.1]);
                        }
                        translate([39.8-nano_length/2,-12.5-1.7/2,7.5+tiny()]){
                            cube([20,6,nano_width-10.6]);
                        }
                        translate([39.8-nano_length/2,-12.5-1.7/2,5+tiny()]){
                            cube([20,4.3,0.1]);
                        }
                    }
                    //actual slot for the nano
                    translate([49.8-nano_length/2,-6.5-1.7/2,2+tiny()]){
                        cube([nano_length+0.4,1.7,nano_width+0.4]);
                    }
                }
            }
        }
    }
}

module motor_driver_case(params, driver_type, h){
    // A stackable "bucket" that holds the motor board under the microscope stand
    union(){
        difference(){
            bucket_base_stackable(params, h);
            // space for sangaboard connectors
            translate_z(stand_bottom_thickness()+pi_standoff_h()){
                sangaboard_connectors();
            }

            // motor cables
            translate([0,z_nut_y(params), h]){
                cube([20,50,15],center=true);
            }

            mounting_holes(params);
        }

        if(driver_type=="sangaboard"){
            sangaboard_supports();
        }
        if (driver_type=="arduino_nano"){
            nano_supports();
        }
    }
}


module thick_bottom_section(params, h, offset_d, center=false){
    hull(){
        linear_extrude(h, center=center){
            offset(offset_d){
                microscope_bottom(params, feet=true);
            }
        }
    }
}

module stand_lugs(params, h, pi_stand_h){
    lug_body_h = 9;
    lug_h = 20;
    lug_z = h-lug_h-3;

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
                            new_bucket(params, h, pi_stand_h);
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



module new_bucket(params, h, pi_stand_h){
    offset_d=1.5;
    wall_t=3.5;

    difference(){
        sequential_hull(){
            new_bucket_base_primative(params, 3);

            translate_z(pi_stand_h+5){
                new_bucket_base_primative(params, 3);
            }
            translate_z(pi_stand_h+10){
                thick_bottom_section(params, h-pi_stand_h-10, wall_t+offset_d);
            }
        }

        sequential_hull(){
            translate_z(2){
                new_bucket_base_primative(params, 1);
            }

            translate_z(pi_stand_h+5){
                new_bucket_base_primative(params, 1);
            }
            translate_z(pi_stand_h+11){
                thick_bottom_section(params, h-pi_stand_h-10, offset_d);
            }
        }
    }

}


module pi_stand_frame_xy(params, primative=false){
    initial_pos = primative ? [0,0,0] : [5,0,2];
    translate([28, -38, 0]){
        rotate(-y_wall_angle(params)){
            translate(initial_pos){
                children();
            }
        }
    }
}

//Prototyping of new stand.
//TODO remove this befoe release
//to_print();
//rendered();

module new_bucket_base_primative(params, ex_rad=3){
    pi_base_size = pi_stand_base_size();
    pi_block_size = [pi_base_size.x, pi_base_size.y, tiny()];
    minkowski(){
        hull(){
            reflect_x(){
                pi_stand_frame_xy(params, primative=true){
                    cube(pi_block_size);
                }
            }
        }
        cylinder(r=ex_rad, h=tiny());
    }
}



module new_stand(params, pi_stand_h){
    h=73;

    stand_lugs(params, h, pi_stand_h);

    pi_base_size = pi_stand_base_size();
    extra_space = [1.5, 1.5, 1.5];
    pi_cutout_size = [pi_base_size.x, pi_base_size.y, pi_stand_h] + extra_space;

    difference(){
        new_bucket(params, h, pi_stand_h);
        pi_stand_frame_xy(params){
            translate(-extra_space/2){
                cube(pi_cutout_size);
            }
            translate([5, -50, 2]){
                cube([60, 100, 15]);
            }
        }
    }
}


//TODO remove this befoe release
module to_print(){
    params = default_params();
    pi_stand_h = 42;
    new_stand(params, pi_stand_h);
    //pi_stand(pi_stand_h);
}

//TODO remove this befoe release
module rendered(){
    params = default_params();
    pi_stand_h = 42;
    color("#505050"){
        render(6){
            new_stand(params, pi_stand_h);
        }
    }
    color("Dodgerblue"){
        render(6){
            pi_stand_frame_xy(params){
                pi_stand(pi_stand_h);
            }
        }
    }
}


function pi_stand_board_inset() = [3, 3, 0];
function pi_stand_thickness() = 2;
function pi_stand_base_size() = let(
    t = pi_stand_thickness(),
    board_size = [pi_board_dims().x, pi_board_dims().y, t]
) board_size + 2 * pi_stand_board_inset();

module pi_stand(h=50){
    hole_inset = [3.5, 3.5, 0];
    board_inset = pi_stand_board_inset();
    standoff_h = 4.5;
    wall_t = board_inset.x-.5;

    function pi_holes() = [[0, 0, 0]+hole_inset+board_inset,
                           [58, 0, 0]+hole_inset+board_inset,
                           [0, 49, 0]+hole_inset+board_inset,
                           [58, 49, 0]+hole_inset+board_inset];

    base_size = pi_stand_base_size();

    difference(){
        union(){
            cube(base_size);
            for (hole = pi_holes()){
                translate(hole){
                    cylinder(d=5.5, h=standoff_h, $fn=12);
                }
            }
            cube([base_size.x, wall_t, h]);
            translate_x(base_size.x- (wall_t)){
                cube([wall_t, base_size.y, h]);
            }
        }
        for (hole = pi_holes()){
            translate(hole){
                cylinder(d=2.5, h=99, center=true, $fn=3);
            }
        }
        translate(board_inset+ [0, 0, standoff_h+1]){
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
