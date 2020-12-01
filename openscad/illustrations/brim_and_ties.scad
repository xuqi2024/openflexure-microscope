use <../main_body.scad>
use <../z_axis.scad>
use <../utilities.scad>
use <../microscope_parameters.scad>
use <../libs/libdict.scad>

params = default_params();
render_params = replace_value("print_ties", false, params);

smart_brim_r = key_lookup("smart_brim_r", params);
color("Red")render(6)exterior_brim(r=smart_brim_r, brim_only=true){
    main_body(params);
}
color("Red")xy_leg_ties(params);

color("Red")xy_actuators(params, ties_only=true);
color("Red")z_actuator_column(params, ties_only=true);
color("LightGray"){
    render(6){
        main_body(render_params);
    }
}