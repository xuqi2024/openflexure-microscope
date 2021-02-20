/*

Some sketches to work towards a nicer dovetail mechanism in OpenSCAD.

(c) Richard Bowman 2021, released under CERN-OHL-W v2

*/

/*
Conversion notes:

I swapped from lookup functions to regular dicts with a regex
p\("([a-z_]+)"\)
replace with
key_lookup("$1", p)

 functions renamed to old names
ofu_ -> ""
*/

use <./libdict.scad>;
use <utilities.scad>;

function dovetail_default_params() = [
    ["depth", 4],            // y distance between outer flat surface and tip
    ["angle", 60],           // angle of sloping part
    ["outer_flat", 6],       // width of outer flat parts
    ["overall_width", 30],   // width of whole structure
    ["overall_height", 16],  // height of whole structure
    ["block_depth", 12],     // y size of mounting block
    ["fillet_r", 0.5],       // fillet radius for rounded corners
    ["relief_r", 0.7],       // fillet radius for rounded corners
    ["lever", 6],            // distance from flat surface to pivot of clamp
    ["flex_l", 3],           // length of clamp flexure
    ["flex_t", 1.6],         // thickness of above
    ["clamp_t", 8],          // x dimension of clamping flange
    ["top_t", 2],            // thickness of the top solid layer
    ["bottom_t", 2],         // thickness of the bottom solid layer
    ["vertical_gap", 1],     // gap between clamp and top/bottom layers
    ["clamp_support_t", 0.5],// thickness of internal bridge support for clamp
    ["clamp_angle", 7],      // angle through which we allow the clamp to bend
];

module block_sharp(p){
    // the block to which we attach the male dovetail 
    // or from whiuch we cut the female one

    w = key_lookup("overall_width", p);
    block = [w, key_lookup("block_depth", p)];

    translate([-w/2, -block[1]]) square(block);
}

module flange_r(p, width=tiny()){
    // the angled part of a male dovetail

    w = key_lookup("overall_width", p);
    flat = key_lookup("outer_flat", p);
    shiftx = [-width, 0];
    // we extend the parallelogram into the block slightly, 
    // at the same angle.
    shift_in = tiny()*[-cos(key_lookup("angle", p)), -sin(key_lookup("angle", p))];

    polygon([
        female_point(p) + shift_in,
        male_point(p),
        male_point(p) + shiftx,
        female_point(p) + shiftx + shift_in
    ]);
}

function male_point(p) = let(
    w = key_lookup("overall_width", p),
    flat = key_lookup("outer_flat", p),
    depth = key_lookup("depth", p),
    angle = key_lookup("angle", p)
) [w/2 - flat + depth/tan(angle), depth];

function female_point(p) = let(
    w = key_lookup("overall_width", p),
    flat = key_lookup("outer_flat", p),
    depth = key_lookup("depth", p),
    angle = key_lookup("angle", p)
) [w/2 - flat, 0];

module dovetail_section_m_sharp(p){
    // A male dovetail, before any filleting of the corners
    difference(){
        union(){
            block_sharp(p);

            hull() reflect([1, 0]) flange_r(p);
        }

        // relieve internal corners
        reflect([1, 0]) translate(female_point(p)){
            circle(key_lookup("relief_r", p));
        }        
    }
}

module dovetail_section_f_sharp(p){
    // A female dovetail, before any filleting of the corners
    difference(){
        union(){
            block_sharp(p);
        }
        
        hull() reflect([1, 0]) mirror([0,1]) flange_r(p);

        // relieve internal corners
        hull() reflect([1, 0]) translate(-male_point(p)){
            circle(key_lookup("relief_r", p));
        }        
    }
}

module rotate_repeat(angle){
    union(){
        children();
        rotate(angle) children();
    }
}

module clamp_frame(p){
    // place the origin at the pivot point of the clamp
    // and align y axis with the dovetail angle
    translate(female_point(p)) rotate(key_lookup("angle", p) - 90){
        translate([0, -key_lookup("lever", p)]) children();
    }
}

module clamp_cutout_2d(p){
    // 2D cutout to make a male dovetail clamp
    fillet_r = key_lookup("fillet_r", p);
    fp = female_point(p);
    mp = male_point(p);
    lever = key_lookup("lever", p);
    flex_l = key_lookup("flex_l", p);
    flex_t = key_lookup("flex_t", p);
    clamp_t = key_lookup("clamp_t", p);
    relief_r = key_lookup("relief_r", p);
    clamp_angle = key_lookup("clamp_angle", p);
    $fn=16;
    clamp_frame(p){
        // between nut and screw
        hull(){
            translate([0, fillet_r + flex_t/2]) circle(fillet_r);
            translate([0, lever]) circle(fillet_r); 
        } 
        // next to flexure
        hull() reflect([1,0]){
            translate([flex_l/2, fillet_r + flex_t/2]) circle(fillet_r);
        }
        // behind clamp
        sequential_hull(){
            translate([flex_l/2, -fillet_r - flex_t/2]) circle(fillet_r);
            rotate_repeat(clamp_angle) translate([-clamp_t, -fillet_r - flex_t/2]){
                circle(fillet_r);
            }
            rotate_repeat(clamp_angle) translate([-clamp_t, 99]) circle(fillet_r);
        } 
    }
}
module clamp_cutout_empty_2d(p){
    // 2D cutout to make a male dovetail clamp
    union(){
        clamp_cutout_2d(p);

        // take the hull of just the internal part
        hull() intersection(){
            clamp_cutout_2d(p);
            hull() repeat([-99, 0], 2, center=false){
                clamp_frame(p) reflect([0, 1]) {
                    translate([0, key_lookup("lever", p)]) circle(key_lookup("relief_r", p));
                }
            }
        }
    }
}
module clamp_cutout_base_2d(p){
    // 2D cutout to separate the point of the clamp from the base
    fillet_r = key_lookup("fillet_r", p);
    relief_r = key_lookup("relief_r", p);
    lever = key_lookup("lever", p);
    
    union(){
        // separate the flange from the block
        hull() translate(female_point(p)){
            circle(relief_r);
            translate([-key_lookup("clamp_t", p) - relief_r, 0]) circle(relief_r);
        }

        // take the hull of just the external part
        intersection(){
            clamp_cutout_2d(p);
            hull() reflect([1, 0]) translate(female_point(p)){
                circle(key_lookup("relief_r", p));
                translate([0, 99]) circle(key_lookup("relief_r", p));
            }
        }
    }
}
module clamp_back_2d(p, extra_l=0, extra_r=0){
    // back of the internal part of the clamp
    length = key_lookup("clamp_t", p) + key_lookup("fillet_r", p) + extra_l + extra_r;
    clamp_frame(p){
        translate([-length + extra_r, -key_lookup("flex_t", p)/2]){
            square([length, key_lookup("flex_t", p)]);
        }
    }
}
module clamp_support_2d(p){
    // a bridge to support the internal part of the clamp
    // this sits underneath the back of the clamp
    clamp_back_2d(
        p, 
        extra_l=3*key_lookup("fillet_r", p), 
        extra_r=key_lookup("flex_l", p)/2 + tiny()
    );
}
module clamping_flange_2d(p){
    convex_fillet(p) difference(){
        union(){
            hull(){
                // external end
                flange_r(
                    p, 
                    width=(
                        (key_lookup("clamp_t", p) - key_lookup("fillet_r", p))
                        /sin(key_lookup("angle", p))
                    )
                );
                // internal end
                clamp_back_2d(p);
            }

            // add the flexure to join to the block. 
            clamp_back_2d(
                p, 
                extra_r=key_lookup("flex_l", p) + key_lookup("fillet_r", p),
                extra_l=-key_lookup("fillet_r", p)
            );
        }

        clamp_cutout_2d(p);
    }
}

module clamping_flange(p){
    // The moving part that makes the right hand flange
    // clamp the female dovetail
    gap = key_lookup("vertical_gap", p);
    bottom = key_lookup("bottom_t", p) + gap + key_lookup("clamp_support_t", p);
    top = key_lookup("overall_height", p) - gap - key_lookup("top_t", p);
    translate([0,0,bottom]) linear_extrude(top - bottom){
        clamping_flange_2d(p);
    }
}

module clamping_bolt_and_nut(p){
    // The counterbored screw and nut that clamp the dovetail
    h = key_lookup("overall_height", p);
    clamp_frame(p) translate([0, key_lookup("lever", p) - 2, h/2]){
        $fn = 16;
        // Counterbored hole for screw
        rotate([0, 90, 0]){
            cylinder(d=3*1.2, h=99);
            translate([0,0,key_lookup("fillet_r", p) + 4]) cylinder(d=3*1.3*2, h=99);
        }
        // Nut trap, with angled entry
        rotate([0, -90, 0]){
            cylinder(d=3*1.2, h=8);
            translate([0,0,key_lookup("fillet_r", p) + 1.5]) rotate([0,0,60]) sequential_hull(){
                // TODO: replace this with a proper parametric nut trap!
                cylinder(r=3*1.1, h=3.2, $fn=6);
                //translate([2,0,0]) cylinder(r=3*1.2, h=2.8, $fn=6);
                translate([99,0,0]) cylinder(r=3*1.1, h=3.2, $fn=6);
            }
        }
    }
}

module clamp_support(p){
    // a bridge to support the internal part of the clamp
    gap = key_lookup("vertical_gap", p);
    bottom = key_lookup("bottom_t", p) + gap;
    translate([0,0,bottom]) linear_extrude(key_lookup("clamp_support_t", p)){
        clamp_support_2d(p);
    }
}

module convex_fillet(p){
    // smooth the convex corners
    $fn=12;

    offset(key_lookup("fillet_r", p)) offset(-key_lookup("fillet_r", p)){
        children();
    }
}
module concave_fillet(p){
    // smooth the concave corners
    $fn=12;

    offset(-key_lookup("fillet_r", p)) offset(key_lookup("fillet_r", p)){
        children();
    }
}

module dovetail_section_m(p, relief=true){
    convex_fillet(p){
        dovetail_section_m_sharp(p, relief=relief);
    }
}

module undercut_male_dovetail(p){
    // Chamfer the bottom of the mating faces to avoid
    // wonkiness due to "elephant's foot" issues
    minkowski(){
        mirror([0,1,0]) linear_extrude(tiny()){
            dovetail_section_f_sharp(p);
        }

        cylinder(r1=2, r2=tiny(), h=2, $fn=16, center=true);
    }
}
module dovetail_clamp_m(p){
    // male dovetail with clamping arm
    h = key_lookup("overall_height", p);
    difference(){
        union(){
            difference(){
                linear_extrude(h) convex_fillet(p) difference(){
                    dovetail_section_m_sharp(p);

                    clamp_cutout_base_2d(p);
                }

                // void for clamp
                translate([0,0,2]) linear_extrude(h-4){
                    concave_fillet(p) clamp_cutout_empty_2d(p);
                }
            }

            // clamping flange
            clamping_flange(p);
            clamp_support(p);
        }

        clamping_bolt_and_nut(p);
        
        // work around "elephant's foot"/brim on mating faces
        undercut_male_dovetail(p);
    }
}



module dovetail_f(p, height=50){
    h = height;
    linear_extrude(h) convex_fillet(p){
        dovetail_section_f_sharp(p);
    }
}

%mirror([0,1,0]) dovetail_f(dovetail_default_params());
//translate([0,25,0]) dovetail_f(default_params());
render(6) dovetail_clamp_m(dovetail_default_params());
