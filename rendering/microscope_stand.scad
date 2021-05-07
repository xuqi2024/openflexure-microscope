

use <../openscad/libs/microscope_parameters.scad>
use <../openscad/libs/lib_microscope_stand.scad>

microscope_stand_rendered();

module microscope_stand_rendered(){
    params = default_params();
    pi_stand_h = 42;
    color("#505050"){
        render(6){
            microscope_stand(params, pi_stand_h);
        }
    }
    color("Dodgerblue"){
        render(6){
            pi_stand_frame_xy(params){
                pi_stand(pi_stand_h);
            }
        }
    }
}