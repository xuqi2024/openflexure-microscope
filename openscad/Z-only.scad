use <./illumination_dovetail.scad>
use <./libs/microscope_parameters.scad> 
use <./libs/main_body_structure.scad>
use <./libs/utilities.scad>
use <./libs/libdict.scad>
use <./libs/z_axis.scad>
use <./libs/wall.scad>

params = default_params();

z_only(params);

module z_only(params, cable_guides = false, spacer = false){
    //This is the z-axis of the main body 
    // The conditional statement allows cable guides to be included or omitted.
    difference(){
        union(){
            add_hull_base(microscope_base_t()); 
            // The wings have been removed from this design of the z-axis. 
            z_axis_casing(params, condenser_mount=true, cable_housing = false);
            if (spacer){
                //////////
            }
        }
        mounting_hole_lugs(params);
        //This also cuts the walls hence why it is two objects
        z_axis_casing_cutouts(params);
        xy_actuator_cut_outs(params);
        central_optics_cut_out(params);
        z_axis_clearance(params);
        z_motor_clearance(params);
        if (cable_guides){ 
            z_cable_housing_cutout(params, h=99, top=false);
        }
    }

    // Adding the z actuator
    difference(){
        z_actuator_assembly(params);
        // removing the extruding cylinders from the actuator
        translate([-50,0,-100])
        cube(size = 100);
    }
}