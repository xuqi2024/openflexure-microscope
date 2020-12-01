/*

An illustration for the OpenFlexure Microscope; how to put the nut in

(c) 2016 Richard Bowman - released under CERN Open Hardware License

*/

use <../openscad/compact_nut_seat.scad>
use <../openscad/utilities.scad>
use <../openscad/actuator_assembly_tools.scad>
include <../openscad/microscope_parameters.scad>
use <../openscad/feet.scad>
use <../openscad/libs/libdict.scad>


module double_reflect(){
    reflect([1,0,0]){
        reflect([0,1,0]){
            children();
        }
    }
}

module viton_band_in_situ_vertical(h=25, foot_z=-11, tool_kink=true){
    band_d=2;
    $fn=32;
    reflect([1,0,0]){
        translate([7, 0, h - 3.5]){
            rotate([90,0,90]){
                rotate_extrude(angle=180, convexity=2){
                    translate([4, 0]){
                        circle(d=band_d);
                    }
                }
            }
        }
    }
    double_reflect(){
        p1 = [7, 4, h - 3.5];
        p2 = [5, 5, h - 18];
        p3 = [4.55, 1.85, foot_z + 4];
        // Anoyingly cannot do the if inside the squential hull
        if (tool_kink) {
            sequential_hull(){
                translate(p1) cylinder(d=band_d,h=tiny());
                translate(p2) cylinder(d=band_d,h=tiny());
                translate(p3) cylinder(d=band_d,h=tiny());
            }
        } else {
            sequential_hull(){
                translate(p1) cylinder(d=band_d,h=tiny());
                translate(p3) cylinder(d=band_d,h=tiny());
            }
        }
    }

    double_reflect(){
        translate([-.4, 1, foot_z + 4]){
            rotate([80,90,0]){
                rotate_extrude(angle=90, convexity=2){
                    translate([5, 0]){
                        circle(d=band_d);
                    }
                }
            }
        }
    }

}

module cut_actuator_housing(cut=true){
    difference(){
        screw_seat(25, motor_lugs=true);

        // cutout actuator hole
        difference(){ 
            translate([-3,-10,0]) cube([6,10,5]);
            actuator_end_cutout();
        }
        // only render half
        if (cut) {
            rotate([0,-90,0])cylinder(r=99,h=99,$fn=4);
        }
    }
}

module render_frame(frame_dict){
    params = default_params();

    foot_tr = key_lookup("foot_tr", frame_dict);
    band_tr = key_lookup("band_tr", frame_dict);
    tool_tr = key_lookup("tool_tr", frame_dict);
    casing_cut = key_lookup("casing_cut", frame_dict);
    casing_alpha = key_lookup("casing_alpha", frame_dict);
    foot_alpha = key_lookup("foot_alpha", frame_dict);
    tool_kink = key_lookup("tool_kink", frame_dict);

    color("HotPink", 1.0){
        actuator_column(25, 0, join_to_casing=false);
    }
    color("gray", 1){
        translate(band_tr){
            viton_band_in_situ_vertical(tool_kink=tool_kink);
        }
    }
    color("green", 1){
        translate([0,0,-45]+tool_tr){
            rotate([0, 0, 90]){
                double_ended_band_tool(bent=true);
            }
        }
    }
    color("HotPink", foot_alpha){
        translate(foot_tr){
            render(6){
                outer_foot(params, lie_flat=false, letter="X");
            }
        }
    }
    // See though object last
    color("HotPink", casing_alpha){
        render(6){
            cut_actuator_housing(cut=casing_cut);
        }
    }
}

frame1 = [["foot_tr", [0,0,-40]],
          ["band_tr", [0,0,-40]],
          ["tool_tr", [0,0,-40]],
          ["casing_cut", false],
          ["casing_alpha", 1],
          ["foot_alpha", 1],
          ["tool_kink", true]];

frame2 = [["foot_tr", [0,0,-40]],
          ["band_tr", [0,0,-40]],
          ["tool_tr", [0,0,-40]],
          ["casing_cut", true],
          ["casing_alpha", .5],
          ["foot_alpha", .5],
          ["tool_kink", true]];

frame3 = [["foot_tr", [0,0,0]],
          ["band_tr", [0,0,0]],
          ["tool_tr", [0,0,0]],
          ["casing_cut", true],
          ["casing_alpha", .5],
          ["foot_alpha", .5],
          ["tool_kink", true]];

frame4 = [["foot_tr", [0,0,0]],
          ["band_tr", [0,0,0]],
          ["tool_tr", [0,0,-40]],
          ["casing_cut", true],
          ["casing_alpha", .5],
          ["foot_alpha", .5],
          ["tool_kink", false]];

frame5 = [["foot_tr", [0,0,0]],
          ["band_tr", [0,0,0]],
          ["tool_tr", [0,0,-40]],
          ["casing_cut", false],
          ["casing_alpha", 1],
          ["foot_alpha", 1],
          ["tool_kink", false]];

FRAME=5;
if (FRAME==1){
    render_frame(frame1);
}else if (FRAME==2){
    render_frame(frame2);
}else if (FRAME==3){
    render_frame(frame3);
}else if (FRAME==4){
    render_frame(frame4);
}else if (FRAME==5){
    render_frame(frame5);
}