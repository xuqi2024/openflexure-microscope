use <../openscad/libs/illumination.scad>
use <../openscad/libs/utilities.scad>
use <librender/render_settings.scad>
use <librender/render_utils.scad>
use <librender/assembly_parameters.scad>
use <librender/hardware.scad>
use <librender/electronics.scad>
use <mount_microscope.scad>
use <condenser_assembly.scad>
use <../openscad/libs/z_axis.scad>

FRAME = 5;
LOW_COST = false;
mount_illumination(FRAME, LOW_COST);

module mount_illumination(frame, low_cost=false){
    
    if (frame == 1){
        mounted_microscope_frame(){
            rendered_illumination_dovetail_assembly(exploded=true);
        }
        mounted_microscope(low_cost=low_cost);
    }
    else if (frame == 2){
        mounted_microscope_frame(){
            rendered_illumination_dovetail_assembly();
        }
        mounted_microscope(low_cost=low_cost);
    }
    else if (frame == 3){
        mounted_microscope_frame(){
            rendered_illumination_dovetail_assembly();
            rendered_condenser_assembly(pos=condenser_pos_exp(), include_led=false);
            illumination_wiring(exploded=true);
        }
        line_offset = [0 ,35, 55];
        line_pos1 = translate_pos(condenser_pos_exp(), line_offset);
        line_pos2 = translate_pos(condenser_pos(), line_offset);
        construction_line(line_pos1, line_pos2, .4);
        mounted_microscope(low_cost=low_cost);
    }
    else if (frame == 4){
        mounted_microscope_frame(){
            rendered_illumination_dovetail_assembly();
            rendered_condenser_assembly(tighten_arrow=true);
            illumination_wiring();
        }
        mounted_microscope(low_cost=low_cost);
    }
    else if (frame == 5){
        mounted_microscope_with_illumination(low_cost=low_cost);
    }
}

module mounted_microscope_with_illumination(low_cost=false){
    mounted_microscope_frame(){
        rendered_illumination_dovetail_assembly();
        rendered_condenser_assembly();
        illumination_wiring();
    }
    mounted_microscope(low_cost=low_cost);
}

module rendered_illumination_dovetail_assembly(exploded=false){
    params = render_params();
    dovetail_lift = exploded ? 10 : 0;
    coloured_render(body_colour()){
        translate_z(dovetail_lift){
            illumination_dovetail(params, h = 60);
        }
    }
    illumination_dovetail_screw(params, right=true, exploded=exploded);
    illumination_dovetail_screw(params, right=false, exploded=exploded);
}


module illumination_dovetail_screw(params, right=true, turn=false, exploded=false){
    screw_pos = exploded ? illum_dovetail_screw_pos_exp(params, right=right) : illum_dovetail_screw_pos(params, right=right);
    washer_pos = exploded ? illum_dovetail_washer_pos_exp(params, right=right) : illum_dovetail_washer_pos(params, right=right);
    if (exploded){
        construction_line(translate_pos(illum_dovetail_screw_pos(params, right=right), [0, 0, -10]),
                          illum_dovetail_screw_pos_exp(params, right=right),
                          .2);
    }
    place_part(screw_pos){
        m3_cap_x10();
        if (turn){
            translate_z(4){
                turn_clockwise(5);
            }
        }
    }
    place_part(washer_pos){
        m3_washer();
    }
}

// The two wires powering the illumination PCB
module illumination_wiring(params=render_params(), exploded=false){
    top_z = condenser_z()+2 + (exploded ? 30 : 0); //NB should match `condenser_pos_exp()`
    housing_top = illumination_cable_housing_top_pos(params, z_extra=2);
    drop = illumination_dovetail_z(params) - housing_top.z;
    points=[
        [0,10,top_z],
        [0,illumination_dovetail_y()-2,top_z],
        illumination_cable_channel_xypos() + [0,0,top_z],
        illumination_cable_channel_xypos() + [0,0,illumination_dovetail_z(params)],
        left_illumination_screw_pos(params) + [-5, -5, -drop/2],
        housing_top,
        illumination_cable_housing_bottom_pos(params)
    ];
    coloured_render("DimGray"){
        wire(
            d=1,
            points=flat_wire_points(d=1, points=points, n=2, index=0)
        );
    }
    coloured_render("red"){
        wire(
            d=1,
            points=flat_wire_points(d=1, points=points, n=2, index=1)
        );
    }
}