


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
    assembled_microscope_without_electronics(low_cost=low_cost);
    mounted_microscope_frame(){
        render_sample_clips(exploded=(frame==1));
    }
}

module render_sample_clips(params=render_params(), exploded=false){
    each_actuator(params){
        translate([0, -stage_hole_inset(), key_lookup("sample_z", params)]){
            coloured_render(extras_colour()){
                rotate_z(120){
                    translate_z(exploded?5:0){
                        default_sample_clip();
                    }
                }
            }
            translate_z(exploded?40:2.5){
                m3_cap_x10();
            }
            if(exploded){
                construction_line([0,0,0], [0,0,40]);
            }
        }
    }
}