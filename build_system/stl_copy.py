def copy_extra_stls(writer):
    for camera in ["6ledcam", "dashcam"]:

        select_mount_top = {"camera": camera, "optics": f"{camera}_lens"}
        writer.copy_stl(f"{camera}_mount_top.stl", select_stl_if=select_mount_top)

    select_mount_bottom = [{"camera": "dashcam", "optics": "dashcam_lens"},
                           {"camera": "6ledcam", "optics": "6ledcam_lens"}]
    writer.copy_stl("dashcam_and_6ledcam_mount_bottom.stl", select_stl_if=select_mount_bottom)
