use <./illumination_dovetail.scad>
use <./libs/microscope_parameters.scad> 
use <./libs/main_body_structure.scad>
use <./libs/utilities.scad>
use <./libs/libdict.scad>
use <./libs/z_axis.scad>
use <./libs/wall.scad>
$fn=32;
params = default_params();
z_only_with_smart_brim(params);

module z_only_with_smart_brim(params){
    // Adds a smart brim to the z-only module to prevent the back from peeling upwards when printing
    // Smart brim is required instead of typical brim to prevent the brim affecting the internal structures
    smart_brim_r = key_lookup("smart_brim_r", params);
    exterior_brim(r=smart_brim_r){
        z_only(params, cable_guides = false, spacer = false, cable_housing = false, rectangular = true);

    }
}

module z_only(params, cable_guides = false, spacer = false, cable_housing = false, rectangular = false){
    //This is the z-axis of the main body 
    difference(){
        union(){
            add_hull_base(microscope_base_t()); 
            // The wings have been removed from this design of the z-axis as they are not required 
            if (cable_housing){
                // The conditional statement allows cable guides to be included or omitted
                if (rectangular){
                    // Rectangular z-only module, used for the upside down version of the z-axis which sits ontop of the spacer
                    z_axis_casing(params, condenser_mount=true, cable_housing = true, rectangular = true);
                }
                else{
                    // Triangular z-only module
                    z_axis_casing(params, condenser_mount=true, cable_housing = true, rectangular = false);
                }
            }
            else{
                if (rectangular){
                    z_axis_casing(params, condenser_mount=true, cable_housing = false, rectangular = true);
                }
                else{
                    z_axis_casing(params, condenser_mount=true, cable_housing = false, rectangular = false);
                }
            }
        }
        mounting_hole_lugs(params);
        // This cuts the screw holes and/or nut traps (depending on whether it is for rectangular or triangular) into the z-axis
        if (rectangular){
            z_axis_casing_cutouts(params, rectangular = true);
        }
        else{
            z_axis_casing_cutouts(params);
        }
        xy_actuator_cut_outs(params);
        central_optics_cut_out(params);
        z_axis_clearance(params);
        z_motor_clearance(params);
        if (cable_guides){ 
            // Cable guide cutouts to allow the cables to be threaded through 
            z_cable_housing_cutout(params, h=99, top=false);
        }
    }

    // Adding the z actuator
    difference(){
        z_actuator_assembly(params);
        // Removing the extruding cylinders from the actuator
        translate([-50,0,-100])
        cube(size = 100);
    }
}