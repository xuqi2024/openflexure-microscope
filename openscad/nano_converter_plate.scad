use <./libs/lib_microscope_stand.scad>
use <./libs/libdict.scad>
use <../openscad/libs/utilities.scad>

exterior_brim(smooth_r = 5){
    nano_converter_plate_stl();
}

module nano_converter_plate_stl(){
    nano_converter_plate();
}

function nano_converter_plate_size() = let(
    inset = electronics_drawer_board_inset(),
    width = electronics_drawer_front_width()-inset.y,
    // Plate thickness should be thick enough that the USB cut-out does not go
    // through the board.
    usb_height = electronics_drawer_standoff_h() + 17,
    thickness = usb_height - sanga_stand_height() + 2
) [pi_board_dims().x, width, thickness];

module nano_converter_plate(){

    size = nano_converter_plate_size();

    mount_hole = zero_z(electronics_drawer_block_hole_pos())-electronics_drawer_board_inset();
    mount_hole_positions = [pi_hole_pos()[0], pi_hole_pos()[1], mount_hole];

    difference(){
        union(){
            cube(size);
            // additional cube in -x direction for wall around Pico
            translate_x(-2){
                cube([4,size.y,size.z]);
            }
            translate_z(size.z-tiny()){
                nano_conv_plate_zc_a0591_mounts("standoff");
            }
        }
        for (hole = mount_hole_positions){
            translate(hole + [0, 0, 1.5]){
                no2_selftap_counterbore();
            }
        }

        nano_conv_plate_pi_port_cutout();
        translate_x(sanga_connector_x(sanga_version="v0.4")){
            nano_conv_plate_nano_cutout();
        }
        translate_z(0.5){
            nano_conv_plate_zc_a0591_mounts();
        }
    }
}

module nano_conv_plate_zc_a0591_mounts(type="hole"){
    assert(is_in(type, ["standoff", "hole"]), "Mount type must be standoff or hole");
    translate(zc_a0591_pos(board_no=1)){
        hole_nos = (type=="hole") ? [0,1] : [0,1,2,3];
        zc_a0591_board_mounts(type, hole_nos=hole_nos);
    }

    translate(zc_a0591_pos(board_no=2)){
        rotate_z(90){
            hole_nos = (type=="hole") ? [1,3] : [0,1,2,3];
            zc_a0591_board_mounts(type, hole_nos=hole_nos);
        }
    }
    translate(zc_a0591_pos(board_no=3)){
        rotate_z(90){
            hole_nos = (type=="hole") ? [0,2,3] : [0,1,2,3];
            zc_a0591_board_mounts(type, hole_nos=hole_nos);
        }
    }
}

module nano_conv_plate_pi_port_cutout(){
    size = nano_converter_plate_size();
    translate([size.x-18, 1.5, -2]){
        cube([19, 15, size.z]);
    }
    translate([size.x-18, 19.5, -2]){
        cube([19, 15, size.z]);
    }
    translate([size.x-22, 37, -2]){
        cube([23, 18, size.z]);
    }
}

//A cutout for an upside down arduino nano.
module nano_conv_plate_nano_cutout(){
    difference(){
        union(){
            cube([8,18,20], center=true);
            translate([-19/2, -tiny(), 3.5]){
                cube([19, 44.5, 20]);
            }
            translate_y(40.8){
                cube([9, 6, 20], center=true);
            }
            translate_y(25.8){
                cube([8, 6, 20], center=true);
            }
            translate_y(55){
                no2_selftap_hole(h=99, center=true);
            }
            // RaspberryPi Pico additions
            translate([-22/2, -tiny(), 4]){
                cube([22, 52, 20]);
            }
            translate_y(47){
                cube([9, 10, 20], center=true);
            }
            translate([-4,12.5-tiny(),6.5]){
                cube([6, 7, 10], center=true);
                cube([4, 5, 20], center=true);
            }
        }
        union(){
            // a break-off bit to support back of a nano
            translate([-24/2, 44.5, 4.75]){
                cube([24, 1, 1]);
            }
            translate([-24/2, 50, 4.75]){
                cube([24, 1, 1]);
            } 
            translate([-18/2, 44.5, 5.75-tiny()]){
                cube([18, 6.5, 10]);
            }
            hull(){
                translate([-7/2, 44.5, 3.5]){
                   cube([7, 6.5, 10]);
                }
                translate([0, 44.5+6.5/2, 0]){
                    $fn=12;
                    cylinder(d=6.5, h=tiny());
                }
            } 
        }
    }
}

function zc_a0591_size() = [34.5, 32, 1.6];

function zc_a0591_pos(board_no) =
    assert(is_in(board_no, [1,2,3]), "Invalid a valid zc_a0591 board number provided")
    let(
        size = nano_converter_plate_size(),
        motor_brd_size = zc_a0591_size(),
        positions = [[size.x-motor_brd_size.x, 0, 0],
                     [size.x, motor_brd_size.x, 0],
                     [size.x-motor_brd_size.y, motor_brd_size.x, 0]]
    ) positions[board_no - 1];


module zc_a0591_board_mounts(type="hole", hole_nos = [0, 1, 2, 3]){
    assert(is_in(type, ["standoff", "hole"]), "Mount type must be standoff or hole");
    board_size = zc_a0591_size();
    hole_inset = 2.3;
    all_hole_pos = [[hole_inset, hole_inset, 0],
                    [hole_inset, board_size.y-hole_inset, 0],
                    [board_size.x-hole_inset, hole_inset, 0],
                    [board_size.x-hole_inset, board_size.y-hole_inset, 0]];
    hole_pos = [for (i=hole_nos) all_hole_pos[i]];
    for (pos = hole_pos){
        translate(pos){
            if (type == "hole"){
                no2_selftap_hole(h=99, center=false);
            }
            else{
                cylinder(d=4.5, h=1.8, center=false, $fn=12);
            }
        }
    }
}
