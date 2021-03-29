/******************************************************************
*                                                                 *
* OpenFlexure Microscope: OpenSCAD Utility functions              *
*                                                                 *
* This is part of the OpenFlexure microscope, an open-source      *
* microscope and 3-axis translation stage.  It gets really good   *
* precision over a ~10mm range, by using plastic flexure          *
* mechanisms.                                                     *
*                                                                 *
* (c) Richard Bowman, January 2016                                *
* Released under the CERN Open Hardware License                   *
*                                                                 *
******************************************************************/


//utilities

// this is a tiny distance. Used to be a parameter d in the code but that caused confusion with diameters
function tiny() = 0.05;

function zeroz(size) = [size.x, size.y, 0]; //set the Z component of a 3-vector to 0

module reflect(axis){
    //reflects children about the origin, keeping the originals
    children();
    mirror(axis){
        children();
    }
}

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

module nut(d,h=-1,center=false,fudge=1.18,shaft=false){
    //make a nut, for metric bolt of nominal diameter d
    //d: nominal bolt diameter (e.g. 3 for M3)
    //h: height of nut
    //center: works as for cylinder
    //fudge: multiply the diameter by this number (1.22 works when vertical)
    //shaft: include a long cylinder representing the bolt shaft, diameter=d*1.05
    h=(h<0)?d*0.8:h;
    union(){
        cylinder(h=h,center=center,r=0.9*d*fudge,$fn=6);
        if(shaft){
            cylinder(r=d/2*1.05*(fudge+1)/2,h=999,$fn=16,center=true);
        }
    }
}

module nut_from_bottom(d,h=-1,fudge=1.2,shaft=true,chamfer_r=0.75,chamfer_h=0.75){
    //make a nut, for metric bolt of nominal diameter d
    //d: nominal bolt diameter (e.g. 3 for M3)
    //h: height of nut
    //center: works as for cylinder
    //fudge: multiply the diameter by this number (1.22 works when vertical)
    //shaft: include a long cylinder representing the bolt shaft, diameter=d*1.05
    h=(h<0)?d*0.8:h;
    union(){
        cylinder(h=h,r=0.9*d*fudge,$fn=6);
        translate([0,0,-0.05]){
            cylinder(h=chamfer_h,r1=0.9*d*fudge+chamfer_r,r2=0.9*d*fudge,$fn=6);
        }
        mirror([0,0,1]){
            cylinder(h=999,r=0.9*d*fudge+chamfer_r,$fn=6);
        }
        if(shaft){
            sr=d/2*1.05*(fudge+1)/2; //radius of shaft
            translate([0,0,h/2]){
                cylinder(r=sr,h=999,$fn=16,center=true);
            }
            //add a little cut to the roof of the surface so the initial bridges don't have to span the hole.
            intersection(){
                union(){
                    translate([0,0,h]){
                        cube([999,sr*2,0.5],center=true);
                    }
                    translate([0,0,h+0.25]){
                        cube([sr*2,sr*2,0.5],center=true);
                    }
                }
                cylinder(h=h+1,r=0.9*d*fudge,$fn=6);
            }
        }
    }
}

module nut_y(d,h=-1,center=false,fudge=1.15,extra_height=0.7,shaft=false,shaft_length=0,top_access=false){
    //make a nut, for metric bolt of nominal diameter d
    //d: nominal bolt diameter (e.g. 3 for M3)
    //h: height of nut
    //center: works as for cylinder
    //fudge: multiply the diameter by this number (1.22 works when vertical)
    //shaft: include a long cylinder representing the bolt shaft, diameter=d*1.05
    //top_access: extend the nut upwards to allow it to drop in.
    h=(h<0)?d*0.8:h;
    r=0.9*d*fudge;
    union(){
        rotate([-90,top_access?30:0,0]){
            cylinder(h=h,center=center,r=r,$fn=6);
        }
        translate([-r*sin(30),center?-h/2:0,0]){
            cube([2*r*sin(30),h,r*cos(30)+extra_height]);
        }
        if(shaft || shaft_length > 0){
            sl = shaft_length>0 ? shaft_length : 999;
            translate([0,h/2,0]){
                reflect([0,1,0]){
                    cylinder_with_45deg_top(h=sl,r=d/2*1.05*fudge,$fn=16,extra_height=extra_height);
                }
            }
            //Center could be used instead of reflect
        }
        if(top_access){ //hole from the top
            translate([-r*cos(30),center?-h/2:0,0]){
                cube([2*r*cos(30),h,999]);
            }
        }
    }
}

module screw_y(d,h=-1,center=false,fudge=1.05,extra_height=0.7,shaft=false,shaft_length=999){
    //make a nut, for metric bolt of nominal diameter d
    //d: nominal bolt diameter (e.g. 3 for M3)
    //h: height of nut
    //center: works as for cylinder
    //fudge: multiply the diameter by this number (1.22 works when vertical)
    //shaft: include a long cylinder representing the bolt shaft, diameter=d*1.05
    h=(h<0)?d*0.8:h; //height of screw head
    r=0.9*d*fudge; //radius of screw head
    union(){
        cylinder_with_45deg_top(h=h,r=d*1.05*fudge,$fn=16,extra_height=extra_height);
        if(shaft){
            translate([0,center ? 0 : h/2,0]){
                reflect([0,1,0]){
                    cylinder_with_45deg_top(h=shaft_length+h/2,r=d/2*1.05*fudge,$fn=16,extra_height=extra_height);
                }
            }
            //Center could be used instead of reflect
        }
    }
}

module pinch_y(d, screw_l=999, counterbore_l=999, nut_l=-1, gap=[], t=2,extra_height=0.7,top_access=false){
    //gap with a nut/bolt to squeeze it
    nut_l = nut_l<0 ? d : nut_l; //default nut height
    gap = len(gap)==3 ? gap : [4*d, d, 4*d];
    union(){
        translate([0,gap.y/2+t]){
            screw_y(d,h=counterbore_l,shaft=true,shaft_length=2*screw_l,extra_height=extra_height);
        }
        cube(gap,center=true);
        translate([0,-gap.y/2-t]){
            mirror([0,1,0]){
                nut_y(d, h=nut_l,center=false,shaft=false,top_access=top_access);
            }
        }
    }
}


module chamfered_hole(r=10, h=10, chamfer=1,center=false){
    // A cylinder with angled flanges.
    // This can be substracted from an object of height h to make a
    // chamfered hole.
    translate([0,0, center ? -h/2 : 0]){
        union(){
            translate([0,0,-tiny()]){
                cylinder(r1=r+chamfer+tiny(),r2=r,h=chamfer+tiny());
            }
            cylinder(r=r,h=h);
            translate([0,0,h-chamfer]){
                cylinder(r1=r,r2=r+chamfer+tiny(),h=chamfer+tiny());
            }
        }
    }
}

module cyl_slot(r=1, h=1, dy=2, center=false){
    // An elongated cylinder use to make a slot for a screw. Slot is oriented in the y direction
    // r: raduis of the slots
    // h: the height
    // dy: the length of the slot (centre to centre on circles) total length is dy+2*r
    // center: if true the shape is centred on all axes.

    hull(){
        repeat([0, dy, 0], 2, center=true){
            cylinder(r=r, h=h, center=center);
        }
    }
}

module unrotate(rotation){
    //undo a previous rotation
    //Note: this is not the same as rotate(-rotation) due to ordering.
    rotate([0,0,-rotation.z]){
        rotate([0,-rotation.y,0]){
            rotate([-rotation.x,0,0]){
                children();
            }
        }
    }
}

module smatrix(xx=1, yy=1, zz=1, xy=0, xz=0, yx=0, yz=0, zx=0, zy=0, xt=0, yt=0, zt=0){
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
        translate([0,0,baseheight]){
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
        rotate([0,45,0]){
            translate([999/2,0,0]){
                cube([1,1,1]*999,center=true);
            }
        }
    }
}

module sequential_hull(){
    //given a sequence of >2 children, take the convex hull between each pair - a helpful, general extrusion technique.
    for(i=[0:$children-2]){
        hull(){
            children(i);
            children(i+1);
        }
    }
}

module union_preserving_holes(){
    //given a number of children, return the union of them, but preserve holes in each part
    difference(){
        union(){  //the union of all the parts
            children();
        }
        union(){ //the union of all the holes
            for(i=[0:$children-1]){
                difference(){
                    hull(){
                        children(i);
                    }
                    children(i);
                }
            }
        }
    }
}

// TODO: Find out why this is called this.
module cylinder_with_45deg_top(h,r,center=false,extra_height=0.7,$fn=$fn){
    union(){
        rotate([90,0,180]){
            hull(){
                cylinder(h=h,r=r,$fn=$fn,center=center);
                translate([0,r-0.001,center?0:h/2]){
                    cube([2*sin(45/2)*r,0.002,h],center=true);
                }
            }
        }
        rotate([90,0,180]){
            translate([0,r-0.001,(center?0:h/2)]){
                cube([2*sin(45/2)*r,0.002+2*extra_height,h],center=true);
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
                        translate([0,0,i*fin_h+flat_h*1.5]){
                            cube([999,999,flat_h],center=true);
                        }
                    }
                }
            }
            cylinder(r1=0,r2=fin_r,h=fin_h-2*flat_h,$fn=8);
        }
    }
}

module square_to_circle(r, h, layers=4, top_cylinder=0){
    // A stack of thin shapes, starting as a square and
    // gradually gaining sides to turn into a cylinder
    sides=[4,8,16,32,64,128,256]; //number of sides
    for(i=[0:(layers-1)]){
        rotate(180/sides[i]){
            translate([0,0,i*h/layers]){
                cylinder(r=r/cos(180/sides[i]),h=h/layers+tiny(),$fn=sides[i]);
            }
        }
    }
    
    if(top_cylinder>0){
        translate([0,0,tiny()]){
            cylinder(r=r,h=h+top_cylinder, $fn=sides[layers-1]);
        }
    }
}

module hole_from_bottom(r, h, base_w=-1, dz=0.5, big_bottom=true){
    // This creates a shape that can be used to create a 3D printable
    // hole in a large bridge. Builds up in layer to avoid unprintable
    // cantilevered paths.

    base = base_w>0 ? [base_w,2*r,2*dz] : [2*r,2*r,tiny()];
    union(){
        translate([0,0,0]){
            cube(base,center=true);
        }
        translate([0,0,base.z/2-tiny()]){
            square_to_circle(r, dz*4, 4, h-dz*5+tiny());
        }
        if(big_bottom){
            mirror([0,0,1]){
                cylinder(r=999,h=999,$fn=8);
            }
        }
    }
}


module lighttrap_cylinder(r1,r2,h,ridge=1.5){
    //A shape made up of truncated cones to form a christmas-tree-like shape.
    //It can be subtracted from and object to create a shaft that is good for
    //trapping stray light in an optical path
    //r1 is the radius of the bottom of the shape
    //     (i.e. the bottom of the bottom truncated cone) 
    //r2 is the inner radius of the top of the shape
    //     (i.e. the top of the top truncated cone) 
    //NOTE: to make a uniform width shaft set r2==r1-ridge

    //there must be at least one cone or we divide by zero
    n_cones = max(floor(h/ridge),1);
    cone_h = h/n_cones;

    for(i = [0 : n_cones - 1]){
        p = i/(n_cones - 1);
        section_r1 = (1-p)*r1 + p*(r2+ridge);
        section_r2=(1-p)*(r1-ridge) + p*r2;
        translate([0, 0, i * cone_h - tiny()]){
            cylinder(r1=section_r1, r2=section_r2, h=cone_h+2*tiny());
        }
    }
}
lighttrap_sqylinder(r1=5,f1=5,f2=5,r2=5-1.5,h=20,ridge=1.5);

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
        translate([0, 0, i * cone_h - tiny()]){
            minkowski(){
                cylinder(r1=(1-p)*r1 + p*(r2+ridge),
                    r2=(1-p)*(r1-ridge) + p*r2,
                    h=cone_h);
                cube([1,1,0]*((1-p)*f1 + p*f2) + [0,0,2*tiny()], center=true);
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
                translate([0,flat/sqrt(3),0]){
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
            translate([0,0,0]){
                cylinder(r=bottom_r,h=tiny());
            }
            translate([0,0,grip_h-0.5]){
                trylinder(r=inner_r-squeeze+t,flat=2.5*squeeze,h=tiny());
            }
            translate([0,0,grip_h+0.5]){
                trylinder(r=inner_r-squeeze+t,flat=2.5*squeeze,h=tiny());
            }
            translate([0,0,h-tiny()]){
                trylinder(r=inner_r-squeeze+flare+t,flat=2.5*squeeze,h=tiny());
            }
        }
        if(solid==false){
            sequential_hull(){
                translate([0,0,-tiny()]){
                    cylinder(r=bottom_r-t,h=tiny());
                }
                translate([0,0,grip_h-0.5]){
                    trylinder(r=inner_r-squeeze,flat=2.5*squeeze,h=tiny());
                }
                translate([0,0,grip_h+0.5]){
                    trylinder(r=inner_r-squeeze,flat=2.5*squeeze,h=tiny());
                }
                translate([0,0,h]){
                    trylinder(r=inner_r-squeeze+flare,flat=2.5*squeeze,h=tiny());
                }
            }
        }
    }
}

module deformable_hole_trylinder(r1, r2, h=99, corner_roc=-1, dz=0.5, center=false){
    // A cylinder with feathered edges, to make a hole that is
    // slightly deformable, in an otherwise rigid structure.
    // r1: inner radius
    // r2: outer radius
    // h, center: as for cylinder
    // corner_roc: radius of curvature of the trylinder
    // dz: thickness of layers
    n = floor(h/(2*dz)); //number of layers in the structure
    flat_l = 2*sqrt(r2*r2 - r1*r1);
    corner_roc = corner_roc < 0 ? r1 - flat_l/(2*sqrt(3)) : corner_roc;
    repeat([0,0,2*dz], n, center=center){
        union(){
            cylinder(r=r2, h=dz+tiny());
            translate([0,0,center ? -dz : dz]){
                trylinder(r=corner_roc, flat=flat_l, h=dz+tiny());
            }
        }
    }
}
module self_tap_hole(mean_r, h, dr=1, dz=0.5, bridge_facets=0, center=false, screw=true){
    // A cylinder with bridges around the edges, aiming to make
    // a hole with nicely feathered edges.
    // mean_r is the radius of the thing you're inserting.  The
    // "hard" edge of the hole will be mean_r + dr/2 and the "soft"
    // inner edge will be at mean_r - dr/2;
    // bridge_facets determines the number of bridges used - can be
    // safely left at the default value.
    // center has the same meaning as in cylinder.
    inner_r = mean_r - dr/2;
    outer_r = mean_r + dr/2;

    //default number of facets
    default_facets = floor(180/acos(inner_r/outer_r));
    bridge_facets = bridge_facets > 0 ? bridge_facets : default_facets; 
    difference(){
        cylinder(r=outer_r, h=h, center=center);
        repeat([0,0,2*dz], ceil(h/dz/2), center=center){
            for(i=[1:bridge_facets]){
                rotate(i*360/bridge_facets){
                    translate([-999,inner_r,screw ? i/bridge_facets*2*dz : 0]){
                        cube([999*2,999,dz]);
                    }
                }
            }
        }
    }
}


module exterior_brim(r=4, h=0.2, brim_only=false){
    // Add a "brim" around the outside of an object *only*, preserving holes in the object
    if (!brim_only){
        children();
    }

    if(r > 0){
        linear_extrude(h){
            difference(){
                offset(r){
                    projection(cut=true){
                        translate([0,0,-tiny()]){
                            children();
                        }
                    }
                }
                offset(-r+tiny()){
                    offset(r){
                        projection(cut=true){
                            translate([0,0,-tiny()]){
                                children();
                            }
                        }
                    }
                }
            }
        }
    }
}


