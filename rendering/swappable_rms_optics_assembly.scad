use <../openscad/libs/utilities.scad>
use <../openscad/libs/microscope_parameters.scad>
use <../openscad/libs/z_axis.scad>
use <../openscad/lens_tool.scad>
use <../openscad/libs/lib_optics.scad>
use <../openscad/libs/lib_swappable_optics.scad>
use <../openscad/libs/optics_configurations.scad>
use <../openscad/libs/libdict.scad>

use <librender/assembly_parameters.scad>
use <librender/render_utils.scad>
use <librender/render_settings.scad>
use <librender/optics.scad>
use <librender/electronics.scad>
use <librender/hardware.scad>
use <librender/rendered_components.scad>

FRAME = 11;

render_rms_assembly(FRAME);

module cut_yz_plane(positive=true){
    difference(){
        children();
        rotate_y(positive?90:-90) cylinder(r=999, h=999, $fn=5);
    }
}

module render_rms_assembly(frame){
    if (frame <= 3){
        assemble_om(frame);
    }
    else if (frame == 4){
        swappable_rms_carrier(render_params());
        translate([0,0,30]) color("grey") swappable_rms_carrier_balls(render_params());
    }
    else if (frame == 5){
        swappable_rms_carrier(render_params());
        color("grey") swappable_rms_carrier_balls(render_params());
    }
    else if (frame == 6){
        swappable_rms_carrier(render_params());
        color("grey") swappable_rms_carrier_balls(render_params());
    }
    else if (frame == 7){
        swappable_rms_carrier(render_params());
        color("grey") swappable_rms_carrier_balls(render_params());
    }
    else if (frame == 8){
        swappable_rms_mount(render_params());
        color("grey") swappable_rms_mount_dowels(render_params(), explode=true);
    }
    else if (frame == 9){
        swappable_rms_mount(render_params());
        color("grey") swappable_rms_mount_dowels(render_params(), explode=false);
    }
    else if (frame == 10){
        color("yellow") cut_yz_plane() swappable_rms_mount(render_params());
        color("grey") swappable_rms_mount_dowels(render_params(), explode=false);

        sp = swappable_rms_params(render_params());
        mount_h = key_lookup("mount_h", sp);
        carrier_h = key_lookup("carrier_h", sp);
        sep = mount_to_carrier_separation(render_params());
        translate([0,0,mount_h + carrier_h + sep]){
            rotate_y(180){
            color("yellow") cut_yz_plane(false) swappable_rms_carrier(render_params());
                color("grey") swappable_rms_carrier_balls(render_params());
            }
        }
    }
    else if (frame == 11){
        rp = render_params();
        op = rms_f50d13_config();
        coloured_render("yellow") place_part(swappable_rms_carrier_placement(rp, op)) cut_yz_plane(false) swappable_rms_carrier(render_params());
        coloured_render("grey") place_part(swappable_rms_carrier_placement(rp, op)) swappable_rms_carrier_balls(render_params());
        coloured_render("darkgrey") place_part(swappable_rms_mount_placement(rp, op)) cut_yz_plane(true) swappable_rms_mount(render_params());
        coloured_render("grey") place_part(swappable_rms_mount_placement(rp, op)) swappable_rms_mount_dowels(render_params(), explode=false);
        coloured_render(optics_module_colour()) optics_module_swappable_rms(rp, op);
    }
}

module assemble_om(frame){

    pos = (frame == 1) ? optics_module_pos_above_tool() : optics_module_pos_on_tool();
    cut = (frame == 3)? true : false;

    rendered_lens_tool();
    rendered_optics_module(pos,
                           cut=cut,
                           lens=false,
                           camera=false,
                           objective=false,
                           nut=false,
                           screw=false,
                           ribbon_cable=false);
    place_part(tube_lens_tool_pos()){
        tube_lens();
    }
}

module camera_and_screws(camera_pos, explode=false, connector_open=false){
    ex_dist = 13;
    screw_z = picamera2_size().z + 2 + (explode ? 2*ex_dist : 0);
    holes = [for (i = [2, 3]) picamera2_holes()[i]];
    camera_pos_ex = translate_pos(camera_pos, [0, 0, -ex_dist]);

    render_pos = explode ? camera_pos_ex : camera_pos;
    cover_pos = explode ? picamera_cover_pos(ex_dist=ex_dist) : picamera_cover_pos();

    place_part(render_pos){
        picamera2(lens=false, connector_open=connector_open);
        place_part(cover_pos){
            rendered_picamera_2_cover();
        }
        for (hole_pos = holes){
            translate(hole_pos - [0, 0, screw_z]){
                mirror([0,0,1]){
                    no2_x6_5_selftap();
                }
                if (explode){
                    construction_line([0, 0, 0], [0, 0, 2*screw_z]);
                }
            }
        }
    }
}

module rendered_optics_module(pos,
                              cut=false,
                              lens=true,
                              camera=true,
                              objective=true,
                              nut=true,
                              screw=true,
                              ribbon_cable=true,
                              explode=undef,
                              screw_tight=true,
                              connector_open=false,
                              cable_positions=undef){
    
    ribbon_pos = is_undef(cable_positions) ? default_ribbon_pos() : cable_positions;

    cut_dir = cut ? "+x" : "none";
    place_part(pos){
        cutaway(cut_dir, optics_module_colour()){
            optics_config = rms_f50d13_config();
            params = render_params();
            optics_module_rms(params, optics_config);
        }
        if (nut){
            exploded = (explode == "nut") ? true : false;
            nut_pos_ex = translate_pos(optics_module_nut_pos(), [0, 0, 20]);
            nut_pos = exploded ? nut_pos_ex : optics_module_nut_pos();
            place_part(nut_pos){
                m3_nut();
            }
            if (exploded){
                translate([0, -1, -2]){
                    construction_line(nut_pos_ex, optics_module_nut_pos());
                }
            }
        }
        if (screw){
            exploded = (explode == "screw") ? true : false;
            screw_pos_ex = translate_pos(optics_module_screw_pos(), [0, 12, 0]);
            screw_pos_assembled = translate_pos(optics_module_screw_pos(), [0, 4, 0]);
            screw_pos = exploded ? screw_pos_ex :
                screw_tight ? optics_module_screw_pos() : screw_pos_assembled;
            place_part(screw_pos){
                m3_cap_x8();
            }
            if (exploded){
                translate_y(-8){
                    construction_line(screw_pos_ex, screw_pos_assembled);
                }
            }
        }
        camera_pos = create_placement_dict([0, 0, -17.5], [0, 0, 135]);
        if (camera){
            exploded = (explode == "camera") ? true : false;
            camera_and_screws(camera_pos, exploded, connector_open=connector_open);
        }
        if (ribbon_cable){
            ribbon_start = create_placement_dict([0, 0, -18.75], [0, 0, 135], [0, 180, 0], init_translation=[15, 0, 0]);
            positions = concat([ribbon_start], ribbon_pos);
            exploded = (explode == "ribbon_cable") ? true : false;
            ribbon_tr = exploded ? [15, -15, 0] : [0, 0, 0];
            translate(ribbon_tr){
                picamera_cable(positions);
            }
            if (exploded){
                construction_line(translate_pos(ribbon_start, -ribbon_tr),
                                  translate_pos(ribbon_start, ribbon_tr));
            }
        }
        if (objective){
            exploded = (explode == "objective") ? true : false;
            obj_z = exploded ? 33.1 : 30.1;
            translate_z(obj_z){
                rendered_objective();
            }
            if (exploded){
                translate_z(70){
                    turn_clockwise(15, 5);
                }
            }
        }
        // lens last as transparent!
        if (lens){
            translate_z(18.5){
                tube_lens();
            }
        }
    }
}

