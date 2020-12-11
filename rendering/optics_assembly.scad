/*

This file should render the optics of the microscope...

(c) 2017 Richard Bowman, released under CERN Open Hardware License

*/

use <../openscad/optics.scad>
use <../openscad/libs/utilities.scad>
use <../openscad/libs/microscope_parameters.scad>
use <../openscad/libs/libdict.scad>
use <../openscad/libs/illumination.scad>
use <../openscad/libs/threads.scad>
use <librender/render_settings.scad>

params = default_params();

mounts=true;
lenses=true;

module lens(d=16, f=40, ct=4.5){
    $fn=60;
    color("PaleTurquoise", .60)render(6)intersection(){
        cylinder(d=d, h=999);
        translate([0,0,-f+ct]) sphere(r=f);
    }
}
module led(){
    $fn=60;
    color("white", .75)render(6)union(){
        cylinder(d=6, h=0.7);
        cylinder(d=5, h=5);
        translate([0,0,5]) sphere(r=5/2);
    }
}

module objective(){
    union(){
        stage1_z = 16;
        stage2_z = stage1_z+15.5;
        stage3_z = stage2_z+8;
        stage4_z = stage3_z+2;

        //coppied in from optics.scad!
        radius=25.4*0.8/2-0.25;
        pitch=0.7056;
        $fn=60;
        sequential_hull(){
            cylinder(d=24.5,h=tiny());
            translate([0,0,stage1_z]){
                cylinder(d=24.5,h=tiny());
            }
            translate([0,0,stage1_z]){
                cylinder(d=22.5,h=tiny());
            }
            translate([0,0,stage2_z]){
                cylinder(d=22.5,h=tiny());
            }
            translate([0,0,stage3_z]){
                cylinder(d=17,h=tiny());
            }
            translate([0,0,stage3_z]){
                cylinder(d=9,h=tiny());
            }
            translate([0,0,stage4_z]){
                cylinder(d=4,h=tiny());
            }
        }
        translate([0,0,-4]){
            cylinder(r=radius,h=4+tiny());
            outer_thread(radius=radius,
                        pitch=pitch,
                        thread_base_width = 0.60,
                        thread_length=2.5);
        }
    }
}

module rendered_objective(){
    color("Silver"){
        render(6){
            objective();
        }
    }
}

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
    translate([0,0,12.8]) lens(d=12.7, f=15);

    translate([0,0,40.1]) rendered_objective();

    translate([0,0,condenser_z-35.5]) mirror([0,0,1]) lens(d=13,f=9,ct=6);

    translate([0,0,condenser_z]) rotate([180,0,0]) led();
}
