use <../libs/double_dove_illumination.scad>
use <../libs/illumination.scad>


lens_t=1;
lens_d=13;
lens_r = lens_d/2;
base_r = lens_r+2;
base_height = 30;
condenser_back_y=15;
condenser_body(lens_r=lens_r,
                   lens_t=lens_t,
                   base_r=base_r,
                   width=18,
                   lens_assembly_z=base_height,
                   back_y=condenser_back_y,
                   bottom_height=0);



translate([-9, condenser_back_y-2, 0]){
    cube([18, double_dove_mount_y()-condenser_back_y-4, base_height]);
}

double_dove_height = base_height+6;
nut_z = double_dove_height-6;
translate([0,double_dove_mount_y(), 0]){
    double_dove_with_nuts(h=double_dove_height, nut_z=nut_z);
}
