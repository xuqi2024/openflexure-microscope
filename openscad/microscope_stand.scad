// A "bucket" base for the microscope to raise it up and house
// the electronics.
// There are two buckets on a motorised microscope, one to
// hold the Raspberry Pi and one to hold the motor driver.
// The motor driver case stacks underneath, as it's optional.
//
// The buckets (with the exception of the top one that holds
// the microscope body) are stackable - so other accessories
// like a battery pack or SSD for storage could be stacked
// underneath

// (c) Richard Bowman 2019
// Released under the CERN Open Hardware License

use <./libs/microscope_parameters.scad>
use <./libs/lib_microscope_stand.scad>

TALL_BUCKET_BASE = false;

microscope_stand_stl(TALL_BUCKET_BASE);

module microscope_stand_stl(tall_bucket_base){
    pi_stand_h = 42;
    params = default_params();
    microscope_stand(params, pi_stand_h);
    translate([110, -80, 0]){
        rotate([0,0,60]){
            pi_stand(pi_stand_h);
        }
    }
}

