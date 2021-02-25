

use <./main_body.scad>
use <libs/main_body_transforms.scad>
include <libs/microscope_parameters.scad>
use <libs/utilities.scad>
use <../rendering/librender/electronics.scad>
use <../rendering/librender/render_utils.scad>
use <./libs/gears.scad>
use <./libs/wall.scad>

//estimated angle
params = default_params();

rendered();
//to_print();

module rendered(){

    coloured_render("WhiteSmoke"){
        main_body(params);
    }

    motor_pos = create_placement_dict([0,20,y_motor_z_pos(params)],[0, 0, 180]);
    connector_pos = create_placement_dict([-22,-13,-43], [0,0,y_wall_angle(params)-45]);
    cable_verticies = [[0,-10,45],[-22,-13,45]];

    reflect([1,0,0]){
        coloured_render("DodgerBlue"){
            translate([0, 0, 32.5]){
                y_actuator_frame(params){
                    large_gear();
                }
            }
        }

        
        y_actuator_frame(params){
            motor28BYJ48(motor_pos, connector_pos, cable_verticies);
        }

        coloured_render("DodgerBlue"){
            translate([0,0,side_housing_h(params)]){
                cable_thing(params);
            }
        }
    }

}

module to_print(){

    //augmented_screw_seat();
    translate([0, 40, 0]){
            cable_thing(params);
    }

}

module cable_thing(params, h=7){
    difference(){
        union(){
            y_actuator_frame(params){
                hull(){
                    for(x_tr = [-.5, .5]*35){
                        translate([x_tr,12,0]){
                            cylinder(d=8, h=h);
                        }
                    }
                    translate([11,-11,0]){
                        cylinder(d=8, h=h);
                    }
                    translate([-16,-14.5,0]){
                        cylinder(d=1, h=h);
                    }
                    
                }
            }
            side_housing(params, h=h,cavity_h=0, attach=false);
        }
        y_actuator_frame(params){
            translate([-50,3.7,1.5]){
                cube([100,100,100]);
            }
            translate([0,12,-1]){
                cylinder(d=29, h=21);
            }
            translate([-10,-6,-1]){
                cube([20,100,21]);
            }
            translate([-28+8,-12,1]){
                cube([28,6.1,h-3]);
            }
            rotate([0,0,-148]){
                translate([0,-5.1,-1]){
                    cube([25,5.1,h-1]);
                }
            }
            for(x_tr = [-.5, .5]*35){
                translate([x_tr,12,0]){
                    cylinder(d=4.5, h=h, center=true);
                }
            }
        }
        side_housing_cutout(params, h-2);
    }
}










