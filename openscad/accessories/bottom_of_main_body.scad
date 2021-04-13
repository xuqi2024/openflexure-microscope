// This is mainly useful to create laser cut cases
// it's the bottom of the main body.  NB you need
// to make cut-outs underneath the moving parts and
// under the feet, to allow them to protrude through
// the plate.

use <../libs/main_body_structure.scad>
use <../libs/microscope_parameters.scad>
use <../libs/utilities.scad>

bottom_of_main_body();

module bottom_of_main_body(){
    params = default_params();
    projection(cut=true){
        translate_z(-0.1){
            main_body(params);
        }
    }
}