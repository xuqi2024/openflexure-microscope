use <./libs/lib_microscope_stand.scad>
use <./libs/utilities.scad>
use <./libs/microscope_parameters.scad>



module microscope_stand_no_pi(){
    params = default_params();
    h=15;
    difference(){
        union(){
            bucket_base_with_microscope_top(params, h=h);
        }

        mounting_holes(params);

    }
}

microscope_stand_no_pi();
