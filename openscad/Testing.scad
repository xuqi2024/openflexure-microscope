use <./illumination_dovetail.scad>
use <./libs/microscope_parameters.scad> 
use <./libs/main_body_structure.scad>
use <./libs/utilities.scad>
use <./libs/libdict.scad>
use <./libs/z_axis.scad>
use <./libs/wall.scad>
use <./libs/z_axis.scad>
use <./libs/illumination.scad>
use <./libs/compact_nut_seat.scad>
use <./libs/main_body_transforms.scad>
use <./libs/gears.scad>

params = default_params();
upright_z_spacer_height = 30;
upright_z_spacer(params);

module half_upright_z_spacer(params){
    difference(){
        hull(){
            each_illumination_corner(params){
                mirror([0,0,1]){
                    cylinder(r=5,h=upright_z_spacer_height);
                }
            }
        }
        translate([0,75,0])
        cylinder(r = 20, h = 100);
        // Holes for screts to go into
        reflect_x(){
            translate(right_illumination_screw_pos(params)){
                rotate(-20){
                    translate_z(-9){
                        m3_nut_trap_with_shaft(0,0);
                    }
                }
            }
        translate([-50, 0, -55])
        cube(size = 100);
        }
    }
}

module upright_z_spacer(params){
    union(){
    half_upright_z_spacer(params);
    translate([0,0,95])
    rotate([0,180,0])
    half_upright_z_spacer(params);    
    }
}

    