use <../openscad/libs/main_body_structure.scad>
use <../openscad/libs/main_body_transforms.scad>
use <../openscad/libs/microscope_parameters.scad>
use <../openscad/libs/utilities.scad>
use <../openscad/libs/libdict.scad>
use <librender/render_settings.scad>
use <librender/render_utils.scad>
use <librender/rendered_main_body.scad>

FRAME = 2;

render_check_main_body(FRAME);

module render_check_main_body(frame){
    params = default_params();


    coloured_render(body_colour()){
        rendered_main_body();
    }
    if (frame==1){
        stage_top = key_lookup("stage_t", params) + upper_xy_flex_z(params);
        coloured_render(highlight_colour()){
            thick_section(h=3*tiny(), z_pos = stage_top-2*tiny()){
                xy_stage_with_nut_traps(params);
            }
        }
        coloured_render(highlight_colour()){
            minkowski(){
                xy_top_flexures(params);
                cube(tiny(), center=true);
            }
        }
    }
    if (frame==2){
        leg_top = upper_xy_flex_z(params);
        leg_block_t = key_lookup("leg_block_t", params);
        coloured_render(highlight_colour()){
            translate_z(flex_dims().z){
                thick_section(h=3*tiny(), z_pos = leg_top-2*tiny()){
                    leg_frame(params, 135){
                        leg(params);
                    }
                }
            }
            thick_section(h=3*tiny(), z_pos = leg_top+leg_block_t-2*tiny()){
                leg_frame(params, 135){
                    leg(params);
                }
            }
        }
        coloured_render(highlight_colour2()){
            minkowski(){
                difference(){
                    xy_top_flexures(params);
                    minkowski(){
                        translate_z(-2){
                            thick_section(h=3, z_pos = leg_top+1){
                                xy_stage_with_nut_traps(params);
                            }
                        }
                        cube(tiny(), center=true);
                    }
                }
                cube(tiny(), center=true);
            }
        }
        
        /*Render the the two flexure seperatley to avoid weird CGAL error on render*/
        coloured_render(highlight_colour2()){
            minkowski(){
                difference(){
                    thick_section(h=flex_dims().z, z_pos = leg_top+tiny()){
                        leg_frame(params, 135){
                            leg(params);
                        }
                    }
                    thick_section(h=2*flex_dims().z, z_pos = leg_top-2*tiny()){
                        leg_frame(params, 135){
                            leg(params);
                        }
                    }
                    translate_z(-1.5*flex_dims().z){
                        thick_section(h=2*flex_dims().z, z_pos = leg_top+flex_dims().z){
                            leg_frame(params, 135){
                                leg(params);
                            }
                        }
                    }
                }
                cube(tiny(), center=true);
            }
        }
    }
}