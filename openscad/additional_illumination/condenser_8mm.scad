use <../libs/illumination.scad>

condenser_8mm_stl();

module condenser_8mm_stl(){
    // NB the module is called in the renders with default arguments.  If
    // non-default arguments are used here, it will mean the STL doesn't
    // match the renders.
    condenser(led_size=8, ap_tray_width=10, lens_assembly_z=30);
}