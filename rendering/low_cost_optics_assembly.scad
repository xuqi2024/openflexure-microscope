use <../openscad/libs/utilities.scad>
use <../openscad/libs/microscope_parameters.scad>
use <../openscad/libs/z_axis.scad>
use <../openscad/lens_tool.scad>
use <../openscad/libs/lib_optics.scad>
use <../openscad/libs/optics_configurations.scad>

use <librender/assembly_parameters.scad>
use <librender/render_utils.scad>
use <librender/render_settings.scad>
use <librender/optics.scad>
use <librender/electronics.scad>
use <librender/hardware.scad>
use <librender/rendered_components.scad>

FRAME = 11;

render_low_cost_assembly(FRAME);

module render_low_cost_assembly(frame){
    if (frame <= 3){
        assemble_lens_spacer(frame);
    }
    else if (frame == 4){
        rendered_low_cost_optics(optics_module_pos(),
                                 cut=false,
                                 lens=true,
                                 camera=true,
                                 nut=false,
                                 screw=false,
                                 ribbon_cable=false,
                                 connector_open=true,
                                 explode="camera");
    }
    else if (frame == 5){
        rendered_low_cost_optics(optics_module_pos(),
                                 cut=false,
                                 lens=true,
                                 camera=true,
                                 nut=false,
                                 screw=false,
                                 ribbon_cable=false,
                                 connector_open=true);
    }
    else if (frame == 6){
        rendered_low_cost_optics(optics_module_pos(),
                                 cut=false,
                                 lens=true,
                                 camera=true,
                                 nut=true,
                                 screw=false,
                                 ribbon_cable=false,
                                 connector_open=true,
                                 explode="nut");
    }
    else if (frame == 7){
        rendered_low_cost_optics(optics_module_pos(),
                                 cut=false,
                                 lens=true,
                                 camera=true,
                                 nut=true,
                                 screw=true,
                                 ribbon_cable=false,
                                 connector_open=true,
                                 explode="screw");
    }
    else if (frame == 8){
        rendered_low_cost_optics(optics_module_pos(),
                                 cut=false,
                                 lens=true,
                                 camera=true,
                                 nut=true,
                                 screw=true,
                                 ribbon_cable=false,
                                 screw_tight=false,
                                 connector_open=true);
    }
    else if (frame == 9){
        rendered_low_cost_optics(optics_module_pos(),
                                 cut=false,
                                 lens=true,
                                 camera=true,
                                 nut=true,
                                 screw=true,
                                 ribbon_cable=true,
                                 screw_tight=false,
                                 connector_open=true,
                                 explode="ribbon_cable");
    }
    else if (frame == 10){
        rendered_low_cost_optics(optics_module_pos(),
                                 cut=false,
                                 lens=true,
                                 camera=true,
                                 nut=true,
                                 screw=true,
                                 ribbon_cable=true,
                                 screw_tight=false,
                                 connector_open=true);
    }
    else if (frame == 11){
        rendered_low_cost_optics(optics_module_pos(),
                                 cut=false,
                                 lens=true,
                                 camera=true,
                                 nut=true,
                                 screw=true,
                                 ribbon_cable=true,
                                 screw_tight=false,
                                 connector_open=false);
    }
}

module assemble_lens_spacer(frame){
    params = render_params();
    optics_config = pilens_config();
    pos = (frame == 1) ?
        lens_spacer_pos_above_tool(params, optics_config):
        lens_spacer_pos_on_tool(params, optics_config);
    cut = (frame == 3)? true : false;
    rendered_low_cost_optics(pos,
                             cut=cut,
                             lens=false,
                             camera=false,
                             nut=false,
                             screw=false,
                             ribbon_cable=false);
    picamera2_lens();
}


module rendered_camera_platform(){
    params = render_params();
    optics_config = pilens_config();
    coloured_render(optics_module_colour()){
        camera_platform(params, optics_config, 5);
    }
}

module camera_platform_and_screws(lens_spacer_z, explode=false, connector_open=false){
    ex_dist = 13;
    screw_z = - 1 - (explode ? 2*ex_dist : 0);
    holes = picamera2_holes();
    camera_pos = create_placement_dict([0, 0, lens_spacer_z], [0, 0, 135]);
    camera_pos_ex = translate_pos(camera_pos, [0, 0, -ex_dist]);

    render_pos = explode ? camera_pos_ex : camera_pos;
    cover_pos = explode ? picamera_cover_pos(ex_dist=ex_dist) : picamera_cover_pos();
    platform_z_pos = explode ? - 2*ex_dist : 0;
    translate_z(platform_z_pos){
        rendered_camera_platform();
    }
    place_part(render_pos){
        picamera2(lens=false, connector_open=connector_open);
        for (hole_pos = holes){
            translate(hole_pos - [0, 0, screw_z]){
                no2_x6_5_selftap();
                if (explode){
                    construction_line([0, 0, 0], [0, 0, 2*screw_z]);
                }
            }
        }
    }
}

module rendered_low_cost_optics(pos,
                                cut=false,
                                lens=true,
                                camera=true,
                                nut=true,
                                screw=true,
                                ribbon_cable=true,
                                explode=undef,
                                screw_tight=true,
                                connector_open=false,
                                cable_positions=undef){
    
    
    cut_dir = cut ? "+x" : "none";
    params = render_params();
    optics_config = pilens_config();
    ribbon_pos = is_undef(cable_positions) ?
        default_ribbon_pos(low_cost=true, params=params, optics_config=optics_config):
        cable_positions;

    place_part(pos){
        cutaway(cut_dir, optics_module_colour()){
            lens_spacer(params, optics_config);
        }
        if (nut){
            exploded = (explode == "nut") ? true : false;
            nut_pos_ex = translate_pos(camera_platform_nut_pos(), [0, 5, 20]);
            nut_pos = exploded ? nut_pos_ex : camera_platform_nut_pos();
            place_part(nut_pos){
                m3_nut();
            }
            if (exploded){
                translate([0, -1, -2]){
                    construction_line(nut_pos_ex,
                                      translate_pos(camera_platform_nut_pos(), [0,0,5]));
                }
            }
        }
        if (screw){
            exploded = (explode == "screw") ? true : false;
            screw_pos_ex = translate_pos(camera_platform_screw_pos(), [0, 12, 0]);
            screw_pos_assembled = translate_pos(camera_platform_screw_pos(), [0, 4, 0]);
            screw_pos = exploded ? screw_pos_ex :
                screw_tight ? camera_platform_screw_pos() : screw_pos_assembled;
            place_part(screw_pos){
                m3_cap_x10();
            }
            if (exploded){
                translate_y(-8){
                    construction_line(screw_pos_ex, screw_pos_assembled);
                }
            }
        }
        lens_spacer_z = lens_spacer_z(params, optics_config);
        if (camera){
            exploded = (explode == "camera") ? true : false;
            camera_platform_and_screws(lens_spacer_z, exploded, connector_open=connector_open);
        }
        if (ribbon_cable){
            ribbon_start = create_placement_dict([0, 0, lens_spacer_z-1.25], [0, 0, 135], [0, 180, 0], init_translation=[15, 0, 0]);
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
        // lens last as transparent!
        if (lens){
            translate_z(pi_lens_z_pos(params, optics_config)){
                mirror([0, 0, 1]){
                    picamera2_lens();
                }
            }
        }
    }
}

