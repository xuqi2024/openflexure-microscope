use <../libs/illumination.scad>

$fn=200;
condenser_annulus_stl();

module condenser_annulus_stl() {
    lens_d=condenser_lens_diameter();
    base_r = condenser_base_r(lens_d);
    condenser_annulus(4.5, base_r, 2, 3, 1);
}