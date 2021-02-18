

use <libs/compact_nut_seat.scad>
include <libs/microscope_parameters.scad>
use <libs/utilities.scad>
use <../rendering/librender/electronics.scad>
use <../rendering/librender/render_utils.scad>
use <./libs/gears.scad>

//estimated angle
a_to_wall = 10;


//rendered();
to_print();

module rendered(){

    coloured_render("WhiteSmoke"){
        augmented_screw_seat(h=43.8);
    }

    render(6){
        translate([0,0,43.8]){
            cable_thing();
        }
    }

    coloured_render("DodgerBlue"){
        translate([0, 0, 32.5]){
            large_gear();
        }
    }


    motor28BYJ48(create_placement_dict([0,20,43],[0, 0, 180]),
                create_placement_dict([20,-15,-43], [0,0,90+a_to_wall]),
                [[0,-10,45],[20,-10,45]]);
}

module to_print(){

    //augmented_screw_seat();
    translate([0, 40, 0]){
            cable_thing();
    }

}


function connector_size() = [5.5, 14.5, 8];
function housing_size(h=43.8) = [connector_size().x+4+2,connector_size().y+4+2+12, h];


module side_housing_placement(){
    translate([16, -housing_size().y+3, 0]){
        rotate([0, 0, a_to_wall]){
            children();
        }
    }
}

module side_housing(h=43.8, cavity_h=undef){
    c_h = is_undef(cavity_h) ? h+1 : cavity_h;
    difference(){
        side_housing_placement(){
            intersection(){
                cube(housing_size(h));
                hull(){
                    translate([housing_size().x-4+tiny(),4-tiny(),0]){
                        cylinder(r=4,h=999,center=true);
                    }
                    translate([housing_size().x-4+tiny(),housing_size().y-4+tiny(),0]){
                        cylinder(r=4,h=999,center=true);
                    }
                    translate([-99,4-tiny(),0]){
                        cylinder(r=4,h=999,center=true);
                    }
                    translate([-99,housing_size().y-4+tiny(),0]){
                        cylinder(r=4,h=999,center=true);
                    }
                }
            }
        }
        side_housing_cutout(c_h);
    }
}

module side_housing_cutout(h){
    housing_cut_size = [connector_size().x+2,connector_size().y+2, h+1];
    side_housing_placement(){
        translate([2, 6, -1]){
            cube(housing_cut_size);
        }
    }
}

module augmented_screw_seat(h=43.8){
    screw_seat(actuator_h, motor_lugs=true);
    difference(){
            side_housing(h=h);
        translate([0,0,29]){
            cylinder(d=30, h=80);
        }
    }
}

module cable_thing(h=7){
    difference(){
        union(){
            hull(){
                for(x_tr = [-.5, .5]*35){
                    translate([x_tr,12,0]){
                        cylinder(d=8, h=h);
                    }
                }
                translate([-11,-11,0]){
                    cylinder(d=8, h=h);
                }
                translate([15,-14.5,0]){
                    cylinder(d=1, h=h);
                }
                
            }
            side_housing(h=h,cavity_h=h-2);
        }
        translate([-50,3.7,1.5]){
            cube([100,100,100]);
        }
        translate([0,12,-1]){
            cylinder(d=29, h=21);
        }
        translate([-10,-6,-1]){
            cube([20,100,21]);
        }
        translate([-8,-12,1]){
            cube([28,6,h-3]);
        }
        translate([0,0,-1]){
            rotate([0,0,-45]){
                cube([25,5,h-1]);
            }
        }
        for(x_tr = [-.5, .5]*35){
            translate([x_tr,12,0]){
                cylinder(d=4.5, h=h, center=true);
            }
        }
        side_housing_cutout(3);
    }
}










