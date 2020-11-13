/******************************************************************
*                                                                 *
* OpenFlexure Microscope: Riser to mount sample slightly higher   *
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


use <utilities.scad>;
use <main_body.scad>;
use <sample_clips.scad>;
use <main_body_transforms.scad>;
include <microscope_parameters.scad>;


sep = 26;
$fn=24;

slide = [75.8,25.8,1.0];



module slide_riser_base(h, thickness, y_space){
    difference(){
        
        xy_stage(h=thickness,on_buildplate=true);

        //angled cut-out for slide
        hull() translate([0,0,h]){
            translate([0,-slide[2],d/2]) cube([slide[0],slide[1],d], center=true);
            translate([0,999-slide[2],999+d/2]) cube([slide[0],slide[1],d], center=true);
        }
        //extra cutout on clip side
        translate([-999/2,0,h]) cube([999,slide[1]/2+y_space,999]);
        
        //cut-out for middle of slide (immersion oil, etc.)
        translate([-999/2,-slide[1]/2+2, h-2]) cube([999,slide[1]-4,999]);
    }
}


module slide_riser(h=.6, thickness=4){
    y_space = 1.5;
    clip_l = 30;
    clip_w = 7;
    clip_r = 12;
    // Distance clip overlaps with slide position.
    // This is reduced by the tilted cutout:
    clip_overlap = 5; 
    clip_y = clip_overlap+y_space;
    clip_angle_h = 1+h+slide[2];
    handle_end = 75;
    difference(){
        union(){
            difference(){
                union(){
                    slide_riser_base(h,thickness, y_space);
                    // This is the bar that froms the stationary handle.
                    // It is very long and will be cut down later.
                    translate([-999+30,slide[1]/2+y_space,0]) cube([999,9,12]);
                }

                //space for clip to push through
                translate([-slide[1]/2+2,0, -1]) cube([slide[1]-4,999,clip_w+3]);

                //counter bored mounting holesmounting holes
                each_leg() translate([0,-stage_hole_inset,0]){
                    cylinder(r=3/2*1.15,h=999,center=true);
                    translate([0,0,thickness+d])cylinder(r=3*1.15,h=999);
                } 
            }
            //Clip and handle
            translate([-clip_l+4,slide[1]/2+y_space,0]){
                difference(){
                    translate([0,0,clip_w/2])rotate([-90,0,0])rotate([0,0,-90]){
                            sample_clip([0,clip_l,-clip_y], w=clip_w, roc=clip_r);
                    }
                    translate([0,-clip_y+clip_angle_h,0])rotate([45,0,0])translate([clip_l,-5,0])cube([10,10,10], center=true);
                    
                }
                translate([-999+7,slide[1]/2+y_space+clip_r-2,0]) cube([999,9,7]);
            }
        }
        // cut off end of the super long handles
        translate([-999/2-handle_end,0,0])cube([999,999,999],center=true);
    }
}


h=.6;
slide_riser(h);

// Comment this back in to see slide position
// translate([0,0,h+slide[2]/2]) cube(slide,center=true);
