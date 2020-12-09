
use <../openscad/libs/gears.scad>
use <../openscad/libs/utilities.scad>
use <../openscad/actuator_assembly_tools.scad>
use <../openscad/main_body.scad>
use <../openscad/feet.scad>
use <librender/hardware.scad>
use <librender/render_utils.scad>
use <../openscad/libs/libdict.scad>



extras_colour = "DodgerBlue";
tools_colour = "MediumAquamarine";

FRAME=4;
if (FRAME==1){
    what_you_need();
}else if (FRAME==2){
    body_with_nut(exploded=true);
}else if (FRAME==3){
    body_with_gear(exploded=true);
}
else if (FRAME==4){
    body_with_gear(exploded=false);
}

module render_foot(foot, lie_flat=false){
    color(extras_colour){
        render(6){
            if ((foot == "X") || (foot == "Y")){
                outer_foot(render_params(), lie_flat=lie_flat, letter=foot);
            }
            else{
                middle_foot(render_params(), lie_flat=lie_flat, letter="Z");
            }
        }
    }
}

module what_you_need(){
    repeat([0, 40, 0],3,center=true){
        color(extras_colour)large_gear();
        translate([-21, 0, 0])rotate([0, 90, 0])rotate([0, 0, 30])m3_hex_x25();
        translate([-28, 6, 0])m3_washer();
        translate([-36, 6, 0])m3_washer();
        translate([-32, -6, 0])m3_nut(brass=true);
        translate([-32, 0, 0])viton_band();
        
    }
    translate([28, 40, 0])rotate([0, 0, 90])render_foot("X", lie_flat=true);
    translate([28, 0, 0])rotate([0, 0, 90])render_foot("Z", lie_flat=true);
    translate([28, -40, 0])rotate([0, 0, 90])render_foot("Y", lie_flat=true);
    color(tools_colour)render(6)translate ([52, 0, 0]) double_ended_band_tool(bent=false);
    color(tools_colour)render(6)translate ([65, 0, 1.7]) band_tool_holder();
    color(tools_colour)render(6)translate([65, 40, 0]) nut_tool();
}

function x_actuator_pos() = let(
    params = render_params(),
    leg_r = key_lookup("leg_r", params),
    actuating_nut_r = actuating_nut_r(params),
    nut_dist = (leg_r+actuating_nut_r)/sqrt(2)
) [nut_dist, nut_dist, 0];

module body_with_nut(exploded=false){
    params = render_params();
    //TODO change 25 to referenceing the column height once it is in parameter dictionary
    column_height = 25;
    internal_nut_pos =  x_actuator_pos() + [0, 0, column_height-4];
    exploded_nut_pos = [70, 70, column_height-10];
    nut_pos = exploded ? exploded_nut_pos : internal_nut_pos;
    if (exploded){
        construction_line(internal_nut_pos, exploded_nut_pos);
    }
    color("WhiteSmoke"){
        render(6){
            main_body(params);
        }
    }
    translate(nut_pos)rotate([0, 0, 45])m3_nut(brass=true, center=true);
}

module body_with_gear(exploded=false){
    column_height = 25;
    in_place_lead_assmbly_pos =  x_actuator_pos() + [0, 0, column_height+7];
    exploded_lead_assmbly_pos = in_place_lead_assmbly_pos + [0, 0, 30];
    lead_assmbly_pos = exploded ? exploded_lead_assmbly_pos : in_place_lead_assmbly_pos;
    body_with_nut();
    translate(lead_assmbly_pos){
        lead_screw_assembly(exploded=exploded, construction_offset=[0, 0, -25]);
    }
}

module lead_screw_assembly(exploded=false, construction_offset=[0, 0, 0]){
    //The assembly of the gear the M3x25 lead screw and the two washers
    
    //exploded translatiosn for the parts
    tr_screw = exploded ? [0 ,0, 35] : large_gear_screw_pos();
    tr_wash1 = exploded ? [0 ,0, -5] : [0, 0, -.5];
    tr_wash2 = exploded ? [0 ,0, -10] : [0, 0, -1];
    //translate everything so the gear is in place at the bottom.
    translate([0, 0, 1]){
        translate(tr_screw)m3_hex_x25();
        color(extras_colour)large_gear();
        translate(tr_wash1)m3_washer();
        translate(tr_wash2)m3_washer();
        if (exploded){
            construction_line(tr_screw, tr_wash2+construction_offset);
        }
    }
}


