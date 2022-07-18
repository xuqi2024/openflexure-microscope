use <../openscad/libs/illumination.scad>
use <../openscad/libs/utilities.scad>
use <../openscad/libs/libdict.scad>
use <../openscad/libs/gears.scad>
use <librender/render_settings.scad>
use <librender/render_utils.scad>
use <librender/assembly_parameters.scad>
use <librender/rendered_components.scad>
use <librender/hardware.scad>
use <librender/optics.scad>
use <mount_microscope.scad>

FRAME = 6;
assemble_condenser(FRAME);

module assemble_condenser(frame){
    if (frame<=3){
        insert_condenser_lens(frame);
    }
    else{
        assemble_condenser_thumbscrew(frame-3);
    }
}



module assemble_condenser_thumbscrew(frame){
    home = create_placement_dict([0, 0, 0]);
    explode = (frame==1) ? "nut" :
        (frame==2) ? "thumbscrew" :
            undef;
    thumbscrew = (frame>1) ? true : false;
    rendered_condenser_assembly(home,
                                include_led=false,
                                include_thumbscrew=thumbscrew,
                                include_nut=true,
                                explode=explode);
}

module insert_condenser_lens(frame){
    rendered_lens_tool();
    place_part(condenser_lens_tool_pos()){
        condenser_lens();
    }
    pos = (frame == 1) ? condenser_pos_above_tool() : condenser_pos_on_tool();
    cut = (frame == 3) ? true : false;
    rendered_condenser(pos, cut);
}


module rendered_condenser(pos, cut=false){
    cut_dir = cut ? "+x" : "none";
    cutaway(cut_dir, extras_colour()){
        place_part(pos){
            condenser();
        }
    }
}

module rendered_condenser_assembly(pos=undef,
                                   include_led=true,
                                   include_thumbscrew=true,
                                   include_nut=true,
                                   cut=false,
                                   explode=undef,
                                   tighten_arrow=false){
    cond_pos = is_undef(pos) ? condenser_pos() : pos;
    rendered_condenser(cond_pos, cut=cut);
    place_part(cond_pos){
        place_part(condenser_lens_pos_relative()){
            condenser_lens();
        }
        if (include_led){
            led();
        }
        if (include_nut){
            exploded = explode == "nut";
            nut_pos = condenser_clamp_axis_pos(4.4);
            explode_nut_translation = 20*[cos(30)*sin(30), cos(30)*cos(30), sin(30)];
            nut_pos_exp = translate_pos(condenser_clamp_axis_pos(4.4),
                                        explode_nut_translation);
            if (exploded){
                construction_line(nut_pos, nut_pos_exp);
            }                            
            place_part(exploded ? nut_pos_exp : nut_pos){
                condenser_nut();
            }
        }
        if (include_thumbscrew){
            exploded = explode == "thumbscrew";
            screw_pos = exploded ? 40 : 1;
            thumbscrew_pos = exploded ? 20 : 14.4;
            if (exploded){
                construction_line(condenser_clamp_axis_pos(4),
                                  condenser_clamp_axis_pos(50));
            }
            if (tighten_arrow){
                place_part(condenser_clamp_axis_pos(29)){
                    rotate_x(90){
                        turn_clockwise(8, 5, .15);
                    }
                }
            }

            place_part(condenser_clamp_axis_pos(screw_pos)){
                condenser_m3x25();
            }
            place_part(condenser_clamp_axis_pos(thumbscrew_pos)){
                rendered_illumination_thumbscrew();
            }
        }
    }
}

module rendered_illumination_thumbscrew(){
    coloured_render(extras_colour()){
        rotate_x(90){
            illumination_thumbscrew();
        }
    }
}

module condenser_m3x25(){
    rotate_x(90){
        translate_z(25){
            m3_hex_x25();
        }
    }
}

module condenser_nut(){
    rotate_x(90){
        rotate_z(30){
            m3_nut();
        }
    }
}
