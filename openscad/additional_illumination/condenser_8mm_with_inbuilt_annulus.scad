use <../libs/illumination.scad>

$fn=200;
condenser_with_annulus_8mm_stl();

module condenser_with_annulus_8mm_stl(){
    // NB the module is called in the renders with default arguments.  If
    // non-default arguments are used here, it will mean the STL doesn't
    // match the renders.
    condenser(led_size=8, ap_tray_width=10, annulus_inner_radius=3.7, annulus_ring_width=2, annulus_height=3, lens_assembly_z=30);
}