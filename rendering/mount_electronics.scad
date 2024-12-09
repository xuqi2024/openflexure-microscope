


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

FRAME = 8;
LOW_COST = false;


render_mount_electronics(FRAME, LOW_COST);

module render_mount_electronics(frame, low_cost=false){
    if (frame == 1){
        render_electronics_drawer(slide=true);
        render_drawer_nut(slide=true, exploded=true);
    }
    if (frame == 2){
        render_electronics_drawer(slide=true);
        render_drawer_nut(slide=true, exploded=false);
    }
    if (frame == 3){
        render_electronics_drawer(slide=true);
        render_rpi_4b(slide=true, exploded=true);
    }
    if (frame == 4){
        render_electronics_drawer(slide=true);
        render_rpi_4b(slide=true, exploded=true);
        render_rpi_4b_screws(slide=true, exploded=true);
    }
    if (frame == 5){
        render_electronics_drawer(slide=true);
        render_rpi_4b(slide=true, exploded=false);
        render_rpi_4b_screws(slide=true, exploded=false);
    }
    if (frame == 6){
        render_electronics_drawer(slide=true);
        render_rpi_4b(slide=true, exploded=false);
        render_rpi_4b_screws(slide=true, exploded=false);
        render_sangaboard_v0_5(slide=true, exploded=true);
        render_sangaboard_screws(slide=true, exploded=true);
    }
    if (frame == 7){
        render_electronics_drawer(slide=true);
        render_rpi_4b(slide=true, exploded=false);
        render_rpi_4b_screws(slide=true, exploded=false);
        render_sangaboard_v0_5(slide=true, exploded=false);
        render_sangaboard_screws(slide=true, exploded=false);
    }
    if (frame == 8){
        microscope_with_clips(low_cost=low_cost);
        render_electronics_drawer(slide=true);
        render_rpi_4b(slide=true);
        render_rpi_4b_screws(slide=true);
        render_sangaboard_v0_5(slide=true);
        render_sangaboard_screws(slide=true);
    }
    if (frame == 9){
        microscope_with_clips(low_cost=low_cost);
        render_electronics_drawer(slide=false);
        render_rpi_4b(slide=false);
        render_rpi_4b_screws(slide=false);
        render_sangaboard_v0_5(slide=false);
        render_sangaboard_screws(slide=false);
    }
    if (frame == 10){
        microscope_with_clips(low_cost=low_cost);
        render_electronics_drawer(slide=false);
        render_rpi_4b(slide=false);
        render_rpi_4b_screws(slide=false);
        render_sangaboard_v0_5(slide=false);
        render_sangaboard_screws(slide=false);
        render_electronics_drawer_screw(exploded=true);
    }
    if (frame == 11){
        microscope_with_clips(low_cost=low_cost);
        render_electronics_drawer(slide=false);
        render_rpi_4b(slide=false);
        render_rpi_4b_screws(slide=false);
        render_sangaboard_v0_5(slide=false);
        render_sangaboard_screws(slide=false);
        render_electronics_drawer_screw(exploded=false);
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

module render_drawer_nut(slide=false, exploded=false){
    slide_out = slide? [100,0,0] : [0,0,0] ; 
    explode = exploded ? [0,6.9,15] : [0,6.9,0] ;
    electronics_drawer_frame_xy(render_params()){
        translate(slide_out){
            translate(explode){
                translate(electronics_drawer_side_screw_pos()){
                    if (exploded){
                        construction_line([0,0,-3], [0,0,-explode.z]);
                    }                
                    rotate_x(90){
                        rotate_z(30){
                            m3_nut(center=true);
                        }
                    }
                }
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
    explode = exploded ? [0,0,12] : [0,0,0] ;
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
    explode = exploded ? [0,0,25] : [0,0,0] ;
    hole_pos = pi_hole_pos(true);
    electronics_drawer_frame_xy(render_params()){
        translate(slide_out + explode){
            translate([0, 0, electronics_drawer_standoff_h()+stack]){
                for (i = [0, 1]){
                    translate(hole_pos[i]){
                        no2_x6_5_selftap();
                    }
                    if (exploded){
                        construction_line(hole_pos[i], hole_pos[i]-[0,0,30]);
                    }
                }
            }
        }
    }
}

module render_electronics_drawer_screw(exploded=false){
    explode_side = exploded ? [0,-15,0] : [0,0,0] ;
    explode_front = exploded ? [25,0,0] : [0,0,0] ;
    electronics_drawer_frame_xy(render_params()){
        translate(explode_side){
            translate(electronics_drawer_side_screw_pos()){
                if (exploded){
                    construction_line([0,0,0], -explode_side);
                }
                rotate_x(90){
                    m3_cap_x10();
                }
            }
        }
        translate(explode_front){
            translate(electronics_drawer_front_screw_pos()){
                if (exploded){
                    construction_line([0,0,0], -explode_front);
                }
                rotate([90,0,90]){
                    m3_cap_x10();
                }
            }
        }
    }
}

module render_microscope(low_cost=false){
        microscope_with_clips(low_cost=low_cost);
        render_electronics_drawer(slide=false);
        render_rpi_4b(slide=false);
        render_rpi_4b_screws(slide=false);
        render_sangaboard_v0_5(slide=false);
        render_sangaboard_screws(slide=false);
        render_electronics_drawer_screw(exploded=false);
}
