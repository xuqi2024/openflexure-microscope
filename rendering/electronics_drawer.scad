


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

FRAME = 5;
LOW_COST = false;
render_mount_electronics(FRAME, LOW_COST);

module render_mount_electronics(frame, low_cost=false){
    if (frame == 1){
        render_electronics_drawer(slide=true);
        render_rpi_4b(slide=true, exploded=true);
    }
    if (frame == 2){
        render_electronics_drawer(slide=true);
        render_rpi_4b(slide=true, exploded=true);
        render_rpi_4b_screws(slide=true, exploded=true);
    }
    if (frame == 3){
        render_electronics_drawer(slide=true);
        render_rpi_4b(slide=true, exploded=false);
        render_rpi_4b_screws(slide=true, exploded=false);
    }
    if (frame == 4){
        render_electronics_drawer(slide=true);
        render_rpi_4b(slide=true, exploded=false);
        render_rpi_4b_screws(slide=true, exploded=false);
        render_sangaboard_v0_5(slide=true, exploded=true);
        render_sangaboard_screws(slide=true, exploded=true);
    }
    if (frame == 5){
        render_electronics_drawer(slide=true);
        render_rpi_4b(slide=true, exploded=false);
        render_rpi_4b_screws(slide=true, exploded=false);
        render_sangaboard_v0_5(slide=true, exploded=false);
        render_sangaboard_screws(slide=true, exploded=false);
    }


    if (frame == 14){
        microscope_with_clips(low_cost=low_cost);
        render_electronics_drawer(slide=true);
    }
}

module microscope_with_clips(low_cost=false){
    assembled_microscope_without_electronics(low_cost=low_cost);
    mounted_microscope_frame(){
        render_sample_clips();
    }
}

module render_electronics_drawer(slide=false){
    slide_out = slide? [100,0,0] : [0,0,0] ; 
    electronics_drawer_frame_xy(render_params()){
        translate(slide_out){
            coloured_render(body_colour()){
                electronics_drawer_stl(pi_version=4, sanga_version="stack_11mm");
            }
        }
    }
}

module render_rpi_4b(slide=false, exploded=false){
    slide_out = slide ? [100,0,0] : [0,0,0] ;
    explode = exploded ? [0,0,0.5] : [0,0,0] ;
    electronics_drawer_frame_xy(render_params()){
        translate(slide_out + explode){
            translate(electronics_drawer_board_inset() + [0, 0, electronics_drawer_standoff_h()]){
                rpi_4b();
            }
        }
    }
}

module render_rpi_4b_screws(slide=false, exploded=false){
    slide_out = slide ? [100,0,0] : [0,0,0] ;
    explode = exploded ? [0,0,15] : [0,0,0] ;
    hole_pos = pi_hole_pos(true);
    electronics_drawer_frame_xy(render_params()){
        translate(slide_out + explode){
            translate([0, 0, electronics_drawer_standoff_h()+1]){
                for (i = [2, 3]){
                    translate(hole_pos[i]){
                        no2_x6_5_selftap();
                    }
                    if (exploded){
                        construction_line(hole_pos[i], hole_pos[i]-[0,0,20]);
                    }
                }
            }
        }
    }
}

module render_sangaboard_v0_5(slide=false, exploded=false){
    slide_out = slide ? [100,0,0] : [0,0,0] ;
    explode = exploded ? [0,0,5] : [0,0,0] ;
    hole_pos = pi_hole_pos(true);
    electronics_drawer_frame_xy(render_params()){
        translate(slide_out + explode){
            translate(electronics_drawer_board_inset() + [0, 0, sanga_stand_height("stack_11mm")]){
                sangaboard_v0_5();
            }
        }
    }
}

module render_sangaboard_screws(slide=false, exploded=false){
    slide_out = slide ? [100,0,0] : [0,0,0] ;
    stack = 11.5 + 5; // stack height 11.5mm, plus two board thicknesses, plus header base thickness
    explode = exploded ? [0,0,20] : [0,0,0] ;
    hole_pos = pi_hole_pos(true);
    electronics_drawer_frame_xy(render_params()){
        translate(slide_out + explode){
            translate([0, 0, electronics_drawer_standoff_h()+stack]){
                for (i = [0, 1]){
                    translate(hole_pos[i]){
                        no2_x6_5_selftap();
                    }
                    if (exploded){
                        construction_line(hole_pos[i], hole_pos[i]-[0,0,25]);
                    }
                }
            }
        }
    }
}


module render_microscope(low_cost=false){
    assembled_microscope_without_electronics(low_cost=low_cost);
    mounted_microscope_frame(){
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
