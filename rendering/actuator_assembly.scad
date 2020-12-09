
use <../openscad/libs/gears.scad>
use <../openscad/libs/utilities.scad>
use <../openscad/actuator_assembly_tools.scad>
use <librender/hardware.scad>
use <librender/render_utils.scad>

gear_colour = "DodgerBlue";
tools_colour = "MediumAquamarine";

FRAME=2;
if (FRAME==1){
    what_you_need();
}else if (FRAME==2){
    rotate([0, 60, 0])lead_screw_assembly(exploded=true);
}
else if (FRAME==3){
    rotate([0, 60, 0])lead_screw_assembly();
}



module what_you_need(){
    repeat([0,40,0],3,center=true){
        color(gear_colour)large_gear();
        translate([-21,0,0])rotate([0,90,0])rotate([0,0,30])m3_hex_x25();
        translate([-28,6,0])m3_washer();
        translate([-36,6,0])m3_washer();
        translate([-32,-6,0])m3_nut(brass=true);
        translate([-32,0,0])viton_band();
        
    }
    color(tools_colour)render(6)translate ([22,0,0]) double_ended_band_tool(bent=false);
    color(tools_colour)render(6)translate ([35,0,1.7]) band_tool_holder();
    color(tools_colour)render(6)translate([35,40,0]) nut_tool();
}

module lead_screw_assembly(exploded=false){
    //The assembly of the gear the M3x25 lead screw and the two washers
    
    //exploded translatiosn for the parts
    tr_screw = exploded ? [0 ,0, 35] : large_gear_screw_pos();
    tr_wash1 = exploded ? [0 ,0, -5] : [0, 0, -.5];
    tr_wash2 = exploded ? [0 ,0, -10] : [0, 0, -1];
    //translate everything so the gear is in place at the bottom.
    translate([0, 0, 1]){
        translate(tr_screw)m3_hex_x25();
        color(gear_colour)large_gear();
        translate(tr_wash1)m3_washer();
        translate(tr_wash2)m3_washer();
        if (exploded){
            construction_line(tr_screw, tr_wash2);
        }
    }
}
