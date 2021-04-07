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

params = default_params();
microscope_stand(params);