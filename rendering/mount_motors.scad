


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
use <mount_upright_optics.scad>
use <motor_assembly.scad>

FRAME=3;
OPTICS_VERSION = "upright";
render_mount_motors(FRAME, OPTICS_VERSION);

module render_mount_motors(frame, optics_version="rms"){
    if (frame == 1){
        assembled_microscope_without_electronics(optics_version=optics_version,
                                                 xy_motor=true,
                                                 z_motor=false,
                                                 explode="xy");
    }
    else if(frame == 2){
        assembled_microscope_without_electronics(optics_version=optics_version, explode="z");
    }
    else if(frame == 3){
        assembled_microscope_without_electronics(optics_version=optics_version);
    }
}


module assembled_microscope_without_electronics(optics_version="rms",
                                                xy_motor=true,
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
            if (optics_version == "upright"){
                z_motor_and_cap(params,
                                optics_version=optics_version,
                                exploded=exploded,
                                connector_pos=connector_positions.z,
                                cable_pos=cable_positions.z,
                                cap=false);
            }
            else{
                z_motor_and_cap(params,
                                optics_version=optics_version,
                                exploded=exploded,
                                connector_pos=connector_positions.z,
                                cable_pos=cable_positions.z,
                                cap=true);
            }
        }
    }
    if (optics_version == "upright"){
        mounted_microscope_upright_with_optics(optics_version=optics_version);
    }
    else{
        mounted_microscope_with_illumination(optics_version=optics_version);
    }
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

module z_motor_and_cap(params, optics_version="rms", exploded=false, connector_pos=undef, cable_pos=undef, cap=false){
    z_connector_pos = is_undef(connector_pos) ? z_connector_pos() : connector_pos;
    z_cable_pos = is_undef(cable_pos) ? z_cable_verticies() : cable_pos;
    explode_unit = exploded ? 10 : 0;

    if (cap){
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
    }
    motor_placement = (optics_version=="upright") ? locate_on_upright(): create_placement_dict([0,0,0]) ; 
    place_part(motor_placement){
    z_cable_tidy_frame(params){
        translate_z(explode_unit){
            motor_with_gear(z_motor_pos(), z_connector_pos, z_cable_pos);
        }
        tight_screw = cap ? 0 : -1.5 ;
        translate_z(3*explode_unit + tight_screw){
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
}