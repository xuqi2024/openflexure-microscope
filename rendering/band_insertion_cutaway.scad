/*

An illustration for the OpenFlexure Microscope; how to put the nut in

(c) 2016 Richard Bowman - released under CERN Open Hardware License

*/

use <../openscad/libs/compact_nut_seat.scad>
use <../openscad/libs/utilities.scad>
use <../openscad/libs/lib_actuator_assembly_tools.scad>
use <../openscad/libs/microscope_parameters.scad>
use <../openscad/libs/libfeet.scad>
use <../openscad/libs/gears.scad>
use <../openscad/libs/main_body_structure.scad>
use <../openscad/libs/libdict.scad>
use <librender/hardware.scad>
use <librender/render_settings.scad>
use <librender/assembly_parameters.scad>
use <librender/render_utils.scad>
use <actuator_assembly.scad>

module cut_actuator_housing(params, cut=true){
    difference(){
        xy_screw_seat(params, label="");

        // cutout actuator hole
        difference(){
            translate([-3,-10,0]){
                cube([6,10,5]);
            }
            actuator_end_cutout();
        }
        // only render half
        if (cut) {
            rotate_y(-90){
                cylinder(r=99,h=99,$fn=4);
            }
        }
    }
}

module render_band_insertion(frame_dict){
    params = default_params();

    foot_tr = key_lookup("foot_tr", frame_dict);
    band_tr = key_lookup("band_tr", frame_dict);
    tool_tr = key_lookup("tool_tr", frame_dict);
    casing_cut = key_lookup("casing_cut", frame_dict);
    casing_alpha = key_lookup("casing_alpha", frame_dict);
    foot_alpha = key_lookup("foot_alpha", frame_dict);
    tool_kink = key_lookup("tool_kink", frame_dict);
    actuator_h = key_lookup("actuator_h", params);

    coloured_render(body_colour(), 1.0){
        actuator_column(actuator_h, 0, join_to_casing=false);
    }

    translate(band_tr){
        viton_band_in_situ_vertical(tool_kink=tool_kink);
    }

    color(tools_colour(), 1){
        translate([0,0,-45]+tool_tr){
            rotate_z(90){
                band_tool(params, bent=true);
            }
        }
    }
    color(extras_colour(), 1){
        translate([0,0,-45 - 2]+tool_tr){
            rotate_z(90){
                band_tool_holder(params);
            }
        }
    }
    color(extras_colour(), foot_alpha){
        translate(foot_tr){
            render(6){
                outer_foot(params, lie_flat=false, letter="X");
            }
        }
    }
    translate_z(xy_lead_assembly_height()){
        lead_screw_assembly();
    }
    translate_z(xy_nut_height()){
        rotate_z(30){
            m3_nut(brass=true, center=true);
        }
    }

    color(tools_colour()){
        render(6){
            rotate_z(180){
                translate([0, -15, xy_nut_height()-4]){
                    nut_tool();
                }
            }
        }
    }

    // See though object last
    color(body_colour(), casing_alpha){
        render(6){
            cut_actuator_housing(params, cut=casing_cut);
        }
    }
}

function band_insertion_frame_parameters(frame_number) = let(
    frame1 = [["foot_tr", [0,0,-40]],
              ["band_tr", [0,0,-40]],
              ["tool_tr", [0,0,-37]],
              ["casing_cut", false],
              ["casing_alpha", 1],
              ["foot_alpha", 1],
              ["tool_kink", true]],

    frame2 = [["foot_tr", [0,0,-40]],
              ["band_tr", [0,0,-40]],
              ["tool_tr", [0,0,-37]],
              ["casing_cut", true],
              ["casing_alpha", .5],
              ["foot_alpha", .5],
              ["tool_kink", true]],

    frame3 = [["foot_tr", [0,0,0]],
              ["band_tr", [0,0,0]],
              ["tool_tr", [0,0,0]],
              ["casing_cut", true],
              ["casing_alpha", .5],
              ["foot_alpha", .5],
              ["tool_kink", true]],

    frame4 = [["foot_tr", [0,0,0]],
              ["band_tr", [0,0,0]],
              ["tool_tr", [0,0,-40]],
              ["casing_cut", true],
              ["casing_alpha", .5],
              ["foot_alpha", .5],
              ["tool_kink", false]],

    frame5 = [["foot_tr", [0,0,0]],
              ["band_tr", [0,0,0]],
              ["tool_tr", [0,0,-40]],
              ["casing_cut", false],
              ["casing_alpha", 1],
              ["foot_alpha", 1],
              ["tool_kink", false]],

    frames = [frame1, frame2, frame3, frame4, frame5]
) frames[frame_number-1];

FRAME = 5;
render_band_insertion(band_insertion_frame_parameters(FRAME));
