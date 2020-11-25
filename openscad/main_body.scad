/******************************************************************
*                                                                 *
* OpenFlexure Microscope: Microscope body                         *
*                                                                 *
* This is the chassis of the OpenFlexure microscope, an open      *
* microscope and 3-axis translation stage.  It gets really good   *
* precision over a ~10mm range, by using plastic flexure          *
* mechanisms.                                                     *
*                                                                 *
* (c) Richard Bowman, January 2016                                *
* Released under the CERN Open Hardware License                   *
*                                                                 *
******************************************************************/

use <./utilities.scad>
use <./compact_nut_seat.scad>
use <./logo.scad>
use <./z_axis.scad>
use <./wall.scad>
use <./main_body_transforms.scad>
use <./reflection_illuminator.scad>
include <./microscope_parameters.scad> //All the geometric variables are now in here.


module leg_flexures(brace){
    // These are the flexures on the top and bottom of the leg that connect the
    // two vertical bars together.
    //
    // `brace` sets the distance to widen the block at the bottom of the leg
    //  two flexures are prodcued offset by brace. Therefore
    //  * if brace=0 there is one normal sized flexure.
    //  * if brace=flex_dims().x there is one double width fexure
    //  * if brace>flex_dims().x there are two seperare flexures

    block_size = [leg_middle_w, leg_dims().y, leg_block_t];
    flex_size = [leg_outer_w, leg_dims().y, flex_dims().z];

    for (i = [0,1]){
        z_pos=[flex_z1, flex_z2][i];
        brace_pos= [brace, 0][i];
        translate([0,0,z_pos]){
            //Hull two blocks to make a big one
            hull(){
                repeat([0,brace_pos,0],2){
                    translate([-block_size.x/2,0,0]){
                        cube(block_size);
                    }
                }
            }
            //Repeat two flexures may be seperate depending on brace.
            repeat([0,brace_pos,0],2){
                translate([-flex_size.x/2,0,0]){
                    cube(flex_size);
                }
            }
        }
    }

}

module leg(brace=flex_dims().x){
    // The legs support the stage - this is either used directly
    // or via "actuator" to make the legs with levers
    fw=flex_dims().x;

	union(){
       	//leg
		reflect([1,0,0]){
			//vertical bars of the leg
			translate([leg_middle_w/2+flex_dims().y,0,0]){
                hull(){
                    cube(leg_dims());
                    //extend the base to make the bars triangular
                    cube([leg_dims().x, fw+brace ,tiny()]);
                }
            }
		}
        leg_flexures(brace);

		//thin links between legs
        flex_sep = flex_z2-flex_z1;
        n = floor(flex_sep/leg_link_spacing);
		if(n > 2){
            // adjust spacing so it is even
			link_space_adj = flex_sep/n;
			translate([0, leg_dims().y/2, flex_z1+link_space_adj])
                repeat([0, 0, link_space_adj], n-1)
                    cube([leg_outer_w,2,0.5],center=true);
		}
	}
}

module actuator(){
    // A leg that supports the stage, plus a lever to tilt it.
    // No longer includes the flexible nut seat actuating column.
    // TODO: find the code that unifies this with leg()
	brace=20;
    fw=flex_dims().x;
    w = actuator.x;
    union(){
        leg(brace=brace);

		//arm (horizontal bit)
		difference(){
            sequential_hull(){
                translate([-leg_middle_w/2,0,0]) cube([leg_middle_w,brace+fw,4]);
                translate([-w/2,0,0]) cube([w,brace+fw+0,actuator.z]);
                translate([-w/2,0,0]) cube(actuator);
            }
            //don't foul the actuator column
            translate([0,actuating_nut_r,0]) actuator_end_cutout();
        }

	}
}

module actuator_silhouette(h=999){
    // This defines the cut-out from the base structure for the XY
    // actuators.
    linear_extrude(2*h,center=true) minkowski(){
        circle(r=flex_dims().y,$fn=12);
        projection() actuator();
    }
}

module mounting_hole_lugs(holes=true){
    // lugs either side of the XY table to bolt the microscope down
    // these are to mount onto the baseplate

    //Just get one lug hole and then reflect the lug.
    hole_pos = base_mounting_holes("lugs").x;
    reflect([1,0,0]){
        difference(){
            //the lug
            hull(){
                translate([z_flexure_x,0,0]) rotate(-120) cube([10,tiny(),10]);
                translate(hole_pos) cylinder(r=4*1.1,h=3);
            }
            //the lug hole
            if (holes) translate(hole_pos) {
                cylinder(r=3/2*1.1,h=50,center=true);
                translate([0,0,3]) cylinder(r=3*1.1, h=22);
            }
        }
    }
}

module xy_limit_switch_mount(d=3.3*2, h=6){
    // A mount for the XY limit switch (M3)
    leg_frame(45) translate([-9, -flex_dims().y-zawall_h*sin(6)-3.3+1, zawall_h-6]) cylinder(d=d,h=h);
}


// The "wall" that forms most of the microscope's structure
module wall_inside_xy_stage(){

    // First, go around the inside of the legs, under the stage.
    // This starts at the Z nut seat.  I've split it into two
    // blocks, because the shape is not convex so the base
    // would be bigger than the walls otherwise.
    reflect([1,0,0]) sequential_hull(){
        mirror([1,0,0]) z_bridge_wall_vertex();
        z_bridge_wall_vertex();
        inner_wall_vertex(45, -leg_outer_w/2, zawall_h);
        z_anchor_wall_vertex();
        inner_wall_vertex(135, leg_outer_w/2, zawall_h);
        //The wall that has the reflection illumination cut-out is double thickness
        // to improve stiffness
        inner_wall_vertex(135, -(leg_outer_w/2-wall_t/2), zawall_h, thick=true);
        inner_wall_vertex(-135, leg_outer_w/2-wall_t/2, zawall_h, thick=true);

    };

}

module wall_outside_xy_actuators(){
    // Add the wall from the XY actuator column to the middle
    sequential_hull(){
        z_anchor_wall_vertex(); // join at the Z anchor
        // [nb this is no longer actually the z anchor since the new z axis]
        // anchor at the same angle on the actuator
        // NB the base of the wall is outside the
        // base of the screw seat
        leg_frame(45) translate([-ss_outer().x/2+wall_t/2,actuating_nut_r,0]){
            rotate(-45) wall_vertex(y_tilt=atan(wall_t/zawall_h));
        }
    }
}

module wall_inside_xy_actuators(){
    // Connect the Z anchor to the XY actuators
    hull(){
        translate([-(z_anchor_w/2+wall_t/2+1), z_anchor_y + 1, 0])
                     wall_vertex();
        y_actuator_wall_vertex();
    }
}

module wall_between_actuators(){
    // link the actuators together
    hull(){
        y_actuator_wall_vertex();
        translate([0,z_nut_y+ss_outer().y/2-wall_t/2,0]) wall_vertex();
    }
}

module reflection_illuminator_cutout(){
    // The shape for a hole in the main body for the reflection illuminator to poke through.

    //
    top_cutout_w = 17.8;
    mid_cutout_w = illuminator_width() + 1;
    bottom_cutout_w = illuminator_width() + 4;

    // Create a trapezoidal shape with width=top_cutout_w at the top.
    // This is the widest cutout we cab make at height 'wall_h' without the bridge
    // having a corner in it.
    hull() {
        translate([-(bottom_cutout_w)/2, -49, -0.5]){
            cube([bottom_cutout_w, 49, 1]);
        }
        translate([-(mid_cutout_w)/2, -49, 10]){
            cube([mid_cutout_w, 49, 1]);
        }
        translate([-top_cutout_w/2, -49, wall_h]){
            cube([top_cutout_w, 49, 1]);
        }
    }
}

module xy_stage(h=10,on_buildplate=false){
    // This module is the outer shape of the XY stage.
    // A square without corners, and a hole through middle.
    // The size in XY is set by microscope_parameters.scad,
    // the thickness (z) is set by input h
    // The boolean value on_buildplate sets wether the stage is printed on the
    // buildplate. If true, the bottom is flat, if false the bottom is made from
    // bridges round the edge, that then work inwards.

    side_length = leg_middle_w+2*flex_dims().y;
    cut_out_side_length = leg_middle_w-2*flex_dims().x;
    thickness = on_buildplate?h:h-1;
    z = on_buildplate?0:1;

    difference(){
        hull(){
            each_leg(){
                translate([0,-flex_dims().y-tiny(),z+thickness/2]){
                    cube([side_length,2*tiny(),thickness],center=true);
                }
            }
        }
        // Cuts out the hole in the stage, starting from a square.
        if (on_buildplate){
            //Normal hole if being printed on build plate
            cylinder(r=hole_r,h=999,center=true,$fn=32);
        }
        else{
            // If being printed in the in the air it needs a series of bridges to
            // be printed.
            intersection(){
                // hole_from_bottom() is used to create a cylinder which starts
                // as a square, then and octagon, doubling in number of side until
                // "circular"
                translate([0,0,1]){
                    rotate(45){
                        hole_from_bottom(hole_r,h=999);
                    }
                }
                //The hole is intersected with this cube so the area above the
                //Top x-y flexures is not cut out
                hull(){
                    each_leg(){
                        cube([cut_out_side_length,tiny(),999],center=true);
                    }
                }
            }
        }
	}
}


module xy_legs_and_actuators(){
    // This is the xy_actuators including the casing and all 4 legs

    // back legs
	reflect([1,0,0]) leg_frame(135) leg();
    //front legs and actuator columns
    each_actuator(){
        //actuator is the leg bat to connect to the flexure at the bottom of the column
        actuator();
		translate([0,actuating_nut_r,0])
            actuator_column(h=actuator_h, join_to_casing=true);
    }

	for(i = [0,1]){
        label = ["X","Y"][i];
        angle = [-45,45][i];
        leg_frame(angle){
            translate([0,actuating_nut_r,0]){
                screw_seat(h=actuator_h,
                           travel=xy_actuator_travel,
                           motor_lugs=motor_lugs,
                           extra_entry_h=actuator.z+2,
                           label=label);
            }
        }
    }
}

module internal_xy_structure(){

    difference() {
        add_hull_base(base_t) wall_inside_xy_stage();
        central_optics_cut_out();
        // Cut-out for reflection optics
        reflection_illuminator_cutout();
    }
    //mounts for the optical endstops for X and
    reflect([1,0,0]) hull(){
        inner_wall_vertex(45, -9, zawall_h);
        xy_limit_switch_mount();
    }
    //lugs to bolt the microscope down to base
    mounting_hole_lugs();
}

module xy_stage_with_nut_traps()
{
    //This is the microscope xy-stage built at the correct height
    //and including the nut traps.
    difference(){
		translate([0,0,flex_z2]) xy_stage(h=stage_t);
		each_leg(){
            translate([0,-stage_hole_inset,leg_height]){
                m3_nut_trap_with_shaft(0,0); //mounting holes
            }
        }
	}
}

module xy_flexures(){

    //Bottom flexures: flexures between legs and inner walls
    w=flex_dims().x;
    //The flexure length, increased for some overlap
    flex_len = flex_dims().y + wall_t/2;
    each_leg(){
        reflect([1,0,0]){
            translate([leg_middle_w/2-w, 0, flex_z1+0.5]){
                //Each flexure is the hull of two offset cuboids.
                hull(){
                    repeat([flex_len,-flex_len,0],2){
                        cube([w, tiny(), flex_dims().z]);
                    }
                }
            }
        }
    }

    // Top flexures: flexures between legs and stage
    // NOTE: these connect the legs together, and pass all the way under the stage.
    // This is important! If they get cut then the bridges will fail!
	difference(){
        //Make a truncated square with a truncated "corner" at each leg
		hull() each_leg(){
            translate([0,0,flex_z2+flex_dims().z/2+0.5])
                cube([leg_middle_w,tiny(),flex_dims().z],center=true);
        }
        //chop out a smaller truncated square
		hull() each_leg(){
            cube([leg_middle_w-2*flex_dims().x,tiny(),999],center=true);
        }
	}
}

module xy_leg_ties(){
    // Small ties that connect the legs to the walls of the structure to stop the
    // legs moving during printing. These muse be cut after printing.

    z_tr = wall_h*0.7;
    // Note that the walls slope in by 6 degrees so must compensate tie length
    tie_length = flex_dims().y + z_tr*tan(6) + 2;
    x_tr = leg_middle_w/2+flex_dims().y+flex_dims().x/2;
    y_tr = 1-tie_length;

    reflect([1,0,0]){
        leg_frame(135){
            reflect([1,0,0]){
                translate([x_tr, y_tr, z_tr]){
                    cube([1, tie_length, 0.5]);
                }
            }
        }
    }
}

module xy_positioning_system(){
    // This module creates the main XY positioning mechanism. Including the actuator columns.

	xy_legs_and_actuators();
    internal_xy_structure();
    xy_stage_with_nut_traps();

	// Connect the legs to the stage and structure with flexures
	xy_flexures();

    //tie the legs to the wall to stop movement during printing
    xy_leg_ties();
}

module central_optics_cut_out() {
    // Central cut-out for optics
    sequential_hull(){
        h=base_t*3;
        translate([0,z_flexure_x+1.5-14/2,0]){
            cube([14,2*tiny(),h],center=true);
        }
        cube([2*(z_flexure_x-flex_dims().x),1,h],center=true);
        translate([0,8-(z_flexure_x-flex_dims().x-tiny()),0]){
            cube([16,2*tiny(),h],center=true);
        }
    }
}

module xy_actuator_cut_outs(){
    each_actuator(){
        actuator_silhouette(xy_actuator_travel+actuator.z);
        translate([0,actuating_nut_r,0]){
            screw_seat_outline(h=999,adjustment=-tiny(),center=true);
        }
    }
}


module actuator_walls_and_z_casing(z_axis=true){
    // These are the wall that link the actuators. And the casing for the
    // z-axis. This casing includes the mount for the illumination dovetail.
    difference(){
        add_hull_base(base_t) {
            //link the XY actuators to the wall
            if (z_axis) reflect([1,0,0]) wall_inside_xy_actuators();
            reflect([1,0,0]) wall_outside_xy_actuators();
            reflect([1,0,0]) wall_between_actuators();
             // outer profile of casing and anchor for the z axis
            if (z_axis) z_axis_casing(condenser_mount=true);
        }
        //This also cuts the walls hence why it is two objects
        if (z_axis)z_axis_casing_cutouts();
        xy_actuator_cut_outs();
        central_optics_cut_out();
    }
}

module body_logos(message){
    // The openflexure and opehardware logos. Plus a customisable message.
    size = 0.25;
    place_on_wall() translate([9,wall_h-2-15*size,-0.5])
        scale([size,size,10]) openflexure_logo();

    mirror([1,0,0]) place_on_wall() translate([8,wall_h-2-15*size,-0.5])
        scale([size,size,10]) oshw_logo_and_text(message);
}

module xy_only_body(){
    // This is a version of the body with only xy actuators. It is not used in the microscope
    // but can be useful for other positioning systems.
    xy_positioning_system();
    difference(){
        actuator_walls_and_z_casing(z_axis=false);
        body_logos("xy-only");
    }
}

module main_body(){
    // This module represents the main body of the microscope, including the positioning mechanism.

    xy_positioning_system();
	//z axis - Only the actuator column is housed at this point
    z_actuator_assembly();

	difference(){
        actuator_walls_and_z_casing();
        //front mounting holes
        for(hole_pos=base_mounting_holes("front"))
             translate(hole_pos) cylinder(r=3/2*1.1,h=50,center=true);
        body_logos(version_numstring);
	}
}


// If this file is "included" rather than "used", render the main body.
exterior_brim(r=enable_smart_brim ? smart_brim_r : 0){
    main_body();
}

