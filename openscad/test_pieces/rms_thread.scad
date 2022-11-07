use <../libs/rms_thread.scad>
use <../libs/utilities.scad>

// An internal RMS thread, to check it fits objectives reliably.
difference(){
    // NB the cylinder below should ideally match optics_module_base_r in lib_optics.scad
    cylinder(d=rms_thread_nominal_d()+2, h=6);

    translate_z(1){
        rms_thread_cutter(h=5.5);
    }
}