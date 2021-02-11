/*

This file should render the optics of the microscope...

(c) 2017 Richard Bowman, released under CERN Open Hardware License

*/


use <../openscad/optics.scad>
use <../openscad/lens_tool.scad>
use <../openscad/libs/utilities.scad>
use <../openscad/libs/microscope_parameters.scad>
use <../openscad/libs/libdict.scad>
use <../openscad/libs/illumination.scad>
use <librender/render_utils.scad>
use <librender/render_settings.scad>
use <librender/optics.scad>
use <librender/electronics.scad>
use <librender/hardware.scad>

params = default_params();

mounts=true;
lenses=true;
condenser_z = illumination_dovetail_z(params) + 65;
condenser_angle = key_lookup("condenser_angle", params);
condenser_pos = create_placement_dict([0, 0, condenser_z], [0, 0, 180], [180+condenser_angle, 0, 0]);
camera_pos = create_placement_dict([0, 0, -17.5], [0, 0, 135]);

module cutaway(dir="+x", colour="Red"){
    rotations = [["x", [0, 90, 0]],
                 ["+x", [0, 90, 0]],
                 ["-x", [0, -90, 0]],
                 ["y", [-90, 0, 0]],
                 ["+y", [-90, 0, 0]],
                 ["-y", [90, 0, 0]],
                 ["z", [0, 0, 0]],
                 ["+z", [0, 0, 0]],
                 ["-z", [0, 180, 0]]];
    rotation = key_lookup(dir, rotations);
    color(colour){
        render(6){
            difference(){
                children();
                rotate(rotation){
                    cylinder(r=999,h=999,$fn=4); //cutaway
                }
            }
        }
    }
}





// Condenser module
if(mounts) cutaway("+x", extras_colour()){
    place_part(condenser_pos){
        condenser(params);
    }
}

if(mounts) cutaway("+x", optics_module_colour()){
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
    translate([0,0,12.8]) tube_lens();

    translate([0,0,40.1]) rendered_objective();

    translate([0,0,condenser_z-35.5]) condenser_lens();

    translate([0,0,condenser_z]) rotate([180,0,0]) led();
}

place_part(camera_pos){
    picamera2(lens = false);
    holes = [for (i = [2, 3]) picamera2_holes()[i]];
    for (hole_pos = holes){
        translate(hole_pos - [0, 0, picamera2_size().z]){
            mirror([0,0,1]){
                no2_x6_5_selftap();
            }
        }
    }
}

