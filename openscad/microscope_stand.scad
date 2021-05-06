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

//microscope_stand_stl(TALL_BUCKET_BASE);

module microscope_stand_stl(tall_bucket_base){
    base_height = 42;
    params = default_params();
    microscope_stand(params, base_height);
}

rendered();
//to_print();

//TODO remove this befoe release
module to_print(){
    params = default_params();
    pi_stand_h = 42;
    microscope_stand(params, pi_stand_h);
    //pi_stand(pi_stand_h);
}

//TODO remove this befoe release
module rendered(){
    params = default_params();
    pi_stand_h = 42;
    color("#505050"){
        render(6){
            microscope_stand(params, pi_stand_h);
        }
    }
    color("Dodgerblue"){
        render(6){
            pi_stand_frame_xy(params){
                pi_stand(pi_stand_h);
            }
        }
    }
}