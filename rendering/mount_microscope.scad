
use <../openscad/libs/lib_microscope_stand.scad>
use <../openscad/libs/simple_post_stand_lib.scad>
use <../openscad/libs/libdict.scad>
use <../openscad/libs/microscope_parameters.scad>
use <../openscad/libs/utilities.scad>
use <./librender/render_utils.scad>
use <./librender/render_settings.scad>
use <./librender/assembly_parameters.scad>
use <./librender/hardware.scad>
use <mount_optics.scad>
use <prepare_stand.scad>


FRAME = 1;
LOW_COST = true;
MANUAL = false;
render_mount_microscope(FRAME, LOW_COST, MANUAL);

module render_mount_microscope(frame, low_cost, manual){
    if (frame==1){
        mounted_microscope(low_cost=low_cost, manual=manual, exploded=true);
    }
    else if (frame==2){
        mounted_microscope(low_cost=low_cost, manual=manual);
    }
}

module mounted_microscope(stand_params=default_stand_params(), low_cost=false, manual=false, exploded=false){
    params = render_params();
    stand_params = render_stand_params(manual=manual);
    if (manual){
        coloured_render(stand_colour()){
            simple_post_stand(params, type="back", wall_height=10, screws=true);
        }
        for (i = [0, 1]){
            stand_lug_screw(params, stand_params, i, exploded=exploded);
        }
    }
    else {        
        stand_prepared(params, stand_params);
        for (i = [0, 1, 2, 3]){
            stand_lug_screw(params, stand_params, i, exploded=exploded);
        }
    }
    mounted_microscope_frame(stand_params, exploded=exploded){
        body_with_optics(low_cost=low_cost);
    }
}

module mounted_microscope_frame(stand_params=default_stand_params(),exploded=false){
    //stand_params = default_stand_params();
    place_part(microscope_on_stand_pos(stand_params, exploded=exploded)){
        children();
    }
}

function render_stand_params(manual=false) = let(
        params_dummy = default_stand_params(tall=false, no_pi=true),
        z_nominal = microscope_stand_height(params_dummy)-microscope_depth(),
        post_mount_height = key_lookup("foot_height", default_params()),
        st_params_manual = replace_value("extra_height", post_mount_height-z_nominal, params_dummy),
        st_params_normal = default_stand_params(tall=false, no_pi=false)
    ) manual? st_params_manual : st_params_normal;

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
