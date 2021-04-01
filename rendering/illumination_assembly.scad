use <../openscad/libs/illumination.scad>;
use <../openscad/libs/utilities.scad>;
use <../openscad/libs/microscope_parameters.scad>;
use <../openscad/libs/main_body_structure.scad>
use <../openscad/libs/libdict.scad>;
use <librender/render_settings.scad>;
use <librender/assembly_parameters.scad>;


params = default_params();

// This is taken straight from illumination, h=50 should match illumination_dovetail.scad
color(extras_colour()){
    render(6){
        illumination_dovetail(params, h = 60);
    }
}

// This should match condenser.scad
color(body_colour()){
    translate_z(key_lookup("sample_z", params) + 50){
        rotate_y(180){
            render(6){
                condenser(params, lens_d=13, lens_t=1, lens_assembly_z= 30);
            }
        }
    }
}

// TODO: If I add in the riser, we might find out the condenser is too low...?

// main body
color(body_colour()){
    render(6){
        main_body(render_params());
    }
}