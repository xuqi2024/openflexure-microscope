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

FRAME = 4;

render_rms_assembly(FRAME);

module render_rms_assembly(frame){
    if (frame <= 3){
        assemble_om(frame);
    }
    else if (frame == 4){
        rendered_optics_module(optics_module_pos(),
                               cut=false,
                               lens=true,
                               camera=true,
                               objective=false,
                               nut=false,
                               screw=false,
                               explode="camera");
    }
    else if (frame == 5){
        rendered_optics_module(optics_module_pos(),
                               cut=false,
                               lens=true,
                               camera=true,
                               objective=false,
                               nut=false,
                               screw=false);
    }
    else if (frame == 6){
        rendered_optics_module(optics_module_pos(),
                               cut=false,
                               lens=true,
                               camera=true,
                               objective=true,
                               nut=false,
                               screw=false,
                               explode="objective");
    }
    else if (frame == 7){
        rendered_optics_module(optics_module_pos(),
                               cut=false,
                               lens=true,
                               camera=true,
                               objective=true,
                               nut=false,
                               screw=false);
    }
    else if (frame == 8){
        rendered_optics_module(optics_module_pos(),
                               cut=false,
                               lens=true,
                               camera=true,
                               objective=true,
                               nut=true,
                               screw=false,
                               explode="nut");
    }
    else if (frame == 9){
        rendered_optics_module(optics_module_pos(),
                               cut=false,
                               lens=true,
                               camera=true,
                               objective=true,
                               nut=true,
                               screw=true,
                               explode="screw");
    }
    else if (frame == 10){
        rendered_optics_module(optics_module_pos(),
                               cut=false,
                               lens=true,
                               camera=true,
                               objective=true,
                               nut=true,
                               screw=true);
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
                           screw=false);
    place_part(tube_lens_tool_pos()){
        tube_lens();
    }
}

module camera_and_screws(camera_pos, explode=false){
    ex_dist = 13;
    screw_z = picamera2_size().z + 2 + (explode ? 2*ex_dist : 0);
    holes = [for (i = [2, 3]) picamera2_holes()[i]];
    camera_pos_ex = translate_pos(camera_pos, [0, 0, -ex_dist]);

    render_pos = explode ? camera_pos_ex : camera_pos;
    cover_pos = explode ? picamera_cover_pos(ex_dist=ex_dist) : picamera_cover_pos();

    place_part(render_pos){
        picamera2(lens = false);
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
                              explode=undef){
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
            screw_pos = exploded ? screw_pos_ex : optics_module_screw_pos();
            place_part(screw_pos){
                m3_cap_x8();
            }
            if (exploded){
                translate_y(-8){
                    construction_line(screw_pos_ex, optics_module_screw_pos());
                }
            }
        }
        if (camera){
            exploded = (explode == "camera") ? true : false;
            camera_pos = create_placement_dict([0, 0, -17.5], [0, 0, 135]);
            camera_and_screws(camera_pos, exploded);
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

