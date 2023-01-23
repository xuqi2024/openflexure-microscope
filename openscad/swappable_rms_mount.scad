use <libs/lib_swappable_optics.scad>;
use <libs/microscope_parameters.scad>;
use <libs/utilities.scad>;
use <libs/libdict.scad>;

module swappable_rms_mount_stl(){
    mount_h = key_lookup("mount_h", swappable_rms_params(default_params()));
    translate_z(mount_h){
        rotate_x(180){
            swappable_rms_mount(default_params());
        }
    }
}

swappable_rms_mount_stl();
