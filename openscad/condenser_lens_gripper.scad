use <./libs/illumination.scad>

$fn=200;
condenser_lens_gripper_stl();

module condenser_lens_gripper_stl(){
    lens_d=condenser_lens_diameter();
    lens_t=condenser_lens_thickness();
    base_r = condenser_base_r(lens_d);
    union() {
        condenser_lens_gripper(lens_d/2, lens_t, base_r);
        // Need to add a base
        translate([0,0,-lens_t]) {
            difference() {
                cylinder(r=base_r, h=lens_t);
                translate([0,0,-tiny()]) {
                    cylinder(r=(lens_d/2) - condenser_aperture_difference(), h=lens_t+tiny());
                }
            }
        }
    }
}
