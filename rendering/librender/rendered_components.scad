// This library contains certain components rendered in colour

use <render_utils.scad>
use <render_settings.scad>
use <../../openscad/lens_tool.scad>

module rendered_lens_tool(){
    coloured_render(tools_colour()){
        lens_tool();
    }
}