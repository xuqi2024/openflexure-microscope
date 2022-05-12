

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