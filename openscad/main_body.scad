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

use <./utilities.scad>;
use <./compact_nut_seat.scad>;
use <./logo.scad>;
use <./z_axis.scad>;
use <./wall.scad>;
use <./main_body_transforms.scad>;
use <./reflection_illuminator.scad>;
include <./microscope_parameters.scad>; //All the geometric variables are now in here.


module leg(brace=flex_dims()[0]){
    // The legs support the stage - this is either used directly
    // or via "actuator" to make the legs with levers
    fw=flex_dims()[0];
    
	union(){
       	//leg
		reflect([1,0,0]){
			//vertical legs
			translate([leg_middle_w/2+flex_dims()[1],0,0]) hull(){
				cube(leg_dims());
				cube([leg_dims()[0],fw+brace,tiny()]); //extend it to be a triangle
			}

            //flexure bridges between the legs
            zs = [flex_z1, flex_z2]; //heights of bridges between legs
            bs = [brace, 0]; //"brace positions" - a nonzero value here
                             //widens the leg, and adds another flexure
                             //at the new position.  bs[i]=fw will double
                             //the width of the flexure, while a larger 
                             //value produces two distinct flexures.
			for(i=[0,1]) translate([0,0,zs[i]]){
				translate([-tiny(),0,0]) hull() repeat([0,bs[i],0],2) //solid part
                        cube([leg_middle_w/2+tiny(),leg_dims()[1],leg_block_t-0.2*leg_dims()[1]]);
				translate([-tiny(),0,0]) repeat([0,bs[i],0],2) //flexures
                        cube([leg_middle_w/2+flex_dims()[1]+leg_dims()[0],leg_dims()[1],flex_dims()[2]]);
			}
		}
        
		//thin links between legs
		if(flex_z2-flex_z1 > 2*bridge_dz){
			n=floor((flex_z2-flex_z1)/bridge_dz);
			dz=(flex_z2-flex_z1)/n;
			translate([0,leg_dims()[1]/2,flex_z1+dz]) repeat([0,0,dz],n-1) cube([leg_outer_w,2,0.5],center=true);
		}
	}
}
module actuator(){
    // A leg that supports the stage, plus a lever to tilt it.
    // No longer includes the flexible nut seat actuating column.
    // TODO: find the code that unifies this with leg()
	brace=20;
    fw=flex_dims()[0];
    w = actuator[0];
    union(){
        leg(brace=brace);

		//arm (horizontal bit)
		difference(){
            sequential_hull(){
                translate([-leg_middle_w/2,0,0]) cube([leg_middle_w,brace+fw,4]);
                translate([-w/2,0,0]) cube([w,brace+fw+0,actuator[2]]);
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
        circle(r=flex_dims()[1],$fn=12);
        projection() actuator();
    }
}

module mounting_hole_lugs(){
    // lugs either side of the XY table to bolt the microscope down
    //these are to mount onto the baseplate 
    for(p=base_mounting_holes) {
        if(p[1]<0 && p[0]>0) reflect([1,0,0]) hull(){
            translate([z_flexure_x,0,0]) rotate(-120) cube([10,tiny(),10]);
            translate(p) cylinder(r=4*1.1,h=3);
        }
    }
}

module xy_limit_switch_mount(d=3.3*2, h=6){
    // A mount for the XY limit switch (M3)
    leg_frame(45) translate([-9, -flex_dims()[1]-zawall_h*sin(6)-3.3+1, zawall_h-6]) cylinder(d=d,h=h);
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
        leg_frame(45) translate([-ss_outer()[0]/2+wall_t/2,actuating_nut_r,0]){
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
        translate([0,z_nut_y+ss_outer()[1]/2-wall_t/2,0]) wall_vertex();
    }
}

// Cut out hole for reflection illuminator
module fl_cube_cutout(){
    // size of cutout for fl cube
    top_cutout_w = 17.8; // As big as we can get at height 'wall_h' without bridging a corner
    mid_cutout_w = illuminator_width() + 1;
    bottom_cutout_w = illuminator_width() + 4;

    // Create a trapezoid with min width (cube_width) at top
    hull() {
        translate([-(bottom_cutout_w)/2, -49, -0.5]) cube([bottom_cutout_w, 49, 1]);
        translate([-(mid_cutout_w)/2, -49, 10]) cube([mid_cutout_w, 49, 1]); // Highest we usually need
        translate([-top_cutout_w/2, -49, wall_h]) cube([top_cutout_w, 49, 1]);
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
    difference(){
        side_length = leg_middle_w+2*flex_dims()[1];
        cut_out_side_length = leg_middle_w-2*flex_dims()[0];
        thickness = on_buildplate?h:h-1;
        z = on_buildplate?0:1;
		hull() each_leg() translate([0,-flex_dims()[1]-tiny(),z+thickness/2]) cube([side_length,2*tiny(),thickness],center=true);
        if (on_buildplate){
            cylinder(r=hole_r,h=999,center=true,$fn=32);
        }else{
            intersection(){
                // This cuts out the hole in the stage, starting from a square.
                // The intersection restricts it to the space between the bridges, to avoid any
                // holes in the sides of the stage.
                translate([0,0,1]) rotate(45) hole_from_bottom(hole_r,h=999);
                hull() each_leg() cube([cut_out_side_length,tiny(),999],center=true);
            }
        }
	}
}


///////////////////// MAIN STRUCTURE STARTS HERE ///////////////
module xy_positioning_system() {
    // This module represents the main body of the microscope, including the positioning mechanism.

	//legs (incl. actuators)
	reflect([1,0,0]) leg_frame(135) leg();
	each_actuator(){
        actuator();
		translate([0,actuating_nut_r,0]) actuator_column(h=actuator_h, join_to_casing=true);
    }
	//Actuator housings (screw seats and motor mounts)
    xy_labels=["X","Y"];
    xy_angles=[-45,45];
	for(i=[0:1]) leg_frame(xy_angles[i]) translate([0,actuating_nut_r,0]){
        screw_seat(h=actuator_h, travel=xy_actuator_travel, motor_lugs=motor_lugs, extra_entry_h=actuator[2]+2, label=xy_labels[i]);
    }
	//flexures connecting bottoms of legs to centre
	each_leg() reflect([1,0,0]) translate([0,0,flex_z1]){
        w=flex_dims()[0];
        translate([leg_middle_w/2-w,0,0.5]) hull()
			repeat([1,-1,0]*(flex_dims()[1]+wall_t/2),2) cube([w,tiny(),flex_dims()[2]]);
    }
    //tie the legs to the wall (built later) during printing
    reflect([1,0,0]) leg_frame(135) reflect([1,0,0]) {
        translate([leg_middle_w/2+flex_dims()[1]+flex_dims()[0]/2, -wall_h*0.7*tan(6)-1-flex_dims()[1], wall_h*0.7]) cube([1, wall_h*0.7*tan(6)+2+flex_dims()[1], 0.5]);
    }

	// flexures between legs and stage
    // NB these connect the legs together, and pass all the way under the stage.  This
    // is important, if they get cut then the bridges will fail!
	difference(){
		hull() each_leg() translate([0,0,flex_z2+flex_dims()[2]/2+0.5]) cube([leg_middle_w,tiny(),flex_dims()[2]],center=true);
		hull() each_leg() cube([leg_middle_w-2*flex_dims()[0],tiny(),999],center=true);
	}

	// XY stage
	difference(){
		translate([0,0,flex_z2]) xy_stage(h=stage_t);
		each_leg() translate([0,-stage_hole_inset,leg_height]) m3_nut_trap_with_shaft(0,0); //mounting holes
	}
    ////////////// Reinforcing wall and base /////////////////
    //Add_hull_base generates the flat base of the structure.
    difference() {
        add_hull_base(base_t) wall_inside_xy_stage();
        central_optics_cut_out();
        // Cut-out for reflection optics
        fl_cube_cutout();
    }

    // add mounts for the optical endstops for X and Y
    reflect([1,0,0]) hull(){
        inner_wall_vertex(45, -9, zawall_h);
        xy_limit_switch_mount();
    }
}

module central_optics_cut_out() {
    // Central cut-out for optics
    intersection(){
        sequential_hull(){
            h=999;
            translate([0,z_flexure_x+1.5-14/2,0]) cube([14,2*tiny(),h],center=true);
            translate([0,0,0]) cube([2*(z_flexure_x-flex_dims()[0]),1,h],center=true);
            translate([0,8-(z_flexure_x-flex_dims()[0]-tiny()),0]) cube([16,2*tiny(),h],center=true);
        }
        // Limit the height so it slopes up gently to allow for
        // actuator travel, etc.
        sequential_hull(){
            translate([0,-999,0]) cube([999,tiny(),z_strut_t+1]*2,center=true);
            cube([999,tiny(),z_strut_t+1]*2,center=true);
            translate([0,z_nut_y,0]) cube([999,tiny(),z_strut_t+z_actuator_travel+1]*2,center=true);
        }
    }
}

module main_body(){
// This module represents the main body of the microscope, including the positioning mechanism.

	//z axis
    z_axis_flexures();
    z_axis_struts();
    objective_mount();
    z_actuator_column();
    difference(){
        z_actuator_housing();
        z_axis_clearance(); //make sure the actuator can get in ok!
    }

    xy_positioning_system();

	//base
	difference(){
		union(){
            add_hull_base(base_t) {
                // Next, link the XY actuators to the wall
                reflect([1,0,0]) wall_inside_xy_actuators();
                z_axis_casing(condenser_mount=true); //casing and anchor for the z axis
                reflect([1,0,0]) wall_outside_xy_actuators();
                reflect([1,0,0]) wall_between_actuators();
                // add a small object to make sure the base is big enough
                wall_vertex(h=base_t);
            }
            mounting_hole_lugs(); //lugs to bolt the microscope down
		}

        //////  Things we need to cut out holes for... ///////////

        // XY actuator cut-outs
		each_actuator(){
			actuator_silhouette(xy_actuator_travel+actuator[2]);
			translate([0,actuating_nut_r,0]) screw_seat_outline(h=999,adjustment=-tiny(),center=true);
		}
		// Cut-outs for the Z axis
		z_axis_casing_cutouts();

        central_optics_cut_out();

        //post mounting holes (2 near z actuator, 2 in mounting lugs)
        for(p=base_mounting_holes) translate(p){ 
             cylinder(r=3/2*1.1,h=50,center=true); 
             translate([0,0,3]) cylinder(r=3*1.1, h=22); 
        }

        //////////////// logo and version string /////////////////////
        size = 0.25;
        place_on_wall() translate([9,wall_h-2-15*size,-0.5]) 
        scale([size,size,10]) openflexure_logo();

        mirror([1,0,0]) place_on_wall() translate([8,wall_h-2-15*size,-0.5]) 
        scale([size,size,10]) oshw_logo_and_text(version_numstring);
	} ///////// End of things to chop out of base/walls ///////
}


// If this file is "included" rather than "used", render the main body.
exterior_brim(r=enable_smart_brim ? smart_brim_r : 0){
    main_body();
}

