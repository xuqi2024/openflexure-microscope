// This is mainly useful to create laser cut cases
// it's the bottom of the main body.  NB you need
// to make cut-outs underneath the moving parts and
// under the feet, to allow them to protrude through
// the plate.

use <../main_body.scad>
use <../libs/microscope_parameters.scad>

params = default_params();
projection(cut=true){
    translate([0,0,-0.1]){
        main_body(params);
    }
}
