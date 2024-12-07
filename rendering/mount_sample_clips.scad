use <../openscad/libs/microscope_parameters.scad>
use <../openscad/libs/utilities.scad>
use <../openscad/libs/libdict.scad>
use <../openscad/libs/main_body_transforms.scad>
use <../openscad/libs/main_body_structure.scad>
use <librender/assembly_parameters.scad>
use <librender/render_utils.scad>
use <librender/render_settings.scad>
use <librender/hardware.scad>
use <librender/tools.scad>
use <mount_illumination.scad>
use <mount_microscope.scad>
use <motor_assembly.scad>
use <mount_motors.scad>
use <../openscad/sample_clips.scad>

FRAME = 2;
LOW_COST = false;
MANUAL = false;
render_mount_sample_clips(FRAME, LOW_COST, MANUAL);

module render_mount_sample_clips(frame, low_cost=false, manual=false){
    if(frame > 2){
        assembled_microscope_without_electronics(low_cost=low_cost, manual=manual);
    }
    mounted_microscope_frame(manual=manual){
        render_sample_clips(
            exploded=(frame<=3), 
            screws_exploded=(frame==1),
            allen_key=(frame==3));
    }
}

module render_sample_clips(params=render_params(), exploded=false, screws_exploded=false, allen_key=false){
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
                    rotate_x(90){
                        // as defined, the allen key goes along the z axis
                        allen_key_2_5();
                    }
                }
            }
        }
    }
}

