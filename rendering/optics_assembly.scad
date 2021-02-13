/*

This file should render the optics of the microscope...

(c) 2017 Richard Bowman, released under CERN Open Hardware License

*/


use <../openscad/optics.scad>
use <../openscad/lens_tool.scad>
use <../openscad/libs/utilities.scad>
use <../openscad/libs/microscope_parameters.scad>
use <../openscad/libs/libdict.scad>
use <../openscad/libs/illumination.scad>
use <librender/render_utils.scad>
use <librender/render_settings.scad>
use <librender/optics.scad>
use <librender/electronics.scad>
use <librender/hardware.scad>

params = default_params();


condenser_z = illumination_dovetail_z(params) + 65;
condenser_angle = key_lookup("condenser_angle", params);
condenser_pos = create_placement_dict([0, 0, condenser_z], [0, 0, 180], [180+condenser_angle, 0, 0]);
condenser_pos_above_tool = create_placement_dict([0, 0, 90],
                                                 [0, 0, -90],
                                                 [180+condenser_angle, 0, 0]);
condenser_pos_on_tool = create_placement_dict([0, 0, 57],
                                              [0, 0, -90],
                                              [180+condenser_angle, 0, 0]);

om_pos = create_placement_dict([0, 0, 0]);
om_pos_above_tool = create_placement_dict([0, 0, 75] ,[0, 180, 0], [0, 0, 180]);
om_pos_on_tool = create_placement_dict([0, 0, 42] ,[0, 180, 0], [0, 0, 180]);

tube_lens_tool_pos = create_placement_dict([0, 0, lens_tool_height()+3.6], [0, 180, 0]);

condenser_lens_tool_pos = create_placement_dict([0, 0, lens_tool_height()+1.51]);


camera_pos = create_placement_dict([0, 0, -17.5], [0, 0, 135]);

FRAME = 6;

if (FRAME <= 3){
    assemble_om(FRAME);
}
else if (FRAME <= 6){
    assemble_condenser(FRAME-3);
}
else{
    //FRAME = 7
    cutaway_optics();
}

module assemble_om(frame){
    rendered_lens_tool();
    place_part(tube_lens_tool_pos){
        tube_lens();
    }
    pos = (frame == 1) ? om_pos_above_tool : om_pos_on_tool;
    cut = (frame == 3)? true : false;
    rendered_optics_module(pos, cut);
}

module assemble_condenser(frame){
    rendered_lens_tool();
    place_part(condenser_lens_tool_pos){
        condenser_lens();
    }
    pos = (frame == 1) ? condenser_pos_above_tool : condenser_pos_on_tool;
    cut = (frame == 3)? true : false;
    rendered_condenser(pos, cut);
}

module cutaway_optics(){
    rendered_condenser(condenser_pos, cut=true);
    rendered_optics_module(om_pos, cut=true);
    translate([0, 0, 18.5]){
        tube_lens();
    }
    translate([0,0,30.1]){
        rendered_objective();
    }
    translate([0,0,condenser_z-35.5]){
        condenser_lens();
    }
    translate([0,0,condenser_z]){
        rotate([180,0,0]){
            led();
        }
    }
    camera_and_screws(camera_pos);
}

module camera_and_screws(camera_pos){
    place_part(camera_pos){
        picamera2(lens = false);
        holes = [for (i = [2, 3]) picamera2_holes()[i]];
        for (hole_pos = holes){
            translate(hole_pos - [0, 0, picamera2_size().z]){
                mirror([0,0,1]){
                    no2_x6_5_selftap();
                }
            }
        }
    }
}

module rendered_lens_tool(){
    coloured_render(tools_colour()){
        lens_tool();
    }
}

module rendered_optics_module(pos, cut=true){
    cut_dir = cut ? "+x" : "none";
    place_part(pos){
        cutaway(cut_dir, optics_module_colour()){
            // Optics module for RMS objective, using Comar 40mm singlet tube lens
            optics_module_rms(
                params,
                tube_lens_ffd=47, 
                tube_lens_f=50, 
                tube_lens_r=12.7/2+0.1, 
                objective_parfocal_distance=45,
                tube_length=150
            );
        }
    }
}

module rendered_condenser(condenser_pos, cut=true){
    cut_dir = cut ? "+x" : "none"; 
    cutaway(cut_dir, extras_colour()){
        place_part(condenser_pos){
            condenser(params);
        }
    }
}

