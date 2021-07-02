// Creating an condenser and condenser mount for the Upright microscope. 

use <./libs/microscope_parameters.scad>
use <./libs/illumination.scad>
use <./libs/lib_optics.scad>
use <./libs/optics_configurations.scad>
use <./reflection_illuminator.scad>
use <./libs/utilities.scad>
use <./libs/cameras/camera.scad>

$fn = 32;
params = default_params(); 
optics_config = pilens_config();
camera_mount_height = camera_mount_height(optics_config);
platform_h = lens_spacer_z(params, optics_config) - 5;

condenser_only_and_base(params, optics_config);



module condenser_bounary(){
    // Creates a cylindrical tube to remove the condenser attachment for use in the upright microscope
    difference(){
        cylinder(d = 150, h = 40);
        translate([0,0,-1])  cylinder(d = 17, h = 42); 
    }
}

module condenser_only(params){
    difference(){
        condenser(params, lens_d=13, lens_t=1, lens_assembly_z= 30);
        translate([0,0,-1]) condenser_bounary();
    }
}

module condenser_base_hull(){
    // Creates a base for the cylindrical consenser tube to stand on
    translate([-1,11,0])   rotate([0,0,135]){
        hull(){
            translate([-9.5,-5.5,34])   cylinder(r = 3.5+tiny(), h = 4);
            translate([3.5,-5.5,34])   cylinder(r = 3.5+tiny(), h = 4);
            translate([-9.5,15.5,34])   cylinder(r = 3.5+tiny(), h = 4);
            translate([3.5,15.5,34])   cylinder(r = 3.5+tiny(), h = 4);
            //Pointed coerner part to prevent overhang of condenser
            translate([-18,4.5,34])   cylinder(r = 1.5+tiny(), h = 4);

        }
    }
}

module condenser_base(params){
    // Creates a base for the cylindrical consenser tube to stand on
    difference(){
        condenser_base_hull();
        // add the screw holes
        translate([2,1,35-tiny()]){
            translate_z(camera_mount_height){
                camera_mount_counterbore(optics_config);
            }
        }
    }
}

module condenser_only_and_base(params, optics_config){
    // Combines the condenser only section and the condenser base
    difference(){
        union(){
            condenser_base(params);
            translate([2.5,1,35])   condenser_only(params);
        }
        // Creating a large hole for the LED and wires to go through in the base
        translate([2.5,1,15]) cylinder(r=5, h = 25);
    }
}