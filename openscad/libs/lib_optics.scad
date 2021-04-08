
use <./utilities.scad>
use <./z_axis.scad>
include <./microscope_parameters.scad> // NB this defines "camera" and "optics"
use <./threads.scad>
use <./libdict.scad>
use <./cameras/camera.scad> // this will define the 2 functions and 1 module for the camera mount, using the camera defined in the "camera" parameter.

//TODO: stop saying dovetail here as there is no dovetail!

//TODO: split up huge modules

function dt_bottom() = -2; //bottom of dovetail (<0 to allow some play)
function bottom_position(camera_mount_top_z) = camera_mount_top_z-camera_mount_height(); //nominal distance from PCB to microscope bottom
function fl_cube_bottom(camera_mount_top_z) = bottom_position(camera_mount_top_z) + camera_sensor_height() + 6; //bottom of the beamsplitter filter cube (0 except for the RMS f=50mm modules where it's -8 or -20)
function fl_cube_top(camera_mount_top_z) = fl_cube_bottom(camera_mount_top_z) + fl_cube_w + 2.7; //top of beamsplitter cube
fl_cube_top_w = fl_cube_w - 2.7;
$fn=24;


function fl_cube_width() = fl_cube_w;

module fl_cube_cutout(camera_mount_top_z, taper=true){
    fl_cube_cutout_w = fl_cube_w+1; //make the cutout a little bigger than the fl_cube
    // A cut-out that enables a filter cube to be inserted.
    union(){
        sequential_hull(){
            translate([-fl_cube_cutout_w/2,-fl_cube_w/2,fl_cube_bottom(camera_mount_top_z)]){
                cube([fl_cube_cutout_w,999,fl_cube_cutout_w]);
            }
            translate([-fl_cube_cutout_w/2+2,-fl_cube_w/2,fl_cube_bottom(camera_mount_top_z)]){
                cube([fl_cube_cutout_w-4,999,fl_cube_cutout_w+2]); //sloping sides
            }
            translate([-fl_cube_cutout_w/2+2,-fl_cube_w/2+2,fl_cube_bottom(camera_mount_top_z)]){
                cube([fl_cube_cutout_w-4,fl_cube_w-4,fl_cube_cutout_w+2]);
            }
            if(taper){
                //taper gradually to the diameter of the beam
                translate([-tiny(),-tiny(),fl_cube_bottom(camera_mount_top_z)]){
                    cube([2*tiny(),2*tiny(),fl_cube_cutout_w*1.5]);
                }
            }
        }
        //a space at the back to allow the grippers for the dichroics to extend back a bit further.
        hull(){
            translate([-fl_cube_w/2+2,-fl_cube_w/2-1,fl_cube_bottom(camera_mount_top_z)]){
                cube([fl_cube_w-4,999,fl_cube_w]);
            }
            translate([-fl_cube_w/2+4,-fl_cube_w/2,fl_cube_bottom(camera_mount_top_z)]){
                cube([fl_cube_w-8,999,fl_cube_w+2]);
            }
        }

    }
}
module fl_cube_casing(camera_mount_top_z){
    // A solid object, big enough to contain the beamsplitter cube cutout.
    minkowski(){
        difference(){
            fl_cube_cutout(camera_mount_top_z);
            translate([-999, fl_cube_w/2, -999]){
                cube(999*2);
            }
        }
        cylinder(r=1.6, h=0.5);
    }
}

module fl_screw_holes(camera_mount_top_z, d, h){
    reflect_x(){
        union(){
            translate([fl_cube_w/2+3,0,fl_cube_bottom(camera_mount_top_z)+fl_cube_w]){
                rotate_x(90){
                    trylinder_selftap(d, h);
                }
            }
        }
    }
}

module optical_path(lens_aperture_r, lens_z, bottom_z=0){
    // The cut-out part of a camera mount, consisting of
    // a feathered cylindrical beam path.  Camera mount is now cut out
    // of the camera mount body already.
    union(){
        translate_z(bottom_z-tiny()){
            //beam path
            lighttrap_cylinder(r1=5, r2=lens_aperture_r, h=lens_z-bottom_z+2*tiny());
        }
        translate_z(lens_z){
            //lens
            cylinder(r=lens_aperture_r,h=2*tiny());
        }
    }
}
module optical_path_fl(lens_aperture_r, lens_z, bottom_z=0){
    // The cut-out part of a camera mount, with a space to slot in a filter cube.
    rotation = delta_stage ? 120 : 180; // The angle that the fl module exits from (0* is the dovetail)
    rotate(rotation){
        union(){
            translate_z(bottom_z-tiny()){
                //beam path to bottom of cube
                lighttrap_sqylinder(r1=5, f1=0, r2=0, f2=fl_cube_w-4, h=fl_cube_bottom(bottom_z)-bottom_z+2*tiny());
            }
            //filter cube
            fl_cube_cutout(bottom_z);
            translate_z(fl_cube_top(bottom_z)-tiny()){
                //beam path
                lighttrap_sqylinder(r1=1.5, f1=fl_cube_w-4-3, r2=lens_aperture_r, f2=0, h=lens_z-fl_cube_top(bottom_z)+4*tiny());
            }
            translate_z(lens_z){
                //lens
                cylinder(r=lens_aperture_r,h=2*tiny());
            }
        }
    }
}

module lens_gripper(lens_r=10,h=6,lens_h=3.5,base_r=-1,t=0.65,solid=false, flare=0.4){
    // This creates a tapering, distorted hollow cylinder suitable for
    // gripping a small cylindrical (or spherical) object
    // The gripping occurs lens_h above the base, and it flares out
    // again both above and below this.
    trylinder_gripper(inner_r=lens_r, h=h, grip_h=lens_h, base_r=base_r, t=t, solid=solid, flare=flare);
}

module camera_mount_top_slice(){
    // A thin slice of the top of the camera mount
    linear_extrude(tiny()){
        projection(cut=true){
            camera_mount();
        }
    }
}
module objective_fitting_base(params){
    // A thin slice of the mounting wedge that bolts to the microscope body
    linear_extrude(tiny()){
        projection(){
            objective_fitting_wedge(params);
        }
    }
}

module camera_mount_body(
    params,  //microscope parameter dictionary
    optics_config, //dictionary of optics configuration
    body_r, //radius of mount body
    body_top, //height of the top of the body
    dt_top, //height of the top of the dovetail
    extra_rz = [], //extra [r,z] values to extend the mount
    bottom_r=8, //radius of the bottom of the mount
    dt_waist=true, //whether to make the middle of the dovetail looser for easy insertion
    dovetail=true //set this to false to remove the attachment point
){

    beamsplitter = key_lookup("beamsplitter", optics_config);
    camera_mount_top_z = key_lookup("camera_mount_top_z", optics_config);

    // Make a camera mount, with a cylindrical body and a dovetail.
    // Just add a lens mount on top for a complete optics module!
    dt_h=dt_top-dt_bottom();
    camera_mount_rotation = delta_stage ? -45:0; // The angle of the camera mount (the ribbon cables exits at 135* from dovetail for '0*' &  180* from dovetail for '-45*')
    fl_cube_rotation = delta_stage ? -60:0; // The angle of the block to hold the fl cube (0* for the fl cube exiting at 180* from the dovetail and -60* for the fl cube exiting at 120* from the dovetail)
    // This is the main body of the mount

    union(){
        //The tube + the camera mount
        difference(){
            // Make the main tube, then add the dovetail and beamsplitter (if needed)
            union(){
                //hull together the base and the tube
                sequential_hull(){
                    //Where the tube meets the camera
                    rotate(camera_mount_rotation){
                        translate_z(camera_mount_top_z){
                            camera_mount_top_slice();
                        }
                    }
                    //the bottom of the tube
                    translate_z(dt_bottom()){
                        cylinder(r=bottom_r,h=tiny());
                    }
                    //the top of the tube
                    translate_z(body_top){
                        cylinder(r=body_r,h=tiny());
                    }

                    // allow for extra coordinates above this, if wanted.
                    // Would be best in a for loop, but that breaks the sequential_hull.
                    if(len(extra_rz) > 0){
                        translate_z(extra_rz[0][1]-tiny()){
                            cylinder(r=extra_rz[0][0],h=tiny());
                        }
                    }
                    if(len(extra_rz) > 1){
                        translate_z(extra_rz[1][1]-tiny()){
                            cylinder(r=extra_rz[1][0],h=tiny());
                        }
                    }
                    if(len(extra_rz) > 2){
                        translate_z(extra_rz[2][1]-tiny()){
                            cylinder(r=extra_rz[2][0],h=tiny());
                        }
                    }
                    if(len(extra_rz) > 3){
                        translate_z(extra_rz[3][1]-tiny()){
                            cylinder(r=extra_rz[3][0],h=tiny());
                        }
                    }
                }

                if(dovetail){
                    //Make the dovetail by sequentially hulling from bottom, through tube to dovetail
                    sequential_hull(){
                        // all the things at the bottom
                        hull(){
                            //Where the tube meets the camera
                            rotate(camera_mount_rotation){
                                translate_z(camera_mount_top_z){
                                    camera_mount_top_slice();
                                }
                            }
                            //the bottom of the tube
                            translate_z(dt_bottom()){
                                cylinder(r=bottom_r,h=tiny());
                            }
                            //the bottom of the dovetail
                            translate_z(dt_bottom()){
                                objective_fitting_base(params);
                            }
                        }
                        //the bottom of the dovetail
                        translate_z(dt_bottom()){
                            objective_fitting_base(params);
                        }
                        hull(){
                            //the bottom of the dovetail
                            translate_z(dt_bottom()){
                                objective_fitting_base(params);
                            }
                            //the top of the dovetail
                            translate_z(dt_top){
                                objective_fitting_base(params);
                            }
                        }
                        hull(){
                            //the bottom of the tube
                            translate_z(dt_bottom()){
                                cylinder(r=bottom_r,h=tiny());
                            }
                            //the top of the tube
                            translate_z(body_top){
                                cylinder(r=body_r,h=tiny());
                            }
                        }
                    }
                }
                if(beamsplitter){
                    // join together the top of the camera, the beamsplitter and the tube
                    hull(){
                        rotate(camera_mount_rotation){
                            translate_z(camera_mount_top_z){
                                //Where the tube meets the camera
                                camera_mount_top_slice();
                            }
                        }
                        rotate(fl_cube_rotation){
                            hull(){
                                //the box to fit the fl cube in
                                fl_cube_casing(camera_mount_top_z, fl_cube_cutout);
                                //the mounts for the fl cube screw holes
                                fl_screw_holes(camera_mount_top_z, d = 4, h =8);
                            }
                        }
                        //TODO: the section bellow is a repeat of above
                        //the bottom of the tube
                        translate_z(dt_bottom()){
                            cylinder(r=bottom_r,h=tiny());
                        }
                        //the top of the tube
                        translate_z(body_top){
                            cylinder(r=body_r,h=tiny());
                        }
                    }
                }
            }

            // Mount for the nut that holds it on
            translate_z(-1){
                objective_fitting_cutout(params);
            }
            // screw holes  and faceplate for fl module
            if(beamsplitter){
                rotate(fl_cube_rotation){
                    translate_y(-2.5){
                        fl_screw_holes(camera_mount_top_z, d = 2.5, h = 6);
                    }
                    hull(){
                        translate([0,-fl_cube_w,fl_cube_bottom(camera_mount_top_z)+fl_cube_w/2+3.5]){
                            cube([fl_cube_w+15,fl_cube_w,fl_cube_w+7],center=true);
                        }
                        translate([0,-fl_cube_w-6,fl_cube_bottom(camera_mount_top_z)+fl_cube_w/2+9]){
                            cube([fl_cube_w+20,fl_cube_w,fl_cube_w+6],center = true);
                        }
                    }
                }
            }
        }
        // add the camera mount
        rotate(camera_mount_rotation){
            translate_z(camera_mount_top_z){
                camera_mount();
            }
        }
    }
}

/**
* This optics module takes an RMS objective and a tube length correction lens
*/
module optics_module_rms(params, optics_config, dovetail=true){

    sample_z = key_lookup("sample_z", params);
    assert(key_lookup("optics_type", optics_config)=="RMS", "Use an RMS optics configuration to create a RMS optics module.");
    assert(sample_z > 60, "RMS objectives won't fit in small microscope frames!");
    assert(objective_mount_y > 12, "RMS objectives won't fit in small microscope frames!");


    // The optics configuration specifices  parameters that are unpacked are below

    //Radius of the tube lens
    tube_lens_r = key_lookup("tube_lens_r", optics_config);
    //Front focal distance (from flat side to focus) - measure this, or take it from the lens spec. sheet
    tube_lens_ffd = key_lookup("tube_lens_ffd", optics_config);
    //The nominal focal length of the tube lens.
    tube_lens_f = key_lookup("tube_lens_f", optics_config);
    //The distance behind the objective's "shoulder" where the image is formed.  This should be infinity (safe to use 99999) for infinity-corrected lenses, or 150 for 160mm tube length objectives (the image is formed ~10mm from the end of the tube).
    tube_length = key_lookup("tube_length", optics_config);
    //The distance from the shoulder of the objective to the sample focus position
    objective_parfocal_distance = key_lookup("objective_parfocal_distance", optics_config);
    // Whether the
    beamsplitter = key_lookup("beamsplitter", optics_config);
    camera_mount_top_z = key_lookup("camera_mount_top_z", optics_config);

    //radius of RMS thread, to be gripped by the mount
    rms_r = 20/2;
    tube_lens_aperture = tube_lens_r - 1.5; // clear aperture of the tube lens
    pedestal_h = 2; // height of tube lens above bottom of lens assembly (to allow for flex)

    dovetail_top = min(27, sample_z-objective_parfocal_distance-0.5); //height of the top of the dovetail, i.e. the position of the objective's "shoulder"

    ///////////////// Lens position calculation //////////////////////////
    // calculate the position of the tube lens based on a thin-lens
    // approximation: the light is focussing from the objective shoulder
    // to a point 160mm away, but we want to refocus it so it's
    // closer (i.e. focusses at the bottom of the mount).  If we let:
    // dos = distance from objective to sensor
    // dts = distance from tube lens to sensor
    // ft = focal length of tube lens
    // fo = tube length of objective lens
    // then 1/dts = 1/ft + 1/(fo-dos+dts)
    // the solution to this, if b=fo-dos and a=ft, is:
    // dts = 1/2 * (sqrt(b) * sqrt(4*a+b) - b)
    a = tube_lens_f;
    dos = sample_z - objective_parfocal_distance - bottom_position(camera_mount_top_z) - camera_sensor_height(); //distance from the sensor to the objective shoulder
    echo("Objective to sensor:",dos);
    b = tube_length - dos;
    dts = 1/2 * (sqrt(b) * sqrt(4*a+b) - b);
    echo("Distance from tube lens principal plane to sensor:",dts);
    // that's the distance to the nominal "principal plane", in reality
    // we measure the front focal distance, and shift accordingly:
    tube_lens_z = bottom_position(camera_mount_top_z) + camera_sensor_height() + dts - (tube_lens_f - tube_lens_ffd);

    // having calculated where the lens should go, now make the mount:
    lens_assembly_z = tube_lens_z - pedestal_h; //height of lens assembly
    lens_assembly_base_r = rms_r+1; //outer size of the lens grippers

    //the objective sits parfocal_distance below the sample
    lens_assembly_h = sample_z-lens_assembly_z-objective_parfocal_distance;

    union(){
        // The bottom part is just a camera mount with a flat top
        difference(){
            // camera mount with a body that's shorter than the dovetail
            camera_mount_body(params, optics_config, body_r=lens_assembly_base_r, bottom_r=10.5, body_top=lens_assembly_z, dt_top=dovetail_top, dovetail=dovetail);
            // camera cut-out and hole for the beam
            if(beamsplitter){
                optical_path_fl(tube_lens_aperture, lens_assembly_z, camera_mount_top_z);
            }
            else{
                optical_path(tube_lens_aperture, lens_assembly_z, camera_mount_top_z);
            }
            // make sure the camera mount makes contact with the lens gripper, but
            // doesn't foul the inside of it
            translate_z(lens_assembly_z){
                lens_gripper(lens_r=rms_r-tiny(), lens_h=lens_assembly_h-2.5,h=lens_assembly_h, base_r=lens_assembly_base_r-tiny(), solid=true); //same as the big gripper below
            }

        }
        // A threaded hole for the objective with a lens gripper for the tube lens
        translate_z(lens_assembly_z){
            // threaded cylinder for the objective
            radius=25.4*0.8/2-0.25; //Originally this was 9.75, is that a fudge factor, or allowance for the thread?;
            pitch=0.7056;
            difference(){
                hull(){
                    cylinder(r=lens_assembly_base_r,h=tiny(),$fn=50);
                    translate_z(lens_assembly_h-5){
                        cylinder(r=radius+1.2+0.44, h=5);
                    }
                }
                sequential_hull(){
                    cylinder(r=lens_assembly_base_r-1, h=2*tiny(),center=true,$fn=50);
                    translate_z(lens_assembly_h-5){
                        cylinder(r=radius+0.44,h=tiny(),$fn=100);
                    }
                    translate_z(999){
                        cylinder(r=radius+0.44,h=tiny(),$fn=100);
                    }
                }
            }
            translate_z(lens_assembly_h-5){
                inner_thread(radius=radius,pitch=pitch,thread_base_width = 0.60,thread_length=5);
            }

            gripper_t = key_lookup("gripper_t", optics_config);
            // gripper for the tube lens
            lens_gripper(lens_r=tube_lens_r, lens_h=pedestal_h+1,h=pedestal_h+1+2.5, t=gripper_t);
            // pedestal to raise the tube lens up within the gripper
            difference(){
                cylinder(r=tube_lens_aperture + 1.0,h=2);
                cylinder(r=tube_lens_aperture,h=999,center=true);
            }
        }
    }
}

function lens_aperture(lens_r) = lens_r - 1.5;

module lens_spacer_gripper(lens_r, lens_h, pedestal_h, lens_assembly_base_r, lens_assembly_z){

    lens_assembly_h = lens_h + pedestal_h; //height of the lens assembly

    // A lens gripper to hold the objective
    translate_z(lens_assembly_z){
        // gripper
        trylinder_gripper(inner_r=lens_r,
                          grip_h=lens_assembly_h-1.5,
                          h=lens_assembly_h,
                          base_r=lens_assembly_base_r,
                          flare=0.4,
                          squeeze=lens_r*0.15);
        // pedestal to raise the tube lens up within the gripper
        difference(){
            cylinder(r=lens_aperture(lens_r) + 1.0,h=pedestal_h);
            cylinder(r=lens_aperture(lens_r),h=999,center=true);
        }
    }
}

module lens_spacer(params, optics_config){
    // Mount a lens some distance from the camera

    assert(key_lookup("optics_type", optics_config)=="spacer", "Use spacer optics configuration to create a lens spacer.");
    
    //unpack lens spacer parameters
    lens_r = key_lookup("lens_r", optics_config);
    parfocal_distance = key_lookup("parfocal_distance", optics_config);
    lens_h = key_lookup("lens_h", optics_config);
    lens_spacing = key_lookup("lens_spacing", optics_config);

    //z position of lens once in microscope
    //lens sits parfocal_distance below the sample
    lens_z_microscope = key_lookup("sample_z", params) - parfocal_distance;

    // z_position of the lens for this piece.
    //This is the height of the camera_sensor above the circuit board plus the spacing between the lens and the sensor
    lens_z = camera_sensor_height()+lens_spacing;

    pedestal_h = 4; // extra height on the gripper, to allow it to flex
    lens_assembly_z = lens_z - pedestal_h; //z position of the bottom of the lens assembly

    lens_assembly_base_r = lens_r+1; //outer size of the lens grippers

    //This is the height of the block the camera mounts into.
    camera_mount_height = camera_mount_height();

    translate_z(lens_z_microscope-lens_z){
        difference(){
            union(){
                // This is the main body of the mount
                sequential_hull(){
                    translate_z(camera_mount_height){
                        camera_mount_top_slice();
                    }
                    translate_z(camera_mount_height+5){
                        cylinder(r=6,h=tiny());
                    }
                    translate_z(lens_assembly_z){
                        cylinder(r=lens_assembly_base_r, h=tiny());
                    }
                }

                lens_spacer_gripper(lens_r, lens_h, pedestal_h, lens_assembly_base_r, lens_assembly_z);

                // add the camera mount
                translate_z(camera_mount_height){
                    camera_mount(screwhole=false, counterbore=false);
                }
            }
            union(){
                // cut out the optical path
                optical_path(lens_aperture(lens_r), lens_assembly_z, 0);
                //cut out counterbores
                translate_z(camera_mount_height){
                    camera_mount_counterbore();
                }
            }
        }
    }
}
