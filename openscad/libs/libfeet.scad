/******************************************************************
*                                                                 *
* OpenFlexure Microscope: Microscope Feet                         *
*                                                                 *
* This file generates the feet for the microscope                 *
*                                                                 *
* Each foot sits under one actuator column, and clips in with     *
* lugs either side.  They have hooks in the bottom to hold the    *
* elastic bands and stops to limit the lower travel of the stage. *
*                                                                 *
* (c) Richard Bowman, January 2017                                *
* Released under the CERN Open Hardware License                   *
*                                                                 *
* http://www.github.com/rwb27/openflexure_microscope              *
* http://www.docubricks.com/projects/openflexure-microscope       *
* http://www.waterscope.org                                       *
*                                                                 *
******************************************************************/

use <./microscope_parameters.scad>
use <./utilities.scad>
use <./libdict.scad>
use <./compact_nut_seat.scad>

module foot_ground_plane(tilt=0, top=0, bottom=-999){
    //This represents where the ground would be, given that the
    //foot is usually printed tilted, pivoting around it's +y edge
    //As printed, the ground plane is the print bed, i.e. z=0
    //However, the foot is used in a different orientation, tilted
    //around the outer edge (so the microscope sits on the outer
    //edges of the feet).
    //NB top and bottom refer to distances in the model frame, so
    //they will be slightly smaller Z shifts in the printer frame.
    //top or bottom=0 places the plane on the print bed, which is
    // z=l/2*tan(tilt) in the foot frame (as it's tilted about one
    // corner).
    translate_z(bottom){
        skew_flat(tilt, true){
            cylinder(r=999,h=top-bottom,$fn=8);
        }
    }
}
module skew_flat(tilt, shift=false){
    // This transformation skews a plane so it's parallel to the print bed, in
    // the foot (which has been rotated by an angle `tilt`).  Z coordinates are
    // unchanged by this transform; it's a skew **not** a rotation.
    // if shift is true, move things up so that z=0 corresponds to the print
    // bed.  Otherwise, z=0 is below the bottom of the foot (because z=0 is
    // touched by the edge of the foot in the unskewed frame - and the skew will
    // move that side of the model downwards.  It's all because we rotate the
    // model about the corner, rather than the centre...
    l = actuator_housing_xy_size().y;
    z_shift = shift ? l/2*tan(tilt) : 0;

    skew_matrix = [[1, 0, 0, 0],
                   [0, 1, 0, 0],
                   [0, tan(-tilt), 1, z_shift],
                   [0, 0, 0, 1]];

    multmatrix(skew_matrix){
        children();
    }
}


module filleted_bridge(gap, roc_xy=2, roc_xz=2){
    // This can be subtracted from a structure of width gap.x to form
    // a hole in the bottom of the object with rounded edges.
    // It's used here to smooth the band anchor to avoid damaging the bands.
    w = gap.x;
    b = gap.y;
    h = gap.z;
    x1 = w/2 - roc_xy;
    x2 = w/2 - roc_xz;
    y1 = b/2 + roc_xy;
    difference(){
        translate(-zero_z(gap)/2 -[0,roc_xy,999]){
            cube(gap + [0,2*roc_xy,roc_xz] + [0,0,999]);
        }
        reflect_y(){
            sequential_hull(){
                reflect_x(){
                    translate([x1, y1, -999]){
                        cylinder(r=roc_xy, h=tiny());
                    }
                }
                reflect_x(){
                    translate([x1, y1, 0]){
                        cylinder(r=roc_xy, h=h+roc_xz);
                    }
                }
                reflect_x(){
                    translate([x2, b/2, h+roc_xz]){
                        rotate_x(-90){
                            cylinder(r=roc_xz, h=tiny());
                        }
                    }
                }
                reflect_x(){
                    translate([x2, -2*tiny(), h+roc_xz]){
                        rotate_x(90){
                            cylinder(r=roc_xz ,h=tiny());
                        }
                    }
                }
            }
        }
    }
}
module thick_section(h=tiny(), center=false, shift=true){
    // A 3D object, corresponding to the linearly-extruded projection of another object.
    linear_extrude(h, center=center){
        projection(cut=true){
            translate_z(shift ? -tiny() : 0){
                children();
            }
        }
    }
}
module offset_thick_section(h=tiny(), offset=0, center=false, shift=true){
    // A 3D object, corresponding to the linearly-extruded projection of another object. Cut a tiny distance above z=0
    linear_extrude(h, center=center){
        offset(r=offset){
            projection(cut=true){
                translate_z(shift ? -tiny() : 0){
                    children();
                }
            }
        }
    }
}


//TODO think of a less confusing name for this!!!!!!
// This is used to create long tilted extrusions where the bottom of the section may have a different angle
// This module takes a child module, cuts it a tiny bit above z=0. This cut is extruded along the angle of the foot
// Only a section of this is returned which extends from the input `z` up by a hight h. The angle this section is cut
// can be tilted independently  by `section_angle`.
module foot_section(foot_angle=0,    //the angle the actuator column makes with the Z axis
                    section_angle=0, //the angle between the section and the XY plane
                    offset=0,        //grow the section by this much in XY plane
                    h=tiny(),        //thickness
                    z=0){
    assert(h<=999, "Maximum h for foot section is 999");
    intersection(){
        translate_z(z){
            rotate_x(section_angle){
                cube([999,999,h],center=true);
            }
        }
        rotate_x(foot_angle){
            // This is set to 1000 so that numbers up to 999 can be put into h
            offset_thick_section(h=1000, center=true, offset=offset){
                children();
            }
        }
    }
}

module foot_letter(letter="", actuator_tilt=0, h=10, base_cleareance=2){
    //To add a letter to the side of the foot.
    //For letters that got below the line, base clearance may need increasing

    //Calculate the y and z position in the tilted frame
    y_tr_tilted_frame = actuator_housing_xy_size().y/2-.5;
    z_tr_tilted_frame = -y_tr_tilted_frame*tan(actuator_tilt) + h/2 + base_cleareance;

    // y and z position in the untilted frame
    y_tr = y_tr_tilted_frame*cos(actuator_tilt)-z_tr_tilted_frame*sin(actuator_tilt);
    z_tr = y_tr_tilted_frame*sin(actuator_tilt)+z_tr_tilted_frame*cos(actuator_tilt);

    translate([0, y_tr, z_tr]){
        rotate_x(actuator_tilt){
            rotate_z(180){
                rotate_x(90){
                    translate([-h/2,-h/2,0]){
                        linear_extrude(1){
                            text(letter,10);
                        }
                    }
                }
            }
        }
    }
}

module foot(params,
            travel=5,       // how far into the foot the actuator can move down
            bottom_tilt=0,  // the angle of the bottom of the foot
            hover=0,        // distance between the foot and the ground
            actuator_tilt=0,// the angle of the top of the foot
            lie_flat=true,
            letter=""){
    $fn=32;
    // The feet sit at the bottoms of the actuator columns.  Their main
    // function is to anchor the Viton bands and provide downward force.

    w = actuator_housing_xy_size().x; //size of the outside of the screw seat column
    l = actuator_housing_xy_size().y;
    cw = column_core_size().x; //size of the inside of the screw seat column
    wall_t = (w-cw)/2; //thickness of the wall
    foot_height = key_lookup("foot_height", params);
    h = foot_height - hover; //defined in parameters.scad, set hover=2 to not touch ground, useful for the middle foot.
    tilt = bottom_tilt - actuator_tilt; //the angle of the ground relative to the axis of the foot
    // The following transforms will either make the foot "in place" (i.e. the top is z=0) or
    // printable (i.e. with the bottom on z=0).

    y_tr_flat = l/2*tan(tilt)*sin(actuator_tilt);
    y_tr_tilted = h*tan(actuator_tilt);
    y_tr = lie_flat ? y_tr_flat : y_tr_tilted;
    translate_y(y_tr){
        //the foot base may be tilted, lie_flat makes this z=0
        rotate_x(lie_flat ? tilt : 0){
            //makes the bottom z=0
            translate_z(lie_flat ? -l/2*tan(tilt) : -h){
                union(){
                    difference(){
                        union(){
                            foot_section(actuator_tilt, 0, h=2*h){
                                //main part of foot
                                screw_seat_shell();
                            }
                            foot_section(actuator_tilt, 0, h=2*h+3){
                                //lugs on top
                                nut_seat_void();
                            }
                        }
                        //hollow out the inside
                        difference(){
                            //the core tapers at the top to support the lugs
                            sequential_hull(){
                                foot_section(actuator_tilt, 0, z=-99){
                                    nut_seat_void();
                                }
                                foot_section(actuator_tilt, 0, z=h-4){
                                    nut_seat_void();
                                }
                                foot_section(actuator_tilt, 0, offset=-wall_t, z=h){
                                    nut_seat_void();
                                }
                                foot_section(actuator_tilt, 0, offset=-wall_t, z=99){
                                    nut_seat_void();
                                }
                            }
                            //we double-subtract the anchor for the bands at the bottom, so that it
                            //doesn't protrude outside the part.
                            cube([2*column_base_radius()+1.5, 999, 2*(h-travel-0.5)],center=true);
                        }
                        //cut out the core again, without tapering, in the middle (to make two lugs,
                        //one on either side - rather than a ring around the top.
                        intersection(){
                            cube([cw-3.3*2, 999, 999],center=true);
                            foot_section(actuator_tilt, 0, h=99, z=99/2+h-travel-0.5){
                                nut_seat_void();
                            }
                        }

                        //cut out the shell close to the microscope centre to allow the actuator
                        //to protrude below the bottom of the body
                        difference(){
                            rotate_x(actuator_tilt){
                                translate([0,-l/2,h-travel-0.5]){
                                    cube([actuator_entry_width(), wall_t*3, 999], center=true);
                                }
                            }
                            //NOTE: We do not cut all the way through the foot. This is to keep the foot strong.
                            foot_ground_plane(tilt=0, top=h-travel-0.5);
                        }


                        //round the edges of the above slot, and make an actual hole (i.e. no adhesion
                        //layer) for the elastic bands to sit in.  Rounded edges should help strength
                        //and avoid damaging the bands.
                        //NOTE: width should match the band anchor above,
                        //and height/span should match the slot above.
                        skew_flat(bottom_tilt){
                            rotate_x(actuator_tilt){
                                translate_z(h-travel-4-2){
                                    filleted_bridge([2*column_base_radius()+1.5, 4, 2], roc_xy=4, roc_xz=3);
                                }
                            }
                        }
                        //cut off the foot below the "ground plane" (i.e. print bed)
                        foot_ground_plane(tilt, top=0);

                    }
                    foot_letter(letter,actuator_tilt);
                }
            }
        }
    }
}


module middle_foot(params, lie_flat=false,letter="Z"){
        foot(params,
             travel=z_actuator_travel(params),
             bottom_tilt=0,
             actuator_tilt=z_actuator_tilt(params),
             hover=2,
             lie_flat=lie_flat,
             letter=letter);
}

module outer_foot(params, lie_flat=false,letter=""){
    foot(params,
         travel=xy_actuator_travel(params),
         bottom_tilt=15,
         lie_flat=lie_flat,
         letter=letter);
}
