use <./libs/lib_nano_converter_plate.scad>
use <./libs/utilities.scad>

PI_VERSION = 4;

// Define the type of microcontroller
// Options include "ArduinoNano" (Default), "PiPico"
MICROCONTROLLER_TYPE = "ArduinoNano";
//MICROCONTROLLER_TYPE = "PiPico";

// Define the type of Stepper Motor Driver Boards
// Options include "zc_a0591" (Default), "inland"
STEPPER_DRIVER_TYPE = "zc_a0591";
STEPPER_DRIVER_TYPE = "inland";

// Specify if the smart brim should be generated
INCLUDE_BRIM = false;

nano_converter_plate_stl(PI_VERSION, MICROCONTROLLER_TYPE, STEPPER_DRIVER_TYPE, INCLUDE_BRIM);

module nano_converter_plate_stl(pi_version=4, microcontroller_type="ArduinoNano", stepper_driver_type="zc_a0591", include_brim=true){
    brim_radius = include_brim == false ? 0 : 5;
    
    exterior_brim(r=brim_radius, smooth_r = 5){
        nano_converter_plate(pi_version, microcontroller_type, stepper_driver_type);
    }
    echo(str("Pi version: ",pi_version));
}
