use <librender/hardware.scad>
use <librender/render_utils.scad>
use <librender/assembly_parameters.scad>
use <librender/render_settings.scad>
use <../openscad/libs/utilities.scad>
use <../openscad/libs/lib_microscope_stand.scad>
use <../openscad/libs/simple_post_stand_lib.scad>
use <mount_microscope.scad>

FRAME = 1;
MANUAL = false;

render_prepare_stand(FRAME, MANUAL);

module render_prepare_stand(frame, manual=false){
    params = render_params();
    stand_params = render_stand_params(manual=manual);
    if (frame==1){
        render_stand(params, stand_params);
        coloured_render(remove_colour()){
            stand_supports(params, stand_params);
        }
    }else if (frame==2){
        render_stand(params, stand_params, manual=manual);
        stand_nut(params, stand_params, exploded=true);
    }else if (frame==3){
        render_stand(params, stand_params, manual=manual);
        stand_nut(params, stand_params, low=true);
        stand_nut_temp_screw(params, stand_params, exploded=true);
    }else if (frame==4){
        render_stand(params, stand_params, manual=manual);
        stand_nut(params, stand_params);
        stand_nut_temp_screw(params, stand_params, turn=true);
    }else if (frame==5){
        render_stand(params, stand_params, manual=manual);
        stand_nut(params, stand_params);
        stand_nut(params, stand_params, nut_num=1, exploded=true);
        if (!manual){
            stand_nut(params, stand_params, nut_num=2, exploded=true);
            stand_nut(params, stand_params, nut_num=3, exploded=true);
        }
    }
    else if (frame==6){
        render_stand(params, stand_params, manual=manual);
        stand_nut(params, stand_params);
        stand_nut(params, stand_params, nut_num=1);
        stand_nut_temp_screw(params, stand_params, nut_num=1, turn=true);
        stand_nut(params, stand_params, nut_num=2);
        stand_nut_temp_screw(params, stand_params, nut_num=2, turn=true);
        stand_nut(params, stand_params, nut_num=3);
        stand_nut_temp_screw(params, stand_params, nut_num=3, turn=true);
    }
    else if (frame==7){
        stand_prepared(params, stand_params, manual=manual);
    }
    // last frames used when putting in the nut for fitting
    // the electronics drawer, wiring.md
    else if (frame==8){
        stand_prepared(params, stand_params);
        render_electronics_drawer_nut(exploded=true);
    }
    else if (frame==9){
        stand_prepared(params, stand_params);
        render_electronics_drawer_nut(exploded=false);
    }
}

module stand_prepared(params, stand_params, manual=false){
    render_stand(params, stand_params, manual=manual);
    stand_nut(params, stand_params);
    stand_nut(params, stand_params, nut_num=1);
    if (!manual){
        stand_nut(params, stand_params, nut_num=2);
        stand_nut(params, stand_params, nut_num=3);
    }
}

module render_stand(params, stand_params, manual=false){
    coloured_render(stand_colour()){
        if (manual){
            simple_post_stand(params, type="back", wall_height=10, screws=true);
        }
        else{
            microscope_stand(params, stand_params, supports=false);
        }
    }
}

module stand_nut_temp_screw(params, stand_params, nut_num=0, turn=false, exploded=false){
    nut_pos = exploded ? stand_nut_temp_screw_pos_exp(params, stand_params, nut_num) : stand_nut_temp_screw_pos(params, stand_params, nut_num);
    if (exploded){
        construction_line(stand_nut_temp_screw_pos(params, stand_params, nut_num), stand_nut_temp_screw_pos_exp(params, stand_params, nut_num));
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

module stand_nut(params, stand_params, nut_num=0, low=false, exploded=false){
    nut_pos = exploded ? stand_nut_placement_exp(params, stand_params, nut_num) :
        low ? stand_nut_placement_low(params, stand_params, nut_num) : stand_nut_placement(params, stand_params, nut_num);
    if (exploded){
        construction_line(stand_nut_placement_low(params, stand_params, nut_num), stand_nut_placement_exp(params, stand_params, nut_num));
    }
    place_part(nut_pos){
        m3_nut(center=true);
    }
}

module render_electronics_drawer_nut(exploded=false){
    explode = exploded ? [0,0,15] : [0,0,0] ;
    electronics_drawer_frame_xy(render_params()){
        translate(explode + [-6.9,0,0]){
            translate(electronics_drawer_front_screw_pos()){
                if (exploded){
                    translate_x(1){
                        construction_line([0,0,-1.5], -explode);
                    }
                }
                rotate([90,30,90]){
                    m3_nut();
                }
            }
        }
    }
}
