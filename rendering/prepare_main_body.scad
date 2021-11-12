use <librender/hardware.scad>
use <librender/render_utils.scad>
use <librender/assembly_parameters.scad>
use <librender/render_settings.scad>
use <../openscad/libs/main_body_structure.scad>
use <../openscad/libs/utilities.scad>


FRAME=2;

render_prepare_main_body(FRAME);

module render_prepare_main_body(frame){
    params = render_params();
    if (frame==1){
        render_body(params);
        stage_nut(params, exploded=true);
    }else if (frame==2){
        render_body(params);
        stage_nut(params, low=true);
        stage_nut_temp_screw(params, exploded=true);
    }else if (frame==3){
        render_body(params);
        stage_nut(params);
        stage_nut_temp_screw(params, turn=true);
    }else if (frame==4){
        render_body(params);
        stage_nut(params);
        stage_nut(params, nut_num=1, exploded=true);
        stage_nut(params, nut_num=2, exploded=true);
        stage_nut(params, nut_num=3, exploded=true);
    }
    else if (frame==5){
        render_body(params);
        stage_nut(params);
        stage_nut(params, nut_num=1);
        stage_nut_temp_screw(params, nut_num=1, turn=true);
        stage_nut(params, nut_num=2);
        stage_nut_temp_screw(params, nut_num=2, turn=true);
        stage_nut(params, nut_num=3);
        stage_nut_temp_screw(params, nut_num=3, turn=true);
    }
    else if (frame==6){
        main_body_stage_prepared();
    }
}

module main_body_stage_prepared(){
    params = render_params();
    render_body(params);
    stage_nut(params);
    stage_nut(params, nut_num=1);
    stage_nut(params, nut_num=2);
    stage_nut(params, nut_num=3);
}

module render_body(params){
    coloured_render(body_colour()){
        main_body(params);
    }
}

module stage_nut_temp_screw(params, nut_num=0, turn=false, exploded=false){
    nut_pos = exploded ? stage_nut_temp_screw_pos_exp(params) : stage_nut_temp_screw_pos(params);
    rotate_z(45+nut_num*90){
        if (exploded){
            construction_line(stage_nut_temp_screw_pos(params), stage_nut_temp_screw_pos_exp(params));
        }
        place_part(nut_pos){
            m3_cap_x10();
            if (turn){
                translate_z(4){
                    turn_clockwise(5);
                }
            }
        }
    }
}

module stage_nut(params, nut_num=0, low=false, exploded=false){
    nut_pos = exploded ? stage_nut_placement_exp(params) :
        low ? stage_nut_placement_low(params) : stage_nut_placement(params);
    rotate_z(45+nut_num*90){
        if (exploded){
            construction_line(stage_nut_placement_low(params), stage_nut_placement_exp(params));
        }
        place_part(nut_pos){
            m3_nut(center=true);
        }
    }
}