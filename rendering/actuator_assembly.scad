
use <../openscad/libs/gears.scad>
use <../openscad/libs/utilities.scad>
use <../openscad/actuator_assembly_tools.scad>
use <librender/hardware.scad>

gear_colour = "DodgerBlue";
tools_colour = "MediumAquamarine";

what_you_need();
module what_you_need(){
    repeat([0,40,0],3,center=true){
        color(gear_colour)large_gear();
        translate([-21,0,0])rotate([0,90,0])rotate([0,0,30])m3_hex_x25();
        translate([-28,6,0])m3_washer();
        translate([-36,6,0])m3_washer();
        translate([-32,-6,0])m3_nut(brass=true);
        translate([-32,0,0])viton_band();
        
    }

    color(tools_colour)translate ([22,0,0]) double_ended_band_tool(bent=false);
    color(tools_colour)translate ([35,0,1.7]) band_tool_holder();
    color(tools_colour)translate([35,40,0]) nut_tool();

}



module lead_screw_assembly(){
    translate(large_gear_screw_pos()+[0,0,0])m3_hex_x25();
    color(gear_colour)large_gear();
    translate([0,0,-.5])m3_washer();
    translate([0,0,-1])m3_washer();
}