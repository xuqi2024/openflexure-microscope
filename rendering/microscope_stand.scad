
use <../openscad/libs/utilities.scad>
use <../openscad/libs/microscope_parameters.scad>
use <../openscad/libs/lib_microscope_stand.scad>
use <../openscad/nano_converter_plate.scad>
use <./librender/electronics.scad>
use <./librender/assembly_parameters.scad>
use <./librender/render_utils.scad>
use <./librender/render_settings.scad>
use <./librender/hardware.scad>
use <mount_motors.scad>

microscope_stand_rendered();


module microscope_stand_rendered(use_nano=false){
    params = render_params();
    
    slide = true;
    slide_dist = slide ? 90 : 0;
    rendered_pi_stand(params, use_nano=use_nano, slide_dist=slide_dist);

    pi_stand_frame_xy(params){
        translate(pi_stand_front_nut_trap_pos()){
            rotate_y(90){
                m3_nut();
            }
        }
        translate(pi_stand_side_screw_pos()){
            rotate_x(90){
                m3_cap_x8();
            }
        }
        
        translate(pi_stand_front_screw_pos()){
            rotate_y(90){
                m3_cap_x8();
            }
        }
    }
    connector_positions = [x_connector_pos_board(params),
                           y_connector_pos_board(params),
                           z_connector_pos_board(params)];
    connector_positions_out = [x_connector_pos_board_out(params, slide_dist),
                               y_connector_pos_board_out(params, slide_dist),
                               z_connector_pos_board_out(params, slide_dist)];
    con_pos = slide ? connector_positions_out : connector_positions;

    cable_positions = [y_cable_verticies(slide), y_cable_verticies(slide), z_cable_verticies(slide)];

    assembled_microscope_without_electronics(connector_positions=con_pos, cable_positions=cable_positions);
}



module rendered_pi_stand(params, use_nano=false, slide_dist=0){
    stand_params = default_stand_params();
    coloured_render(extras_colour()){
        pi_stand_frame_xy(params, slide_dist=slide_dist){
            pi_stand(stand_params);
        }
    }
    pi_stand_frame_xy(params, slide_dist=slide_dist){
        inset = pi_stand_board_inset();
        pi_pos = inset + [0, 0, pi_stand_standoff_h()] ;
        sanga_pos = inset + [0, 0, sanga_stand_height()];
        translate(pi_pos){
            rpi_4b();
        }

        translate(sanga_pos){
            if (use_nano){
                coloured_render(extras_colour()){
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
        
    }
}
