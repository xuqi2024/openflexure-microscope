use <../openscad/libs/main_body_structure.scad>
use <../openscad/libs/microscope_parameters.scad>
use <../openscad/libs/utilities.scad>
use <../openscad/libs/libdict.scad>
use <librender/render_settings.scad>
use <librender/render_utils.scad>
use <librender/rendered_main_body.scad>


render_main_body_checks();

module render_main_body_checks(){
    params = default_params();
    stage_top = key_lookup("stage_t", params) + upper_xy_flex_z(params);

    coloured_render(body_colour()){
        rendered_main_body();
    }
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