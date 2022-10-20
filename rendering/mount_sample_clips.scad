use <../openscad/libs/microscope_parameters.scad>
use <../openscad/libs/utilities.scad>
use <../openscad/libs/libdict.scad>
use <../openscad/libs/main_body_transforms.scad>
use <../openscad/libs/main_body_structure.scad>
use <librender/assembly_parameters.scad>
use <librender/render_utils.scad>
use <librender/render_settings.scad>
use <librender/hardware.scad>
use <mount_illumination.scad>
use <mount_microscope.scad>
use <motor_assembly.scad>
use <mount_motors.scad>
use <../openscad/sample_clips.scad>

FRAME=2;
LOW_COST = false;
render_mount_sample_clips(FRAME, LOW_COST);

module render_mount_sample_clips(frame, low_cost=false){
    if(frame > 2){
        assembled_microscope_without_electronics(low_cost=low_cost);
    }
    mounted_microscope_frame(){
        render_sample_clips(
            exploded=(frame<=3), 
            screws_exploded=(frame==1),
            allen_key=(frame==3));
    }
}

module render_sample_clips(params=render_params(), exploded=false, screws_exploded=true, allen_key=false){
    clip_z = exploded?10:0;
    screw_z = clip_z + (screws_exploded?12.5:2.5);
    each_actuator(params){
        translate([0, -stage_hole_inset(), key_lookup("sample_z", params)]){
            coloured_render(extras_colour()){
                rotate_z(120){
                    translate_z(clip_z){
                        default_sample_clip();
                    }
                }
            }
            translate_z(screw_z){
                m3_cap_x10();
            }
            if(allen_key){
                translate_z(screw_z + 1.5){
                    allen_key(d=2.5);
                }
            }
        }
    }
}


// A ball-ended hex key
module allen_key(d=2.5, l1=90, l2=18, radius_of_curvature=undef){
    roc = (radius_of_curvature==undef) ? l2/4 : radius_of_curvature;

    // A hexagon that measures d across the flats
    // The diameter of the circle is across the points
    // hence the 1/cos term.
    module hexagon(){
        circle($fn=6, d=d/cos(360/12));
    }
    module hexagon_3d(){
        linear_extrude(tiny()){
            hexagon();
        }
    }
        
    coloured_render("DimGray"){
        union(){
            // ball and long shaft
            sequential_hull(){
                translate_z(-0.4*d) scale(0.6) hexagon_3d();
                translate_z(-0.2*d) hexagon_3d();
                translate_z(0.2*d) hexagon_3d();
                translate_z(0.4*d) scale(0.6) hexagon_3d();
                translate_z(1.0*d) hexagon_3d();
                translate_z(l1 - roc + tiny()) hexagon_3d();
            }
            // curved part
            translate([0, roc, l1-roc]){ // centre of curve
                rotate_y(90){
                    rotate_z(180){
                        rotate_extrude(angle=90, $fn=64){
                            translate([roc,0]){
                                rotate_z(30){
                                    hexagon();
                                }
                            }
                        }
                    }
                }
            }
            // short shaft
            translate([0, roc - tiny(), l1]){
                rotate_x(-90){
                    linear_extrude(l2 - roc){
                        hexagon();
                    }
                }
            }
        }
    }
}
