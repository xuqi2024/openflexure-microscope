


use <../openscad/libs/microscope_parameters.scad>
use <../openscad/libs/utilities.scad>
use <../openscad/libs/lib_microscope_stand.scad>
use <../openscad/electronics_drawer.scad>
use <librender/assembly_parameters.scad>
use <librender/render_utils.scad>
use <librender/render_settings.scad>
use <librender/hardware.scad>
use <librender/electronics.scad>
use <mount_motors.scad>
use <mount_sample_clips.scad>
use <mount_microscope.scad>


OPTICS_VERSION = "rms";
render_microscope(OPTICS_VERSION);

module render_microscope(optics_version="rms"){
    assembled_microscope_without_electronics(optics_version=optics_version);
    mounted_microscope_frame(){
        render_sample_clips();
    }
    electronics_drawer_frame_xy(render_params()){
        coloured_render(body_colour()){
            electronics_drawer_stl();
        }

        translate(electronics_drawer_board_inset() + [0, 0, electronics_drawer_standoff_h()]){
            rpi_4b();
        }

        translate(electronics_drawer_board_inset() + [0, 0, sanga_stand_height("v0.4")]){
            sangaboard_v0_4();
        }
    }
}
