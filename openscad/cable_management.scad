

use <./main_body.scad>
use <libs/main_body_transforms.scad>
include <libs/microscope_parameters.scad>
use <libs/utilities.scad>
use <../rendering/librender/electronics.scad>
use <../rendering/librender/render_utils.scad>
use <./libs/gears.scad>
use <./libs/wall.scad>
use <./libs/z_axis.scad>

//estimated angle
params = default_params();

//rendered();
to_print();


module rendered(){
    coloured_render("WhiteSmoke"){
        main_body(params);
    }

    y_motor_pos = create_placement_dict([0,20,y_motor_z_pos(params)],[0, 0, 180]);
    y_connector_pos = create_placement_dict([-22,-13,-43], [0,0,y_wall_angle(params)-45]);
    y_cable_verticies = [[0,-10,45],[-22,-13,45]];

    z_motor_pos = create_placement_dict([0,20,0],[0, 0, 180]);
    z_connector_pos = create_placement_dict([-27,3,-86], [0,0,-15]);
    z_cable_verticies = [[0,-10,3],[-27,0,3]];

    reflect([1,0,0]){
        coloured_render("DodgerBlue"){
            translate([0, 0, 32.5]){
                y_actuator_frame(params){
                    large_gear();
                }
            }
        }

        
        y_actuator_frame(params){
            motor28BYJ48(y_motor_pos, y_connector_pos, y_cable_verticies);
        }

        coloured_render("DodgerBlue"){
            translate([0,0,side_housing_h(params)]){
                side_cable_tidy(params);
            }
        }
    }


    coloured_render("DodgerBlue"){
        front_cable_tidy(params);
        z_cable_tidy_frame(params, z_extra=-11){
            large_gear();
        }
    }

    z_cable_tidy_frame(params){
        motor28BYJ48(z_motor_pos, z_connector_pos, z_cable_verticies);
    }

}

module to_print(){
    z_cable_tidy_frame_undo(params, z_extra=0.8){
        front_cable_tidy(params);
    }
    reflect([1, 0, 0]){
        translate([0, -20, 0]){
            side_cable_tidy(params);
        }
    }
}

module cable_tidy_body_back(h, curve_both=false){
    translate([11,-11,0]){
        cylinder(d=8, h=h);
    }
    if (curve_both){
        translate([-11,-11,0]){
        cylinder(d=8, h=h);
    }
    }
    else{
        translate([-16,-14.5,0]){
            cylinder(d=1, h=h);
        }
    }
}


module cable_tidy_body(h, curve_both=false){
    hull(){
        for(x_tr = [-.5, .5]*35){
            translate([x_tr,12,0]){
                cylinder(d=8, h=h);
            }
        }
        cable_tidy_body_back(h, curve_both); 
    }
}


module cable_tidy_body_cutouts(h, front=false){
    translate([-22,3.7,1.5]){
        cube([44,100,100]);
    }
    translate([0,12,-1]){
        cylinder(d=29, h=21);
    }
    translate([-10,-6,-1]){
        cube([20,100,21]);
    }
    if (front){
        hull(){
            translate([-10,-12,1]){
                cube([20,6.1,h-3]);
            }
            rotate([0,0,-10]){
                translate([-20,-7,1]){
                    cube([11,5.1,h-3]);
                }
            }
        }
        rotate([0,0,-10]){
            translate([-20,-7,-1]){
                cube([11,5.1,h-1]);
            }
        }
    }
    else{
        translate([-28+8,-12,1]){
            cube([28,6.1,h-3]);
        }
        rotate([0,0,-148]){
            translate([0,-5.1,-1]){
                cube([25,5.1,h-1]);
            }
        }
    }
    
    for(x_tr = [-.5, .5]*35){
        translate([x_tr,12,0]){
            cylinder(d=4.5, h=h, center=true);
        }
    }
}

module side_cable_tidy(params, h=7){
    difference(){
        union(){
            y_actuator_frame(params){
                cable_tidy_body(h);
            }
            side_housing(params, h=h,cavity_h=0, attach=false);
        }
        y_actuator_frame(params){
            cable_tidy_body_cutouts(h);
        }
        side_housing_cutout(params, h-2);
    }
}

module front_cable_tidy(parmas, h=7){
    cutout_h = z_motor_z_pos(params) + 0.8 + h - 2;
    difference(){
        union(){
            z_cable_tidy_frame(params, z_extra=0.8){
                cable_tidy_body(h, curve_both=true);
            }
            hull(){
                z_cable_housing_top(params, h);
                z_cable_tidy_frame(params, z_extra=0.8){
                    cable_tidy_body_back(h, curve_both=true);
                }
            }
        }
        z_cable_tidy_frame(params, z_extra=0.8){
            cable_tidy_body_cutouts(h, front=true);
        }
        z_cable_housing_cutout(params, cutout_h, top=true);
    }
}

