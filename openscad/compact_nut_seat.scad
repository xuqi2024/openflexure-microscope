/*

An attempt at an alternative to my ageing "nut_seat_with_flex" design...

(c) 2016 Richard Bowman - released under CERN Open Hardware License

*/

use <./libs/utilities.scad>
include <microscope_parameters.scad>

nut_size = 3;
nut_w = 6.3*1.1; //nominal width of the nut (vertex-to-vertex, bigger than flat-flat distance - 6.3 is theoretical value and the 1.03 is determined by experiment)
nut_h = 2.6;
nut_slot = [nut_w*sin(60), nut_w, nut_h+0.4];
shaft_r = nut_size/2 * 1.15; //radius of hole to cut for screw
column_base_r = shaft_r + 2; //radius of the bottom of the actuator column
//column_clearance_w = nut_slot.x + 2*1.5 + 2*7;
column_core = zeroz(nut_slot) + 2*[1.5+7+1, 1.5+1.5, 0];// NB leave z=0 here
wall_t = 1.6; //thickness of the wall around the column for the screw seat

function nut_size() = nut_size;
function column_base_radius() = column_base_r;
function column_core_size() = column_core;
function nut_slot_size() = nut_slot;
function ss_outer(h=-2) = column_core + [wall_t*2,wall_t*2,(h+2)*2];

module nut_trap_and_slot(r, slot, squeeze=0.9, trap_h=-1){
    // A cut-out that will hold a nut.  The nut slots in horizontally
    // along the +y axis, and is pulled up and into the tight part of the
    // nut seat when a screw is inserted.
    hole_r = r*1.15/2;
    trap_h = trap_h<0 ? r : trap_h;
    w = slot.x; //width of the nut entry slot (should be slightly larger than the nut)
    l = slot.y; //length/depth of the slot (now ignored)
    h = slot.z; //height of the slot
    r1 = w/2/cos(30); //bottom of nut trap is large
    r2 = r*squeeze; //top of nut trap is very tight
    sequential_hull(){
        translate([-w/2,999,0]) cube([w,tiny(),h]);
        union(){
            translate([-w/2,l/2-tiny(),0]) cube([w,tiny(),h]);
            rotate(30) cylinder(d=w/sin(60), h=h, $fn=6);
        }
        a = 1/trap_h;
        rotate(30) cylinder(r=r1*(1-a) + r2*a, h=h+1, $fn=6);
        rotate(30) cylinder(r=r2, h=h+trap_h, $fn=6);
    }
    // ensure the hole in the top can be made nicely
    intersection(){
        translate([-999, -hole_r,0]) cube([999, 2*hole_r, h + trap_h + 0.5]);
        rotate(30) cylinder(r=r2, h=999, $fn=6);
    }

}


module m3_nut_trap_with_shaft(slot_angle=0,tilt=0)
{
    // Nut trap for an M3 nut with a screw from the top this is a solid
    // Object difference it from your part.
    // Trap starts at z=1mm and ends at 7.5mm
    // We recommend have the outer stucture occupies the space from z = 0-9mm


    // nut trap

    rotate([tilt,0,0])rotate([0,0,slot_angle]) translate([0,0,1]) union()
    {
        nut_trap_and_slot(nut_size, nut_slot);
        cylinder(r=shaft_r, h=999, $fn=16);
    }

}

module central_actuator_column(h, top){
    //The central column of the actuator including the square head. The column extends down
    //past the bottom of the base and must be cut
    $fn=16;
    r1 = column_base_r; //size of the bottom part
    r2 = sqrt(top.x*top.x+top.y*top.y)/2; //outer radius of top
    sequential_hull(){
        translate([0, 0, -99]){
            resize([2*r1, top.y, tiny()]){
                cylinder(r=r1, h=tiny());
            }
        }
        translate([0, 0, h-top.z - 2*(r2-r1)]){
            resize([2*r1, top.y, tiny()]){
                cylinder(r=r1, h=tiny());
            }
        }
        translate([0, 0, h-top.z/2]){
            cube(top, center=true);
        }
    }
}

module actuator_hooks(h,top){
    //These are the hooks on the actuator
    //Reflect to get two hooks
    reflect([1,0,0]){
        //Translate to the correct postion on the actuator
        translate([top.x/2,0,h]){
            //Mirror as build upside down
            mirror([0,0,1]){
                // The hook is the sequantiall hull of:
                sequential_hull(){
                    //A thin cube on the side wall of the block
                    translate([-tiny(),-top.y/2,0]){
                        cube([tiny(),top.y,top.z]);
                    }
                    //A thin cylinder inside the block so the nex section is thin
                    translate([0, 0, 0.5]){
                        scale([0.5 ,1, 1]){
                            cylinder(d=4.5, h=top.z-2);
                        }
                    }
                    //A compressed truncated cone just outside the block
                    translate([1.5,0,0.5]){
                        resize([3,4,3.5]){
                            cylinder(d1=1, d2=4, h=4);
                        }
                    }
                    //Another compressed truncated cone just under where the
                    //hook rises
                    translate([3.5,0,0.5]){
                        resize([2.5,3.0,1.5]){
                            cylinder(d1=1,d2=3.5);
                        }
                    }
                    // A tri-lobular shape for the top of the hook formed from the union
                    // of three cylinders.
                    union(){
                        reflect([0,1,0]){
                            translate([4.5,0.5,0]){
                                cylinder(d=1,h=1);
                            }
                        }
                        translate([4,0,0]){
                            cylinder(d=1,h=1);
                        }
                    }
                }
            }
        }
    }
}

module actuator_ties(tilt=0, lever_tip=3){
    // The ties for the actuator.
    rotate([tilt,0,0]){
        translate([0, 0, lever_tip+flex_dims().z+3]){
                    cube([ss_outer().x-wall_t, 1, 0.5], center=true);
        }
    }
}

module actuator_column(h, tilt=0, lever_tip=3, flip_nut_slot=false, join_to_casing=true, no_voids=false){
    // An "actuator column", a nearly-vertical tower, with a nut trap and hooks
    // for elastic bands at the top, usually attached to a flexure at the bottom.
    // There's often one of these inside the casing under an adjustment screw/gear
    //h: height of the column
    //tilt: the column is rotated about the x axis
    //lever_tip: height of the actuating lever at its end (can taper up at 45 degrees)
    //flip_nut_slot: if set to true, the nut is inserted from -y
    //join_to_casing: if set to true, the column is joined to the casing by thin threads
    //no_voids: don't leave a void for the nut or screw, used for the drilling jig.

    top = nut_slot + [3,3,nut_size + 1.5]; //size of the top part
    slot_angle = flip_nut_slot ? 180 : 0; //enter from -y if needed
    $fn=16;
    difference(){
        union(){
            rotate([tilt,0,0]){
                central_actuator_column(h, top);
                // hooks for elastic bands/springs
                actuator_hooks(h, top);
            }
            // join the column to the casing, for strength during printing
            // This module does the tilt itself so it can be rendered seperately
            // for instructions
            if(join_to_casing){
                actuator_ties(tilt, lever_tip);
            }
        }

        // nut trap
        if(!no_voids) rotate([tilt,0,0]) rotate(slot_angle)
            translate([0,0,h-top.z]) nut_trap_and_slot(nut_size, nut_slot);

        // shaft for the screw
        // NB this is raised up from the bottom so it stays within the shaft - this may need to change depending on the length of screw we use...
        if(!no_voids) rotate([tilt,0,0]) translate([0,0,lever_tip]){
            cylinder(r=shaft_r, h=999);
            translate([0,0,-lever_tip+1]) cylinder(r1=0, r2=shaft_r, h=lever_tip-1); //pointy bottom (stronger)
        }

        // space for lever and flexure
        translate([-99, -flex_dims().y/2, flex_dims().z]) sequential_hull(){
            cube([999,flex_dims().y,lever_tip]);
            translate([0,-999,999]) cube([999,flex_dims().y,lever_tip]);
        }

        // tiny holes, to increase the perimeter of the bottom bit and make it
        // stronger
        translate([-tiny(),0,flex_dims().z]) cube([2*tiny(), 10, 4]);
        // cut off at the bottom
        mirror([0,0,1]) cylinder(r=999,h=999,$fn=4);
    }
}
//actuator_column(25);


module actuator_end_cutout(lever_tip=3-0.5 ){
    // This shape cuts off the end of an actuator, leaving a thin strip to
    // connect to the actuator column (the flexure).
    sequential_hull(){
        translate([-999,-flex_dims().y/2,flex_dims().z]) cube([2,2,2]*999);
        translate([-999,-flex_dims().y/2,flex_dims().z+lever_tip]) cube([2,2,2]*999);
        translate([-999,-flex_dims().y/2-999,flex_dims().z+999]) cube([2,2,2]*999);
    }
}

module nut_seat_silhouette(r=ss_outer().y/2, dx=ss_outer().x-ss_outer().y, offset=0){
    // a (2D) shape made from the convex hull of two circles
    //    hull() reflect([1,0]) translate([x,0]) circle(r=r);
    // we don't actually build it like that though, as the hull is a slow operation...
    union(){
        reflect([1,0]) translate([dx/2,0]) circle(r=r+offset);
        square([dx,2*(r+offset)], center=true);
    }
}

module nut_seat_void(h=1, tilt=0, center=true){
    // Inside of the actuator column housing (should be subtracted
    // h is the height of the top (excluding nut hole)
    // center=true will cause it to punch through the bottom.
    // This ensures enough clearance to let the actuator column move.
    r = column_core.y/2;
    x = column_core.x/2 - r;
    rotate([tilt,0,0]) intersection(){
        linear_extrude(999,center=center) nut_seat_silhouette(offset=-wall_t);
        translate([0,0,h]) rotate(90) hole_from_bottom(nut_size*1.1/2, h=999, base_w=999);
    }
}
//color("red")nut_seat_void(10,tilt=-10);

module screw_seat_shell(h=1, tilt=0){
    // Outside of the actuator column housing - this is the structure that
    // the gear sits on top of.  It needs to be hollowed out before use
    // (see screw_seat)
    r = ss_outer(h).y/2;
    x = ss_outer(h).x/2 - r;
    double_h = ss_outer(h).z;
    difference(){
        rotate([tilt,0,0]) hull(){
            linear_extrude(double_h-3, center=true) nut_seat_silhouette();
            linear_extrude(double_h, center=true) nut_seat_silhouette(offset=-2);
        }
        mirror([0,0,1]) cylinder(r=999,h=999,$fn=8); //ground
        // hole through which we can insert the nut
        //rotate([tilt,0,0]) translate([-99,column_core.y/3, h-16]) cube(999); //this gets added later
    }
}

module motor_lugs(h=20, tilt=0, angle=0){
    // lugs to mount a micro geared stepper motor on a screw_seat.
    motor_shaft_pos=[0,-20,h+2]; //see height of screw_seat_shell above
    motor_screw_pos=[35/2,motor_shaft_pos.y+7.8,motor_shaft_pos.z+11];
    screw_r = sqrt(pow(motor_screw_pos.x,2)+pow(motor_screw_pos.y,2));
    rotate([tilt,0,0]) rotate(angle) reflect([1,0,0]) difference(){
        union(){
            hull(){
                translate(motor_screw_pos-[0,0,11]) cylinder(r=4,h=11);
                translate([0,0,motor_screw_pos.z-screw_r-11]) cylinder(r=5,h=screw_r-5);
            }
        }
        //space for gears
        translate([0,0,h]) cylinder(r1=8,r2=17,h=2+tiny());
        translate([0,0,h+2]) cylinder(h=999,r=17);
        //hollow inside of the structure
        rotate(-angle) nut_seat_void(h=h, tilt=tilt);
        //mounting screws
        translate(motor_screw_pos) trylinder_selftap(4,h=40,center=true);
    }
}

module screw_seat(h=25, travel=5, tilt=0, entry_w=2*column_base_r+3, extra_entry_h=7, motor_lugs=false, lug_angle=0, label=""){
    // This forms a hollow column, usually built around an actuator_column to
    // support the screw (see screw_seat_shell)
    entry_h = extra_entry_h + travel; //ensure the actuator can move
    nut_slot_z = h-nut_size-1.5-nut_slot.z;
    difference(){
        union(){
            screw_seat_shell(h=h + travel, tilt=tilt);
            if(motor_lugs) rotate(180) motor_lugs(h=h + travel, angle=lug_angle, tilt=-tilt);
            if(len(label) > 0) rotate([tilt,0,0]) translate([0, ss_outer(h).y/2, nut_slot_z - 2]){
                rotate([90,0,0]) linear_extrude(1, center=true) mirror([1,0])
                        text(label, size=10, font="Sans", halign="center", valign="top");
            }

        }
        nut_seat_void(h=h + travel, tilt=tilt); //hollow out the inside

        edge_y = ss_outer(h).y/2; //allow the actuator to poke in
        smatrix(zy=sin(tilt)) translate([0,-edge_y,0])
                    cube([entry_w, edge_y, entry_h*2], center=true);

        //entrance slot for nut
        rotate([tilt,0,0]) translate([0,0,nut_slot_z]) nut_trap_and_slot(nut_size, nut_slot + [0,0,0.3]);
    }
}

module screw_seat_outline(h=999,adjustment=0,center=false,tilt=0){
    // The bottom of a screw seat
    rotate([tilt,0,0]) linear_extrude(h,center=center) nut_seat_silhouette(offset=adjustment);
}


module tilted_actuator(pivot_z, pivot_w, lever, column_h=actuator_h, base_w = column_base_r*2){
    // A lever with its pivot wide and high, actuated by the above actuator
    pw = pivot_w;
    pz = pivot_z;
    nut_y = flex_dims().y + sqrt(lever*lever - pivot_z*pivot_z);
    tip_h = 3;
    difference(){
        reflect([1,0,0]){
            // pivot flexures
            translate([-pw/2, -tiny(), pz]) cube(flex_dims() + [0,2*tiny(),0]);
            // arms linking flexures to actuator column
            sequential_hull(){
                translate([-pw/2, flex_dims().y, pz]) cube(flex_dims());
                union(){
                    translate([-base_w/2, flex_dims().y, 0]) cube([base_w, tiny(), 5]);
                    translate([-column_base_r, nut_y-12, 0]) cube([2*column_base_r, tiny(), 5]);
                }
                translate([0, nut_y, 0]) cylinder(r=column_base_r, h=5);
            }
        }
        // cut-out to form the flexure for the column
        translate([-99, nut_y - flex_dims().y/2, flex_dims().z]) cube([1,1,1]*999);
        hull() repeat([0,-5,5],2) {
            translate([-99, nut_y - flex_dims().y/2, tip_h]) cube([1,1,1]*999);
        }
    }
    translate([0, nut_y, 0]) actuator_column(column_h, -asin(pivot_z/lever), flip_nut_slot=true);
}

module untilted_actuator(pushstick_z, pivot_w, lever, column_h=actuator_h, pushstick_w=6){
    // A lever with its pivot at the bottom, actuated by a column at the end.
    pw = pivot_w;
    pz = pushstick_z;
    nut_y = flex_dims().y + lever;
    tip_h = 3;
    base_w = 2*column_base_r;
    difference(){
        reflect([1,0,0]){
            // pivot flexures
            translate([-pw/2, -tiny(), 0]) cube(flex_dims() + [0,2*tiny(),0]);
            // arms linking flexures to actuator column
            sequential_hull(){
                union(){
                    translate([-pushstick_w/2, flex_dims().y, pz]) cube(flex_dims());
                    translate([-pw/2, flex_dims().y, 0]) cube(flex_dims());
                }
                translate([-base_w/2, nut_y - 20, 0]) cube([base_w, 8, 5]);
                translate([0, nut_y, 0]) cylinder(r=column_base_r, h=5);
            }
        }
        // cut-out to form the flexure for the column
        translate([-99, nut_y - flex_dims().y/2, flex_dims().z]) cube([1,1,1]*999);
        hull() repeat([0,-5,5],2) {
            translate([-99, nut_y - flex_dims().y/2, tip_h]) cube([1,1,1]*999);
        }
    }
    translate([0, nut_y, 0]) actuator_column(column_h, 0);
}

module actuator_void(h, w1, w2, lever, tilted=false, extend_back=tiny()){
    // A solid object that's big enough to give clearance for an actuator
    c = tiny(); //additional clearance (makes it angular)
    w_n = 2*column_base_r + 2*c; // width of neck
    nut_y = tilted ? sqrt(lever*lever - h*h) : lever;
    tilt = tilted?-asin(h/lever):0;
    top_dy = tilted ? 0 : h*flex_a()+1;
    minkowski(){
        hull(){
            translate([-min(w1,w2)/2-c, -extend_back, -tiny()]) cube([min(w1,w2)+2*c,tiny(),h]);
            translate([-w1/2-c, 0, -tiny()]) cube([w1+2*c,tiny(),c]);
            translate([-w2/2-c, top_dy, h]) cube([w2+2*c,tiny(),c]);
            translate([-w_n/2, nut_y, -tiny()]) rotate([tilt,0,0]) cube([w_n, 2, 5 + lever*flex_a()+c+1.5]);

        }
        scale([1,1,1.5]) sphere(r=1.5, $fn=8);
    }
}

module flexure_anchor_cutout(h=999,w=999, extend_back=999){
    // A flexure anchor that is 999 wide and deep (for subtraction)
    // If we subtract this from an actuator_void, it leaves a good
    // solid chunk inside the actuator shroud for the actuator to
    // pivot around.
    intersection(){
        mirror([0,1,0]) hull() reflect([1,0,0]){
            translate([0,extend_back,h/2]) cube([999,tiny(),tiny()]);
            translate([0,0,flex_dims().z]) mirror([0,0,1]) cube(999);
        }

        cube([999,w,h],center=true);
    }
}

module actuator_shroud_shell(h, w1, w2, lever, tilted=false, extend_back=tiny(), ac_h=actuator_h, motor_lugs=motor_lugs){
    // A cover for an actuator as defined above.
    ns_h = ac_h + lever * flex_a() + 1.5; //internal height of nut seat
    nut_y = flex_dims().y + (tilted ? sqrt(lever*lever - h*h) : lever);
    tilt = tilted?-asin(h/lever):0;

    difference(){
        union(){
            minkowski(){
                actuator_void(h, w1, w2, lever, tilted, extend_back);
                //sphere(r=wall_t,$fn=8);
                cylinder(r=wall_t,$fn=16,h=0.8);
            }
            translate([0,nut_y,0]) screw_seat_shell(ns_h, tilt);
            translate([0,nut_y,0]) motor_lugs(ns_h, tilt);

        }
        mirror([0,0,1]) cylinder(r=999,h=999,$fn=8); //don't extend below ground
        translate([0,-extend_back,0]) rotate([90,0,0]) cylinder(r=999,h=999,$fn=8); //cut off at the end, so we don't go past the back and close it off
    }
}
module actuator_shroud_core(h, w1, w2, lever, tilted=false, extend_back=tiny(), ac_h=actuator_h, anchor=true, pushstick_h=pushstick.z+3){
    // The inside of a cover for an actuator as defined above.
    // It's split like this for ease of combining them together.
    ns_h = ac_h + lever * flex_a() + 1.5; //internal height of nut seat
    nut_y = flex_dims().y + (tilted ? sqrt(lever*lever - h*h) : lever);
    tilt = tilted?-asin(h/lever):0;

    difference(){
        actuator_void(h, w1, w2, lever, tilted, extend_back); //cut out so it's hollow
        if(tilted){ //make the void smaller so we get an anchor
            translate([0,0,h+flex_dims().z]) mirror([0,0,1]) flexure_anchor_cutout(h=2*(h-pushstick_h), extend_back=extend_back);
        }else{
            flexure_anchor_cutout(h=2*(h-pushstick_h), extend_back=extend_back);
        }
    }

    translate([0,nut_y,0]) nut_seat_void(ns_h, tilt); //cut out the nut seat
    // hole through which we can insert the nut
    translate([0,nut_y]) rotate([tilt,0,0])
            rotate(tilted ? 180 : 0)
            translate([-nut_slot.x/2-0.5,0,ac_h-nut_slot.z-nut_size-1.5])
            cube(nut_slot + [1,999,1]);
}

module actuator_shroud(h, w1, w2, lever, tilted=false, extend_back=tiny(), ac_h=actuator_h, anchor=true){
    difference(){
        actuator_shroud_shell(h, w1, w2, lever, tilted=tilted, extend_back=extend_back, ac_h=ac_h);
        actuator_shroud_core(h, w1, w2, lever, tilted=tilted, extend_back=extend_back, ac_h=ac_h, anchor=anchor);
    }
}
