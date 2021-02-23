/******************************************************************
*                                                                 *
* OpenFlexure Microscope: Microscope Parameters                   *
*                                                                 *
* This is the top-level configuration file for the OpenFlexure    *
* microscope, an open microscope and 3-axis translation stage.    *
* It gets really good precision over a ~10mm range, by using      *
* plastic flexure mechanisms.                                     *
*                                                                 *
* Generally I've tried to put parts (or collections of closely    *
* related parts) in their own files.  However, all the parts      *
* depend on the geometry of the microscope - so these parameters  *
* are gathered together here.  In general, the ones you might     *
* to change are towards the top!  Lower-down ones are defined in  *
* terms of higher-up ones - confusion might arise if you redefine *
* these later...                                                  *
*                                                                 *
* (c) Richard Bowman, January 2016                                *
* Released under the CERN Open Hardware License                   *
*                                                                 *
* http://www.github.com/rwb27/openflexure_microscope              *
* http://www.docubricks.com/projects/openflexure-microscope       *
* http://www.waterscope.org                                       *
*                                                                 *
******************************************************************/

use <./libdict.scad>

$fn=32;

// These are the most useful parameters to change!
motor_lugs = true;
version_numstring = "6.1.3";
camera = "picamera_2"; //see cameras/camera.scad for valid values
optics = "rms_f50d13"; //see optics.scad for valid values
led_r = 4.5/2; //size of the LED used for illumination
endstops = false; //whether to build mounts for optical endstops inside the microscope.
feet_endstops = false; //whether to include cut-outs for endstop switches in the feet.
beamsplitter = true; //enables a cut-out in some optics modules for a beamsplitter
delta_stage = false;

enable_smart_brim = true;
tall_bucket_base = false; //If true creates a taller bucket base for the infinity corrected optics.

// This sets the basic geometry of the default microscope
// Stages can be built with modified parameters but with **no guarantee** that any other
// set of parameters will work.
// These parameters define the default size for the structural elements of the micoroscope, optics parameters are set seperately.
function default_params() = [["leg_r", 30],     // radius on which the innermost part of legs sit. (This sets the stage size)
                             ["sample_z", 75 ], // z position of sample
                             ["stage_t", 15],   //thickness of the XY stage (at thickest point, most is 1mm less)
                             ["leg_block_t", 5], // Thickness of the block at the top and bottom of the leg
                             ["stage_hole_r", 20], // size of hole in the stage
                             ["xy_lever_ratio", 4.0/7.0], // mechanical advantage of actuator over xy-stage - can be used to trade speed and precision
                             ["z_lever_ratio", 1.0], //  mechanical advantage of actuator over objective mount (must be >1)
                             ["condenser_angle", 15], //angle of the top of the condenser relative to the xy plane
                             ["print_ties", true], //sets whether the ties that support printing are on. It is usefull to be able to turn these off for rendering
                             ["smart_brim_r", 5] // The radius of the smart brim on the main body
                            ]; 


// height of the top of the leg. Shorter than sample x so that you can get nuts in, and so the slide doesn't crash.
function leg_height(params) = let(
    sample_z = key_lookup("sample_z", params),
    stage_t = key_lookup("stage_t", params),
    leg_block_t = key_lookup("leg_block_t", params)
) sample_z - stage_t + leg_block_t;



// The variables below affect the position of the objective mount
z_strut_l = 18; //length of struts supporting Z carriage
objective_mount_y = 18; // y position of clip for optics
objective_mount_nose_w = 6; // width of the pointy end of the mount
condenser_clip_w = 14; // width of the dovetail clip for the condenser
foot_height=15;

// This variables set the dimensions of flexures.
// It is well tested with PLA.
function flex_dims() = let
(
    flex_w = 4, // width  of flexures
    flex_l = 1.5,    // length of flexures
    flex_t = 0.75// thickness  of flexures
)  [flex_w, flex_l, flex_t];

// This returns the sine of the angle through which flexures can be bent
// Note: sin(8.62 deg) = 0.15
function flex_a() = 0.15;


// TODO: Work out what to do with this. This used to be called every time the params file was included
//       but as we move away from includes it is less useful, and sample_z is no longer global.
// Compile a sensible version string
//version_string = str("v",version_numstring, sample_z, motor_lugs?"-M":"");
//echo(str("Compiling OpenFlexure Microscope ",version_string));


stage_hole_inset = flex_dims().y+4; // how far the holes on the XY stage are inset from leg_r
flex_z1 = 0;      // z position of lower flexures for XY axis
function flex_z2(params) = leg_height(params) - key_lookup("leg_block_t", params); //height of upper XY flexures
z_strut_t = 6;  // (z) thickness of struts for Z axis
function leg_dims(params) = [4,flex_dims().x,flex_z2(params)+flex_dims().z]; // size of vertical legs
leg_middle_w = 12; // width of the middle part of each leg
actuator_h = 25; //height of the actuator columns
dz = 0.5; //small increment in Z (~ 2 layers)

function leg_outer_w(params) = leg_middle_w + 2*flex_dims().y + 2*leg_dims(params).x; // overall width of parallelogram legs that support the stage

//TODO understand and check this. Where are those numbers from?
// dimensions of the core part of the actuating levers for X and Y -
// NB should match the column_base_r in compact_nut_seat.scad
function actuator_dims(params) = let(
    width = 3*1.2+2*2
 ) [width, actuating_nut_r(params), 6];

// TODO: Work out why this has this name and change it
// distance from leg_r to the actuating nut/screw for the XY axes
// Length of actuator is the diference in sistance between flexures
// at top and bottom of leg, multiplied by the lever ratio
function actuating_nut_r(params) = let(
    xy_lever_ratio = key_lookup("xy_lever_ratio", params)
) (flex_z2(params) - flex_z1) * xy_lever_ratio;

function xy_actuator_travel(params) = actuating_nut_r(params)*0.15; // distance moved by XY axis actuators

// Z axis
z_flexures_z1 = 8; // height of the lower flexure on z actuator
function z_flexures_z2(params) = min(leg_height(params) - 12, 35); // height of the upper flexure on z actuator
objective_mount_back_y = objective_mount_y + 2; //back of objective mount
z_anchor_y = objective_mount_back_y + z_strut_l + 2*flex_dims().y; // fixed end of the flexure-hinged lever that actuates the Z axis
z_anchor_w = 20; //width of the Z anchor

//required actuator lever length
function z_lever_length(params) = let(
    z_lever_ratio = key_lookup("z_lever_ratio", params)
) (z_strut_l + flex_dims().y)*z_lever_ratio;


function z_nut_y(params) = let(
    // Note that the lever is tilted so we need to find the y projection
    // from the z lever length and the z position of the bottom z flexure
    lev_len_sq = pow(z_lever_length(params), 2),
    bot_z_flex_z_sq = pow(z_flexures_z1, 2),
    z_lever_y_proj = sqrt(lev_len_sq - bot_z_flex_z_sq)
    ) z_anchor_y - flex_dims().y/2 + z_lever_y_proj;


function z_actuator_travel(params) = z_lever_length(params)*0.15; // distance moved by the Z actuator
function z_actuator_tilt(params) = -asin(z_flexures_z1/z_lever_length(params)); //angle of the Z actuator

//TODO understand and rename this
// x position of the outside of the Z-axis static anchors (either side of the XY stage, on the X axis) 
// (no longer used by Z axis but still in use elsewhere.)
function lug_x_pos(params) = let(
    leg_r = key_lookup("leg_r", params),
    tenth_of_height = max(5,leg_dims(params).z*0.1)
) (leg_r-flex_dims().y-tenth_of_height)*sqrt(2);

leg_link_spacing = 10;
base_t=1; // thickness of the flat base of the structure
wall_h=15; // height of the stiffening vertical(ish) walls
wall_t=2; //thickness of the stiffening walls
function inner_wall_h(params) = z_flexures_z2(params) - 10; //height of walls inside xy_stage

// base_mounting_holes returns a list of the holes for mounting the microscope
// to the base. By default it returns all four holes.
// To get only the lugs run `base_mounting_holes("lugs")`
// To get only the front holes run `base_mounting_holes("front")`
function base_mounting_holes(params, type="all") = let
(
    lug_pos = [[lug_x_pos(params)+4,-8,0],
               [-lug_x_pos(params)-4,-8,0]],
    front_pos =[[-20,z_nut_y(params)-4,0],
                [20,z_nut_y(params)-4,0]],
    lugs = (type == "lugs") || (type == "all"),
    front = (type == "front") || (type == "all"),
    //Set which holse to output
    holes = [lugs?lug_pos:[], front?front_pos:[]]
    //Final list comprehension make a single list of holes
) [for (h = holes) each h];

endstop_extra_ringheight=feet_endstops?1:0;

fl_cube_w = 16; //width of the fluorescence filter cube