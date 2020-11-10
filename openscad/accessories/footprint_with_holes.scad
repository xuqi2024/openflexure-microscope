/*

The "footprint" is the shape of the bottom of the bucket base (roughly 
equivalent to the shape of the bottom of the microscope, minus the front legs).
If you want to cut out a recess that neatly fits the microscope (e.g. for a
foam insert for your flight case, or another laser cut base) this might be the
right answer.  This version includes the mounting holes, making it easier for
you to screw the base down.

You might also want to look at footprint_pocket.scad and footprint.scad.

*/

use <../microscope_stand.scad>;

difference(){
    footprint();

    projection() mounting_holes();
}
