use <./libs/microscope_parameters.scad>
use <./libs/lib_microscope_stand.scad>
use <../openscad/libs/utilities.scad>

nano_converter_plate();

module nano_converter_plate(){
    params = default_params();
    inset = pi_stand_board_inset();
    width = pi_stand_front_width()-inset.y;

    usb_height = pi_stand_standoff_h() + 17;
    // Plate thickness should be thick enough that the USB cut-out does not go
    // through the board.
    thickness = usb_height - sanga_stand_height() + 2;
    size = [pi_board_dims().x, width, thickness];

    mount_hole = zero_z(pi_stand_block_hole_pos())-inset;
    hole_positions = [pi_hole_pos()[0], pi_hole_pos()[1], mount_hole];

    difference(){
        union(){
            cube(size);
        }
        for (hole = hole_positions){
            translate(hole + [0, 0, 1.5]){
                no2_selftap_counterbore();
            }
        }
        translate([size.x-18, 1.5, -2]){
            cube([19, 15, thickness]);
        }
        translate([size.x-18, 19.5, -2]){
            cube([19, 15, thickness]);
        }
        translate([size.x-22, 37, -2]){
            cube([23, 18, thickness]);
        }
        translate_x(sanga_connector_x()){
            cube([8,18,20], center=true);
            translate([-19/2, 0, 3.5]){
                cube([19, 44.5, 20]);
            }
            translate_y(40.8){
                cube([9, 6, 20], center=true);
            }
            translate_y(25.8){
                cube([8, 6, 20], center=true);
            }
        }
        motor_brd_size = zc_a0591_size();
        translate_x(size.x-motor_brd_size.x){
            zc_a0591_board_holes([0,1,2]);
        }
        translate([size.x, motor_brd_size.x, 0]){
            rotate_z(90){
                zc_a0591_board_holes([0,1,3]);
            }
        }
        translate([size.x-motor_brd_size.y, motor_brd_size.x, 0]){
            rotate_z(90){
                zc_a0591_board_holes();
            }
        }
    }
}

function zc_a0591_size() = [34.5, 32, 1.6];

module zc_a0591_board_holes(holes = [0, 1, 2, 3]){
    board_size = zc_a0591_size();
    hole_inset = 2.3;
    all_hole_pos = [[hole_inset, hole_inset, 0],
                    [hole_inset, board_size.y-hole_inset, 0],
                    [board_size.x-hole_inset, hole_inset, 0],
                    [board_size.x-hole_inset, board_size.y-hole_inset, 0]];
    hole_pos = [for (i=holes) all_hole_pos[i]];
    for (pos = hole_pos){
        translate(pos){
            cylinder(d=2.7, h=99, center=true, $fn=3);
        }
    }
}
