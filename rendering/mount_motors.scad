


use <../openscad/libs/microscope_parameters.scad>
use <../openscad/libs/utilities.scad>
use <../openscad/libs/gears.scad>
use <../openscad/libs/wall.scad>
use <../openscad/libs/main_body_transforms.scad>
use <../openscad/libs/z_axis.scad>
use <../openscad/libs/main_body_structure.scad>
use <../openscad/cable_tidies.scad>
use <librender/assembly_parameters.scad>
use <librender/render_utils.scad>
use <librender/hardware.scad>
use <mount_illumination.scad>
use <mount_microscope.scad>
use <motor_assembly.scad>

FRAME=3;
render_mount_motors(FRAME);

module render_mount_motors(frame){
    if (frame == 1){
        assembled_microscope_without_electronics(xy_motor=true, z_motor=false, explode="xy");
    }
    else if(frame == 2){
        assembled_microscope_without_electronics(explode="z");
    }
    else if(frame == 3){
        assembled_microscope_without_electronics();
    }
}


module assembled_microscope_without_electronics(xy_motor=true,
                                                z_motor=true,
                                                explode=undef,
                                                connector_positions=[undef, undef, undef],
                                                cable_positions=[undef, undef, undef]){
    params = render_params();

    mounted_microscope_frame(){
        if (xy_motor){
            exploded = explode == "xy";
            mirror([1, 0, 0]){
                y_motor_and_cap(params,
                                exploded=exploded,
                                connector_pos=connector_positions.x,
                                cable_pos=cable_positions.x,
                                mirror_connector=true);
            }
            y_motor_and_cap(params,
                            exploded=exploded,
                            connector_pos=connector_positions.y,
                            cable_pos=cable_positions.y);
        }

        if (z_motor){
            exploded = explode == "z";
            z_motor_and_cap(params,
                            exploded=exploded,
                            connector_pos=connector_positions.z,
                            cable_pos=cable_positions.z);
        }
    }
    mounted_microscope_with_illumination();
}

module y_motor_and_cap(params, exploded=false, connector_pos=undef, cable_pos=undef, mirror_connector=false){
    y_connector_pos = is_undef(connector_pos) ? y_connector_pos(params) : connector_pos;
    y_cable_pos = is_undef(cable_pos) ? y_cable_verticies() : cable_pos;
    explode_unit = exploded ? 10 : 0;
    y_actuator_frame(params){
        translate_z(explode_unit){
            motor_with_gear(y_motor_pos(params),
                            y_connector_pos,
                            y_cable_pos,
                            mirror_connector=mirror_connector);
        }

        translate_z(y_motor_z_pos(params) + 3*explode_unit){
            reflect_x(){
                place_part(motor_screw_pos()){
                    m4_button_x6();
                    if (exploded){
                        construction_line([0, 0, 0], [0, 0, -4*explode_unit], 0.2);
                    }
                }
            }
        }
    }

    coloured_render("DodgerBlue"){
        translate_z(side_housing_h(params)+2*explode_unit){
            side_cable_tidy(params);
        }
    }
    
}

module z_motor_and_cap(params, exploded=false, connector_pos=undef, cable_pos=undef){
    z_connector_pos = is_undef(connector_pos) ? z_connector_pos() : connector_pos;
    z_cable_pos = is_undef(cable_pos) ? z_cable_verticies() : cable_pos;
    explode_unit = exploded ? 10 : 0;

    coloured_render("DodgerBlue"){
        if (exploded){
            z_cable_tidy_frame(params, 2*explode_unit){
                z_cable_tidy_frame_undo(params){
                    front_cable_tidy(params);
                }
            }
        }
        else{
            front_cable_tidy(params);
        }
    }
    
    z_cable_tidy_frame(params){
        translate_z(explode_unit){
            motor_with_gear(z_motor_pos(), z_connector_pos, z_cable_pos);
        }
        translate_z(3*explode_unit){
            reflect_x(){
                place_part(motor_screw_pos()){
                    m4_button_x6();
                    if (exploded){
                        construction_line([0, 0, 0], [0, 0, -4*explode_unit], 0.2);
                    }
                }
            }
        }
    }
}