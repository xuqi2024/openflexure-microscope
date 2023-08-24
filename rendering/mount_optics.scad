
use <../openscad/libs/main_body_structure.scad>
use <../openscad/libs/z_axis.scad>
use <../openscad/libs/optics_configurations.scad>
use <librender/assembly_parameters.scad>
use <librender/render_utils.scad>
use <librender/render_settings.scad>
use <librender/tools.scad>
use <rms_optics_assembly.scad>
use <low_cost_optics_assembly.scad>
use <actuator_assembly.scad>
use <upright_condenser_assembly.scad>

FRAME = 8;
OPTICS_VERSION = "rms";

render_mount_optics(FRAME, OPTICS_VERSION);

module render_mount_optics(frame, optics_version){
    low_cost = (optics_version == "low_cost")? true : false ;
    if (frame==1){
        om_pos = translate_pos(optics_module_pos(low_cost), [0, -10, -100]);
        line_end = translate_pos(optics_module_pos(low_cost), [0, -10, 50]);
        construction_line(om_pos, line_end,.2);
        render_optics(optics_version, om_pos, screw_tight=false);
        body_with_assembled_actuators();
    }
    else if (frame==2){
        om_pos = translate_pos(optics_module_pos(low_cost), [0, -10, -6.5]);
        render_optics(optics_version, om_pos, screw_tight=false);
        body_with_assembled_actuators();
    }
    else if (frame==3){
        om_pos = translate_pos(optics_module_pos(low_cost), [0, -10, -6.5]);
        rendered_z_mount();
        render_optics(optics_version, om_pos, screw_tight=false);
        body_with_assembled_actuators(translucent_body=true);
    }
    else if (frame==4){
        om_pos = translate_pos(optics_module_pos(low_cost), [0, -4, -6.5]);
        rendered_z_mount();
        render_optics(optics_version, om_pos, screw_tight=false);
        body_with_assembled_actuators(translucent_body=true);
    }
    else if (frame==5){
        om_pos = translate_pos(optics_module_pos(low_cost), [0, -4, -6.5]);
        ak_pos = translate_pos(optics_module_allen_key_pos(), [0, 0, -6.5]);
        place_part(ak_pos){
            allen_key_2_5(30);
        }
        rendered_z_mount();
        render_optics(optics_version, om_pos, screw_tight=false);
        body_with_assembled_actuators(translucent_body=true);
    }
    else if (frame==6){
        om_pos = translate_pos(optics_module_pos(low_cost), [0, -4, 0]);
        place_part(optics_module_allen_key_pos()){
            allen_key_2_5(30);
        }
        rendered_z_mount();
        render_optics(optics_version, om_pos, screw_tight=false);
        body_with_assembled_actuators(translucent_body=true);
    }
    else if (frame==7){
        place_part(optics_module_allen_key_pos()){
            allen_key_2_5(-30, clockwise_arrow=true);
        }
        rendered_z_mount();
        render_optics(optics_version, optics_module_pos(low_cost), screw_tight=true);
        body_with_assembled_actuators(translucent_body=true);
    }
    else if (frame==8){
        body_with_optics(optics_version);
    }
}

module render_optics(optics_version="rms", om_pos=undef, screw_tight=false,  cable_positions=undef){
    if (optics_version == "low_cost"){
        params = render_params();
        optics_config = pilens_config();
        cable_pos = is_undef(cable_positions) ?
            curled_ribbon_pos(low_cost=true, params=params, optics_config=optics_config) :
            cable_positions;
        rendered_low_cost_optics(om_pos, screw_tight=screw_tight, cable_positions=cable_pos);
    }
    else if (optics_version == "rms"){
        cable_pos = is_undef(cable_positions) ? curled_ribbon_pos() : cable_positions;
        rendered_optics_module(om_pos, screw=true, screw_tight=screw_tight, cable_positions=cable_pos);
    }
    else if (optics_version == "upright"){
        place_part(om_pos){
            completed_upright_condenser(explode="none", nut=true, screw=true, screw_tight=screw_tight);
        }

    }
}

module body_with_optics(optics_version="rms", translucent_body=false){
    low_cost = (optics_version == "low_cost")? true : false ;
    render_optics(optics_version, optics_module_pos(low_cost), screw_tight=true);
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
