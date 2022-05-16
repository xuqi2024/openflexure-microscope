/******************************************************************
*                                                                 *
* OpenFlexure Microscope: Gears for actuators                     *
*                                                                 *
* This is part of the OpenFlexure microscope, an open-source      *
* microscope and 3-axis translation stage.  It gets really good   *
* precision over a ~10mm range, by using plastic flexure          *
* mechanisms.                                                     *
*                                                                 *
* (c) Richard Bowman, January 2016                                *
* Released under the CERN Open Hardware License                   *
*                                                                 *
******************************************************************/

use <./MCAD/involute_gears.scad> // forward slash - for platform independence
use <./microscope_parameters.scad>
use <./utilities.scad>


/*
* Gearing ratio between the large and small gears
*/
function gear_ratio() = 2;

/**
* Number of teeth on the small gear
*/
function n_teeth_small_gear() = 12;

/**
* Number of teeth on the large gear
*/
function n_teeth_large_gear() = n_teeth_small_gear() * gear_ratio();

/**
* Distance from the centre of the small gear to the centre of the large gear
*/
function gear_c2c_distance() = 20;

/**
* The cirular pitch used for both the small and large gears
*/
function gear_pitch() = gear_c2c_distance() * 360 / (n_teeth_small_gear() + n_teeth_large_gear());

/**
* The pitch radius for the large gear.
* The pitch radius is the ditance from the centre of gear to the meshing point.
* This is calcualted as:
*    pitch radius = Nteeth * circular_pitch / 360
*/
function large_gear_pitch_radius() = gear_pitch_radius(gear_pitch(), n_teeth_large_gear());


/**
* The total radius of the large gear
*/
function large_gear_radius() = gear_outer_radius(large_gear_pitch_radius(), n_teeth_large_gear());

/**
* The poisition of the screw for the large gear relateive to the centre of the bottom plane of the gear.
*/
function large_gear_screw_pos() = [0, 0, 1.5];

/**
* The pitch radius for the small gear.
* The pitch radius is the ditance from the centre of gear to the meshing point.
* This is calcualted as:
*    pitch radius = Nteeth * circular_pitch / 360
*/
function small_gear_pitch_radius() = gear_pitch_radius(gear_pitch(), n_teeth_small_gear());

/**
* The total radius of the small gear measired over the teeth
*/
function small_gear_radius() = gear_outer_radius(small_gear_pitch_radius(), n_teeth_small_gear());

/**
* The value of $fn used for the small gear
*/
function small_gear_fn() = 32;

/**
* Radius of the flange on the large gear. This is larger than the radius across the teeth
* by half the distance from the meshing point to the end of the teeth.
*/
function small_gear_flange_radius() = let(
    pitch_r = small_gear_pitch_radius(),
    outer_r = small_gear_radius(),
    additional_r = (outer_r-pitch_r)/2
) outer_r + additional_r;

/**
* Large gears that are attached to the actuator lead screw and sit ontop
* of the actuator housing. These are driven by the small gear (see `small_gear()`).
*/
module large_gear(){
    $fn=32;

    pitch_r = large_gear_pitch_radius();

    difference(){
        // intersection used to chamfer the bottom of the gear
        intersection(){
            gear(number_of_teeth=n_teeth_large_gear(),
                 circular_pitch=gear_pitch(),
                 circles=0,
                 gear_thickness=6,
                 hub_thickness=6,
                 hub_diameter=20,
                 rim_thickness=6,
                 bore_diameter=1);
            cylinder(r1=pitch_r-2,r2=pitch_r+18,h=20);
        }
        translate(large_gear_screw_pos()){
            nut(3,shaft=true,fudge=1.2,h=999);
        }
    }
}

function small_gear_height() = 9.5;
function small_gear_screw_hole(flat_shaft_w=3.15) = let(
    //Adding 1.25 makes the wall very close to 0.4 mm
    // Should print as a single filament with a 0.4mm nozzle
    y=flat_shaft_w/2+1.25,
    z=small_gear_height()-1.5
) [0, y, z];


/**
* The cut-out in the small gear for the motor shaft
*/
module motor_shaft_cut_out(flat_shaft_w){
    shaft_d=5.2;
    intersection(){
        //5.4mm diameter, slightly loose for 5mm shaft.
        cylinder(d=shaft_d, h=99, center=true);
        cube([99,flat_shaft_w,99], center=true);
    }
    cylinder(d=shaft_d, h=3, center=true);
    reflect_y(){
        screw_pos = small_gear_screw_hole(flat_shaft_w);
        translate_y(screw_pos.y){
            no2_selftap_hole(h=99, center=true);
            //counterbore
            translate_z(screw_pos.z){
                cylinder(d=4.5, h=99);
            }
        }
    }
}

/**
* Small gears that attach onto the 28BYJ-48 stepper motor shaft for motorised actuation
*/
module small_gear(flat_shaft_w=3.15){
    $fn=small_gear_fn();
    h=small_gear_height();
    difference(){
        union(){
            gear(number_of_teeth=n_teeth_small_gear(),
                 circular_pitch=gear_pitch(),
                 circles=0,
                 gear_thickness=h,
                 hub_thickness=h,
                 hub_diameter=1,
                 rim_thickness=h,
                 bore_diameter=1);
            //Flange on the bottom of the gear improve adhesion during printing
            cylinder(r=small_gear_flange_radius(),h=0.5);
        }
        motor_shaft_cut_out(flat_shaft_w=flat_shaft_w);
    }
}

/**
* Thumbwheels for hand actuation of the microscope
*/
module thumbwheel(){
    lobe_r = 10;
    lobe_h = 5;
    base_low_r = 10;
    base_up_r = 12;
    base_h = 12.5;
    n_lobe = 6;

    difference()
    {
        union()
        {
            cylinder(r1=base_low_r,r2=base_up_r,h=base_h);
            for( n = [0 : n_lobe-1] )
            {
                deg = 360*n/n_lobe;
                translate([lobe_r*sin(deg),lobe_r*cos(deg),base_h]){
                    thumbwheel_lobe(r=lobe_r,h=lobe_h);
                }
            }
        }
        translate_z(1.5){
            nut(3,shaft=true,fudge=1.2,h=999);
        }
    }
}

/**
* A lobe for the thumbwheel with conical support
*/
module thumbwheel_lobe(r=5, h=5)
{
    hull(){
        cylinder(r=r,h=h);
        translate_z(-h){
            cylinder(r=tiny(),h=tiny());
        }
    }
}

/**
* A thumbscrew for the locking dovetail on the illumination
*/
module illumination_thumbscrew(){
    h=14;
    taper_h=5;
    difference()
    {
        hull(){
            cylinder(r = 4, h=taper_h, $fn=8);
            translate_z(taper_h){
                cylinder(r=5, h=h-taper_h, $fn=8);
            }
        }
        translate_z(12){
            nut(3, shaft=true, fudge=1.2, h=999);
        }
    }
}

/**
* Approximate cut-out for a 28BYJ-48 stepper motor body
* Note this does not include clearance for the cable or motor shaft
* The centre of the body is at the origin, NOT the shaft.
*/
module motor_clearance(h=15){

    linear_extrude(height=h){
        circle(r=14+1.5);
        hull(){
            reflect([1,0]){
                translate([motor_screw_separation()/2,0]){
                    circle(r=4.5);
                }
            }
        }
    }
    reflect_x(){
        translate_x(motor_screw_separation()/2){
            rotate(180){
                m4_selftap_hole(h=20,center=true);
            }
        }
    }
}

/**
* Clearance for the small gear, large gear, and motor.
* It's positioned with the centre of the large gear at the origin.
* Note: gear_h should match the height of the motor lugs above the
* flat surface for the large gear, in motor_lugs in compact_nut_seat.scad.
*/
module motor_and_gear_clearance(gear_h=10, h=999){

    linear_extrude(h){
        offset(1.5){
            hull(){
                circle(r=large_gear_radius(), $fn=n_teeth_large_gear()*4);
                translate([0,gear_c2c_distance()]){
                    circle(r=small_gear_flange_radius(), $fn=small_gear_fn());
                }
            }
        }
    }
    translate([0,gear_c2c_distance()-7.8,gear_h]){
        motor_clearance(h=h-gear_h);
    }
}