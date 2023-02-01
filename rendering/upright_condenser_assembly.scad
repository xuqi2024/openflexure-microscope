use <../openscad/libs/illumination.scad>
use <../openscad/libs/upright_illumination.scad>
use <../openscad/libs/utilities.scad>
use <../openscad/libs/libdict.scad>
use <../openscad/libs/gears.scad>
use <librender/render_settings.scad>
use <librender/render_utils.scad>
use <librender/assembly_parameters.scad>
use <librender/rendered_components.scad>
use <librender/hardware.scad>
use <librender/optics.scad>
use <librender/electronics.scad>
use <mount_microscope.scad>
use <./condenser_assembly.scad>

USE_BUILT_STL = true;
FRAME = 1;
upright_assemble_condenser(FRAME);

// Use a pre-built STL file
// TODO: make this robust to stale or missing STL files
STL_FOLDER = "../docs/models";

module upright_assemble_condenser(frame){
    if (frame<=3){
        upright_insert_condenser_lens(frame);
    }
    else if(frame <= 6){
        // To keep the frame numbers consistent with the inverted version of the microscope
        // miss out the frames numbers that relate to the thumbscrew assembly
        assert(false, "The thumbscrew is not used in the upright condenser");
    }
    else if(frame <= 10){
        upright_mount_led_board(frame-6);
    }
    else if(frame <= 12){
        upright_mount_led_cable(frame-10);
    }
    else if(frame <= 16){
        //TODO: this is a fudge to get the module the right way up andin the right place
        translate_z(75-5+1.5){
            rotate_y(180){
                upright_mount_condenser_lid(frame-12);
            }
        }
    }
}

module upright_assemble_condenser_thumbscrew(frame){
    explosions = ["nut", "thumbscrew", undef];
    dovetail_height = key_lookup("overall_height", condenser_dovetail_params());
    // The sloping nut trap means that it's best to put the nut in when
    // the condenser is lens-down, i.e. in its orientation as used,
    // with the print bed side on top, hence "flipped" orientation.
    flipped = create_placement_dict([0, 0, dovetail_height], [0, 180, 0]);
    echo("placement", flipped);
    thumbscrew = (frame>1) ? true : false;
    upright_rendered_condenser_assembly(flipped,
                                include_led=false,
                                include_thumbscrew=thumbscrew,
                                include_nut=true,
                                include_lid=false,
                                explode=explosions[frame - 1]);
}

module upright_insert_condenser_lens(frame){
    rendered_lens_tool();
    place_part(condenser_lens_tool_pos()){
        condenser_lens();
    }
    pos = (frame == 1) ? condenser_pos_above_tool() : condenser_pos_on_tool();
    cut = (frame == 3) ? true : false;
    upright_rendered_condenser(pos, cut);
}

module upright_mount_led_board(frame){
    explosions = ["led_board", undef, "led_board_screws", undef];
    upright_rendered_condenser_assembly(
        condenser_upside_down(),
        include_led=false,
        include_thumbscrew=false,
        include_nut=false,
        include_led_board=true,
        include_led_board_screws=(frame>2),
        include_lid=false,
        explode=explosions[frame - 1]
    );
}

module upright_mount_led_cable(frame){
    upright_rendered_condenser_assembly(
        condenser_upside_down(),
        include_led=false,
        include_thumbscrew=false,
        include_nut=false,
        include_led_board=true,
        include_led_board_screws=true,
        include_lid=false,
        explode=undef
    );
    place_part(condenser_upside_down()){
        rendered_illumination_connector(
            explode=(frame==1),
            straight_cable=true
        );
    }
}

module upright_mount_condenser_lid(frame){
    explosions=["lid", undef, "lid_screws", undef];
    upright_rendered_condenser_assembly(
        condenser_upside_down(),
        include_led=false,
        include_thumbscrew=false,
        include_nut=false,
        include_led_board=true,
        include_led_board_screws=true,
        include_lid=true,
        include_lid_screws=(frame>2),
        explode=explosions[frame-1]
    );
    place_part(condenser_upside_down()){
        rendered_illumination_connector(straight_cable=true);
    }
}


// Lid of the condenser is the upright coedenser platform
module upright_rendered_condenser_lid(explode=false){
    coloured_render(extras_colour()){
        // NB both the lid and the condenser render upside down, so
        // we must move the lid down so that it matches up with
        // the condenser.
        translate_z(-upright_condenser_platform_height() - (explode ? 15 : 0)){
            rotate_z(180){
                if (USE_BUILT_STL){
                    cached_stl("upright_condenser_platform");
                }else{
                    upright_condenser_platform_separate();
                }
            }
        }
    }
}


// Screws attaching the lid to the condenser
module upright_rendered_condenser_lid_screws(explode=false){
    z_pos = -2;
    exploded_z_pos = -25;
    // base_r = condenser_base_r(condenser_lens_diameter());
    rotate_y(180){
        reflect_x(){
            translate_x(12){
                translate_z((explode?exploded_z_pos:z_pos)){
                    mirror([0,0,1]){
                        no2_x6_5_selftap();
                    }
                }
                if (explode){
                    construction_line([0, 0, z_pos], [0, 0, exploded_z_pos]);
                }
            }
        }
    }
}

module upright_rendered_condenser(pos, cut=false){
    if (cut){
        cutaway("+x", extras_colour()){
            place_part(pos){
                rotate_z(180){
                    upright_condenser_separate();
                }
            }
        }
    }else{
        coloured_render(extras_colour()){
            place_part(pos){
                rotate_z(180){
                    if (USE_BUILT_STL){
                        cached_stl("upright_condenser");
                    }else{
                        upright_condenser_separate();
                    }
                }
            }
        }
    }
}

// This module renders the condenser (excluding cable), including
// the thumbscrew, lid, lens, and internals.  By default, the LED
// board and other internal components are not rendered, as they
// are not visible.
//
// `pos` should be a placement dictionary, which defaults to the
// in-place position of the condenser. 
// `cut` will produce a cut-through of the condenser (you may wish
// to enable the internal components for this).
// `explode` is set to a string (see the definition for valid ones)
// and will cause the relevant part to appear "exploded".
module upright_rendered_condenser_assembly(pos=undef,
                                   include_led=false,
                                   include_thumbscrew=true,
                                   include_nut=true,
                                   include_led_board=false,
                                   include_led_board_screws=false,
                                   include_lid=true,
                                   include_lid_screws=undef,
                                   cut=false,
                                   explode=undef,
                                   tighten_arrow=false){
    cond_pos = is_undef(pos) ? condenser_pos() : pos;
    upright_rendered_condenser(cond_pos, cut=cut);
    place_part(cond_pos){
        place_part(condenser_lens_pos_relative()){
            condenser_lens();
        }
        if (include_led){
            led();
        }
        if (include_led_board){
            rendered_diffuser(explode=(explode=="led_board"));
            rendered_spacer(explode=(explode=="led_board"));
            rendered_illumination_pcb(explode=(explode=="led_board"));
        }
        if (include_led_board_screws){
            rendered_illumination_pcb_screws(explode=(explode=="led_board_screws"));
        }
        if (include_nut){
            exploded = explode == "nut";
            nut_pos = condenser_clamp_axis_pos(4.4);
            explode_nut_translation = 20*[cos(30)*sin(30), cos(30)*cos(30), -sin(30)];
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
        if (include_lid){
            upright_rendered_condenser_lid(explode=(explode=="lid"));
            if (is_undef(include_lid_screws) || include_lid_screws){
                upright_rendered_condenser_lid_screws(explode=(explode=="lid_screws"));
            }
        }else if (include_lid_screws){
            echo("WARNING: condenser lid screws are only included if the lid is also included.");
        }
    }
}

