// Creating an condenser and condenser mount for the Upright microscope. 

use <./libs/microscope_parameters.scad>
use <./libs/illumination.scad>
use <./libs/lib_optics.scad>
use <./libs/optics_configurations.scad>

params = default_params();
optics_config = pilens_config();

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

module condenser_base(params, optics_config){
    // Creates a base for the cylindrical consenser tube to stand on
    difference(){
        camera_platform(params, optics_config, 5);
        translate([-20,-20,35]) cube([40,40,100]);
    }
}

module condenser_only_and_base(params, optics_config){
    // Combines the condenser only section and the condenser base
    union(){
        condenser_base(params, optics_config);
        translate([-3,5,34])   condenser_only(params);
    }
}