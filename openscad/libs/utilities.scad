// LibFile: utilities.scad
//   A collection of utilities originally developed for the OpenFlexure
//   microscope.
//   
//   (c) Richard Bowman, January 2016
//   Released under the CERN Open Hardware License

// Until we figure out a neater way to do this, I am using a commoncode
// block to include this file for the examples.  Using the Include: block
// will be confusing because we don't install it in the libraries folder
// by default...
// CommonCode:
//    use <./openscad/libs/utilities.scad>;


// Function: tiny()
// Description: 
//   This is a tiny distance. In many places, it is helpful to shift
//   surfaces by a small distance, e.g. to ensure overlap or avoid
//   degenerate points.  `tiny()` is that distance, currently 0.05.
//   
//   `tiny()` was formerly known as `d` in the code 
//   but that caused confusion with diameters.
function tiny() = 0.05;

// Function: zero_z()
// Usage: zero_z(vector)
// Description: 
//   Return a copy of a 3-element vector, with the third (z) component set to 0
function zero_z(size) = [size.x, size.y, 0]; //set the Z component of a 3-vector to 0

function if_undefined_set_default(argument, default) = is_undef(argument) ? default : argument;

// Function: translate_x()
// Usage: translate_x(dist)
// Description: 
//   Translate in the X direction.  Equivalent to `translate([dist, 0, 0])`.
module translate_x(x_tr){
    translate([x_tr, 0, 0]){
        children();
    }
}

// Function: translate_y()
// Usage: translate_y(dist)
// Description: 
//   Translate in the Y direction.  Equivalent to `translate([0, dist, 0])`.
module translate_y(y_tr){
    translate([0, y_tr, 0]){
        children();
    }
}

// Function: translate_z()
// Usage: translate_z(dist)
// Description: 
//   Translate in the Z direction.  Equivalent to `translate([0, 0, dist])`.
module translate_z(z_tr){
    translate([0, 0, z_tr]){
        children();
    }
}

// Function: rotate_x()
// Usage: rotate_x(angle)
// Description: Rotate about X axis. Equivalent to `rotate([angle, 0, 0])`.
module rotate_x(x_angle){
    rotate([x_angle, 0, 0]){
        children();
    }
}

// Function: rotate_y()
// Usage: rotate_y(angle)
// Description: Rotate about Y axis. Equivalent to `rotate([0, angle, 0])`.
module rotate_y(y_angle){
    rotate([0, y_angle, 0]){
        children();
    }
}

// Function: rotate_z()
// Usage: rotate_z(angle)
// Description: Rotate about Z axis. Equivalent to `rotate([0, 0, angle])`.
module rotate_z(z_angle){
    rotate([0, 0, z_angle]){
        children();
    }
}

// Function: reflect()
// Usage: reflect(axis)
// Arguments:
//   axis = a 2- or 3D vector giving the axis to reflect in
// Description:
//   Duplicate the children of this module, once unmodified, and
//   once mirrored about the specified axis.  The mirrored copy
//   is equivalent to `mirror(axis) children()`.
//   
//   Conveninece functions `reflect_x`, `reflect_y`, and `reflect_z`
//   are defined to reflect about the respective axes.
// Examples(3D):
//   reflect([1,0,0]) translate([10,0,0]) cube(10);
//   reflect_x() translate([10,0,0]) cube(10);
module reflect(axis){
    //reflects children about the origin, keeping the originals
    children();
    mirror(axis){
        children();
    }
}


module reflect_x(){
    //shorthand for reflecting in x
    reflect([1, 0, 0]){
        children();
    }
}

module reflect_y(){
    //shorthand for reflecting in y
    reflect([0, 1, 0]){
        children();
    }
}

module reflect_z(){
    //shorthand for reflecting in z
    reflect([0, 0, 1]){
        children();
    }
}


function vector_mirror_x(vec) = _vector_mirror_axis(vec, 0);
function vector_mirror_y(vec) = _vector_mirror_axis(vec, 1);
function vector_mirror_z(vec) = _vector_mirror_axis(vec, 2);

function _vector_mirror_axis(vec, axis_index) = [
    for (i = [0:len(vec)-1])
        if (i==axis_index)
            -vec[i]
        else
            vec[i]
];

// Module: repeat()
// Usage: repeat(delta, N, center=false)
// Arguments:
//   delta = vector specifying the displacement between adjacent copies
//   N = total number of copies
//   ---
//   center = The default, `false`, places the first copy at its original location and the last is displaced by `(N-1)*delta`.  Set to `true` to centre the copies on the original location.
// Description:
//   Create a linear arry of copies of a geometry.
// Examples:
//   repeat([10,0,0], 4) cube(5);
//   repeat([10,0,0], 4, center=true) cube(5, center=true);
module repeat(delta, N, center=false){
    //repeat children along a regular array
    center_tr = (center ?  -(N-1)/2 : 0) * delta;
    translate(center_tr){
        for(i=[0:1:(N-1)]){
            translate(i*delta){
                children();
            }
        }
    }
}

module xz_slice(y=0){
    //slice out just the part of something that sits in the XZ plane
    intersection(){
        translate_y(y){
            cube([999,2*tiny(),999],center=true);
        }
        children();
    }
}

module tube(ri, ro, h, center=false){
    difference(){
        cylinder(r=ro, h=h, center=center);
        if (center){
            cylinder(r=ri, h=h+1, center=true);
        }
        else {
            translate_z(-1){
                cylinder(r=ri, h=h+2, center=false);
            }
        }
    }
}

// Module: m4_selftap_hole()
// Usage: m4_selftap_hole(h=5)
// Description:
//   Use to create a hole for an m4 machine screw to self tap into screw using a `difference()`
//   operation. This is a triangular cross-section hole.
module m4_selftap_hole(h=10, center=false){
    // r and flat calculated from the trylinder selftap function used for years.
    // Moving to explicit tested number rather than arbitary calculations.
    trylinder(r=1.3, flat=1.73, h=h, center=center);
}

// Module: no2_selftap_hole()
// Usage: no2_selftap_hole(h=5)
// Description:
//   Use to create a hole for a No2 self-tap screw using a `difference()` operation.
//   This is a triangular cross-section hole.
module no2_selftap_hole(h=10, center=false){
    //This value for r came from test prints. ranging r from 0.3 to 0.5.
    trylinder(r=.3, flat=1.73, h=h, center=center);
}

module no2_selftap_counterbore(bore_h=999, hole_h=999){
    $fn = 14;
    generic_counterbore(bore_d=5.6, bore_h=bore_h, hole_d=2.5, hole_h=hole_h);
}

// Counterbored through hole for an m3 cap screw counterbore is above z=0
// through hole is below z=0
module m3_cap_counterbore(bore_h=999, hole_h=999){
    $fn = 14;
    generic_counterbore(bore_d=6.5, bore_h=bore_h, hole_d=3.5, hole_h=hole_h);
}

module generic_counterbore(bore_d, bore_h, hole_d, hole_h){
    translate_z(-hole_h){
        cylinder(d=hole_d, h=hole_h+tiny());
    }
    cylinder(d=bore_d, h=bore_h);
}

module nut(d,h=undef,center=false,fudge=1.18,shaft=false){
    //make a nut, for metric bolt of nominal diameter d
    //d: nominal bolt diameter (e.g. 3 for M3)
    //h: height of nut
    //center: works as for cylinder
    //fudge: multiply the diameter by this number (1.22 works when vertical)
    //shaft: include a long cylinder representing the bolt shaft, diameter=d*1.05
    height = if_undefined_set_default(h, d*0.8);
    union(){
        cylinder(h=height,center=center,r=0.9*d*fudge,$fn=6);
        if(shaft){
            cylinder(r=d/2*1.05*(fudge+1)/2,h=999,$fn=16,center=true);
        }
    }
}

module nut_from_bottom(d,h=undef,fudge=1.2,shaft=true,chamfer_r=0.75,chamfer_h=0.75){
    //make a nut, for metric bolt of nominal diameter d
    //d: nominal bolt diameter (e.g. 3 for M3)
    //h: height of nut
    //center: works as for cylinder
    //fudge: multiply the diameter by this number (1.22 works when vertical)
    //shaft: include a long cylinder representing the bolt shaft, diameter=d*1.05
    height = if_undefined_set_default(h, d*0.8);
    union(){
        cylinder(h=height,r=0.9*d*fudge,$fn=6);
        translate_z(-0.05){
            cylinder(h=chamfer_h,r1=0.9*d*fudge+chamfer_r,r2=0.9*d*fudge,$fn=6);
        }
        mirror([0,0,1]){
            cylinder(h=999,r=0.9*d*fudge+chamfer_r,$fn=6);
        }
        if(shaft){
            sr=d/2*1.05*(fudge+1)/2; //radius of shaft
            translate_z(height/2){
                cylinder(r=sr,h=999,$fn=16,center=true);
            }
            //add a little cut to the roof of the surface so the initial bridges don't have to span the hole.
            intersection(){
                union(){
                    translate_z(height){
                        cube([999,sr*2,0.5],center=true);
                    }
                    translate_z(height+0.25){
                        cube([sr*2,sr*2,0.5],center=true);
                    }
                }
                cylinder(h=height+1,r=0.9*d*fudge,$fn=6);
            }
        }
    }
}

module nut_y(d,h=undef,center=false,fudge=1.15,extra_height=0.7,shaft_length=0){
    //make a nut, for metric bolt of nominal diameter d
    //d: nominal bolt diameter (e.g. 3 for M3)
    //h: height of nut
    //center: works as for cylinder
    //fudge: multiply the diameter by this number (1.22 works when vertical)
    //shaft: include a long cylinder representing the bolt shaft, diameter=d*1.05
    height = if_undefined_set_default(h, d*0.8);
    r=0.9*d*fudge;
    union(){
        rotate([-90, 0, 0]){
            cylinder(h=height,center=center,r=r,$fn=6);
        }

        if(shaft_length > 0){
            sl = shaft_length>0 ? shaft_length : 999;
            translate_y(height/2){
                reflect_y(){
                    cylinder_with_45deg_top(h=sl,r=d/2*1.05*fudge,$fn=16,extra_height=extra_height);
                }
            }
            //Center could be used instead of reflect
        }

        // extra space on top 
        center_y = center ? -height/2 : 0;
        flat_length = 2*r*sin(30);
        center_to_flat = r*cos(30);

        translate([-flat_length/2, center_y ,0]){
            cube([flat_length, height, center_to_flat+extra_height]);
        }

    }
}

// Module: cyl_slot()
// Usage: cyl_slot(r=1, h=1, dy=2, center=false)
// Description: An elongated cylinder use to make a slot for a screw. Slot is oriented in the y direction
// Arguments:
//   r = raduis of the slots
//   h = the height
//   dy = the length of the slot (centre to centre on circles) total length is dy+2*r
//   center = if true the shape is centred on all axes.
// Examples:
//   cyl_slot(r=2, h=10, dy=20);
module cyl_slot(r=1, h=1, dy=2, center=false){

    hull(){
        repeat([0, dy, 0], 2, center=true){
            cylinder(r=r, h=h, center=center);
        }
    }
}

keyhole(10, 6, 3, 25, center=false);
// Module: keyhole()
// Usage: keyhole(h, r_hole, r_slot, l_slot, center=false)
// Arguments:
//   h = height of the keyhole shape
//   r_hole = radius of the larger hole.
//   r_slot = radius of the slot.
//   l_slot = length of the slot (y-dir), from centre of hole to centre of circle at top of slot.
//   ---
//   center = The default, `false`, Whether the shape is centred in z.
// Description:
//   Create a keyhole shaped prism. Main lobe centred at (x,y) = (0,0). Slot
//   in the y-direction.
// Examples:
//   keyhole(10, 2.5, 1.6, 5, center=false);
module keyhole(h, r_hole, r_slot, l_slot, center=false){
    translate_y(l_slot/2){
        cyl_slot(r=r_slot, h=h, dy=l_slot, center=center);
    }
    cylinder(r=r_hole, h=h, center=center);
}

// Module: unrotate()
// Usage: unrotate(rotation)
// Description: 
//   Undoing a rotation is not as simple as `rotate(-rotation)` because
//   `rotate()` applies three separate rotations in order.
//   `unrotate()` reverses this, by applying the rotations in reverse order.
// Example(3D):
//   angles = [30, 60, 45];
//   unrotate(angles) rotate(angles) cylinder(r=2, h=10);
// Example(3D):
//   // This doesn't undo the rotation as you might expect!
//   angles = [30, 60, 45];
//   rotate(-angles) rotate(angles) cylinder(r=2, h=10);
module unrotate(rotation){
    //undo a previous rotation
    //Note: this is not the same as rotate(-rotation) due to ordering.
    rotate_x(-rotation.x){
        rotate_y(-rotation.y){
            rotate_z(-rotation.z){
                children();
            }
        }
    }
}

// Module: sparse_matrix_transform()
// Usage: sparse_matrix_transform(xx=1, yy=1, zz=1, xy=0, xz=0, yx=0, yz=0, zx=0, zy=0, xt=0, yt=0, zt=0)
// Description:
//   Sometimes, a matrix transformation is the right way to get something done.
//   However, specifying a full 4x4 matrix can be a bit clumsy - especially as
//   lots of useful transformations are quite close to the identity matrix.
//   This module allows you to specify individual matrix elements.  Unspecified
//   elements will default to the identity matrix.
// Examples:
//   sparse_matrix_transform(yz=0.5) cylinder(r=5, h=20);
//   sparse_matrix_transform(zy=0.5) cylinder(r=5, h=20);
module sparse_matrix_transform(xx=1, yy=1, zz=1, xy=0, xz=0, yx=0, yz=0, zx=0, zy=0, xt=0, yt=0, zt=0){
    //Apply a matrix transformation, specifying the matrix sparsely
    //This is useful because most helpful matrices are close to the identity.
    matrix = [[xx, xy, xz, xt],
              [yx, yy, yz, yt],
              [zx, zy, zz, zt],
              [0,  0,  0,  1]];
    multmatrix(matrix){
        children();
    }
}

//TODO: What does this do? Do we still want it?
module support(size, height, baseheight=0, rotation=[0,0,0], supportangle=45, outline=false){
    //generate "support material" in the STL file for selective supporting of things
    module support_2d(){
        sw=1.0;
        sp=3;
        union(){
            if(outline){
                difference()    {
                    minkowski(){
                        children();
                        circle(r=sw,$fn=8);
                    }
                    children();
                }
            }
            intersection(){
                children();
                rotate(supportangle){
                    for(x=[-size:sp:size]){
                        translate([x,0]){
                            square([sw,2*size],center=true);
                        }
                    }
                }
            }
        }
    }

    unrotate(rotation){
        translate_z(baseheight){
            linear_extrude(height){
                support_2d(){
                    projection(){
                        rotate(rotation){
                            children();
                        }
                    }
                }
            }
        }
    }
    children();
}

module rightangle_prism(size,center=false){
    intersection(){
        cube(size,center=center);
        rotate_y(45){
            translate_x(999/2){
                cube([1,1,1]*999,center=true);
            }
        }
    }
}

// Module: sequential_hull()
// Usage: sequential_hull()
// Description: 
//   Take the convex hull between each pair in a sequence of geometries.
//   
//   `sequential_hull()` allows the construction of relatively complicated
//   shapes, by "hulling" between pairs of objects.  It must have at least
//   two child modules, though it becomes useful when you have rather more.
//   Using it in conjunction with a sequence of spheres, for example, will
//   create a wire that passes each point.
// Example:
//   sequential_hull(){
//   -- $fn=8;
//       translate([0,0,0]) sphere(2);
//       translate([0,0,15]) sphere(2);
//       translate([15,0,15]) sphere(2);
//       translate([0,15,15]) sphere(2);
//   }
// Example:
//   sequential_hull(){
//       translate([0,0,0]) cylinder(r=2, h=tiny());
//       translate([0,0,5]) cylinder(r=4, h=tiny());
//       translate([0,0,7]) cylinder(r=2, h=tiny());
//       translate([0,0,10]) cylinder(r=6, h=3);
//       translate([0,0,20]) cylinder(r=2, h=tiny());
//   }
module sequential_hull(){
    //given a sequence of >2 children, take the convex hull between each pair - a helpful, general extrusion technique.
    for(i=[0:$children-2]){
        hull(){
            children(i);
            children(i+1);
        }
    }
}

module convex_fillet(r){
    offset(r){
        offset(-r){
            children();
        }
    }
}

module concave_fillet(r){
    offset(-r){
        offset(r){
            children();
        }
    }
}

//TODO: Give this a better name
module cylinder_with_45deg_top(h,r,center=false,extra_height=0.7){
    // Block on top of the hortizontal cylinder. Hulled with the cylinder
    // This forms a 45 degree sloped roof for printing
    top_block_dims = [2*sin(45/2)*r, 2*tiny(), h];
    top_block_z = center ? 0 : h/2;
    top_block_tr = [0, r-tiny(), top_block_z];
    union(){
        rotate([90,0,180]){
            hull(){
                cylinder(h=h,r=r,center=center);
                translate(top_block_tr){
                    cube(top_block_dims, center=true);
                }
            }
            translate(top_block_tr){
                cube(top_block_dims + [0, 2*extra_height, 0], center=true);
            }
        }
    }
}

//TODO: Find out if this is still needed, and what it is!
module feather_vertical_edges(flat_h=0.2,fin_r=0.5,fin_h=0.72,object_h=20){
    union(){
    //    children();
        minkowski(){
            intersection(){
                children();
                union(){
                    for(i=[-floor(object_h/fin_h):floor(object_h/fin_h)]){
                        translate_z(i*fin_h+flat_h*1.5){
                            cube([999,999,flat_h],center=true);
                        }
                    }
                }
            }
            cylinder(r1=0,r2=fin_r,h=fin_h-2*flat_h,$fn=8);
        }
    }
}

// Module: square_to_circle()
// Description:
//   Gradually transition from a square to a circle.
//
//   Create a stack of polygons, starting with a square and doubling the
//   number of sides each layer, until we end up with a "circle".
//   
//   Optionally, we can add a cylinder on top, matching the top layer.
// Arguments:
//   r = The radius of the nominal cylinder
//   h = The overall height of the structure
//   ---
//   layers = The number of layers (default is 4).  Each layer will have a height of `h/layers`
//   top_cylinder = The height of the top cylinder.  The top cylinder will have the same number of facets as the final layer, and the whole structure will have a height of `h + top_cylinder`.
module square_to_circle(r, h, layers=4, top_cylinder=0){
    // A stack of thin shapes, starting as a square and
    // gradually gaining sides to turn into a cylinder
    sides=[4,8,16,32,64,128,256]; //number of sides
    for(i=[0:(layers-1)]){
        rotate(180/sides[i]){
            translate_z(i*h/layers){
                cylinder(r=r/cos(180/sides[i]),h=h/layers+tiny(),$fn=sides[i]);
            }
        }
    }

    if(top_cylinder>0){
        translate_z(tiny()){
            cylinder(r=r,h=h+top_cylinder, $fn=sides[layers-1]);
        }
    }
}

// Module: hole_from_bottom()
// Usage: hole_from_bottom(r, h, base_w=-1, delta_z=0.5, layers=4, big_bottom=true)
// Description:
//   A cylinder that is gradually formed from a slot or square at the base.
//   This allows a hole to be formed in the "roof" of a void, with only
//   minimal "stringing" when printed with a fused filament fabrication printer.
//   
//   The most important thing to get right is the first layer, which should be
//   a slot, spanning the full width of the void.  This means that most competent
//   slicers will be able to correctly bridge across the void, parallel to the
//   slot.  You can set the width of the slot using `base_w`, though the neatest
//   way to do this is often with an intersection (see the example).
//   
//   Once you have bridged over the void, leaving a slot for the hole, the next
//   layer will have a square hole.  This should mean the printer bridges over
//   the slot in the layer(s) below, perpendicular to the edges.  Subsequent
//   layers will then fill in the corners, until we have a nice cylinder.
//   
//   You can set `base_w` carefully and just subtract this from the "roof" of
//   a void.  However, it is often easier to set `base_w=999` and 
//   `big_bottom=true`, then take the intersection with your void, see the 
//   example.
// Arguments:
//   r = The radius of the cylinder
//   h = The height of the cylinder
//   ---
//   base_w = The width of the slot at the bottom.  By default it will be 2*r.
//   delta_z = The thickness of the layers.  I suggest twice your printer's layer thickness is a sensible value.
//   layers = The number of steps between square and cylinder (default 4)
//   big_bottom = If true (default), add a very large volume below z=0
// Example(VPT=[0,0,10], VPR=[120, 0, 30], NoAxes):
//   difference(){
//        translate([-10, -10, 0]) cube(20); // The base structure
//   
//        intersection(){
//            cylinder(r=8, h=999, center=true); // This is our void
//   
//            // We set the height of our void by the Z position of 
//            // hole_from_bottom
//            translate([0,0,10]) hole_from_bottom(r=2, h=999, base_w=999, big_bottom=true);
//        }
//      
//        // Cut through the structure so we can see inside
//        rotate(225) translate([-99, 0, -1]) cube(999);
//    }
// Example(2D, NoAxes):
//    -- module example_1(){
//    --     difference(){
//    --         translate([-10, -10, 0]) cube(20); // The base structure
//    --     
//    --         intersection(){
//    --             cylinder(r=8, h=999, center=true); // This is our void
//    --     
//    --             // We set the height of our void by the Z position of 
//    --             // hole_from_bottom
//    --             translate([0,0,10]) hole_from_bottom(r=2, h=999, base_w=999, big_bottom=true);
//    --         }
//    --     }
//    -- }
//    // This code renders some slices through the first example
//    for(i = [0:3]){
//        z = 9.75 + 0.5*i;
//        translate([i*25, 0, 0]) projection(cut=true) translate([0,0,-z]) example_1();
//    }
// Example(3D, VPD=50):
//    hole_from_bottom(r=2, h=10, base_w=10, big_bottom=false);
// Example(3D, VPD=50):
//    hole_from_bottom(r=2, h=10, big_bottom=true);
// See Also: square_to_circle()
module hole_from_bottom(r, h, base_w=-1, delta_z=0.5, layers=4, big_bottom=true){
    // This creates a shape that can be used to create a 3D printable
    // hole in a large bridge. Builds up in layer to avoid unprintable
    // cantilevered paths.

    base = base_w>0 ? [base_w,2*r,2*delta_z] : [2*r,2*r,tiny()];
    union(){
        cube(base,center=true);
        translate_z(base.z/2-tiny()){
            square_to_circle(r, delta_z*4, layers, h-delta_z*5+tiny());
        }
        if(big_bottom){
            mirror([0,0,1]){
                cylinder(r=999,h=999,$fn=8);
            }
        }
    }
}

// Module: lighttrap_cylinder)
// Usage: lighttrap_cylinder(r1, r2, h, ridge=1.5);
// Arguments:
//   r1 = the radius of the bottom of the shape (i.e. the bottom of the bottom truncated cone)
//   r2 = the inner radius of the top of the shape (i.e. the top of the top truncated cone)
//   h = the overall height
//   ---
//   ridge = The height and change in `r` of each ridge (the angle is fixed at 45 degrees)
// Description:
//   A shape made up of truncated cones to form a christmas-tree-like shape.
//   
//   This is designed to be subtracted from a solid block, to form a light path
//   that has minimal reflections from the walls of the cut-out, because the 
//   surfaces are angled.
//   
//   NB for a nominally "straight-edged" cylinder, you must set `r2 = r1 - ridge`.
// Example:
//    lighttrap_cylinder(5, 5-1.5, 21);
// Example:
//    difference(){
//        translate([-10, -10, 0]) cube(20);
//        lighttrap_cylinder(5, 5-1.5, 21);
//        translate([-99, -999, -1]) cube(999);
//    }
module lighttrap_cylinder(r1,r2,h,ridge=1.5){
    //there must be at least one cone or we divide by zero
    n_cones = max(floor(h/ridge),1);
    cone_h = h/n_cones;

    for(i = [0 : n_cones - 1]){
        p = i/(n_cones - 1);
        section_r1 = (1-p)*r1 + p*(r2+ridge);
        section_r2 = (1-p)*(r1-ridge) + p*r2;
        translate_z(i * cone_h - tiny()){
            cylinder(r1=section_r1, r2=section_r2, h=cone_h+2*tiny());
        }
    }
}

module lighttrap_sqylinder(r1,f1,r2,f2,h,ridge=1.5){
    //A shape made up of rounded truncated pyramids to form a
    //square christmas-tree-like shape.
    //Similar to lighttrap_cylinder each section has flat sides
    //It can be subtracted from and object to create a square shaft that is
    //good for trapping stray light in an optical path. The shaft rounded
    //corners
    //r1 is radius of cuvature of the bottom of the bottom pyramid
    //f1 is the flat section of the bottom of the bottom pyramid
    //r2 is radius of cuvature of the top of the top pyramid
    //f2 is the flat section of the to of the top pyramid
    //NOTE: to make a uniform width shaft set r2==r1-ridge and f1=f2
    //ALSO NOTE: Each truncated pyramid is made by varying r, not f. As such
    //    r1 must be greater than or equal to ridge

    assert(r1>=ridge, "r1 is less than ridge this will cause the light trap to fail");
    //there must be at least one cone or we divide by zero
    n_cones = max(floor(h/ridge),1);
    cone_h = h/n_cones;

    for(i = [0 : n_cones - 1]){
        p = i/(n_cones - 1);
        section_r1 = (1-p)*r1 + p*(r2+ridge);
        section_r2 = (1-p)*(r1-ridge) + p*r2;
        section_flat_l = ((1-p)*f1 + p*f2);
        translate_z(i * cone_h - tiny()){
            minkowski(){
                cylinder(r1=section_r1, r2=section_r2, h=cone_h);
                cube([section_flat_l, section_flat_l, 2*tiny()], center=true);
            }
        }
    }
}

module trylinder(r=1, flat=1, h=tiny(), center=false){
    //Triangular prism with filleted corners
    //NOTE the largest cylinder that fits inside it has r=r+f/(2*sqrt(3))
    //One of the sides is parallel with the X axis
    hull(){
        for(a=[0,120,240]){
            rotate(a){
                translate_y(flat/sqrt(3)){
                    cylinder(r=r, h=h, center=center);
                }
            }
        }
    }
}

module trylinder_selftap(nominal_d=3, h=10, center=false){
    // Make a trylinder that you can self-tap a machine screw into.
    // The size is deliberately a bit big for small holes, so that
    // it compensates for splodgy printing
    echo("Warning: `trylinder_selftap` is no longer recommended for use.");
    echo("Use explicitlt defined holes such as `m4_selftap_hole` for screw sizes M4 and above.");
    echo("Use explicit holes for self tap screws, such as `no2_selftap_hole`");
    echo("For machine screws smaller than M4 use nut traps to avoid thread stripping.");
    r = max(nominal_d*0.8/2 + 0.2, nominal_d/2 - 0.2);
    dr = 0.5;
    flat = dr * 2 * sqrt(3);
    trylinder(r=r - dr, flat=flat, h=h, center=center);
}


module trylinder_gripper(inner_r=10,h=6,grip_h=3.5,base_r=-1,t=0.65,squeeze=1,flare=0.8,solid=false){
    // This creates a tapering, distorted hollow cylinder suitable for
    // gripping a small cylindrical (or spherical) object
    // The gripping occurs grip_h above the base, and it flares out
    // again both above and below this.
    // inner_r: radius of the cylinder we're gripping
    // h: overall height of the gripper
    // grip_h: height of the part where the gripper touches the cylinder
    // base_r: radius of the (cylindrical) bottom
    // t: thickness of the walls
    // squeeze: how far the wall must be distorted to fit the cylinder
    // flare: how much larger the top is than the gripping part
    // solid: if true, make a solid outline of the gripper
    $fn=48;
    bottom_r=base_r>0?base_r:inner_r+1+t;

    //TODO: reduce repition
    difference(){
        sequential_hull(){
            cylinder(r=bottom_r,h=tiny());
            translate_z(grip_h-0.5){
                trylinder(r=inner_r-squeeze+t,flat=2.5*squeeze,h=tiny());
            }
            translate_z(grip_h+0.5){
                trylinder(r=inner_r-squeeze+t,flat=2.5*squeeze,h=tiny());
            }
            translate_z(h-tiny()){
                trylinder(r=inner_r-squeeze+flare+t,flat=2.5*squeeze,h=tiny());
            }
        }
        if(solid==false){
            sequential_hull(){
                translate_z(-tiny()){
                    cylinder(r=bottom_r-t,h=tiny());
                }
                translate_z(grip_h-0.5){
                    trylinder(r=inner_r-squeeze,flat=2.5*squeeze,h=tiny());
                }
                translate_z(grip_h+0.5){
                    trylinder(r=inner_r-squeeze,flat=2.5*squeeze,h=tiny());
                }
                translate_z(h){
                    trylinder(r=inner_r-squeeze+flare,flat=2.5*squeeze,h=tiny());
                }
            }
        }
    }
}

module deformable_hole_trylinder(r1, r2, h=99, corner_roc=undef, delta_z=0.5, center=false){
    // A cylinder with feathered edges, to make a hole that is
    // slightly deformable, in an otherwise rigid structure.
    // r1: inner radius
    // r2: outer radius
    // h, center: as for cylinder
    // corner_roc: radius of curvature of the trylinder
    // delta_z: thickness of layers
    n = floor(h/(2*delta_z)); //number of layers in the structure
    flat_l = 2*sqrt(r2*r2 - r1*r1);
    default_corner_radius = r1 - flat_l/(2*sqrt(3));
    corner_radius = if_undefined_set_default(corner_roc, default_corner_radius);
    repeat([0,0,2*delta_z], n, center=center){
        union(){
            cylinder(r=r2, h=delta_z+tiny());
            translate_z(center ? -delta_z : delta_z){
                trylinder(r=corner_radius, flat=flat_l, h=delta_z+tiny());
            }
        }
    }
}


module exterior_brim(r=4, h=0.2, brim_only=false, smooth_r=undef){
    // Add a "brim" around the outside of an object *only*, preserving holes in the object
    // brim width r and the smoothing smooth_r can be defined separately, but default to equal

    _smooth_r = is_undef(smooth_r) ? r : smooth_r;

    if (!brim_only){
        children();
    }

    if(r > 0){
        linear_extrude(h){
            difference(){
                offset(r){
                    offset(-_smooth_r){
                        offset(_smooth_r){
                            projection(cut=true){
                                translate_z(-tiny()){
                                    children();
                                }
                            }
                        }
                    }
                }
                offset(-_smooth_r+tiny()){
                    offset(_smooth_r){
                        projection(cut=true){
                            translate_z(-tiny()){
                                children();
                            }
                        }
                    }
                }
            }
        }
    }
}

module external_fillet_2d(r=3)
{
    offset(r=r){
        offset(r=-r){
            children();
        }
    }
}

module internal_fillet_2d(r=3)
{
    offset(r=-r){
        offset(r=r){
            children();
        }
    }
}

module fillet_2d(r=3)
{
    external_fillet_2d(r=r){
        internal_fillet_2d(r=r){
            children();
        }
    }
}
