
use <../openscad/libs/main_body_structure.scad>
use <../openscad/libs/z_axis.scad>
use <librender/assembly_parameters.scad>
use <librender/render_utils.scad>
use <librender/render_settings.scad>
use <librender/tools.scad>
use <rms_optics_assembly.scad>
use <actuator_assembly.scad>


FRAME = 8;

render_mount_optics(FRAME);

module render_mount_optics(frame){
    if (frame==1){
        om_pos = translate_pos(optics_module_pos(), [0, -10, -100]);
        line_end = translate_pos(optics_module_pos(), [0, -10, 50]);
        construction_line(om_pos, line_end,.2);
        rendered_optics_module(om_pos, screw_tight=false);
        body_with_assembled_actuators();
    }
    else if (frame==2){
        om_pos = translate_pos(optics_module_pos(), [0, -10, -6.5]);
        rendered_optics_module(om_pos, screw_tight=false);
        body_with_assembled_actuators();
    }
    else if (frame==3){
        om_pos = translate_pos(optics_module_pos(), [0, -10, -6.5]);
        rendered_z_mount();
        rendered_optics_module(om_pos, screw_tight=false);
        body_with_assembled_actuators(translucent_body=true);
    }
    else if (frame==4){
        om_pos = translate_pos(optics_module_pos(), [0, -4, -6.5]);
        rendered_z_mount();
        rendered_optics_module(om_pos, screw_tight=false);
        body_with_assembled_actuators(translucent_body=true);
    }
    else if (frame==5){
        om_pos = translate_pos(optics_module_pos(), [0, -4, -6.5]);
        ak_pos = translate_pos(optics_module_allen_key_pos(), [0, 0, -6.5]);
        place_part(ak_pos){
            allen_key_2_5(30);
        }
        rendered_z_mount();
        rendered_optics_module(om_pos, screw_tight=false);
        body_with_assembled_actuators(translucent_body=true);
    }
    else if (frame==6){
        om_pos = translate_pos(optics_module_pos(), [0, -4, 0]);
        place_part(optics_module_allen_key_pos()){
            allen_key_2_5(30);
        }
        rendered_z_mount();
        rendered_optics_module(om_pos, screw_tight=false);
        body_with_assembled_actuators(translucent_body=true);
    }
    else if (frame==7){
        place_part(optics_module_allen_key_pos()){
            allen_key_2_5(-30, clockwise_arrow=true);
        }
        rendered_z_mount();
        rendered_optics_module(optics_module_pos(), screw_tight=true);
        body_with_assembled_actuators(translucent_body=true);
    }
    else if (frame==8){
        body_with_optics();
    }
}

module body_with_optics(translucent_body=false){
    rendered_optics_module(optics_module_pos(), screw_tight=true);
    body_with_assembled_actuators(translucent_body=translucent_body);
}

module rendered_z_mount(){
    params = render_params();
    coloured_render(body_colour()){
        z_axis_flexures(params);
        z_axis_struts(params);
        objective_mount(params);
    }
}