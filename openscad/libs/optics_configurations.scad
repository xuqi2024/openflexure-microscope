use <./libdict.scad>
use <./lib_optics.scad>


// Notes on parameters:
//
// camera_rotation:  The angle of the camera mount (the ribbon cables exits at 135 degrees from
//                   mount for '0' & 180 degrees from mount for '-45')
//
// beamsplitter_rotation: The angle of the block to hold the fl cube (0 for the fl cube exiting
//                        at 180 degree from the mount and -60 for the fl cube exiting at 120
//                        from the mount)

function rms_f50d13_config(camera_type = "picamera_2", beamsplitter=false) = let(
    config_dict = [["optics_type", "RMS"],
                   ["camera_type", camera_type],
                   ["tube_lens_ffd", 47],
                   ["tube_lens_f", 50],
                   ["tube_lens_r", 12.7/2+0.1],
                   ["objective_parfocal_distance", 45],
                   ["beamsplitter", beamsplitter],
                   ["gripper_t", 1],
                   ["tube_length", 150],
                   ["camera_mount_top_z", optics_wedge_bottom() - 3 - 8],
                   ["camera_rotation", 0],
                   ["beamsplitter_rotation", 0]]
) config_dict;

function rms_infinity_f50d13_config(camera_type = "picamera_2", beamsplitter=false) = let(
    finite_config = rms_f50d13_config(camera_type, beamsplitter),
    replacements = [["tube_length", 99999], ["camera_mount_top_z", optics_wedge_bottom() - 3 - 20]]
) replace_multiple_values(replacements, finite_config);

function rms_f40d16_config(camera_type = "picamera_2", beamsplitter=false) = let(
    config_dict = [["optics_type", "RMS"],
                   ["camera_type", camera_type],
                   ["tube_lens_ffd", 38],
                   ["tube_lens_f", 40],
                   ["tube_lens_r", 16/2+0.1],
                   ["objective_parfocal_distance", 45],
                   ["beamsplitter", beamsplitter],
                   ["gripper_t", 0.65],
                   ["tube_length", 150],
                   ["camera_mount_top_z", optics_wedge_bottom() - 3],
                   ["camera_rotation", 0],
                   ["beamsplitter_rotation", 0]]
) config_dict;

function pilens_config(camera_type = "picamera_2") = let(
    config_dict = [["optics_type", "spacer"],
                   ["camera_type", camera_type],
                   ["lens_r", 3],
                   ["parfocal_distance", 6],
                   ["lens_h", 2.5],
                   ["lens_spacing", 17],
                   ["camera_mount_top_z",0]]
) config_dict;

