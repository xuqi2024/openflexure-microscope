/******************************************************************
*                                                                 *
* OpenFlexure Microscope: Microscope body transforms              *
*                                                                 *
* Various transforms used in the microscope.                      *
*                                                                 *
* (c) Richard Bowman, January 2016                                *
* Released under the CERN Open Hardware License                   *
*                                                                 *
******************************************************************/

use <./utilities.scad>
use <../compact_nut_seat.scad>
use <libdict.scad>
include <../microscope_parameters.scad>

module shear_x(amount=1){
    // Shear transformation: tilt the Y axis towards the X axis
    // e.g. if amount=1, then a straight line in Y will be
    // tilted to 45 degrees between X and Y, while X lines are
    // unchanged.  This is used in the Z axis.
	multmatrix([[1,amount,0,0],
					 [0,1,0,0],
					 [0,0,1,0],
					 [0,0,0,1]]) children();
}


module leg_frame(params, angle){
    leg_r = key_lookup("leg_r", params);
    // Transform into the frame of one of the legs of the stage
	rotate(angle) translate([0,leg_r,]) children();
}
module each_leg(params){
    // Repeat for each of the legs of the stage
	for(angle=[45,135,-135,-45]) leg_frame(params, angle) children();
}
module each_actuator(params){
    // Repeat this for both of the actuated legs (the ones with levers)
	reflect([1,0,0]) leg_frame(params,45) children();
}

module place_on_wall(params){
    //this is a complicated transformation!  The wall runs from
    leg_r = key_lookup("leg_r", params);
    wall_start = [z_flexure_x(params)+wall_t/2,-wall_t/2,0]; // to
    wall_end = ([1,1,0]*(leg_r+actuating_nut_r(params))
                 +[1,-1,0]*(ss_outer().x/2-wall_t/2))/sqrt(2);
    wall_disp = wall_end - wall_start; // vector along the wall base
    // pivot about the starting corner of the wall so X is along it
    translate(wall_start) rotate(atan(wall_disp.y/wall_disp.x))
    // move out to the surface (the above are centres of cylinders)
    // and then align y with the vertical axis of the wall
    translate([0,-wall_t/2,0]) rotate([90-atan(wall_t/inner_wall_h(params)/sqrt(2)),0,0])
    // now X and Y are in the plane of the wall, and z=0 is its surface.
    children();
}