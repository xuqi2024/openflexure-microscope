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
    thickness = usb_height - sanga_stand_height() + 1; 
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
        translate([size.x-18, 1.5, -1]){
            cube([19, 15, thickness]);
        }
        translate([size.x-18, 19.5, -1]){
            cube([19, 15, thickness]);
        }
        translate([size.x-22, 37, -1]){
            cube([23, 18, thickness]);
        }
        translate([-1, -1, 1.6]){
            cube(size + [-35 ,2, 0]);
        }
    }
}
