
use <./microscope_parameters.scad>
use <./illumination.scad>
use <./lib_optics.scad>
use <./libdict.scad>
use <./utilities.scad>
use <./z_axis.scad>


// module upright_condenser_top_hull(){
//     // Creates a base for the cylindrical consenser tube to stand on.
//     cylinder(r =10+tiny(), h = tiny());

// }

// module upright_objective_fitting_cutout(params, y_stop=true){
//     // Creates a mount for the nut and screw hole that holds it on
//     difference(){
//         objective_fitting_cutout(params, y_stop=y_stop);
//         translate([-50, -10,35]){
//             cube([100,100,1000]);
//         }
//     }
// }

// the condenser lens is 5mm focal length and the body is 30mm long
// seems to be formed from:
//    condenser_lens_assembly_z() (22mm) + condenser_lens_diameter()/2 (6.5mm) 
//    + lens base thickness (1mm) + gripper (1.5mm)
// effective lens position at 30 - 1.5 mm
function  upright_condenser_platform_height() = let(
    sample_z = key_lookup("sample_z", default_params()),
    platform_ht = sample_z - 5 - (condenser_lens_assembly_z() + 6.5 -1.5 )
) platform_ht;

// Module to create a platform with a fitting wedge for the z-axis
// and a mounting face for the condenser adn cut-out for a 5mm LED or LED PCB
module upright_condenser_platform_separate(params, base_r){

    platform_h = upright_condenser_platform_height();
    assert(platform_h > upper_z_flex_z(params), "Platform height too low for z-axis mounting");

    // Make a platform with a dovetail on the side and a platform on the top
    // this is similar to the camera_platform, but does not have posts and has an extra cut-out
    // so it is defined separately.
    difference(){
        union(){
            // This is the main body of the mount
            sequential_hull(){
                hull(){
                    cylinder(r=base_r,h=tiny());
                    objective_fitting_wedge(h=tiny());
                }
                translate_z(platform_h-tiny()){
                    hull(){
                        // cylinder above base
                        cylinder(r=base_r,h=tiny());
                        objective_fitting_wedge(h=tiny());
                        // cylinder to match the base of the condenser
                        lens_d=condenser_lens_diameter();
                        cylinder(r = condenser_base_r(lens_d) + 2, h = tiny());
                        // mounting positions for the condenser
                        reflect_x(){
                            translate_x(upright_condenser_lug_x()){
                                cylinder(r=4, h=tiny());
                            }
                        }
                    }
                }
            }
        }
        union(){
            // Mount for the nut and screw hole that holds it on
            translate([0,tiny(),0]){
                objective_fitting_cutout(params, y_stop=true);
            }
            translate_z(platform_h){
                // rotate cable exit away from dovetail
                rotate_z(180){
                    //allow space for 2 screw heads and for board thickness
                    board_bore_depth = 6.5;
                    // Note: in illumination_board_cutout, 
                    // h is used both for positioning and for the sizes of the cut-out parts
                    // final position is relative to a mounting plane at z=h
                    h = condenser_lid_h();
                    translate_z(-condenser_lid_h()){
                        illumination_board_cutout(h, board_bore_depth);
                    }
                }
                reflect_x(){
                    translate([upright_condenser_lug_x(),0,tiny()]){
                        mirror([0,0,1]){
                            no2_selftap_hole(h=8);
                        }
                    }
                }
            }
            // Undercut on build plate
            // undercut_objective_fitting_wedge(undercut_height = 1.5);
        }
    }
}

// module led_boring_holes(boring_radius){
//     // Boring holes for the LED to be inserted into the condenser
//     led_access_h=10;
//     // Diameter of LED flange is 6mm. This needs to fit through teh square/octagonal hole of the hole_from_bottom
//     led_diameter = 7;
//     translate([0,0,tiny()]){
//         intersection(){
//             hull(){
//                 translate([0,0,0.5-led_access_h+tiny()]) {
//                     cylinder(r=boring_radius, h = led_access_h);
//                 }
//                 translate([0,0,-4]){
//                     hull(){
//                         cylinder(r = boring_radius + tiny(), h = 0.5);
//                         translate([0,-25,-30]) {
//                             cylinder(r = boring_radius + tiny(), h = 0.5);
//                         }
//                     }
//                 }
//             }
//             translate([0,0,-2.0]){
//                 hole_from_bottom(r=led_diameter/2, h=2, base_w=999, delta_z=0.4, layers=2, big_bottom=true);
//             }
//         }
//     }
// }

// // Condenser including mount to z-axis dovetail
// // for use with upright microscope
// // 5mm LED only - note : poor LED fit
// module upright_condenser(params, optics_config){
//     $fn = 32;
//     // Combines the isolated condenser unit with the platform to create a single structure.  
//         platform_h = lens_spacer_z(params, optics_config) - 5;
//     difference(){
//         union(){
// //TODO
// //            upright_condenser_platform(params, optics_config, base_r=5);
//             translate([0,0,platform_h]){
//                 condenser(lens_assembly_z= 30, include_mounting = false, basic_condenser = true);
//             }
//         }
//         // Creating a large hole for the LED and wires to go through in the base
//         translate([0,0,platform_h+0.5]){
//             led_boring_holes(boring_radius = 6);
//         }
//     }
// }

function upright_condenser_lug_x() = 12;
// Condenser for attaching to platform to mount to z-axis dovetail
// for use with upright microscope
// 5mm LED or LED PCB
module upright_condenser_separate(){
    condenser(lens_assembly_z= condenser_lens_assembly_z(), include_mounting = false, basic_condenser = true);
    lens_d=condenser_lens_diameter();
    base_r = condenser_base_r(lens_d);
    difference(){
        hull(){
            cylinder(r=5, h=8);
            reflect_x(){
                translate_x(upright_condenser_lug_x()){
                    cylinder(r=4, h=4);
                }
            }
        }
        union(){
            // base of condenser module is size base_r + 0.2 
            // in the condenser_body() module of illumination.scad
            // so cutout base_r is certainly smaller, no need for - tiny()
            cylinder(r=base_r , h=99, center = true);
            reflect_x(){
                translate([upright_condenser_lug_x(),0,2]){
                    no2_selftap_counterbore(flip_z=false);
                    }
            }
        }
    }
}


