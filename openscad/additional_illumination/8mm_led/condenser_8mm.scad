use <../../libs/illumination.scad>

$fn=200;
condenser_8mm_stl();

module condenser_8mm_stl(){
    // NB the module is called in the renders with default arguments.  If
    // non-default arguments are used here, it will mean the STL doesn't
    // match the renders.
    led_size = 8;
    condenser(led_size=led_size, lens_assembly_z=condenser_lens_assembly_z(led_size));
}