


use <../openscad/libs/microscope_parameters.scad>
use <../openscad/libs/utilities.scad>
use <../openscad/libs/lib_microscope_stand.scad>
use <../openscad/electronics_drawer.scad>
use <librender/assembly_parameters.scad>
use <librender/render_utils.scad>
use <librender/render_settings.scad>
use <librender/hardware.scad>
use <librender/electronics.scad>
use <./electronics/sangaboard.scad>
use <mount_motors.scad>
use <mount_sample_clips.scad>
use <mount_microscope.scad>


LOW_COST = false;
MANUAL = false;
render_microscope(LOW_COST, MANUAL);

module render_microscope(low_cost=false, manual=false){
    assembled_microscope_without_electronics(low_cost=low_cost);
    mounted_microscope_frame(manual=manual){
        render_sample_clips();
    }
    electronics_drawer_frame_xy(render_params()){
        coloured_render(body_colour()){
            electronics_drawer_stl(pi_version=4, sanga_version="stack_11mm");
        }

        translate(electronics_drawer_board_inset() + [0, 0, electronics_drawer_standoff_h()]){
            rpi_4b();
        }

        translate(electronics_drawer_board_inset() + [0, 0, sanga_stand_height("stack_11mm")]){
            sangaboard_v0_5();
        }
    }
}
