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

render(6) upright_condenser_and_mount_stl(params = default_params() , optics_config = pilens_config() );

// Test for led_boring_holes
//translate([20,0,0]) led_boring_holes(boring_radius = 6);

module upright_condenser_and_mount_stl(params,optics_config){
    $fn = 32;
    condenser_and_platform(params, optics_config);
}

module condenser_top_hull(){
    // Creates a base for the cylindrical consenser tube to stand on.
    cylinder(r =10+tiny(), h = 0.5);

}

module upright_objective_fitting_cutout(params, y_stop=true){
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
    // screw_x = picamera_2_hole_spacing()/2;
    screw_shift = 15; // Vertical distance the mounting screw needs to be translated by to insert into the z-axis of the main body

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

module led_boring_holes(boring_radius){
    // Boring holes for the LED to be inserted into the condenser
    led_access_h=10;
    // Diameter of LED flange is 6mm. This needs to fit through teh square/octagonal hole of the hole_from_bottom
    led_diameter = 7;
    translate([0,0,tiny()]){
        intersection(){
            union(){
                translate([0,0,0.5-led_access_h+tiny()]) {
                    cylinder(r=boring_radius, h = led_access_h);
                }
                translate([0,0,-4]){
                    hull(){
                        cylinder(r = boring_radius + tiny(), h = 0.5);
                        translate([0,-25,-30]) {
                            cylinder(r = boring_radius + tiny(), h = 0.5);
                        }
                    }
                }
            }
            translate([0,0,-2.0]){
                hole_from_bottom(r=led_diameter/2, h=2, base_w=999, delta_z=0.4, layers=2, big_bottom=true);
            }
        }
          
        
    } 
}

module condenser_and_platform(params, optics_config){
    // Combines the isolated condenser unit with the platform to create a single structure.  
        platform_h = lens_spacer_z(params, optics_config) - 5;
    difference(){
        union(){
            condenser_platform(params, optics_config, base_r=5);
            translate([0,0,platform_h])   condenser(params, lens_d=13, lens_t=1, lens_assembly_z= 30, include_mounting = false);
        }
        // Creating a large hole for the LED and wires to go through in the base
        translate([0,0,platform_h+0.5]){
            led_boring_holes(boring_radius = 6);
        }
    }
}