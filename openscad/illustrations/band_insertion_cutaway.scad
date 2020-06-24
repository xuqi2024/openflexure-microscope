/*

An illustration for the OpenFlexure Microscope; how to put the nut in

(c) 2016 Richard Bowman - released under CERN Open Hardware License

*/

use <../compact_nut_seat.scad>;
use <../utilities.scad>;
use <../actuator_assembly_tools.scad>;
include <../microscope_parameters.scad>;

difference(){
    color("pink", 0.5) screw_seat(25, motor_lugs=false);

    difference(){ //an example actuator rod
        translate([-3,-10,0]) cube([6,10,5]);
        actuator_end_cutout();
    }
    rotate([0,90,0]) cylinder(r=999,h=999,$fn=4); //cutaway one side
}
color("pink", 1.0) actuator_column(25, 0, join_to_casing=false);

color("green", 1.0) translate([ss_outer(0)[0]/2-2, 0, -30]) rotate([90,0,-90]) band_tool();

module viton_band_in_situ_vertical(h=25, foot_z=-8){
    band_d=2;
    $fn=32;
    reflect([1,0,0]) translate([8, 0, h - 4]) rotate([90,0,90])
        rotate_extrude(angle=180, convexity=2) translate([4, 0]) circle(d=band_d);
    reflect([1,0,0]) reflect([0,1,0]) translate([8, 4, foot_z + 4 - d]) 
        cylinder(d=band_d, h=h-8-foot_z+2*d); 
    reflect([1,0,0]) reflect([0,1,0]) translate([4, 4, foot_z + 4]) rotate([90,90,0])
        rotate_extrude(angle=90, convexity=2) translate([4, 0]) circle(d=band_d);
    reflect([0,1,0]) translate([0,4,foot_z]) rotate([0,90,0])
        cylinder(d=band_d, h=8+2*d, center=true);
}

color("gray", 1.0) viton_band_in_situ_vertical();