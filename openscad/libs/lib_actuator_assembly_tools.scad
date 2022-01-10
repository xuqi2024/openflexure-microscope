

use <./utilities.scad>
use <./libdict.scad>
use <./compact_nut_seat.scad>

$fn=16;
/**
* Height of the band insertion tool holder
*/
function holder_height() = 20;


/**
* The height to get the band over the actuator. This is the
* actuator height plus the diameter of the band cord.
*/
function height_over_actuator(params) = let(
    actuator_h = key_lookup("actuator_h", params)
) actuator_h +2;

module tool_handle_end_cross_section(){
    translate_x(-actuator_nut_slot_size().x/2){
        cube([actuator_nut_slot_size().x, tiny(), actuator_nut_slot_size().z]);
    }
}

/**
* This is the back of the nut tool handle. It has a rounded sloped shape
*/
module sloped_back_of_handle(w, h){
    radius = 1.5;
    translate([0, radius, radius]){
        rotate_x(-30){
            hull(){
                reflect_x(){
                    translate_x(w/2 - radius){
                        sphere(r=radius);
                        translate_z(h-2*radius){
                            sphere(r=radius);
                        }
                    }
                }
            }
        }
    }
}

module nut_tool_handle(length){
    //width of the handle
    w = actuator_nut_size()*1.1+4;

    difference(){
        sequential_hull(){
            sloped_back_of_handle(w, 8);
            translate([-w/2, 13, 0]){
                cube([w,tiny(),actuator_nut_slot_size().z]);
            }
            translate([-w/2, 16, 0]){
                cube([w,tiny(),actuator_nut_slot_size().z]);
            }
            translate_y(length){
                tool_handle_end_cross_section();
            }
        }
    }
}

module nut_tool_end(){
    // width and height of tool tip (needs to fit through the slot of size
    // actuator_nut_slot_size())
    w = actuator_nut_slot_size().x-0.6;
    h = actuator_nut_slot_size().z-0.7;
    l = 5+actuator_housing_xy_size().y/2+3;

    difference(){
        sequential_hull(){
            tool_handle_end_cross_section();
            translate([-w/2, 5, 0]){
                cube([w, tiny(), h]);
            }
            translate([-w/2, l, 0]){
                cube([w, tiny(), h]);
            }
        }

        //cut out for nut
        translate([0,l,-tiny()]){
            rotate(30){
                cylinder(r=actuator_nut_size()*1.15, h=999, $fn=6);
            }
        }
        //extra cylindrical cut out in the nut vertex
        translate([0,l-actuator_nut_size()*1.15+0.4,-tiny()]){
            cylinder(r=1,h=999,$fn=12);
        }
    }

}

module nut_tool(){

    handle_l = actuator_housing_xy_size().x/2+9; //length of handle part

    translate_y(-(handle_l-tiny())){
        nut_tool_handle(handle_l);
    }
    nut_tool_end();

}

function band_tool_arm_length(params) = let(
    foot_height = key_lookup("foot_height", params)
) height_over_actuator(params)+foot_height+holder_height();

module prong_frame(params){
    //Move the prongs out and tilt them slightly
    sparse_matrix_transform(xz=0.3, xt=1.9, yt=band_tool_arm_length(params)){
        children();
    }
}



/**
* The position of the bottom of the slot in the end of the band tool given
* in the frame of the prong.
*/
function blade_anchor_pos() = [0,-12,0];
function band_tool_end_support_t() = 0.5;
function band_tool_blade_w() = 1.5;

/**
* Creates points for the blades that support the band in the band tool
*/
module blade_point(pos, d1=band_tool_blade_w(), d2=band_tool_blade_w(), h=tiny()){
    union(){
        translate(blade_anchor_pos() + [0,0,pos.z]){
            cylinder(d=d1, h=h);
        }
        translate(pos){
            cylinder(d=d2, h=h);
        }
    }
}

/**
* Create the end of the band tool. This is the two blades and the support between them
*/
module band_tool_end(params, h){
    // the two "blades" that support the band either side of the hook actuator
    reflect_x(){
        prong_frame(params){
            sequential_hull(){
                blade_point([0,band_tool_blade_w(),0], h=band_tool_end_support_t());
                blade_point([0,0,h-1]);
                blade_point([0.3,0.5,h-tiny()],d2=2.1);
            }
        }
    }
    // the flat support that passes between the hook and the outside of the column
    hull(){
        reflect_x(){
            //bottom of the tip
            prong_frame(params){
                translate_y(band_tool_blade_w()){
                    cylinder(d=band_tool_blade_w(), h=band_tool_end_support_t());
                }
                translate(blade_anchor_pos()){
                    cylinder(d=band_tool_blade_w(), h=band_tool_end_support_t());
                }
            }
        }
    }
}

/**
* Create just the arm of the band tool. This does not yet had the end
*/
module band_tool_arm(params, h){
    hull(){
        reflect_x(){
            prong_frame(params){
                translate(blade_anchor_pos()){
                    repeat([0,10,0], 2){
                        cylinder(d=band_tool_blade_w(),h=h);
                    }
                }
            }
        }
        tool_handle_end_cross_section();
    }
}

/**
* Create the cut_out in the end of the band tool arm so that it supports
* blades and neatly slopes up to the handle
*/
module band_tool_end_cut_out(params, h){
    sloped_wall_pos = [band_tool_blade_w()-tiny(), 10, band_tool_end_support_t()-tiny()];
    hull(){
        reflect_x(){
            prong_frame(params){
                translate(blade_anchor_pos() + [-2.25,3,h]){
                    sphere(r=band_tool_blade_w());
                }

                translate(blade_anchor_pos() + sloped_wall_pos){
                    cube([band_tool_blade_w()/2,999,999]);
                }
            }
        }
    }
}

/**
* Create one full arm of the band tool including the end
*/
module band_tool_arm_with_end(params, h){
    band_tool_end(params, h);
    // connect the  end of the tool to the handle
    difference(){
        band_tool_arm(params, h);
        band_tool_end_cut_out(params, h);
    }

}

/**
* Create the centre block in the middle of the band tool
*/
module band_tool_centre_block(roc, flex_t, middle_w){
    //thicker middle part to support the two ends

    bottom_size = [actuator_nut_slot_size().x, middle_w, tiny()];
    top_size = [actuator_nut_slot_size().x, middle_w+2*(roc-0.5), tiny()];

    hull(){
        translate_z(flex_t-tiny()){
            cube(bottom_size, center=true);
        }
        translate_z(roc){
            cube(top_size, center=true);
        }
    }
}

/**
* Create the band tool already bent into shape.
* Instead of callin this module you can call band_tool(params, bent=true); to
* for all the parameters to be calculated the same way as for the tool
* as printed.
*/
module _bent_band_tool(params, h, roc, flex_t, flex_l, middle_w){

    // We make two tools, spaced out by a flexible joiner
    reflect_y(){
        translate([0, middle_w/2+flex_l+roc-3, roc]){
            rotate_x(90){
                band_tool_arm_with_end(params, h);
            }
        }
    }
    //Bent section of the links
    reflect_y(){
        translate([0,middle_w/2,roc]){
            difference(){
                rotate_y(90){
                    cylinder(r=roc,h=actuator_nut_slot_size().x,center=true);
                }
                rotate_y(90){
                    cylinder(r=roc-flex_t,h=99,center=true);
                }
                translate([-99,-99,0]){
                    cube(999);
                }
                translate([-99,-999,-99]){
                    cube(999);
                }
            }
        }
    }
    //bottom of the link.
    translate_z(flex_t/2){
        cube([actuator_nut_slot_size().x,middle_w+2*tiny(),flex_t],center=true);
    }
    band_tool_centre_block(roc, flex_t, middle_w);
}


/**
* Create the band tool for inserting the viton o-ring.
*/
module band_tool(params, bent=false){

    //overall height of the band insertion tool
    h = 4;
    //Radius of curvature of the flexible linkers when bent
    roc=2;
    // Thickness of the flexible linkers
    flex_t = 0.5;
    //length of the flexible linkers
    flex_l = roc*PI/2;
    //width of the band anchor on the foot
    middle_w = 2*column_base_radius()+1.5+2*(h-roc)+flex_t;

    if (bent){
        _bent_band_tool(params, h, roc, flex_t, flex_l, middle_w);
    }
    else{

        // We make two tools, spaced out by a flexible joiner
        reflect_y(){
            translate_y(middle_w/2+flex_l){
                band_tool_arm_with_end(params, h);
            }
        }
        //flexible links between the two tools and the middle part
        translate_z(flex_t/2){
            cube([actuator_nut_slot_size().x,middle_w+2*flex_l+2*tiny(),flex_t],center=true);
        }
        band_tool_centre_block(roc, flex_t, middle_w);
    }
}



module band_tool_holder(params){
    holder_offset = 1.7;
    //the holder is built from the difference between two minkowski sums of the band insertion tool
    translate ([0,0,holder_offset]){
        difference(){
            minkowski(){
                hull(){
                    band_tool(params, bent=true);
                }
                scale ([0.7,1,1]){
                    sphere(r = holder_offset);
                }
            }
            union(){
                minkowski(){
                    hull(){
                        band_tool(params, bent=true);
                    }
                    scale ([0.7,1,1]){
                        sphere(r = holder_offset-0.8);
                    }
                }
                translate ([-999/2,-999/2,holder_height()]){
                    cube([999,999,999], center = false);
                }
            }
        }
    }
}