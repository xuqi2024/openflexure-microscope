use <./utilities.scad>
use <./libdict.scad>
use <./rms_calculations.scad>

//bottom of the beamsplitter filter cube (0 except for the RMS f=50mm modules where it's -8 or -20)
function fl_cube_bottom(params, optics_config) = rms_camera_sensor_z(params, optics_config) + 6;
function fl_cube_top(params, optics_config) = fl_cube_bottom(params, optics_config) + fl_cube_w() + 2.7; //top of beamsplitter cube

function fl_cube_w() = 16; //width of the fluorescence filter cube
function fl_cube_roc() = 0.6;

function fl_cube_width() = fl_cube_w();

module fl_cube_cutout(params, optics_config, taper=true){
    fl_cube_cutout_w = fl_cube_w()+1; //make the cutout a little bigger than the fl_cube
    fl_cube_bottom = fl_cube_bottom(params, optics_config);
    // A cut-out that enables a filter cube to be inserted.
    union(){
        sequential_hull(){
            translate([-fl_cube_cutout_w/2,-fl_cube_w()/2,fl_cube_bottom]){
                cube([fl_cube_cutout_w,999,fl_cube_cutout_w]);
            }
            translate([-fl_cube_cutout_w/2+2,-fl_cube_w()/2,fl_cube_bottom]){
                cube([fl_cube_cutout_w-4,999,fl_cube_cutout_w+2]); //sloping sides
            }
            translate([-fl_cube_cutout_w/2+2,-fl_cube_w()/2+2,fl_cube_bottom]){
                cube([fl_cube_cutout_w-4,fl_cube_w()-4,fl_cube_cutout_w+2]);
            }
            if(taper){
                //taper gradually to the diameter of the beam
                translate([-tiny(),-tiny(),fl_cube_bottom]){
                    cube([2*tiny(),2*tiny(),fl_cube_cutout_w*1.5]);
                }
            }
        }
        //a space at the back to allow the grippers for the dichroics to extend back a bit further.
        hull(){
            translate([-fl_cube_w()/2+2,-fl_cube_w()/2-1,fl_cube_bottom]){
                cube([fl_cube_w()-4,999,fl_cube_w()]);
            }
            translate([-fl_cube_w()/2+4,-fl_cube_w()/2,fl_cube_bottom]){
                cube([fl_cube_w()-8,999,fl_cube_w()+2]);
            }
        }

    }
}
module fl_cube_casing(params, optics_config){
    // A solid object, big enough to contain the beamsplitter cube cutout.
    minkowski(){
        difference(){
            fl_cube_cutout(params, optics_config);
            translate([-999, fl_cube_w()/2, -999]){
                cube(999*2);
            }
        }
        cylinder(r=1.6, h=0.5);
    }
}

module fl_screw_holes(params, optics_config, d, h){
    reflect_x(){
        union(){
            translate([fl_cube_w()/2+3,0,fl_cube_bottom(params, optics_config)+fl_cube_w()]){
                rotate_x(90){
                    trylinder_selftap(d, h);
                }
            }
        }
    }
}

module optical_path_fl(params, optics_config, lens_z, camera_mount_top_z){
    // The cut-out part of a camera mount, with a space to slot in a filter cube.
    bs_rotation = key_lookup("beamsplitter_rotation", optics_config);
    tube_lens_r = key_lookup("tube_lens_r", optics_config);
    aperture_r = tube_lens_r - 1.5;
    rotation = 180 + bs_rotation; // The angle that the fl module exits from (0* is the dovetail)
    rotate(rotation){
        union(){
            translate_z(camera_mount_top_z-tiny()){
                //beam path to bottom of cube
                lighttrap_sqylinder(r1=5, f1=0, r2=0, f2=fl_cube_w()-4, h=fl_cube_bottom(params, optics_config)-camera_mount_top_z+2*tiny());
            }
            //filter cube
            fl_cube_cutout(params, optics_config);
            translate_z(fl_cube_top(params, optics_config)-tiny()){
                //beam path
                lighttrap_sqylinder(r1=1.5, f1=fl_cube_w()-4-3, r2=aperture_r, f2=0, h=lens_z-fl_cube_top(params, optics_config)+4*tiny());
            }
            translate_z(lens_z){
                //lens
                cylinder(r=aperture_r,h=2*tiny());
            }
        }
    }
}