

use <libs/compact_nut_seat.scad>
include <libs/microscope_parameters.scad>
use <../rendering/librender/electronics.scad>
use <../rendering/librender/render_utils.scad>
use <./libs/gears.scad>

//estimated angle
a_to_wall = 10;


connector_size = [5.5, 14.5, 8];
housing_size = [connector_size.x+4+2,connector_size.y+4+2+8, 29];
housing_cut_size = [connector_size.x+2,connector_size.y+2, 99];


//rendered();
to_print();

module rendered(){
    coloured_render("WhiteSmoke"){
        augmented_screw_seat();
    }

    render(6){
        cable_thing();
    }

    coloured_render("DodgerBlue"){
        translate([0, 0, 32.5]){
            large_gear();
        }
    }


    motor28BYJ48(create_placement_dict([0,20,43],[0, 0, 180]),
                create_placement_dict([20,-10,-43], [0,0,90+a_to_wall]),
                [[0,-10,45],[20,-10,45]]);
}

module to_print(){

    augmented_screw_seat();
    translate([0, 20, housing_size.z+21]){
        rotate([180, 0, 0]){
            cable_thing();
        }
    }

}


module augmented_screw_seat(){
    screw_seat(actuator_h, motor_lugs=true);
    translate([16, -housing_size.y+3, 0]){
        rotate([0, 0, a_to_wall]){
            difference(){

                cube(housing_size);
                    

                translate([2, 6, -1]){
                    cube(housing_cut_size);
                }
                translate([housing_size.x/2+2, 3, 0]){
                    cylinder(d=1.8, h=99, center=true);
                }
                translate([housing_size.x/2+2, connector_size.y+2+9, 0]){
                    cylinder(d=1.8, h=99, center=true);
                }
            }
        }
    }
}

module cable_thing(){
    difference(){
        translate([16, -housing_size.y+3, housing_size.z]){
            rotate([0, 0, a_to_wall]){
                difference(){
                    union(){
                        cube([housing_size.x, housing_size.y, 21]);
                        translate([-22, housing_size.y-15, 13]){
                            rotate(-[0, 0, a_to_wall]){
                                cube([30,10,8]);
                            }
                        }
                    }
                    translate([2, 6, -1]){
                        cube(housing_cut_size);
                    }
                    translate([housing_size.x/2+2, 3, 0]){
                        cylinder(d=2.6, h=99, center=true);
                        translate([0,0,2]){
                            cylinder(d=4.5, h=99);
                        }
                    }
                    translate([housing_size.x/2+2, connector_size.y+2+9, 0]){
                        cylinder(d=2.6, h=99, center=true);
                        translate([0,0,2]){
                            cylinder(d=4.5, h=99);
                        }
                    }

                    translate([-20, housing_size.y-13, 15]){
                        rotate(-[0, 0, a_to_wall]){
                            cube([25,6,8]);
                        }
                    }
                    translate([-19, housing_size.y-10, 15]){
                        rotate(-[0, 0, a_to_wall]){
                            cube([10,6,8]);
                        }
                    }
                }
            }
        }
        cylinder(d=30, h=80, center=true);   
    }
}










