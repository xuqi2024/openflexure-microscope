use <../openscad/libs/illumination.scad>
use <../openscad/libs/utilities.scad>
use <../openscad/libs/lib_microscope_stand.scad>
use <librender/render_settings.scad>
use <librender/render_utils.scad>
use <librender/assembly_parameters.scad>
use <librender/hardware.scad>
use <librender/electronics.scad>
use <mount_microscope.scad>
use <prepare_stand.scad>
use <condenser_assembly.scad>
use <../openscad/libs/z_axis.scad>

FRAME = 5;
LOW_COST = false;
MANUAL = false;

mount_illumination(FRAME, LOW_COST, MANUAL);

module mount_illumination(frame, low_cost=false, manual=false){

    stand_params = render_stand_params(manual=manual);
    z_actual = microscope_stand_height(stand_params)-microscope_depth();
    if (frame == 1){
        mounted_microscope_frame(manual=manual){
            rendered_illumination_dovetail_assembly(exploded=true);
        }
        mounted_microscope(stand_params=stand_params, low_cost=low_cost, manual=manual);
    }
    else if (frame == 2){
        mounted_microscope_frame(manual=manual){
            rendered_illumination_dovetail_assembly();
        }
        mounted_microscope(stand_params=stand_params, low_cost=low_cost, manual=manual);
    }
    else if (frame == 3){
        mounted_microscope_frame(manual=manual){
            rendered_illumination_dovetail_assembly();
            rendered_condenser_assembly(pos=condenser_pos_exp(), include_led=false);
            illumination_wiring(manual=manual, exploded=true);
        }
        mounted_microscope(stand_params=stand_params, low_cost=low_cost, manual=manual);
    }
    else if (frame == 4){
        mounted_microscope_frame(manual=manual){
            rendered_illumination_dovetail_assembly();
            rendered_condenser_assembly(pos=condenser_pos_exp(), include_led=false);
            illumination_wiring(manual=manual, exploded=true);
        }
        line_offset = [0 ,35, z_actual-20];
        line_pos1 = translate_pos(condenser_pos_exp(), line_offset);
        line_pos2 = translate_pos(condenser_pos(), line_offset);
        construction_line(line_pos1, line_pos2, .4, arrow=true);
        mounted_microscope(stand_params=stand_params, low_cost=low_cost, manual=manual);
    }
    else if (frame == 5){
        mounted_microscope_frame(manual=manual){
            rendered_illumination_dovetail_assembly();
            rendered_condenser_assembly(tighten_arrow=true);
            illumination_wiring(manual=manual);
        }
        mounted_microscope(stand_params=stand_params, low_cost=low_cost, manual=manual);
    }
    else if (frame == 6){
        mounted_microscope_with_illumination(stand_params=stand_params, low_cost=low_cost, manual=manual);
    }
}

module mounted_microscope_with_illumination(stand_params=default_stand_params(), low_cost=false, manual=false){
    mounted_microscope_frame(manual=manual){
        rendered_illumination_dovetail_assembly();
        rendered_condenser_assembly();
        illumination_wiring(manual=manual);
    }
    mounted_microscope(stand_params=stand_params, low_cost=low_cost, manual=manual);
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
module illumination_wiring(params=render_params(), exploded=false, manual=false){
    top_z = condenser_z()+2 + (exploded ? 30 : 0); //NB should match `condenser_pos_exp()`
    housing_top = illumination_cable_housing_top_pos(params, z_extra=2);
    drop = illumination_dovetail_z(params) - housing_top.z;
    base_point_1 = (manual) ? left_illumination_screw_pos(params) + [0, -5, -65] : housing_top ;
    base_point_2 = (manual) ? base_point_1 + [-5, -5, -5] : illumination_cable_housing_bottom_pos(params) ;
    points=[
        [0,10,top_z],
        [0,illumination_dovetail_y()-2,top_z],
        illumination_cable_channel_xypos() + [0,0,top_z],
        illumination_cable_channel_xypos() + [0,0,illumination_dovetail_z(params)],
        left_illumination_screw_pos(params) + [-5, -5, -drop/2],
        base_point_1,
        base_point_2
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