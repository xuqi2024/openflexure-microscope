use <./libs/microscope_parameters.scad>
use <./libs/illumination.scad>
use <./libs/lib_optics.scad>
use <./libs/optics_configurations.scad>
use <./reflection_illuminator.scad>
use <./libs/utilities.scad>
use <./libs/cameras/camera.scad>
use <./libs/cameras/picamera_2.scad>

$fn = 32;
params = default_params(); 
optics_config = pilens_config();
camera_mount_height = camera_mount_height(optics_config);
platform_h = lens_spacer_z(params, optics_config) - 5;
screw_x = picamera_2_hole_spacing()/2;

render(6)   condenser_platform(params, optics_config, 5);

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
                        camera_bottom_mounting_posts(optics_config, h=tiny());
                    }
                }
            }

            // add the camera mount
            translate_z(platform_h){
                camera_bottom_mounting_posts(optics_config, r=2, h=4);
            }
        }

        // Mount for the nut that holds it on
        translate_z(-4){
            objective_fitting_cutout(params, y_stop=true);
        }
        // add the camera mount
        translate_z(platform_h){
            camera_bottom_mounting_posts(optics_config, outers=false, cutouts=true);
        }
    }
}





module condenser_base_hull(){
    // Creates a base for the cylindrical consenser tube to stand on
    translate([0,0,-34]){
        hull(){
            translate([-screw_x,0,34])   cylinder(r = 3.5+tiny(), h = 4);
            translate([screw_x,0,34])   cylinder(r = 3.5+tiny(), h = 4);
            translate([-screw_x,12.5,34])   cylinder(r = 3.5+tiny(), h = 4);
            translate([screw_x,12.5,34])   cylinder(r = 3.5+tiny(), h = 4);
            //Pointed corner part to prevent overhang of condenser
            translate([0,11.5,34])   cylinder(r = 10+tiny(), h = 4);
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
                translate([-2,-1,-34])   rotate([0,0,-45])    camera_mount_counterbore(optics_config);
            }
        }
    }
}

module condenser_and_base(params, optics_config){
    // Combines the condenser only section and the condenser base
    difference(){
        union(){
            condenser_base(params);
            translate([0,12.5,4])   condenser(params, lens_d=13, lens_t=1, lens_assembly_z= 30, include_mounting = false);
        }
        // Creating a large hole for the LED and wires to go through in the base
        translate([0,12.5,-tiny()]) cylinder(r=5, h = 5);
    }
}

