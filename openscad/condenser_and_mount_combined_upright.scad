use <./libs/microscope_parameters.scad>
use <./libs/illumination.scad>
use <./libs/lib_optics.scad>
use <./libs/libdict.scad>
use <./libs/optics_configurations.scad>
use <./reflection_illuminator.scad>
use <./libs/utilities.scad>
use <./libs/cameras/camera.scad>
use <./libs/cameras/picamera_2.scad>
use <./libs/z_axis.scad>

$fn = 32;
params = default_params(); 
optics_config = pilens_config();
platform_h = lens_spacer_z(params, optics_config) - 5;
screw_x = picamera_2_hole_spacing()/2;
screw_shift = 10; // Vertical distance the mounting screw needs to be translated by to insert into the z-axis of the main body

module condenser_top_hull(){
    // Creates a base for the cylindrical consenser tube to stand on
    rotate_z(45){
        hull(){
            translate([-screw_x,0,0])   cylinder(r = 2, h = 0.5);
            translate([screw_x,0,0])   cylinder(r = 2, h = 0.5);
            translate([-screw_x,12.5,0])   cylinder(r = 2, h = 0.5);
            translate([screw_x,12.5,0])   cylinder(r = 2, h = 0.5);
            //Creates a curved arc for one side of the hull to prevent overhang of condenser
            cylinder(r =10+tiny(), h = 0.5);
        }
    }
}

module upright_objective_fitting_cutout(){
    // Creates a mount for the nut and screw hole that holds it on
    difference(){
        objective_fitting_cutout(params, y_stop=true);
        translate([-50, -10,35])   cube([100,100,1000]);
    }
}

module condenser_platform(params, optics_config, base_r){

    assert(key_lookup("optics_type", optics_config)=="spacer", "Use spacer optics configuration to create a camera_platform.");

    // platform height is 5mm below the lens spacer (board is 1mm thick mounting posts are 4mm tall)
    platform_h = lens_spacer_z(params, optics_config) - 5;
    assert(platform_h > upper_z_flex_z(params), "Platform height too low for z-axis mounting");


    // Make a camera platform with a dovetail on the side and a platform on the top
    difference(){
        union(){
            // This is the main body of the mount
            sequential_hull(){
                hull(){
                    cylinder(r=base_r,h=tiny());
                    objective_fitting_base(params);
                }
                translate_z(platform_h){
                    hull(){
                        cylinder(r=base_r,h=tiny());
                        objective_fitting_base(params);
                        condenser_top_hull();
                    }
                }
            }
        }
        // Mount for the nut and screw hole that holds it on
        translate([0,tiny(),screw_shift])   upright_objective_fitting_cutout(params, y_stop=false);
    }
}

module LED_boring_holes(boring_radius){
    // Boring holes for the LED to be inserted into the condenser
    translate([0,0,41+tiny()]){
        rotate_z(225){
            hull(){
                cylinder(r = boring_radius + tiny(), h = 0.5);
                translate([0,25,-30]) cylinder(r = boring_radius + tiny(), h = 0.5);
            }
        }  
    } 
}

module condenser_and_platform(params, optics_config){
    // Combines the isolated condenser unit with the platform to create a single structure.  
    difference(){
        union(){
            condenser_platform(params, optics_config);
            translate([0,0,platform_h])   condenser(params, lens_d=13, lens_t=1, lens_assembly_z= 30, include_mounting = false);
        }
        // Creating a large hole for the LED and wires to go through in the base
        translate([0,0,41-tiny()]) cylinder(r=5, h = 10);
        LED_boring_holes(boring_radius = 6);
    }
}