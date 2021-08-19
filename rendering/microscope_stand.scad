
use <../openscad/libs/utilities.scad>
use <../openscad/libs/microscope_parameters.scad>
use <../openscad/libs/lib_microscope_stand.scad>
use <../openscad/nano_converter_plate.scad>
use <./librender/electronics.scad>
use <./librender/render_utils.scad>
use <./librender/hardware.scad>

microscope_stand_rendered();


module microscope_stand_rendered(use_nano=false){
    params = default_params();
    pi_stand_h = 42;
    coloured_render("#505050"){
        microscope_stand(params, pi_stand_h);
    }
    coloured_render("Dodgerblue"){
        pi_stand_frame_xy(params){
            pi_stand(pi_stand_h);
        }
    }
    pi_stand_frame_xy(params){
        inset = pi_stand_board_inset();
        pi_pos = inset + [0, 0, pi_stand_standoff_h()] ;
        sanga_pos = inset + [0, 0, sanga_stand_height()];
        translate(pi_pos){
            rpi_4b();
        }

        translate(sanga_pos){
            if (use_nano){
                coloured_render("Dodgerblue"){
                    nano_converter_plate();
                }
            }
            else{
                sangaboard_v0_4();
            }
        }

        translate_z(sangaboard_v0_4_dims().z){
            translate(sanga_pos + pi_hole_pos()[0]){
                no2_x6_5_selftap();
            }
            translate(sanga_pos + pi_hole_pos()[1]){
                no2_x6_5_selftap();
            }
            if (use_nano){
                block_hole_pos = pi_stand_block_hole_pos();
                plate_screw_pos = [block_hole_pos.x, block_hole_pos.y, sanga_pos.z];
                translate(plate_screw_pos){
                    no2_x6_5_selftap();
                }
            }
        }
        translate_z(pi_board_dims().z){
            translate(pi_pos + pi_hole_pos()[2]){
                no2_x6_5_selftap();
            }
            translate(pi_pos + pi_hole_pos()[3]){
                no2_x6_5_selftap();
            }
        }
        translate(pi_stand_side_nut_trap_pos()){
            rotate_x(90){
                rotate_z(30){
                    m3_nut();
                }
            }
        }
        translate(pi_stand_side_screw_pos()){
            rotate_x(90){
                m3_cap_x8();
            }
        }
        translate(pi_stand_front_nut_trap_pos()){
            rotate_y(90){
                m3_nut();
            }
        }
        translate(pi_stand_front_screw_pos()){
            rotate_y(90){
                m3_cap_x8();
            }
        }
    }
}