

use <./utilities.scad>


module fitting_wedge(h, nose_width, nose_shift=0.2, center=false){
    // A trapezoidal wedge that clamps can be clamped into a v-shape.
    // To enable clamping a nut trap must be suntracted from this shape
    // nose_shift moves the tip of the wedge in the -y direction
    // increasing the gap at the tip.
    // This wedge can be subtracted to make the v-shape mount. In this
    // case use a nose_shift < 0.

    nose_x = -nose_width/2-nose_shift;
    nose_y = nose_shift;
    nose_z = center ? -h/2 : 0;
    nose_position = [nose_x, nose_y, nose_z];
    mirror([0,1,0]){
        hull(){
            translate(nose_position){
                cube([nose_width+2*nose_shift, tiny(), h]);
            }
            reflect_x(){
                // TODO: understand these numbers and explain
                translate([-nose_width/2-5+sqrt(2), 5+sqrt(2), 0]){
                    cylinder(r=2, h=h, $fn=16, center=center);
                }
            }
        }
    }
}

module fitting_wedge_cutout(z_pos, y_stop=false, nose_shift=0.2, max_screw=11){
    // Subtract this from a fitting wedge, to cut out a hole for the nut
    // so that it can be anchored to a mount
    // y_stop if set true will also cut flush the faces of the mount in case something is
    // protruding.

    module fitting_wedge_nut(shaft=false){
        // For convenience, this is the nut for the fitting wedge
        shaft_length = shaft ? max_screw-4 : 0;
        nut_y(3, h=2.5, extra_height=0, shaft_length=shaft_length);
    }

    translate([0, -3.7, z_pos]){
        fitting_wedge_nut(shaft=true);
        sequential_hull(){
            fitting_wedge_nut();
            translate_z(7){
                fitting_wedge_nut();
            }
            translate([0,10,7]){
                repeat([0,0,10],2){
                    fitting_wedge_nut();
                }
            }
        }
    }
    if(y_stop){
        translate([-10, -nose_shift, -99]){
            cube([20,20,199]);
        }
    }
}
