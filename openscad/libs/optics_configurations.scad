use <./libdict.scad>
use <./lib_optics.scad>

function rms_f50d13_picamera() = [["tube_lens_ffd", 47],
                                  ["tube_lens_f", 50],
                                  ["tube_lens_r", 12.7/2+0.1],
                                  ["objective_parfocal_distance", 45],
                                  ["beamsplitter", false],
                                  ["gripper_t", 1],
                                  ["tube_length", 150],
                                  ["camera_mount_top_z", dt_bottom() - 3 - 8]];

function rms_infinity_f50d13_picamera() = let(
    finite_config = rms_f50d13_picamera(),
    replacements = [["tube_length", 99999], ["camera_mount_top_z", dt_bottom() - 3 - 20]]
) replace_multiple_values(replacements, finite_config);

function rms_f40d16_picamera() = [["tube_lens_ffd", 38],
                                  ["tube_lens_f", 40],
                                  ["tube_lens_r", 16/2+0.1],
                                  ["objective_parfocal_distance", 45],
                                  ["beamsplitter", false],
                                  ["gripper_t", 0.65],
                                  ["tube_length", 150],
                                  ["camera_mount_top_z", dt_bottom() - 3]];


