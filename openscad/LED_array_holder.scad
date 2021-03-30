use <./libs/illumination.scad>;
use <./libs/utilities.scad>;
use <./libs/locking_dovetail.scad>;
include <./libs/microscope_parameters.scad>;

module LED_array_holder(params){
    // adafruit 3444 LED array
    LED_array_l = 36;
    LED_array_w = 25.5;
    LED_array_hole_r = 2.5;

    dt_block_depth = 16; //thickness of the dovetail (16mm is enough)
    dt_height = 15; // height of the clamp (~15mm is tall enough, lower and it
                    // gets harder to ensure it is horizontal as it can twist).
    dt_params = dovetail_params(
        width=illumination_dovetail_w(params),
        height=dt_height,  // do we want to keep this so tall?  It would probably be fine if we made it shorter.
        block_depth = dt_block_depth,
        taper_block = false
    );


    difference(){
        union(){
            hull(){
                translate([0,-2.5/2,4/2]){
                    minkowski(){
                        cube([LED_array_l-4,LED_array_w-4,4], center = true); // bottom of the holder
                        cylinder(r=2,h=1);
                    }
                }
                translate([0,illumination_dovetail_y(params), 0]){
                    linear_extrude(dt_height){
                        back_of_block_2d(dt_params);
                    }
                }
            }
            // the dovetail clip
            translate([0,illumination_dovetail_y(params), 0]){
                dovetail_clamp_m(dt_params);
            }
        }
        // the hole for wires/heat
        translate_z(1/2){
            minkowski(){
                cube([LED_array_w-2,LED_array_w-2,999], center = true); //the hole for the LED array
                cylinder(r=1,h=1);
            }
        }
        //screw holes
        repeat([LED_array_w + (LED_array_l - LED_array_w)/2, 0, 0], 2, center=true){
            repeat([0, LED_array_w - (LED_array_l - LED_array_w)/2, 0], 2, center=true){
                trylinder_selftap(2.5,h=999, center=true);
            }
        }
    }

}

LED_array_holder(default_params());
