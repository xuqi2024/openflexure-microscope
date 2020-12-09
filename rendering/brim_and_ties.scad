use <../openscad/main_body.scad>
use <../openscad/libs/z_axis.scad>
use <../openscad/libs/utilities.scad>
use <../openscad/libs/libdict.scad>
use <librender/render_utils.scad>
use <../openscad/libs/microscope_parameters.scad>

params = default_params();
smart_brim_r = key_lookup("smart_brim_r", params);
color("Red")render(6)exterior_brim(r=smart_brim_r, brim_only=true){
    main_body(params);
}
color("Red")xy_leg_ties(params);

color("Red")xy_actuators(params, ties_only=true);
color("Red")z_actuator_column(params, ties_only=true);
color("LightGray"){
    render(6){
        main_body(render_params());
    }
}