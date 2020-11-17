import os

def copy_stl(writer, stl_file, select_stl_if=None):
    if writer._json_generator is not None:
        writer._json_generator.register(
            output=stl_file, input_file=stl_file, select_stl_if=select_stl_if
        )
    output = os.path.join(writer._build_dir, stl_file)
    input_file = os.path.join("openflexure-microscope-extra", stl_file)
    writer._ninja.build(output, rule="copy", inputs=input_file)

def add_extra_stls_to_writer(writer):
    for camera in ["6ledcam", "dashcam"]:

        select_mount_top = {"camera": camera, "optics": f"{camera}_lens"}
        copy_stl(writer, f"{camera}_mount_top.stl", select_stl_if=select_mount_top)

    select_mount_bottom = [{"camera": "dashcam", "optics": "dashcam_lens"},
                           {"camera": "6ledcam", "optics": "6ledcam_lens"}]
    copy_stl(writer, "dashcam_and_6ledcam_mount_bottom.stl", select_stl_if=select_mount_bottom)
