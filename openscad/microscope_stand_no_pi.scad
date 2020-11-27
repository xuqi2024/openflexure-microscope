use <microscope_stand.scad>
use <utilities.scad>

h=15;

module microscope_stand_no_pi(params){
    difference(){
        union(){
            bucket_base_with_microscope_top(params, h=h);
        }

        mounting_holes(params);

    }
}

microscope_stand_no_pi(params);
