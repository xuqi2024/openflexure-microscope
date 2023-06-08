use <../libs/illumination.scad>

$fn=200;
condenser_with_annulus_stl();

module condenser_with_annulus_stl(){
    // NB the module is called in the renders with default arguments.  If
    // non-default arguments are used here, it will mean the STL doesn't
    // match the renders.
    condenser(with_annulus=true);
}