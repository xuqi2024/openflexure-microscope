


use <../openscad/libs/microscope_parameters.scad>
use <../openscad/libs/utilities.scad>
use <../openscad/libs/lib_microscope_stand.scad>
use <../openscad/electronics_drawer.scad>
use <../openscad/scanner_case.scad>
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

    translate([0,0, 40]){
        assembled_microscope_without_electronics(low_cost=low_cost);
        mounted_microscope_frame(){
            render_sample_clips();
        }
    }

    shift(){
        electronics_drawer_frame_xy(render_params()){
            coloured_render(body_colour()){
                electronics_drawer_stl();
            }

            translate(electronics_drawer_board_inset() + [0, 0, electronics_drawer_standoff_h()]){
                rpi_4b();
            }

            translate(electronics_drawer_board_inset() + [0, 0, sanga_stand_height("stack_8.5mm")]){
                sangaboard_v0_4();
            }
        }
    }

    coloured_render("DimGrey"){
    //cutaway("+x", "DimGrey"){
        scanner_case_base();
    }

    coloured_render("DimGrey"){
    //cutaway("+x", "DimGrey"){
        scanner_case_rim();
    }

    coloured_render("DodgerBlue"){
    //cutaway("+x", "DodgerBlue"){
        scanner_case_top();
    }

    coloured_render("DimGrey"){
    //cutaway("+x", "DimGrey"){
        scanner_case_lid(0);
    }
}

module shift(){
    translate([5,80,1]){
        rotate(120.5){
            children();
        }
    }
}
