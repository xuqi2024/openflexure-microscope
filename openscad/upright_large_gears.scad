/******************************************************************
*                                                                 *
* OpenFlexure Microscope: Gears for actuators                     *
*                                                                 *
* This is part of the OpenFlexure microscope, an open-source      *
* microscope and 3-axis translation stage.  It gets really good   *
* precision over a ~10mm range, by using plastic flexure          *
* mechanisms.                                                     *
* This file generates a small gear, for motor control.            *
*                                                                 *
* (c) Richard Bowman, January 2016                                *
* Released under the CERN Open Hardware License                   *
*                                                                 *
******************************************************************/

use <./libs/gears.scad>
use <./libs/utilities.scad>

printable_large_gears();

module printable_large_gears(){
    // Calculate the spacing from the gear pitch radius.
    // Add 4mm of clearance
    spacing = 2*large_gear_pitch_radius() + 4;
    repeat([0, spacing, 0], 2, center=true){
        repeat([spacing, 0, 0], 2, center=true){
            large_gear();
        }
    }
}
