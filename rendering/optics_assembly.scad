/*

This file should render the optics of the microscope...

(c) 2017 Richard Bowman, released under CERN Open Hardware License

*/


use <../openscad/libs/microscope_parameters.scad>
use <../openscad/libs/libdict.scad>
use <../openscad/libs/illumination.scad>
use <../openscad/lens_tool.scad>
use <librender/render_utils.scad>
use <librender/render_settings.scad>
use <librender/optics.scad>
use <librender/rendered_components.scad>
use <rms_optics_assembly.scad>

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

condenser_lens_tool_pos = create_placement_dict([0, 0, lens_tool_height()+1.51]);

om_pos = create_placement_dict([0, 0, 0]);

FRAME = 4;

if (FRAME <= 3){
    assemble_condenser(FRAME);
}
else{
    //FRAME = 4
    cutaway_optics();
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

    rendered_optics_module(om_pos, cut=true);

    rendered_condenser(condenser_pos, cut=true);
    translate([0,0,condenser_z-35.5]){
        condenser_lens();
    }
    translate([0,0,condenser_z]){
        rotate([180,0,0]){
            led();
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

