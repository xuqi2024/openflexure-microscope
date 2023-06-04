use <./libs/illumination.scad>

$fn=200;
condenser_with_annulus_stl();

module condenser_with_annulus_stl(){
    // NB the module is called in the renders with default arguments.  If
    // non-default arguments are used here, it will mean the STL doesn't
    // match the renders.
    condenser(annulus_inner_radius=3.5, annulus_ring_width=2, annulus_height=3);
}