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

printable_small_gears();

module printable_small_gears(){
    // Calculate the spacing from the gear pitch radius.
    // Add 4mm of clearance
    spacing = 2*small_gear_pitch_radius() + 4;
    repeat([0, spacing, 0], 3, center=true){
        // 3.15 is a trade off. Firm to push on some printers that print
        // the gears loose. Should be press fit with a small clamp/vice
        // if the printer prints tight. All are then locked with two screws
        // Can be adjusted for printers outside this range.
        small_gear(flat_shaft_w=3.15);
    }
}
