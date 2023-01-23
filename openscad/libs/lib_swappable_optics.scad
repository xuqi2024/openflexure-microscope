use <./utilities.scad>
use <./microscope_parameters.scad>
use <./libdict.scad>
use <./rms_thread.scad>;
use <./lib_optics.scad>;
use <./rms_calculations.scad>;
use <./z_axis.scad>;
use <./fitting_wedge.scad>;
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
    ["dowel_l", 12],                      // length of dowel pins
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

// This shape is added to an optics module body, so that it can have
// the (separate printed part) swappable optics mount attached to it.
module connector_for_swappable_optics_mount(params, optics_config){
    intersection(){
        // We use an intersection with a cube to limit the extent in Y, and avoid
        // fouling the objective mounting wedge.
        cube([999, 22, 999], center=true);
        hull(){
            // the bottom of the tube
            translate_z(optics_wedge_bottom()){
                cylinder(r=rms_optics_mount_bottom_r(),h=tiny());
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

/**
* This optics module takes an RMS objective and a tube length correction lens
* The objective sits in a carrier plate, allowing it to be swapped.
* Currently the large size of the top of this mount makes it incompatible
* with the inverted/delta geometries.
*/
module optics_module_swappable_rms(original_params, optics_config, include_wedge=true){
    params = replace_value("objective_mount_screw_z_shift", -15, original_params);
    difference(){
        // We use the regular RMS optics module, but add in some extra geometry
        // to let us screw the kelvin mount plate on top.
        // This is done using children rather than a union() to preserve the 
        // various holes that are needed in the mount.
        // NB this currently renders, then discards, an RMS thread. That could
        // be disabled for performance reasons but shouldn't cause any problems.
        optics_module_rms(params, optics_config, include_wedge=include_wedge){
            connector_for_swappable_optics_mount(params, optics_config);
        }
        // clearance for the optics carrier
        place_part(swappable_rms_carrier_placement(params, optics_config)){
            minkowski(){
                swappable_rms_carrier_base(params);
                translate([-0.5, -99 + 0.5, -1]){
                    cube([1, 99, 1.5]);
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
                // The basic shape is formed from cuboids that house the
                // dowel pins
                for(a = [0, 120, -120]){
                    rotate(a){
                        w = dowel_sep + dowel_d + 3;
                        translate([-w/2, magnet_r, 0]){
                            cube([w, dowel_l - magnet_d/2 - 1, h]);
                        }
                    }
                }    
                // We also add cylinders to make sure there is enough material
                // for the mounting screws
                for(p=swappable_rms_mounting_screw_positions(params)){
                    translate(p){
                        cylinder(d=7, h=h);
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
                    translate([0, magnet_r, dowel_z]){ // This might want to be lower...
                        repeat([0, -magnet_r, 0], 1){
                            cylinder(d=magnet_d, h=99, $fn=16);
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