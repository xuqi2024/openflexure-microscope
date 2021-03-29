/******************************************************************
*                                                                 *
* OpenFlexure Microscope: Optics unit                             *
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


use <./libs/utilities.scad>

//this is for mini culture plates, 39mm outer diameter and 12.4mm high
sample=[0,19/2,12.4-1.5-9]; //position of clamping point relative to bolt

$fn=32;


module sample_clip(sample,t=2.5,w=6,roc=-1,slope=30){
    //radius of curvature
    roc = roc>0 ? roc : sample.z/2 + sample.y*sin(slope) - t/2;

    //a is the distance from the contact-point cylinder to the
    //centre of the curved part
    a = sqrt(pow(sample.y, 2) + pow(sample.z - roc - t/2, 2));
    //angle through which we must rotate the join between
    angle = acos( (roc + t/2) / a ) + atan((sample.z - roc - t/2)/sample.y);


    difference(){
        union(){
            //anchor to stage
            cylinder(r=w/2,h=t);

            translate([0,0,roc+t]){
                rotate([0,90,0]){
                    difference(){
                        cylinder(r=roc+t,h=w,center=true);
                        cylinder(r=roc,h=999,center=true);
                        translate([0,0,-99]){
                            cube([999,999,999]);
                        }
                        translate([0,0,-99]){
                            rotate(angle){
                                cube([999,999,999]);
                            }
                        }
                    }
                }
            }
            sequential_hull(){
                translate([0,0,roc+t]){
                    rotate([0,90,0]){
                        rotate(angle){
                            translate([0,roc+t/2,0]){
                                cylinder(r=t/2,h=w,center=true);
                            }
                        }
                    }
                }
                translate([0,sample.y,sample.z+t/2]){
                    rotate([0,90,0]){
                        cylinder(r=t/2,h=w,center=true);
                    }
                }
                translate([0,sample.y+t,sample.z+t]){
                    rotate([0,90,0]){
                        cylinder(r=t/2,h=w,center=true);
                    }
                }
            }

        }
        cylinder(r=3/2*1.2,h=999,center=true,$fn=16);
    }
}


//this is for mini culture plates, 39mm outer diameter and 12.4mm high
//sample_clip([0,19/2+3,12.4-1.5],slope=7.5); //mini culture dish

//for a standard microscope slide, use [0,20,-1] to clamp from both holes next to one leg
for(a=[0,180]){
    rotate([0,-90,a]){
        translate([7/2,-10,-7+1]){
            sample_clip([0,20,-1], w=7, roc=7);
        }
    }
}
