/*

This file should render the optics of the microscope...

(c) 2017 Richard Bowman, released under CERN Open Hardware License

*/


use <../openscad/libs/microscope_parameters.scad>
use <../openscad/libs/libdict.scad>
use <../openscad/libs/utilities.scad>
use <../openscad/libs/illumination.scad>
use <../openscad/lens_tool.scad>
use <librender/assembly_parameters.scad>
use <librender/render_utils.scad>
use <librender/render_settings.scad>
use <librender/optics.scad>
use <librender/rendered_components.scad>
use <rms_optics_assembly.scad>

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
    place_part(condenser_lens_tool_pos()){
        condenser_lens();
    }
    pos = (frame == 1) ? condenser_pos_above_tool() : condenser_pos_on_tool();
    cut = (frame == 3)? true : false;
    rendered_condenser(pos, cut);
}

module cutaway_optics(){

    rendered_optics_module(optics_module_pos(), cut=true);

    rendered_condenser(condenser_pos(), cut=true);
    translate_z(condenser_z()-36.5){
        condenser_lens();
    }
    translate_z(condenser_z()){
        rotate_x(180){
            led();
        }
    }
}


module rendered_condenser(pos, cut=true){
    params = render_params();
    cut_dir = cut ? "+x" : "none";
    cutaway(cut_dir, extras_colour()){
        place_part(pos){
            condenser(params);
        }
    }
}

