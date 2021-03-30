/******************************************************************
*                                                                 *
* OpenFlexure Microscope: Lens spacer                             *
*                                                                 *
* This is an alternative optics module (optics.scad) that is to   *
* be used together with the camera platform, to make a cheap      *
* optics module that uses the webcam lens.  New in this version   *
* is compatibility with the taller stage (because the sensor is   *
* no longer required to sit below the microscope body).           *
*                                                                 *
* (c) Richard Bowman, November 2018                               *
* Released under the CERN Open Hardware License                   *
*                                                                 *
******************************************************************/

use <./libs/utilities.scad>
// NOTE: microscope_parameters defines which "camera" and "optics" are used for the lens spacer.
// You must change it in that file not this one.
include <./libs/microscope_parameters.scad>
// ./libs/cameras/camera.scad will use the correct camera module for generating camera mounts
// depending on the "camera" variable
use <./libs/cameras/camera.scad>
use <./libs/lenses/lens.scad>
$fn=24;



module optical_path(lens_aperture_r, lens_z, bottom_z=0){
    // The cut-out part of a camera mount, consisting of
    // a feathered cylindrical beam path.  Camera mount is now cut out
    // of the camera mount body already.
    union(){
        //beam path
        translate_z(bottom_z-tiny()){
            lighttrap_cylinder(r1=5, r2=lens_aperture_r, h=lens_z-bottom_z+2*tiny());
        }
        //lens
        translate_z(lens_z){
            cylinder(r=lens_aperture_r,h=2*tiny());
        }
    }
}

module lens_gripper(lens_r=10,h=6,lens_h=3.5,base_r=-1,t=0.65,solid=false, flare=0.4){
    // This creates a tapering, distorted hollow cylinder suitable for
    // gripping a small cylindrical (or spherical) object
    // The gripping occurs lens_h above the base, and it flares out
    // again both above and below this.
    trylinder_gripper(inner_r=lens_r, h=h, grip_h=lens_h, base_r=base_r, t=t, solid=solid, flare=flare);
}


module camera_mount_top_slice(){
    // A thin slice of the top of the camera mount
    linear_extrude(tiny()){
        projection(cut=true){
            camera_mount();
        }
    }
}

function lens_aperture(lens_r) = lens_r - 1.5;

module lens_spacer_gripper(lens_r, lens_h, pedestal_h, lens_assembly_base_r, lens_assembly_z){

    lens_assembly_h = lens_h + pedestal_h; //height of the lens assembly

    // A lens gripper to hold the objective
    translate_z(lens_assembly_z){
        // gripper
        trylinder_gripper(inner_r=lens_r,
                          grip_h=lens_assembly_h-1.5,
                          h=lens_assembly_h,
                          base_r=lens_assembly_base_r,
                          flare=0.4,
                          squeeze=lens_r*0.15);
        // pedestal to raise the tube lens up within the gripper
        difference(){
            cylinder(r=lens_aperture(lens_r) + 1.0,h=pedestal_h);
            cylinder(r=lens_aperture(lens_r),h=999,center=true);
        }
    }
}

module lens_spacer(params, lens_r, parfocal_distance, lens_h, lens_spacing){
    // Mount a lens some distance from the camera

    //z position of lens once in microscope
    //lens sits parfocal_distance below the sample
    lens_z_microscope = key_lookup("sample_z", params) - parfocal_distance;

    // z_position of the lens for this piece.
    //This is the height of the camera_sensor above the circuit board plus the spacing between the lens and the sensor
    lens_z = camera_sensor_height()+lens_spacing;

    pedestal_h = 4; // extra height on the gripper, to allow it to flex
    lens_assembly_z = lens_z - pedestal_h; //z position of the bottom of the lens assembly

    lens_assembly_base_r = lens_r+1; //outer size of the lens grippers

    //This is the height of the block the camera mounts into.
    camera_mount_height = camera_mount_height();

    translate_z(lens_z_microscope-lens_z){
        difference(){
            union(){
                // This is the main body of the mount
                sequential_hull(){
                    translate_z(camera_mount_height){
                        camera_mount_top_slice();
                    }
                    translate_z(camera_mount_height+5){
                        cylinder(r=6,h=tiny());
                    }
                    translate_z(lens_assembly_z){
                        cylinder(r=lens_assembly_base_r, h=tiny());
                    }
                }

                lens_spacer_gripper(lens_r, lens_h, pedestal_h, lens_assembly_base_r, lens_assembly_z);

                // add the camera mount
                translate_z(camera_mount_height){
                    camera_mount(screwhole=false, counterbore=false);
                }
            }
            union(){
                // cut out the optical path
                optical_path(lens_aperture(lens_r), lens_assembly_z, 0);
                //cut out counterbores
                translate_z(camera_mount_height){
                    camera_mount_counterbore();
                }
            }
        }
    }
}


// Note do not try to set the optics in this file things will go wrong.
// You must define the optics and camera type in microscope_parameters or run openscad in the terminal with the -D flag
if(optics=="pilens"){
    // Optics module for picamera v2 lens

    lens_spacer(
        params = default_params(),
        lens_r = lens_radius(),
        parfocal_distance = lens_parfocal_distance(),
        lens_h = lens_height(),
        lens_spacing = lens_spacing()
    );

}
else{
    echo("No lens_spacer available for this lens type");

}