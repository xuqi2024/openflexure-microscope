


use <../openscad/libs/microscope_parameters.scad>
use <../openscad/libs/utilities.scad>
use <../openscad/libs/lib_microscope_stand.scad>
use <../openscad/pi_stand.scad>
use <librender/assembly_parameters.scad>
use <librender/render_utils.scad>
use <librender/render_settings.scad>
use <librender/hardware.scad>
use <librender/electronics.scad>
use <mount_motors.scad>
use <mount_sample_clips.scad>
use <mount_microscope.scad>


LOW_COST = false;
render_microscope(LOW_COST);

module render_microscope(low_cost=false){
    assembled_microscope_without_electronics(low_cost=low_cost);
    mounted_microscope_frame(){
        render_sample_clips();
    }
    pi_stand_frame_xy(render_params()){
        coloured_render(body_colour()){
            pi_stand_stl();
        }

        translate(pi_stand_board_inset() + [0, 0, pi_stand_standoff_h()]){
            rpi_4b();
        }

        translate(pi_stand_board_inset() + [0, 0, sanga_stand_height("v0.4")]){
            sangaboard_v0_4();
        }
    }
}
