
use <./utilities.scad>
use <./z_axis.scad>
use <./microscope_parameters.scad>
use <./threads.scad>
use <./libdict.scad>
use <./lib_fl_cube.scad>
use <./rms_calculations.scad>
// camera.scad has generic camera modules forward the correct
// camera module depending on the optics configuration
use <./cameras/camera.scad>

$fn=24;

function optics_wedge_bottom() = -2; //bottom of dovetail (<0 to allow some play)

//This is used for both the lens spacer and the tube lens gripper
function lens_aperture(lens_r) = lens_r - 1.5;

module optical_path(optics_config, lens_z, camera_mount_top_z){
    // The cut-out part of a camera mount, consisting of
    // a feathered cylindrical beam path.  Camera mount is now cut out
    // of the camera mount body already.

    rms = key_lookup("optics_type", optics_config) == "RMS";
    lens_r = rms ?
        key_lookup("tube_lens_r", optics_config):
        key_lookup("lens_r", optics_config);
    aperture_r = lens_aperture(lens_r);
    union(){
        translate_z(camera_mount_top_z-tiny()){
            //beam path
            lighttrap_cylinder(r1=5, r2=aperture_r, h=lens_z-camera_mount_top_z+2*tiny());
        }
        translate_z(lens_z){
            //lens
            cylinder(r=aperture_r,h=2*tiny());
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

module camera_mount_top_slice(optics_config){
    // A thin slice of the top of the camera mount
    linear_extrude(tiny()){
        offset(-tiny()){
            projection(cut=true){
                camera_mount(optics_config);
            }
        }
    }
}

module optics_module_body_outer(params, optics_config, body_r, body_top, rms_mount_h, wedge_top, bottom_r, include_wedge){
    // The outer shape of the optics module body. Including the camera mount.

    beamsplitter = key_lookup("beamsplitter", optics_config);
    camera_rotation = key_lookup("camera_rotation", optics_config);
    camera_mount_top_z = rms_camera_mount_top_z(params, optics_config);

    union(){

        //This section connects the top of the camera to the bottom of the main cylinder and wedge
        hull(){
            //Where the tube meets the camera
            rotate(camera_rotation){
                translate_z(camera_mount_top_z){
                    camera_mount_top_slice(optics_config);
                }
            }
            //the bottom of the tube
            translate_z(optics_wedge_bottom()){
                cylinder(r=bottom_r,h=tiny());
            }
            //the bottom of the wedge
            if (include_wedge){
                translate_z(optics_wedge_bottom()){
                    objective_fitting_wedge(h=tiny());
                }
            }
        }

        // The main cylinder and wedge
        wedge_height = wedge_top - optics_wedge_bottom() + tiny();
        cyl_height = body_top - optics_wedge_bottom() + tiny();
        translate_z(optics_wedge_bottom()){
            hull(){
                if (include_wedge){
                    objective_fitting_wedge(h=wedge_height);
                }
                cylinder(r1=bottom_r, r2=body_r ,h=cyl_height);
            }
        }
        translate_z(body_top){
            cylinder(r=body_r, h=rms_mount_h);
        }

        // The actual camera mount
        rotate(camera_rotation){
            translate_z(camera_mount_top_z){
                camera_mount(optics_config);
            }
        }

        if(beamsplitter){
            // join together the top of the camera, the beamsplitter and the tube
            extra_optics_body_for_beamsplitter(params, optics_config, body_r, body_top, bottom_r);
        }
    }
}

module extra_optics_body_for_beamsplitter(params, optics_config, body_r, body_top, bottom_r){
    camera_mount_top_z = rms_camera_mount_top_z(params, optics_config);
    camera_rotation = key_lookup("camera_rotation", optics_config);
    bs_rotation = key_lookup("beamsplitter_rotation", optics_config);
    hull(){
        rotate(camera_rotation){
            translate_z(camera_mount_top_z){
                //Where the tube meets the camera
                camera_mount_top_slice(optics_config);
            }
        }
        rotate(bs_rotation){
            hull(){
                //the box to fit the fl cube in
                fl_cube_casing(params, optics_config);
                //the mounts for the fl cube screw holes
                fl_screw_holes(params, optics_config, d = 4, h =8);
            }
        }
        //TODO: the section bellow is a repeat of above
        //the bottom of the tube
        translate_z(optics_wedge_bottom()){
            cylinder(r=bottom_r,h=tiny());
        }
        //the top of the tube
        translate_z(body_top){
            cylinder(r=body_r,h=tiny());
        }
    }
}

module optics_module_beamsplitter_cutout(params, optics_config){
    bs_rotation = key_lookup("beamsplitter_rotation", optics_config);

    cube_dim = [1, 1, 1] * fl_cube_w();
    cube_centre_z = fl_cube_bottom(params, optics_config)+fl_cube_w()/2;

    rotate(bs_rotation){
        translate_y(-2.5){
            fl_screw_holes(params, optics_config, d = 2.5, h = 6);
        }
        hull(){
            translate([0, -fl_cube_w(), cube_centre_z+3.5]){
                cube(cube_dim + [15, 0, 7], center=true);
            }
            translate([0, -fl_cube_w()-6, cube_centre_z+9]){
                cube(cube_dim + [20, 0, 6], center=true);
            }
        }
    }
}

module optics_module_body(
    params,  //microscope parameter dictionary
    optics_config, //dictionary of optics configuration
    body_r, //radius of mount body
    body_top, //z_poistion of the top of the body
    rms_mount_h, // height of the rms mount
    wedge_top, //z position of the top of the fitting_wedge
    bottom_r=8, //radius of the bottom of the mount
    include_wedge=true //set this to false to remove the attachment point
){
    // Make the main body of the optics module: A camera mount, a cylindrical body and a wedge for mounting.
    // Just add a lens mount on top for a complete optics module!

    beamsplitter = key_lookup("beamsplitter", optics_config);

    //The tube + the camera mount
    difference(){
        optics_module_body_outer(params, optics_config, body_r, body_top, rms_mount_h, wedge_top, bottom_r, include_wedge);
        // Mount for the nut that holds it on
        if (include_wedge){
            translate_z(-1){
                objective_fitting_cutout(params);
            }
        }
        // screw holes  and faceplate for fl module
        if(beamsplitter){
            optics_module_beamsplitter_cutout(params, optics_config);
        }
    }

}

// reduce thread radius by 0.25mm this creates a tight fit when threadding into plastic
function rms_radius(tight=false) = let(
    nominal_r = 25.4*0.8/2,
    adjustment = tight ? -0.25 : 0
) nominal_r+adjustment;

//Major raidus of thread. The 0.44 is determined empirically for the given pitch
function rms_major_radius(tight=false) = rms_radius(tight=tight) + 0.44;


module rms_mount_cutout(mount_h){
    translate_z(mount_h-6){
        cylinder(r=rms_major_radius(tight=true), h=7, $fn=60);
    }
    translate_z(-1){
        cylinder(r=rms_major_radius(tight=true)-1.5, h=mount_h, $fn=60);
    }
}

/**
* This is the mount for the objective and tube lens. This is the screw thread and
* lens gripper
*/
module rms_optics_mount(optics_config, h, pedestal_h){

    gripper_t = key_lookup("gripper_t", optics_config);
    tube_lens_r = key_lookup("tube_lens_r", optics_config);
    aperture_r = lens_aperture(tube_lens_r);

    radius=rms_radius(tight=true);
    pitch=0.7056;

    translate_z(h-5){
        inner_thread(radius=radius,pitch=pitch,thread_base_width = 0.60,thread_length=5);
    }

    // gripper for the tube lens
    lens_gripper(lens_r=tube_lens_r, lens_h=pedestal_h+1, h=pedestal_h+1+2.5, t=gripper_t);
    // pedestal to raise the tube lens up within the gripper
    tube(ri=aperture_r, ro=aperture_r+.8, h=2);

}

/**
* This optics module takes an RMS objective and a tube length correction lens
*/
module optics_module_rms(params, optics_config, include_wedge=true){
    assert(key_lookup("optics_type", optics_config)=="RMS",
    "Cannot create an RMS optics module for a non-RMS configuration.");

    beamsplitter = key_lookup("beamsplitter", optics_config);

    // height of pedestal for tube lens to sit on (to allow for flex)
    pedestal_h = 2;
    //height of the top of the wedge
    wedge_top = 27;

    // Calculate the position and size of the mout that holds the lens and
    rms_optics_mount_z = tube_lens_face_z(params, optics_config) - pedestal_h;
    rms_optics_mount_base_r = rms_radius()+1;
    rms_optics_mount_h = objective_shoulder_z(params, optics_config)-rms_optics_mount_z;

    camera_mount_top_z = rms_camera_mount_top_z(params, optics_config);
    difference(){
        union(){
            // The bottom part is just a camera mount with a flat top
            difference(){
                // camera mount with a body that's shorter than the fitting wedge
                optics_module_body(params,
                                   optics_config,
                                   body_r=rms_optics_mount_base_r,
                                   bottom_r=10.5,
                                   body_top=rms_optics_mount_z,
                                   rms_mount_h=rms_optics_mount_h,
                                   wedge_top=wedge_top,
                                   include_wedge=include_wedge);
                // camera cut-out and hole for the beam
                if(beamsplitter){
                    optical_path_fl(params, optics_config, rms_optics_mount_z, camera_mount_top_z);
                }
                else{
                    optical_path(optics_config, rms_optics_mount_z, camera_mount_top_z);
                }
                // cut a hole for the rms thread and tube lens gripper
                translate_z(rms_optics_mount_z){
                    rms_mount_cutout(rms_optics_mount_h);
                }
            }
            translate_z(rms_optics_mount_z){
                rms_optics_mount(optics_config,
                                 h=rms_optics_mount_h,
                                 pedestal_h=pedestal_h);
            }
        }
    }
}

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
        aperture_r = lens_aperture(lens_r);
        tube(ri=aperture_r, ro=aperture_r+1, h=2);
    }
}

/**
* Calculate the z_position of the lens spacer.
* z position of lens is parfocal_distance below the sample
* To reach the bottom of the spacer also subtract camera_sensor_height
* and the desired lens spacing
*/
function lens_spacer_z(params, optics_config) = let(
    sample_z = key_lookup("sample_z", params),
    parfocal_distance = key_lookup("parfocal_distance", optics_config),
    lens_spacing = key_lookup("lens_spacing", optics_config)
) sample_z - (parfocal_distance + camera_sensor_height(optics_config) + lens_spacing);

module lens_spacer(params, optics_config){
    // Mount a lens some distance from the camera

    assert(key_lookup("optics_type", optics_config)=="spacer", "Use spacer optics configuration to create a lens spacer.");

    //unpack lens spacer parameters
    lens_r = key_lookup("lens_r", optics_config);
    lens_h = key_lookup("lens_h", optics_config);
    lens_spacing = key_lookup("lens_spacing", optics_config);

    // z_position of the lens for this piece.
    //This is the height of the camera_sensor above the circuit board plus the spacing between the lens and the sensor
    lens_z = camera_sensor_height(optics_config)+lens_spacing;

    pedestal_h = 4; // extra height on the gripper, to allow it to flex
    lens_assembly_z = lens_z - pedestal_h; //z position of the bottom of the lens assembly

    lens_assembly_base_r = lens_r+1; //outer size of the lens grippers

    //This is the height of the block the camera mounts into.
    camera_mount_height = camera_mount_height(optics_config);

    translate_z(lens_spacer_z(params, optics_config)){
        difference(){
            union(){
                // This is the main body of the mount
                sequential_hull(){
                    translate_z(camera_mount_height){
                        camera_mount_top_slice(optics_config);
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
                    camera_mount(optics_config, screwhole=false, counterbore=false);
                }
            }
            union(){
                // cut out the optical path
                optical_path(optics_config, lens_assembly_z, camera_mount_top_z=0);
                //cut out counterbores
                translate_z(camera_mount_height){
                    camera_mount_counterbore(optics_config);
                }
            }
        }
    }
}

/**
* camera_platform(params, base_r, h)
*
* * params - the microscope parameter dictionary
* * optics_config - optics configuration dictionary
* * base_r - radius of mount body
*/
module camera_platform(params, optics_config, base_r){

    assert(key_lookup("optics_type", optics_config)=="spacer", "Use spacer optics configuration to create a camera_platform.");

    // platform height is 5mm below the lens spacer (board is 1mm thick mounting posts are 4mm tall)
    platform_h = lens_spacer_z(params, optics_config) - 5;
    assert(platform_h > upper_z_flex_z(params), "Platform height too low for z-axis mounting");


    // Make a camera platform with a fitting wedge on the side and a platform on the top
    difference(){
        union(){
            // This is the main body of the mount
            sequential_hull(){
                hull(){
                    cylinder(r=base_r,h=tiny());
                    objective_fitting_wedge(h=tiny());
                }
                translate_z(platform_h){
                    hull(){
                        cylinder(r=base_r,h=tiny());
                        objective_fitting_wedge(h=tiny());
                        camera_bottom_mounting_posts(optics_config, h=tiny());
                    }
                }
            }

            // add the camera mount posts
            translate_z(platform_h){
                camera_bottom_mounting_posts(optics_config, cutouts=false);
            }
        }

        // Mount for the nut that holds it on
        translate_z(-4){
            objective_fitting_cutout(params, y_stop=true);
        }
        // add the camera mount holes
        translate_z(platform_h){
            camera_bottom_mounting_posts(optics_config, outers=false, cutouts=true);
        }
    }
}
