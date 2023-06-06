use <./libs/illumination.scad>

condenser_aperture_8mm_stl();

module condenser_aperture_8mm_stl(){
    condenser_aperture(ap_tray_width=10,ap_tray_depth=aperture_tray_depth() + 0.1);
}
