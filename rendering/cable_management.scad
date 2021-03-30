



use <../openscad/libs/utilities.scad>
use <../openscad/libs/gears.scad>
use <../openscad/libs/wall.scad>
use <../openscad/libs/main_body_transforms.scad>
use <../openscad/libs/z_axis.scad>
use <../openscad/main_body.scad>
use <../openscad/cable_tidies.scad>

use <librender/assembly_parameters.scad>
use <librender/electronics.scad>
use <librender/render_utils.scad>

rendered();

module rendered(){
    params = render_params();
    coloured_render("WhiteSmoke"){
        main_body(params);
    }

    y_motor_pos = create_placement_dict([0,20,y_motor_z_pos(params)],[0, 0, 180]);
    y_connector_pos = create_placement_dict([-22,-13,-43], [0,0,y_wall_angle(params)-45]);
    y_cable_verticies = [[0,-10,45],[-22,-13,45]];

    z_motor_pos = create_placement_dict([0,20,0],[0, 0, 180]);
    z_connector_pos = create_placement_dict([-27,3,-86], [0,0,-15]);
    z_cable_verticies = [[0,-10,3],[-27,0,3]];

    reflect_x(){
        coloured_render("DodgerBlue"){
            translate_z(32.5){
                y_actuator_frame(params){
                    large_gear();
                }
            }
        }


        y_actuator_frame(params){
            motor28BYJ48(y_motor_pos, y_connector_pos, y_cable_verticies);
        }

        coloured_render("DodgerBlue"){
            translate_z(side_housing_h(params)){
                side_cable_tidy(params);
            }
        }
    }


    coloured_render("DodgerBlue"){
        front_cable_tidy(params);
        z_cable_tidy_frame(params, z_extra=-11){
            large_gear();
        }
    }

    z_cable_tidy_frame(params){
        motor28BYJ48(z_motor_pos, z_connector_pos, z_cable_verticies);
    }

}