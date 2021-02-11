/*

This file should render the optics of the microscope...

(c) 2017 Richard Bowman, released under CERN Open Hardware License

*/


use <../openscad/optics.scad>
use <../openscad/libs/utilities.scad>
use <../openscad/libs/microscope_parameters.scad>
use <../openscad/libs/libdict.scad>
use <../openscad/libs/illumination.scad>
use <librender/render_settings.scad>
use <librender/optics.scad>

params = default_params();

mounts=true;
lenses=true;


module cutaway(colour="Red"){
    color(colour){
        render(6){
            difference(){
                children();
            rotate([0,90,0]) cylinder(r=999,h=999,$fn=4); //cutaway
            }
        }
    }
}


condenser_z = illumination_dovetail_z(params) + 65;
condenser_angle = key_lookup("condenser_angle", params);

// Condenser module
if(mounts) cutaway(extras_colour()){
    translate([0,0,condenser_z]){
        rotate([0, 0, 180])
        rotate([180+condenser_angle,0,0]){
            condenser(params);
        }
    }
}

if(mounts) cutaway(optics_module_colour()){
    // Optics module for RMS objective, using Comar 40mm singlet tube lens
    optics_module_rms(
        params,
        tube_lens_ffd=38,
        tube_lens_f=40,
        tube_lens_r=12.7/2+0.1,
        objective_parfocal_distance=35,
        beamsplitter=false
    );
}


if(lenses){
    //Should be f=50 but exaggerating curvature
    translate([0,0,12.8]) lens(d=12.7, f=30);

    translate([0,0,40.1]) rendered_objective();

    translate([0,0,condenser_z-35.5]) mirror([0,0,1]) flanged_lens(d=11,f=9,cut=4, fl_d=13, fl_h=1);

    translate([0,0,condenser_z]) rotate([180,0,0]) led();
}
