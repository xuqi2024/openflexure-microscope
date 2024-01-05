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

RATIO = 2;

printable_large_gears(ratio=RATIO);

module printable_large_gears(ratio=2){
    // check the ratio gives an integer number of teeth
    assert(floor(n_teeth_large_gear(ratio))==n_teeth_large_gear(ratio),"The number of teeth on the large gear is not integer");
    // Calculate the spacing from the gear pitch radius.
    // Add 4mm of clearance
    spacing = 2*large_gear_pitch_radius(ratio) + 4;
    repeat([0,spacing,0],3,center=true){
        large_gear(ratio);
    }
}
