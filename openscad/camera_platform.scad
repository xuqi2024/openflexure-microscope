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

use <utilities.scad>
use <dovetail.scad>
use <z_axis.scad>
include <microscope_parameters.scad> // NB this defines "camera" and "optics"
use <thorlabs_threads.scad>
use <optics.scad>
use <lenses/lens.scad>
use <cameras/camera.scad> // Defines camera_bottom_mounting_posts

dt_bottom = -2; //bottom of dovetail (<0 to allow some play)
$fn=24;


module camera_platform(
        base_r, //radius of mount body
        h //height of dovetail (camera will be above this by 4mm)
    ){
    // Make a camera platform with a dovetail on the side and a platform on the top
    difference(){
        union(){
            // This is the main body of the mount
            sequential_hull(){
                translate([0,0,0]) hull(){
                    cylinder(r=base_r,h=tiny());
                    objective_fitting_base();
                }
                translate([0,0,h]) hull(){
                    cylinder(r=base_r,h=tiny());
                    objective_fitting_base();
                    camera_bottom_mounting_posts(h=tiny());
                }
            }

            // add the camera mount
            translate([0,0,h]) camera_bottom_mounting_posts(r=2, h=4);
        }

        // fitting for the objective mount
        //translate([0,0,dt_bottom]) objective_fitting_wedge();
        // Mount for the nut that holds it on
        translate([0,0,-4]) objective_fitting_cutout(y_stop=true);
        // add the camera mount
        translate([0,0,h]) camera_bottom_mounting_posts(outers=false, cutouts=true);
        // cable routing, if needed
        //rotate(135) translate([-2,0,0.5]) cube([4,999,999]);
    }
}

spacer_z = sample_z - (lens_parfocal_distance()+camera_sensor_height()+lens_spacing());
platform_h = spacer_z-5;  // -5 as board is 1mm thick mounting posts are 4mm thick
if(platform_h < z_flexures_z2) echo("Platform height too low for z-axis mounting");
camera_platform(5, platform_h);