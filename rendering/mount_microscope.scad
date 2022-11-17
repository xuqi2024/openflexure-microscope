
use <../openscad/libs/lib_microscope_stand.scad>
use <../openscad/libs/utilities.scad>
use <./librender/render_utils.scad>
use <./librender/render_settings.scad>
use <./librender/assembly_parameters.scad>
use <./librender/hardware.scad>
use <mount_optics.scad>
use <prepare_stand.scad>


FRAME = 1;
LOW_COST = false;
render_mount_microscope(FRAME, LOW_COST);

module render_mount_microscope(frame, low_cost){
    if (frame==1){
        mounted_microscope(low_cost=low_cost, exploded=true);
    }
    else if (frame==2){
        mounted_microscope(low_cost=low_cost);
    }
}

module mounted_microscope(low_cost=false, exploded=false){
    params = render_params();
    stand_params = default_stand_params();
    stand_prepared(params, stand_params);
    for (i = [0, 1, 2, 3]){
        stand_lug_screw(params, stand_params, i, exploded=exploded);
    }
    mounted_microscope_frame(exploded=exploded){
        body_with_optics(low_cost=low_cost);
    }
}

module mounted_microscope_frame(exploded=false){
    stand_params = default_stand_params();
    place_part(microscope_on_stand_pos(stand_params, exploded=exploded)){
        children();
    }
}

module stand_lug_screw(params, stand_params, screw_num=0, turn=false, exploded=false){
    screw_pos = exploded ? stand_lug_pos_exp(params, stand_params, screw_num) : stand_lug_pos(params, stand_params, screw_num);
    if (exploded){
        construction_line(stand_lug_pos(params, stand_params, screw_num),
                          stand_lug_pos_exp(params, stand_params, screw_num),
                          .25);
    }
    place_part(screw_pos){
        m3_cap_x10();
        if (turn){
            translate_z(4){
                turn_clockwise(5);
            }
        }
    }
}
