use <../openscad/libs/illumination.scad>
use <../openscad/libs/utilities.scad>
use <librender/render_settings.scad>
use <librender/render_utils.scad>
use <librender/assembly_parameters.scad>
use <librender/hardware.scad>
use <mount_microscope.scad>
use <condenser_assembly.scad>

FRAME = 5;
mount_illumination(FRAME);

module mount_illumination(frame){
    
    if (frame == 1){
        mounted_microscope_frame(){
            rendered_illumination_dovetail_assembly(exploded=true);
        }
        mounted_microscope();
    }
    else if (frame == 2){
        mounted_microscope_frame(){
            rendered_illumination_dovetail_assembly();
        }
        mounted_microscope();
    }
    else if (frame == 3){
        mounted_microscope_frame(){
            rendered_illumination_dovetail_assembly();
            rendered_condenser_assembly(pos=condenser_pos_exp(), include_led=false);
        }
        line_offset = [0 ,35, 55];
        line_pos1 = translate_pos(condenser_pos_exp(), line_offset);
        line_pos2 = translate_pos(condenser_pos(), line_offset);
        construction_line(line_pos1, line_pos2, .4);
        mounted_microscope();
    }
    else if (frame == 4){
        mounted_microscope_frame(){
            rendered_illumination_dovetail_assembly();
            rendered_condenser_assembly(include_led=false,
                                        tighten_arrow=true);
        }
        mounted_microscope();
    }
    else if (frame == 5){
        mounted_microscope_frame(){
            rendered_illumination_dovetail_assembly();
            rendered_condenser_assembly(include_led=false);
        }
        mounted_microscope();
    }
}

module rendered_illumination_dovetail_assembly(exploded=false){
    params = render_params();
    dovetail_lift = exploded ? 10 : 0;
    coloured_render(body_colour()){
        translate_z(dovetail_lift){
            illumination_dovetail(params, h = 60);
        }
    }
    illumination_dovetail_screw(params, right=true, exploded=exploded);
    illumination_dovetail_screw(params, right=false, exploded=exploded);
}


module illumination_dovetail_screw(params, right=true, turn=false, exploded=false){
    screw_pos = exploded ? illum_dovetail_screw_pos_exp(params, right=right) : illum_dovetail_screw_pos(params, right=right);
    washer_pos = exploded ? illum_dovetail_washer_pos_exp(params, right=right) : illum_dovetail_washer_pos(params, right=right);
    if (exploded){
        construction_line(translate_pos(illum_dovetail_screw_pos(params, right=right), [0, 0, -10]),
                          illum_dovetail_screw_pos_exp(params, right=right),
                          .2);
    }
    place_part(screw_pos){
        m3_cap_x10();
        if (turn){
            translate_z(4){
                turn_clockwise(5);
            }
        }
    }
    place_part(washer_pos){
        m3_washer();
    }
}