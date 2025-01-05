use <./assembly_parameters.scad>
use <./render_settings.scad>
use <./render_utils.scad>
use <../../openscad/libs/main_body_structure.scad>

VERSION_STRING = "custom";

main_body(render_params(), VERSION_STRING);

module rendered_main_body(colour=undef, alpha=1.0){
    //If this is failing to import you need to run this same file first to create the STL
    render_colour = is_undef(colour) ? body_colour() : colour;
    color(render_colour, alpha){
        import("rendered_main_body.stl");
    }
}
