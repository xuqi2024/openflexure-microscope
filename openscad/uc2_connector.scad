use <microscope_stand.scad>;
use <utilities.scad>;

n_cubes = 2;
cube_l = 50;
base_t = 15;
cube_clearance = 2;
scope_angle = 180;
cube_assembly_h = n_cubes * cube_l + cube_clearance;

module expanded_footprint(){
    // a larger footprint for the microscope to accommodate the UC2 blocks
    hull(){
        footprint(); //from microscope_stand
        rotate(-scope_angle) offset(3)
            translate([-cube_l/2 - cube_clearance, -base_t - cube_l/2]) 
            square([cube_l+cube_clearance, cube_l + cube_clearance + base_t]);
    }
}

difference(){
    union(){
        rotate(scope_angle) bucket_base_with_microscope_top(h=cube_assembly_h+5) expanded_footprint();

        intersection(){
            rotate(scope_angle) top_casing_block(h=cube_assembly_h+5) expanded_footprint();
            translate([-999, -cube_l/2 - base_t]) mirror([0,1,0]) cube([9999,9999,cube_assembly_h]);
        }

    }
    translate([-cube_l/2 - cube_clearance, -cube_l/2 - base_t, 0]) cube([999, cube_l + base_t + cube_clearance, n_cubes*cube_l + cube_clearance]);
}

//cube(cube_l, center=true);
