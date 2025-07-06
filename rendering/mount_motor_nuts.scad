use <../openscad/libs/microscope_parameters.scad>
use <../openscad/libs/utilities.scad>
use <../openscad/libs/gears.scad>
use <../openscad/libs/wall.scad>
use <../openscad/libs/main_body_transforms.scad>
use <../openscad/libs/z_axis.scad>
use <../openscad/libs/main_body_structure.scad>
use <../openscad/cable_tidies.scad>
use <../openscad/libs/libdict.scad>
use <librender/assembly_parameters.scad>
use <librender/render_utils.scad>
use <librender/hardware.scad>
use <mount_illumination.scad>
use <mount_microscope.scad>
use <mount_upright_optics.scad>
use <motor_assembly.scad>

FRAME = 28;
OPTICS_VERSION = "upright";
render_mount_motor_nuts(FRAME, OPTICS_VERSION);

module render_mount_motor_nuts(frame, optics_version="rms"){
    if (frame == 1){
        assembled_microscope_without_motors(optics_version=optics_version,
                                            explode=true);
    }
    else if (frame == 2){
        assembled_microscope_without_motors(optics_version=optics_version,
                                            explode=false);
    }
}

assembled_microscope_without_motors(optics_version="upright",
                                    manual=false,
                                    explode=true
                                    );

// This module will add nuts for the motors for a motorised version, but will pass through a manual version unchanged 
module assembled_microscope_without_motors(optics_version="rms",
                                           manual=false,
                                           explode=false,
                                           post=false){
    params = render_params();
    if (!manual){
        mounted_microscope_frame(){
            y_motor_nuts(params, exploded=explode);
            reflect_x(){
                y_motor_nuts(params, exploded=explode);
            }
            z_motor_nuts(params, optics_version, exploded=explode);
        }
    }
    if (optics_version == "upright"){
        mounted_microscope_upright_with_optics(optics_version=optics_version, manual=manual);
    }
    else{
        mounted_microscope_with_illumination(optics_version=optics_version, manual=manual, post=post);
    }
}

module y_motor_nuts(params, exploded=false){
    actuator_h = key_lookup("actuator_h", params);
    explode_unit = exploded ? [-5, 0, -2.5] : [0, 0, 0];
    y_actuator_frame(params){
        reflect_x(){
            translate_z(y_motor_z_pos(params)-7.5)translate(explode_unit){
                place_part(motor_screw_pos()){
                    m3_nut();
                }
            }
        }
    }
}

module z_motor_nuts(params, optics_version="rms", exploded=false){
    z_connector_pos = is_undef(connector_pos) ? z_connector_pos() : connector_pos;
    z_cable_pos = is_undef(cable_pos) ? z_cable_verticies() : cable_pos;
    explode_unit = exploded ? [-5, 0, -2.5] : [0, 0, 0];

    motor_placement = (optics_version=="upright") ? locate_on_upright(): create_placement_dict([0,0,0]);
    place_part(motor_placement){
        z_cable_tidy_frame(params){
            reflect_x(){
                translate(explode_unit){
                    place_part(motor_screw_pos()+[0, 0, -7.5]){
                        m3_nut();
                    }
                }
            }
        }
    }
}
