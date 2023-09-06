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
    ["magnet_r", (objective_r + magnet_d/2 + 2) * 2/sqrt(3)],  // distance of magnets from the origin
    ["magnet_centre_to_carrier_surface", 0.2*magnet_d],           // how far the magnet is embedded into the carrier (should be >0)
    ["dowel_centre_to_mount_surface", dowel_d/2 + 0.75],        // dowel holes should be recessed enough to avoid plastic deformation when dowels are inserted
    ["disc_magnet_h", 2.5],     // height of disc magnet
    ["disc_magnet_d", 5],       // diameter of disc magnet
    ["disc_magnet_dist", objective_r+(magnet_d/2)], // distance from origin of disc magnets
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
    dowel_sep = key_lookup("dowel_separation", sp),
    centre_to_centre_distance = (dowel_d + magnet_d)/2,
    c_to_c_vertical_separation = sqrt( // centre to centre dowel to magnet
        centre_to_centre_distance^2 - (dowel_sep/2)^2
    ),
    magnet_c_to_s = key_lookup("magnet_centre_to_carrier_surface", sp),
    dowel_c_to_s = key_lookup("dowel_centre_to_mount_surface", sp)
) c_to_c_vertical_separation - magnet_c_to_s - dowel_c_to_s;

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
    [-25 - 8*cos(60), -8*sin(60), 0],   //-12.3, 2.43 initial values with 20 > 25
    [-25 + 8*cos(60), 8*sin(60), 0],    //-27.61, -2.43
    [25 - 8*cos(60), 8*sin(60), 0],     //27.61, -2.43
    [25 + 8*cos(60), -8*sin(60), 0],    //12.3, 2.43
];

// This shape is added to an optics module body, so that it can have
// the (separate printed part) swappable optics mount attached to it.
// TODO - Note to self (Freya) - this geometry changes to accomodate the carrier but will need to be made larger to not get too cut out
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
* use -18 so lower z screw position will allow clearance for objective mount sliding
*/
module optics_module_swappable_rms(original_params, optics_config, include_wedge=true){
    params = replace_value("objective_mount_screw_z_shift", -18, original_params);
    optics_config = replace_value("camera_rotation", 180, optics_config);   // rotate camera cutout by 180deg for routing
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
                    cube([1, 99, 99]);
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
    disc_magnet_d = key_lookup("disc_magnet_d", swappable_params);
    disc_magnet_dist = key_lookup("disc_magnet_dist", swappable_params);
    $fn=16;

    // Base the shape on where the mounting balls are
    // Add extra cylinders either side for magnet mounts
    for(a = [0, 120, -120]){
        for(b = [90, -90]){
            hull(){
                cylinder(r=objective_r, h=h, $fn=32);   // RMS mount (x1)
                rotate(a){
                    translate([0, magnet_r, 0]){
                        cylinder(d=magnet_d+2*2, h=h);  // Ball mount (x3)
                    }
                }

                // Extra cylinders for disc magnets. TODO see if distance parameters want to change here? disc_magnet_dist is currently a bit handwavy
                rotate(b){
                    translate([0, disc_magnet_dist, 0]){
                        cylinder(d=1.2*disc_magnet_d, h=h);  // Disc magnet cylinders - make slightly larger than diameter of disc magnets so they are enclosed
                    }
                }
            }
        }
    }

    // Adds a one-way tab to keep objectives one way round
    difference(){
        hull(){
            translate_z(h/2)
                cube([h, h, h], center = true);
            
            // Tab just needs to extend far enough out before being hulled;
            // -0.5*magnet_r will take centre point to approx. the y distance of the magnets
            translate_y(-0.5*magnet_r)  
                scale([2,1.5])  
                    cylinder(r=0.5*magnet_r, h=3*h/4, $fn=64);
        }
    }
                // Subtracts small indent for grabbing
        translate([0, -magnet_r, 0])  
            scale([1,0.5])  
                cylinder(r=0.5*magnet_r, h=h);
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
    magnet_centre_to_carrier_surface = key_lookup("magnet_centre_to_carrier_surface", swappable_params);
    magnet_bottom_z = h - magnet_centre_to_carrier_surface - magnet_d/2;

    disc_magnet_h = key_lookup("disc_magnet_h", swappable_params);
    disc_magnet_d = key_lookup("disc_magnet_d", swappable_params);
    disc_magnet_dist = key_lookup("disc_magnet_dist", swappable_params);
    $fn=32;

    difference(){
        swappable_rms_carrier_base(params);

        // Cut-out for the objective (thread is added later)
        translate_z(-1){
            rms_thread_cutter(h=h+2);
        }

        // Push-fits for the magnetic balls
        for(a = [0, 120, -120]){
            for(b=[-90,90]){
            rotate(a){
                // NB if you change the height of the magnet, you need to update
                // mount_to_carrier_separation() as well
                translate([0, magnet_r, magnet_bottom_z]){
                    deformable_hole_trylinder(
                        magnet_d/2 - 0.3, 
                        magnet_d/2 + 0.4, 
                        h=magnet_d
                    );
                }
            }

            // Holes for push-fitting disc magnets collinear to objective
                rotate(b){
                    translate([0, disc_magnet_dist, (h-disc_magnet_h)]){
                        cylinder(
                            h = disc_magnet_h+tiny(), d = disc_magnet_d+0.1  //add tiny() here to get round rendering artifacts, make diameter slightly larger to allow push-fit
                        );
                    }
                }
                
            for(c=[-90,90]){
                rotate(c){
                translate([0, disc_magnet_dist, 0]){
                    cylinder(
                        h = (h+tiny()), d = disc_magnet_d/2+0.1
                    );
                }
            }
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
* Simple mounting jig for the ball bearings of the objective lens carrier,
* to ensure even seating. Each carrier nests inside and force is applied from the back face
* onto a flat surface
* to push-fit the bearings at an even height (currently, protruding from the carrier by one magnet radius. This will probably want to change.)
*/

module swappable_rms_carrier_jig(params){
    swappable_params = swappable_rms_params(params);
    magnet_d = key_lookup("magnet_d", swappable_params);
    magnet_r = key_lookup("magnet_r", swappable_params);
    h = key_lookup("carrier_h", swappable_params);
    objective_r = key_lookup("objective_r", swappable_params);
    magnet_centre_to_carrier_surface = key_lookup("magnet_centre_to_carrier_surface", swappable_params);
    magnet_bottom_z = h - magnet_centre_to_carrier_surface - magnet_d/2;

    disc_magnet_h = key_lookup("disc_magnet_h", swappable_params);
    disc_magnet_d = key_lookup("disc_magnet_d", swappable_params);
    disc_magnet_dist = key_lookup("disc_magnet_dist", swappable_params);
    $fn=32;

    difference(){
        translate([-magnet_r*1.5,-magnet_r*1.5,0]){
            cube([magnet_r*3, magnet_r*3, h+(magnet_d)]);
        }
        
        // jig should ideally seat ball bearings at height of magnet diameter/2 above carrier - so jig height should be h + magnet_d/2
        translate([0,0,magnet_d/2]){
        
        // cut out base of carrier, scale slightly so piece can fit comfortably inside hollow
            linear_extrude(3*h){
                scale([1.01,1.01]){
                    projection(cut=true){
                        swappable_rms_carrier_base(default_params());
                    }
                }
            }
            
        }
    }
}

/**
 * Static Kelvin mount to which the swappable_rms_carrier attaches.
 * This should be screwed onto the top of an optics module
 *
 * NB the mating surface is the top - which wants to print on the
 * bottom. This is the right way up, only if you're thinking of the
 * optics module as used in the upright microscope.
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
    dowel_centre_to_mount_surface = key_lookup("dowel_centre_to_mount_surface", swappable_params);
    // The calculation for dowel_z needs to match mount_to_carrier_separation()
    dowel_z = h - dowel_centre_to_mount_surface;

    // disc magnet parameters
    disc_magnet_h = key_lookup("disc_magnet_h", swappable_params);
    disc_magnet_d = key_lookup("disc_magnet_d", swappable_params);
    disc_magnet_dist = key_lookup("disc_magnet_dist", swappable_params);
    $fn=32;

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
                        cylinder(d=magnet_d, h=99, $fn=16);
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

        // add disc magnet cutouts to mount
        for(b=[-90,90]){
            rotate(b){
                translate([0, disc_magnet_dist, (h-disc_magnet_h)]){
                    cylinder(
                        h = disc_magnet_h+tiny(), d = disc_magnet_d+0.1  //add tiny() here to get round rendering artifacts, make diameter slightly larger to allow push-fit
                    );
                }
            }
        }

        // cutout small cylinders for ejecting disc magnets if needed -TODO I'm pretty sure this is one of the least efficient ways of doing this! Can't seem to get this to play nicely with nesting inside the earlier rotate() yet
        for(c=[-90,90]){
            rotate(c){
                translate([0, disc_magnet_dist, 0]){
                    cylinder(
                        h = (h+tiny()), d = disc_magnet_d/2+0.1
                    );
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

