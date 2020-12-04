use <microscope_stand.scad>
use <./libs/utilities.scad>
use <./libs/microscope_parameters.scad>

h=15;

module microscope_stand_no_pi(params){
    difference(){
        union(){
            bucket_base_with_microscope_top(params, h=h);
        }

        mounting_holes(params);

    }
}
params = default_params();
microscope_stand_no_pi(params);
