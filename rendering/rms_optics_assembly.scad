use <../openscad/libs/utilities.scad>
use <../openscad/libs/microscope_parameters.scad>
use <../openscad/libs/z_axis.scad>
use <../openscad/lens_tool.scad>
use <../openscad/libs/lib_optics.scad>
use <../openscad/libs/optics_configurations.scad>
use <librender/render_utils.scad>
use <librender/render_settings.scad>
use <librender/optics.scad>
use <librender/electronics.scad>
use <librender/hardware.scad>
use <librender/rendered_components.scad>

params = default_params();

om_pos = create_placement_dict([0, 0, 0]);
om_pos_above_tool = create_placement_dict([0, 0, 75] ,[0, 180, 0], [0, 0, 180]);
om_pos_on_tool = create_placement_dict([0, 0, 42] ,[0, 180, 0], [0, 0, 180]);

tube_lens_tool_pos = create_placement_dict([0, 0, lens_tool_height()+3.6], [0, 180, 0]);

om_mount_pos = objective_mount_screw_pos(params);
om_nut_pos = create_placement_dict(om_mount_pos - [0, 3.25, 1], [90, 0, 0], [0, 0, 30]);
om_screw_pos = create_placement_dict(om_mount_pos - [0, -4, 1], [-90, 0, 0], [0, 0, 30]);

FRAME = 6;

if (FRAME <= 3){
    assemble_om(FRAME);
}
else if (FRAME == 4){
    rendered_optics_module(om_pos,
                           cut=false,
                           lens=true,
                           camera=true,
                           objective=false,
                           nut=false,
                           screw=false,
                           explode="camera");
}
else if (FRAME == 5){
    rendered_optics_module(om_pos,
                           cut=false,
                           lens=true,
                           camera=true,
                           objective=false,
                           nut=false,
                           screw=false);
}
else if (FRAME == 6){
    rendered_optics_module(om_pos,
                           cut=false,
                           lens=true,
                           camera=true,
                           objective=true,
                           nut=false,
                           screw=false,
                           explode="objective");
}
else if (FRAME == 7){
    rendered_optics_module(om_pos,
                           cut=false,
                           lens=true,
                           camera=true,
                           objective=true,
                           nut=false,
                           screw=false);
}
else if (FRAME == 8){
    rendered_optics_module(om_pos,
                           cut=false,
                           lens=true,
                           camera=true,
                           objective=true,
                           nut=true,
                           screw=false,
                           explode="nut");
}
else if (FRAME == 9){
    rendered_optics_module(om_pos,
                           cut=false,
                           lens=true,
                           camera=true,
                           objective=true,
                           nut=true,
                           screw=true,
                           explode="screw");
}
else if (FRAME == 10){
    rendered_optics_module(om_pos,
                           cut=false,
                           lens=true,
                           camera=true,
                           objective=true,
                           nut=true,
                           screw=true);
}


module assemble_om(frame){

    pos = (frame == 1) ? om_pos_above_tool : om_pos_on_tool;
    cut = (frame == 3)? true : false;

    rendered_lens_tool();
    rendered_optics_module(pos,
                           cut=cut,
                           lens=false,
                           camera=false,
                           objective=false,
                           nut=false,
                           screw=false);
    place_part(tube_lens_tool_pos){
        tube_lens();
    }
}

module camera_and_screws(camera_pos, explode=false){
    ex_dist = 20;
    screw_z = picamera2_size().z + (explode ? ex_dist : 0);
    holes = [for (i = [2, 3]) picamera2_holes()[i]];
    camera_pos_ex = translate_pos(camera_pos, [0, 0, -ex_dist]);

    render_pos = explode ? camera_pos_ex : camera_pos;

    place_part(render_pos){
        picamera2(lens = false);
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
            optics_module_rms(params, optics_config);
        }
        if (nut){
            exploded = (explode == "nut") ? true : false;
            nut_pos_ex = translate_pos(om_nut_pos, [0, 0, 20]);
            nut_pos = exploded ? nut_pos_ex : om_nut_pos;
            place_part(nut_pos){
                m3_nut();
            }
            if (exploded){
                translate([0, -1, -2]){
                    construction_line(nut_pos_ex, om_nut_pos);
                }
            }
        }
        if (screw){
            exploded = (explode == "screw") ? true : false;
            screw_pos_ex = translate_pos(om_screw_pos, [0, 12, 0]);
            screw_pos = exploded ? screw_pos_ex : om_screw_pos;
            place_part(screw_pos){
                m3_cap_x8();
            }
            if (exploded){
                translate_y(-8){
                    construction_line(screw_pos_ex, om_screw_pos);
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

