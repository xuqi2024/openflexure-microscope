use <./assembly_parameters.scad>
use <./render_settings.scad>
use <./render_utils.scad>
use <../../openscad/libs/main_body_structure.scad>
use <../../openscad/libs/libdict.scad>

main_body(no_lug_params());

function no_lug_params() = let(
    params = render_params()
) replace_value("include_motor_lugs", false, params);
