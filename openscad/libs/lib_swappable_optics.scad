use <./utilities.scad>
use <./microscope_parameters.scad>
use <./libdict.scad>
use <./lib_optics.scad>;
use <./rms_calculations.scad>;
use <../../rendering/librender/render_utils.scad>;


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
        - (dowel_sep/2 + dowel_d/2)^2
    ) - 0.25 * magnet_d - 0.5
);

assert(
    mount_to_carrier_separation(default_params()) > 0.3, 
    str(
        "The swappable RMS mount and carrier end up too close: probably you need ",
        "to use different balls/dowels, or change how they are mounted.",
        "The separation was calculated as ",
        mount_to_carrier_separation(default_params())
    )
);
//echo("Mount to carrier separation is", mount_to_carrier_separation(default_params()));

function swappable_rms_mount_z(params, optics_config) = (
    objective_shoulder_z(params,optics_config) + mount_to_carrier_separation(params)
);

function swappable_rms_mounting_screw_positions(params) = let(
    sp = swappable_rms_params(params)
) [
    [-20 - 8*cos(60), -8*sin(60), 0],
    [-20 + 8*cos(60), 8*sin(60), 0],
    [20 - 8*cos(60), 8*sin(60), 0],
    [20 + 8*cos(60), -8*sin(60), 0],
];

/**
* This optics module takes an RMS objective and a tube length correction lens
* The objective sits in a carrier plate, allowing it to be swapped.
* Currently the large size of the top of this mount makes it incompatible
* with the inverted/delta geometries.
*
* TODO: this should really be deduplicated with the non-swappable version.
*/
module optics_module_swappable_rms(params, optics_config, include_wedge=true){
    assert(key_lookup("optics_type", optics_config)=="RMS",
    "Cannot create an RMS optics module for a non-RMS configuration.");

    swappable_params = swappable_rms_params(params);

    beamsplitter = key_lookup("beamsplitter", optics_config);
    carrier_h = key_lookup("carrier_h", swappable_params);

    // height of pedestal for tube lens to sit on (to allow for flex)
    pedestal_h = 2;

    bottom_r = 10.5;

    // Calculate the position and size of the mout that holds the lens and
    rms_optics_mount_z = tube_lens_face_z(params, optics_config) - pedestal_h;
    rms_optics_mount_base_r = rms_radius()+1;
    // We chop the RMS bit off the RMS mount, so it can be replaced by the carrier
    rms_optics_mount_h = objective_shoulder_z(params, optics_config) - rms_optics_mount_z - carrier_h - 1;
    //height of the top of the wedge - should be level with the cropped RMS mount
    wedge_top = objective_shoulder_z(params, optics_config) - carrier_h - 1;

    camera_mount_top_z = rms_camera_mount_top_z(params, optics_config);
    difference(){
        union(){
            // The bottom part is just a camera mount with a flat top
            difference(){
                union(){
                    // camera mount with a body that comes up to 1mm from the RMS carrier
                    optics_module_body(params,
                                    optics_config,
                                    body_r=rms_optics_mount_base_r,
                                    bottom_r=bottom_r,
                                    body_top=rms_optics_mount_z,
                                    rms_mount_h=rms_optics_mount_h,
                                    wedge_top=wedge_top,
                                    include_wedge=include_wedge);
                    intersection(){
                        cube([999, 22, 999], center=true); // cut it off so we don't foul the mounting wedge
                        hull(){
                            // the bottom of the tube
                            translate_z(optics_wedge_bottom()){
                                cylinder(r=bottom_r,h=tiny());
                            }
                            // the mount at the top
                            translate_z(swappable_rms_mount_z(params, optics_config) - tiny()){
                                linear_extrude(tiny()){
                                    projection(){
                                        swappable_rms_mount(params);
                                    }
                                } 
                            }
                        }
                    }
                }
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
                // clearance for the optics carrier
                place_part(swappable_rms_carrier_placement(params, optics_config)){
                    minkowski(){
                        swappable_rms_carrier_base(params);
                        translate([-0.5, -99 + 0.5, -0.5]){
                            cube([1, 99, 1]);
                        }
                    }
                }
                // mounting screws
                for(p=swappable_rms_mounting_screw_positions(params)){
                    translate(p + [0, 0, swappable_rms_mount_z(params, optics_config)]){
                        no2_selftap_hole(16, true);
                    }
                }
            }
            translate_z(rms_optics_mount_z){
                rms_optics_mount(optics_config,
                                 h=rms_optics_mount_h,
                                 pedestal_h=pedestal_h,
                                 include_rms_thread=false);
            }
        }
    }
}


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

/**
* See swappable_rms_carrier
* This makes a base shape into which we put cut-outs for 
* three magnetic balls, and an RMS thread.
*/ 
module swappable_rms_carrier_base(params){
    swappable_params = swappable_rms_params(params);
    magnet_d = key_lookup("magnet_d", swappable_params);
    magnet_r = key_lookup("magnet_r", swappable_params);
    h = key_lookup("carrier_h", swappable_params);
    objective_r = key_lookup("objective_r", swappable_params);
    $fn=16;

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
        swappable_rms_carrier_base(params);

        // Cut-out for the objective (thread is added later)
        rms_mount_cutout(h);

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
    
    // Add on the RMS thread (I think this causes STL errors...)
    translate_z(h - 5){
        rms_thread(h=5);
    }
}

function swappable_rms_carrier_placement(params, optics_config) = let(
    carrier_h = key_lookup("carrier_h", swappable_rms_params(params))
) create_placement_dict(
    [0, 0, objective_shoulder_z(params, optics_config) - carrier_h]
);

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
                sphere(d=magnet_d, $fn=24);
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
            }
        }

        
        // mounting screws
        for(p=swappable_rms_mounting_screw_positions(params)){
            translate(p + [0, 0, 2]){
                mirror([0,0,1]){
                    no2_selftap_counterbore();
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
function swappable_rms_mount_placement(params, optics_config) = let(
    mount_h = key_lookup("mount_h", swappable_rms_params(params))
) create_placement_dict(
    [0, 0, swappable_rms_mount_z(params, optics_config) + mount_h],
    [0, 180, 0] // Flip it upside down (hence needing to shift by carrier_h)
);