
use <../openscad/libs/gears.scad>
use <../openscad/libs/utilities.scad>
use <../openscad/libs/lib_actuator_assembly_tools.scad>
use <../openscad/libs/main_body_structure.scad>
use <../openscad/feet.scad>
use <librender/hardware.scad>
use <librender/tools.scad>
use <librender/render_utils.scad>
use <librender/assembly_parameters.scad>
use <librender/render_settings.scad>
use <../openscad/libs/libdict.scad>



FRAME=5;
if (FRAME==1){
    what_you_need();
}else if (FRAME==2){
    body_with_x_nut(exploded=true);
}else if (FRAME==3){
    body_with_x_gear(exploded=true);
}
else if (FRAME==4){
    body_with_x_gear(exploded=false);
}
else if (FRAME==5){
    body_with_x_gear(exploded=false, lifted=true);
    place_part(x_lead_oil_placement()){
        oil_bottle();
    }
}
else if (FRAME==6){
    body_with_assembled_actuators(x_only=true);
}
else if (FRAME==7){
    body_with_assembled_actuators(x_only=false);
}

module render_foot(foot, lie_flat=false){
    color(extras_colour()){
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

module render_body(){
    params = render_params();
    color(body_colour()){
        render(6){
            main_body(params);
        }
    }
}

module what_you_need(){
    params = render_params();
    repeat([0, 40, 0],3,center=true){
        color(extras_colour()){
            large_gear();
        }
        translate_x(-21){
            rotate_y(90){
                rotate_z(30){
                    m3_hex_x25();
                }
            }
        }
        translate([-28, 6, 0]){
            m3_washer();
        }
        translate([-36, 6, 0]){
            m3_washer();
        }
        translate([-32, -6, 0]){
            m3_nut(brass=true);
        }
        translate_x(-32){
            viton_band();
        }

    }
    translate([28, 40, 0]){
        rotate_z(90){
            render_foot("X", lie_flat=true);
        }
    }
    translate_x(28){
        rotate_z(90){
            render_foot("Z", lie_flat=true);
        }
    }
    translate([28, -40, 0]){
        rotate_z(90){
            render_foot("Y", lie_flat=true);
        }
    }
    color(tools_colour()){
        render(6){
            translate_x(52){
                band_tool(params, bent=false);
            }
        }
    }
    color(tools_colour()){
        render(6){
            translate([65, 0, 1.7]){
                band_tool_holder(params);
            }
        }
    }
    color(tools_colour()){
        render(6){
            translate([65, 40, 0]){
                nut_tool();
            }
        }
    }
}

module x_nut(exploded=false){
    nut_pos = exploded ? x_nut_placement_exp() : x_nut_placement();
    if (exploded){
        construction_line(x_nut_placement(), x_nut_placement_exp());
    }
    place_part(nut_pos){
        m3_nut(brass=true, center=true);
    }
}

module x_lead_screw_assembly(exploded=false){
    lead_assembly_pos = exploded ? x_lead_assembly_placement_exp() : x_lead_assembly_placement();
    place_part(lead_assembly_pos){
        lead_screw_assembly(exploded=exploded, construction_offset=[0, 0, -25]);
    }
}

module x_actuator_assembly(){
    x_nut();
    x_lead_screw_assembly();
    place_part(x_foot_placement()){
            render_foot("X", lie_flat=false);
            viton_band_in_situ_vertical();
    }
}

module y_actuator_assembly(){
    place_part(y_nut_placement()){
        m3_nut(brass=true, center=true);
    }
    place_part(y_lead_assembly_placement()){
        lead_screw_assembly();
    }
    place_part(y_foot_placement()){
            render_foot("Y", lie_flat=false);
            viton_band_in_situ_vertical();
    }
}

module z_actuator_assembly(){
    place_part(z_nut_placement()){
        m3_nut(brass=true, center=true);
    }
    place_part(z_lead_assembly_placement()){
        lead_screw_assembly();
    }
    place_part(z_foot_placement()){
            render_foot("Z", lie_flat=false);
    }
    place_part(z_oring_placement()){
            viton_band_in_situ_vertical();
    }
}

module body_with_x_nut(exploded=false){
    render_body();
    x_nut(exploded=exploded);
}

module body_with_x_gear(exploded=false, lifted=false){
    body_with_x_nut();
    z_tr = lifted ? 5 : 0;
    translate_z(z_tr){
        x_lead_screw_assembly(exploded=exploded);
    }
}

module body_with_assembled_actuators(x_only=false){
    render_body();
    x_actuator_assembly();
    if (!x_only){
        y_actuator_assembly();
        z_actuator_assembly();
    }
}

module lead_screw_assembly(exploded=false, construction_offset=[0, 0, 0]){
    //The assembly of the gear the M3x25 lead screw and the two washers

    //exploded translatiosn for the parts
    tr_screw = exploded ? [0 ,0, 35] : large_gear_screw_pos();
    tr_wash1 = exploded ? [0 ,0, -5] : [0, 0, -.5];
    tr_wash2 = exploded ? [0 ,0, -10] : [0, 0, -1];
    //translate everything so the gear is in place at the bottom.
    translate_z(1){
        translate(tr_screw){
            m3_hex_x25();
        }
        color(extras_colour()){
            large_gear();
        }
        translate(tr_wash1){
            m3_washer();
        }
        translate(tr_wash2){
            m3_washer();
        }
        if (exploded){
            construction_line(tr_screw, tr_wash2+construction_offset);
        }
    }
}


