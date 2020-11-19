use <./illumination.scad>;
use <./utilities.scad>;
use <./dovetail.scad>;
include <./microscope_parameters.scad>;

module LED_array_holder(){
//normal dovetail parameters
front_dovetail_y = 35; // position of the main dovetail clip
front_dovetail_w = 30; // width of the main dovetail clip
lens_assembly_z = 10; //height of the dovetail clip
dt_clip = [front_dovetail_w, 16, lens_assembly_z]; //size of the dovetail clip
arm_end_y = front_dovetail_y-dt_clip[1]-2;
// adafruit 3444 LED array
LED_array_l = 36;
LED_array_w = 25.5;
LED_array_hole_r = 2.5;

difference(){
    union(){
        hull(){
            translate([0,-2.5/2,4/2]){
            minkowski(){
                    cube([LED_array_l-4,LED_array_w-4,4], center = true); // bottom of the holder
                    cylinder(r=2,h=1);
                }
            }
            translate([-dt_clip[0]/2, arm_end_y,0]) cube([dt_clip[0], 2, lens_assembly_z]); //fils in the gap between the condenser and the clip
            }        
        // the dovetail clip
        translate([0,front_dovetail_y, 0]) mirror([0,1,0]) dovetail_clip(dt_clip);
    }
    // the hole for wires/heat 
        translate([0,0,1/2]){
            minkowski(){
                cube([LED_array_w-2,LED_array_w-2,999], center = true); //the hole for the LED array
                cylinder(r=1,h=1);
            }
        }
    //screw holes
    mirror([1,0,0]){
        translate([(LED_array_w/2+(LED_array_l-LED_array_w)/4),(LED_array_w/2-(LED_array_l-LED_array_w)/4),0])trylinder_selftap(2.5,h=999);
        translate([-(LED_array_w/2+(LED_array_l-LED_array_w)/4),(LED_array_w/2-(LED_array_l-LED_array_w)/4),0])trylinder_selftap(2.5,h=999);
        translate([(LED_array_w/2+(LED_array_l-LED_array_w)/4),-(LED_array_w/2-(LED_array_l-LED_array_w)/4),0])trylinder_selftap(2.5,h=999);
        translate([-(LED_array_w/2+(LED_array_l-LED_array_w)/4),-(LED_array_w/2-(LED_array_l-LED_array_w)/4),0])trylinder_selftap(2.5,h=999);
    }
}

}

LED_array_holder();