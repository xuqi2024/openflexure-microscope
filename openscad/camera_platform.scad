/******************************************************************
*                                                                 *
* OpenFlexure Microscope: Optics unit                             *
*                                                                 *
* This is part of the OpenFlexure microscope, an open-source      *
* microscope and 3-axis translation stage.  It gets really good   *
* precision over a ~10mm range, by using plastic flexure          *
* mechanisms.                                                     *
*                                                                 *
* The optics module holds the camera and whatever lens you are    *
* using as an objective - current options are either the lens     *
* from the Raspberry Pi camera module, or an RMS objective lens   *
* and a second "tube length conversion" lens (usually 40mm).      *
*                                                                 *
* See the section at the bottom of the file for different         *
* versions, to suit different combinations of optics/cameras.     *
* NB you set the camera in the variable at the top of the file.   *
*                                                                 *
* (c) Richard Bowman, January 2016                                *
* Released under the CERN Open Hardware License                   *
*                                                                 *
******************************************************************/

use <./libs/utilities.scad>
use <./libs/locking_dovetail.scad>
use <./libs/z_axis.scad>
include <./libs/microscope_parameters.scad> // NB this defines "camera" and "optics"
use <./libs/threads.scad>
use <optics.scad>
use <./libs/lenses/lens.scad>
use <./libs/cameras/camera.scad> // Defines camera_bottom_mounting_posts

dt_bottom = -2; //bottom of dovetail (<0 to allow some play)
$fn=24;


// camera_platform(params, base_r, h)
//
// * params - the microscope parameter dictionary
// * base_r - radius of mount body
// * h      - height of dovetail (camera will be above this by 4mm)
module camera_platform(params, base_r, h){
    // Make a camera platform with a dovetail on the side and a platform on the top
    difference(){
        union(){
            // This is the main body of the mount
            sequential_hull(){
                hull(){
                    cylinder(r=base_r,h=tiny());
                    objective_fitting_base(params);
                }
                translate_z(h){
                    hull(){
                        cylinder(r=base_r,h=tiny());
                        objective_fitting_base(params);
                        camera_bottom_mounting_posts(h=tiny());
                    }
                }
            }

            // add the camera mount
            translate_z(h){
                camera_bottom_mounting_posts(r=2, h=4);
            }
        }

        // Mount for the nut that holds it on
        translate_z(-4){
            objective_fitting_cutout(params, y_stop=true);
        }
        // add the camera mount
        translate_z(h){
            camera_bottom_mounting_posts(outers=false, cutouts=true);
        }
    }
}

// TODO: Stop this being in the global scope
params = default_params();
sample_z = key_lookup("sample_z", params);
spacer_z = sample_z - (lens_parfocal_distance()+camera_sensor_height()+lens_spacing());
platform_h = spacer_z-5;  // -5 as board is 1mm thick mounting posts are 4mm thick
assert(platform_h > z_flexures_z2(params), "Platform height too low for z-axis mounting");
camera_platform(params, 5, platform_h);