/******************************************************************
*                                                                 *
* OpenFlexure Microscope: Optics unit                             *
*                                                                 *
* This is part of the OpenFlexure microscope, an open-source      *
* microscope and 3-axis translation stage.  It gets really good   *
* precision over a ~10mm range, by using plastic flexure          *
* mechanisms.                                                     *
*                                                                 *
* The optics module holds the camera and whatever lens you are    *
* using as an objective - current options are either the lens     *
* from the Raspberry Pi camera module, or an RMS objective lens   *
* and a second "tube length conversion" lens (usually 40mm).      *
*                                                                 *
* See the section at the bottom of the file for different         *
* versions, to suit different combinations of optics/cameras.     *
* NB you set the camera in the variable at the top of the file.   *
*                                                                 *
* (c) Richard Bowman, January 2016                                *
* Released under the CERN Open Hardware License                   *
*                                                                 *
******************************************************************/

use <./libs/utilities.scad>
use <./libs/microscope_parameters.scad>
use <./libs/lib_optics.scad>

module chamfer_bottom_edge(chamfer=0.3, h=0.5){
    difference(){
        children();

        minkowski(){
            cylinder(r1=2*chamfer, r2=0, h=2*h, center=true);
            linear_extrude(tiny()){
                difference(){
                    square(999, center=true);
                    projection(cut=true){
                        translate_z(-tiny()){
                            hull(){
                                children();
                            }
                        }
                    }
                }
            }
        }
    }
}

module fl_cube_outer(){
    // The outer body for fl_cube()
    roc = 0.6;
    w = fl_cube_w();
    foot = roc*0.7;
    bottom_t = roc*3;
    $fn=8;
    chamfer_bottom_edge(){
        union(){
            reflect_x(){
                // outer "arms" that are responsible for the tight fit
                sequential_hull(){
                    translate([w/2-2-roc*0.8/sqrt(2), w+2-roc*1.2, 0]){
                        cylinder(r=roc, h=w);
                    }
                    translate([w/2-roc, w-roc/sqrt(2), 0]){
                        cylinder(r=roc, h=w);
                    }
                    translate([w/2-roc, foot+bottom_t+roc, 0]){
                        cylinder(r=roc, h=w);
                    }
                }
                translate([w/2-3*roc, foot+bottom_t+roc, 0]){
                    difference(){
                        // the curved bits at the bottom
                        resize([0,(bottom_t+roc)*2,0]){
                            cylinder(r=3*roc, h=w, $fn=24);
                        }
                        // cut out the inner radius
                        cylinder(r=roc, h=999, center=true);
                        // restrict it to a quarter-turn
                        mirror([1,0,0]){
                            translate([-roc,0,-99]){
                                cube(999);
                            }
                        }
                        mirror([1,0,0]){
                            translate([0,-roc,-99]){
                                cube(999);
                            }
                        }
                    }
                }
            }
            // join the two arms together at the bottom
            translate([0,foot+bottom_t/2, w/2]){
                cube([w - roc*3*2 + 2*tiny(), bottom_t, w], center=true);
            }

            //TODO: Find what this means?
            // feet at the bottom (and also in the middle of the top part)
            points = [[-w/2+roc*3, roc, roc+0.5],
                      [w/2-roc*3, roc, roc+0.5],
                      [0, roc, w-roc],
                      [w/2-2-roc*0.3/sqrt(2), w+2-roc*1.2, w/2],
                      [-(w/2-2-roc*0.3/sqrt(2)), w+2-roc*1.0, w/2]];
            for(p = points){
                translate(p){
                    sphere(r=roc,$fn=8);
                }
            }
        }
    }
}

module fl_cube(){
    // Filter cube that slots into a suitably-modified optics module
    // This prints with the Y axis vertical - to save rotating all the
    // cylinders, it's written here as printed.
    roc = 0.6;
    w = fl_cube_w();
    foot = roc*0.7;
    bottom_t = roc*3;
    dichroic = [12,16,1.1];
    dichroic_t = dichroic.z;
    emission_filter = [10,14,1.5];
    beamsplit = [0, w/2+2, w/2];
    inner_w = w - 6*roc;
    bottom = bottom_t + foot;
    $fn=8;
    difference(){
        union(){
            fl_cube_outer();

            // mount for 45 degree dichroic, with bottom retaining clip
            // y and z position of coated tip of dichroic + clearance room
            by = beamsplit.y + dichroic.y/2/sqrt(2) + 0.3;
            bz = beamsplit.z - dichroic.y/2/sqrt(2) + 0.3;
            // y and z position of back tip of dichroic
            bby = beamsplit.y + dichroic.y/2/sqrt(2) - dichroic.z/sqrt(2);
            bbz = beamsplit.z - dichroic.y/2/sqrt(2) - dichroic.z/sqrt(2);
            sequential_hull(){
                // tall back of triangle
                translate([-inner_w/2, bottom, 0]){
                    cube([inner_w, tiny(), beamsplit.z + beamsplit.y - bottom - dichroic_t*sqrt(2)]);
                }
                //pointy end of triangle
                translate([-inner_w/2, bby, 0]){
                    cube([inner_w, tiny(), bbz]);
                }
                //far end
                translate([-inner_w/2+2, by, 0]){
                    cube([inner_w-4, 1.5, bz]);
                }
                translate([-inner_w/2+2, by, bz]){
                    //start of retaining clip
                    cube([inner_w-4, 1.5, tiny()]);
                }
                //end of retaining clip
                translate([-inner_w/2, by - 4, 4 + 2*dichroic_t]){
                    cube([inner_w, 2, tiny()]);
                }
                //overhanging bit
                translate([-inner_w/2, by - 5, 4 + 2*dichroic_t]){
                    cube([inner_w, 2, 1]);
                }
            }

            // attachment for the excitation filter and LED
            reflect_x(){
                translate([-w/2, bottom + 4, w]){
                    sequential_hull(){
                        depth = w-bottom-4-roc;
                        translate_z(-roc){
                            cube([2*roc, depth, tiny()]);
                        }
                        translate([0.5,0,roc]){
                            cube([2*roc, depth, 1.5]);
                        }
                        translate([0.5+2*roc + 1.5 - 0.2*(1+sqrt(2)),0,roc+1.5-0.2]){
                            rotate_x(-90){
                                cylinder(r=0.2, h=depth);
                            }
                        }
                    }
                }
            }
        }
        // hole for the beam
        translate(beamsplit){
            rotate_x(90){
                cylinder(r=5,h=999, center=true, $fn=32);
            }
        }
        // hole for the emission filter
        translate([-emission_filter.x/2, bottom - roc*1.5, beamsplit.z-emission_filter.y/2]){
            cube([emission_filter.x, emission_filter.z, 999]);
        }
        // access hole for the dichroic
        translate(beamsplit){
            rotate_x(-45){
                translate_y(-dichroic.y/2){
                    scale([1.1,1,1.9]){
                        cube(dichroic, center=true);
                    }
                }
            }
        }
    }
}

fl_cube();