use <./utilities.scad>
use <./microscope_parameters.scad>
use <./libdict.scad>
use <lib_optics.scad>;
use <rms_thread.scad>;

/**
* This optics module accepts a swappable mount for RMS threaded objectives.
* It comes in 3 parts: the objective carrier, the mount for the objective
* carrier, and the optics module.  This is necessary for it to print
* correctly - the bridging just won't work otherwise.
*/
module optics_module_swappable(params, optics_config, include_wedge=true){

    sample_z = key_lookup("sample_z", params);
    assert(key_lookup("optics_type", optics_config)=="RMS", "Use an RMS optics configuration to create a RMS optics module.");
    assert(sample_z > 60, "RMS objectives won't fit in small microscope frames!");


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

    //radius of RMS thread, to be gripped by the mount
    rms_r = 20/2;
    tube_lens_aperture = tube_lens_r - 1.5; // clear aperture of the tube lens
    pedestal_h = 2; // height of tube lens above bottom of lens assembly (to allow for flex)

    wedge_top = min(27, sample_z-objective_parfocal_distance-0.5); //height of the top of the wedge, i.e. the position of the objective's "shoulder"

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
    dos = sample_z - objective_parfocal_distance - bottom_position(optics_config) - camera_sensor_height(optics_config); //distance from the sensor to the objective shoulder
    echo("Objective to sensor:",dos);
    b = tube_length - dos;
    dts = 1/2 * (sqrt(b) * sqrt(4*a+b) - b);
    echo("Distance from tube lens principal plane to sensor:",dts);
    // that's the distance to the nominal "principal plane", in reality
    // we measure the front focal distance, and shift accordingly:
    tube_lens_z = bottom_position(optics_config) + camera_sensor_height(optics_config) + dts - (tube_lens_f - tube_lens_ffd);

    // having calculated where the lens should go, now make the mount:
    lens_assembly_z = tube_lens_z - pedestal_h; //height of lens assembly
    lens_assembly_base_r = rms_r+1; //outer size of the lens grippers

    //the objective sits parfocal_distance below the sample
    lens_assembly_h = sample_z-lens_assembly_z-objective_parfocal_distance;

    union(){
        // The bottom part is just a camera mount with a flat top
        difference(){
            // camera mount with a body that's shorter than the fitting wedge
            optics_module_body(params,
                               optics_config,
                               body_r=lens_assembly_base_r,
                               bottom_r=10.5,
                               body_top=lens_assembly_z,
                               wedge_top=wedge_top,
                               include_wedge=include_wedge);
            // camera cut-out and hole for the beam
            if(beamsplitter){
                optical_path_fl(optics_config, tube_lens_aperture, lens_assembly_z);
            }
            else{
                optical_path(optics_config, tube_lens_aperture, lens_assembly_z);
            }
            // make sure the camera mount makes contact with the lens gripper, but
            // doesn't foul the inside of it
            translate_z(lens_assembly_z){
                cylinder(r=lens_assembly_base_r-tiny(), h=99);
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

/*
 * Parameters used by the various swappable rms modules
 */
function swappable_rms_params(params) = let(
    rms_r=20/2,
    magnet_d=5,
    dowel_d=3,
    objective_r = rms_r + 3
) [
    ["dowel_d", dowel_d],                       // diameter of dowel pins
    ["dowel_l", 16],                      // length of dowel pins
    ["dowel_separation", dowel_d + 0.8], // centre-to-centre separation of dowel pins, (magnet_d + dowel_d)/2/sqrt(2) for 45 degrees
    ["magnet_d", magnet_d],                      // diameter of ball magnets
    ["rms_r", rms_r],
    ["mount_h", 5],
    ["carrier_h", 5],
    ["objective_r", objective_r],                        // guessed width of the objective - for clearance
    ["magnet_r", (objective_r + magnet_d/2 + 2) * 2/sqrt(3)]  // distance of magnets from the origin
];


/**
 * The distance between the mating faces of the mount and carrier.  Should be >0.5mm or they'll clash for sure.
 *
 * NB currently the distance from the top of the mount to the top of the dowels is hard coded as 0.5mm
 * and the distance from the top of the mount to the centre of the ball is hard coded as 0.25*magnet_d
 * this needs to be kept updated...
*/
function mount_to_carrier_separation(params) = let(
    sp = swappable_rms_params(params),
    dowel_d = key_lookup("dowel_d", sp),
    magnet_d = key_lookup("magnet_d", sp),
    dowel_sep = key_lookup("dowel_separation", sp)
) (
    sqrt(
        ((dowel_d + magnet_d)/2)^2
        - dowel_sep^2
    ) - 0.25 * magnet_d - 0.5
);

// assert(
//     mount_to_carrier_separation(default_params()) > 0.5, 
//     str(
//         "The swappable RMS mount and carrier end up too close: probably you need ",
//         "to use different balls/dowels, or change how they are mounted."
//     )
// );
//echo("Mount to carrier separation is", mount_to_carrier_separation(default_params()));

module each_mounting_ball_frame(params){
    swappable_params = swappable_rms_params(params);
    magnet_r = key_lookup("magnet_r", swappable_params);
    for(a = [0, 120, -120]){
        rotate(a){
            translate([0, magnet_r, 0]){
                children();
            }
        }
    }
}

/* A carrier for an RMS microscope objective, with three balls for a Kelvin mount.
 *
 */
module swappable_rms_carrier(params){
    swappable_params = swappable_rms_params(params);
    magnet_d = key_lookup("magnet_d", swappable_params);
    magnet_r = key_lookup("magnet_r", swappable_params);
    h = key_lookup("carrier_h", swappable_params);
    objective_r = key_lookup("objective_r", swappable_params);
    $fn=16;

    difference(){
        // Base the shape on where the mounting balls are
        for(a = [0, 120, -120]){
            hull(){
                cylinder(r=objective_r, h=h, $fn=32);   // RMS mount (x1)
                rotate(a){
                    translate([0, magnet_r, 0]){
                        cylinder(d=magnet_d+2*2, h=h);  // Ball mount (x3)
                    }
                }
            }
        }

        // Cut-out for the objective (thread is added later)
        translate_z(-1){
            rms_thread_cutter(h=h+2);
        }

        // Push-fits for the magnetic balls
        for(a = [0, 120, -120]){
            rotate(a){
                // NB if you change the height of the magnet, you need to update
                // mount_to_carrier_separation() as well
                translate([0, magnet_r, h - magnet_d*0.75]){
                    deformable_hole_trylinder(
                        magnet_d/2 - 0.3, 
                        magnet_d/2 + 0.4, 
                        h=magnet_d
                    );
                }
            }
        }      

    }
}

/**
 * Render the magnetic balls, for instructions.  In-place relative to the carrier, above.
 */
module swappable_rms_carrier_balls(params){
    swappable_params = swappable_rms_params(params);
    magnet_d = key_lookup("magnet_d", swappable_params);
    magnet_r = key_lookup("magnet_r", swappable_params);
    h = key_lookup("carrier_h", swappable_params);
    for(a = [0, 120, -120]){
        rotate(a){
            // NB if you change the height of the magnet, you need to update
            // mount_to_carrier_separation() as well
            translate([0, magnet_r, h - magnet_d*0.25]){
                sphere(d=magnet_d, $fn=12);
            }
        }
    }
}

/**
 * Static Kelvin mount to which the swappable_rms_carrier attaches.
 * This should be screwed onto the top of an optics module
 */
module swappable_rms_mount(params){
    swappable_params = swappable_rms_params(params);
    magnet_d = key_lookup("magnet_d", swappable_params);
    dowel_d = key_lookup("dowel_d", swappable_params);
    dowel_l = key_lookup("dowel_l", swappable_params);
    magnet_r = key_lookup("magnet_r", swappable_params);
    h = key_lookup("mount_h", swappable_params);
    objective_r = key_lookup("objective_r", swappable_params);
    dowel_sep = key_lookup("dowel_separation", swappable_params);
    // The calculation for dowel_z needs to match mount_to_carrier_separation()
    dowel_z = h - dowel_d/2 - 0.5;

    difference(){
        union(){
            hull(){
                for(a = [0, 120, -120]){
                    rotate(a){
                        w = dowel_sep + dowel_d + 3;
                        translate([-w/2, magnet_r, 0]){
                            cube([w, dowel_l - magnet_d/2 - 1, h]);
                        }
                    }
                }
            }
        }

        // Clearance to get the objective in and out
        hull(){
            repeat([0, -99, 0], 2){
                cylinder(r=objective_r, h=99, $fn=32, center=true);
            }
        }

        for(a = [0, 120, -120]){
            rotate(a){
                // holes to allow access to the dowels
                //w = dowel_sep + dowel_d + 1;
                //translate([-w/2, magnet_r - magnet_d/2, dowel_d - dowel_d/2 - 0.5]){
                //    cube([w, magnet_d, 99]);
                //}
                // horizontal holes through which to insert the dowels
                reflect_x(){
                    translate([dowel_sep/2, 0, dowel_z]){
                        rotate_x(-90){
                            cylinder(d=dowel_d, $fn=16, h=99);
                        }
                    }
                }
                // Vertical holes so the balls can make contact
                hull(){
                    translate([0, 0, dowel_z]){ // This might want to be lower...
                        repeat([0, magnet_r, 0], 2){
                            cylinder(d=dowel_sep + dowel_d, h=99, $fn=16);
                        }
                    }
                }
                // Mounting holes
                reflect_x(){
                    translate([(dowel_sep + dowel_d + 3)/2 + 1, magnet_r, -tiny()]){
                        mirror([0,0,1]) m3_cap_counterbore(99, 99);
                    }
                }
            }
        }
    }
}

/**
 * Just the dowels from the above
 */
module swappable_rms_mount_dowels(params, explode=false){
    swappable_params = swappable_rms_params(params);
    magnet_d = key_lookup("magnet_d", swappable_params);
    dowel_d = key_lookup("dowel_d", swappable_params);
    dowel_l = key_lookup("dowel_l", swappable_params);
    magnet_r = key_lookup("magnet_r", swappable_params);
    h = key_lookup("mount_h", swappable_params);
    objective_r = key_lookup("objective_r", swappable_params);
    dowel_sep = key_lookup("dowel_separation", swappable_params);
    // The calculation for dowel_z needs to match mount_to_carrier_separation()
    dowel_z = h - dowel_d/2 - 0.5;

    difference(){
        for(a = [0, 120, -120]){
            rotate(a){
                // horizontal holes through which to insert the dowels
                reflect_x(){
                    translate([dowel_sep/2, magnet_r - magnet_d/2 - 1 + (explode?25:0), dowel_z]){
                        rotate_x(-90){
                            cylinder(d=dowel_d, $fn=16, h=dowel_l);
                        }
                    }
                }
            }
        }
    }
}