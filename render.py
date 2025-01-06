#!/usr/bin/env python3

"""
This is the main script to create the renderings used in the documentation.
"""

# Function docstrings are fairly redundant in this file
# pylint: disable=missing-function-docstring

import os
from build_system.openscad_render_system import RenderSystem, ScadRender, Camera

def register_rms_optics_assembly(rendersystem):
    input_file = "rendering/rms_optics_assembly.scad"
    cameras = []
    imgsizes = []
    scad_lines = []
    output_files = []

    for frame in [1, 2, 3]:
        cameras.append(Camera(position=[29, 0, 59], angle=[69, 0, 90], distance=290))
        imgsizes.append([1000, 2000])
        output_files.append(f"rendering/annotations/optics_assembly_tube_lens{frame}.png")
        scad_lines.append(f"render_rms_assembly({frame});")

    camera_png_files = []
    for frame in [1, 2]:
        cameras.append(Camera(position=[7, -14, -21], angle=[247, 0, 211], distance=250))
        imgsizes.append([1200, 2000])
        output_files.append(f"docs/renders/optics_assembly_camera{frame}.png")
        camera_png_files.append(output_files[-1])
        scad_lines.append(f"render_rms_assembly({frame+3});")

    objective_png_files = []
    for frame in [1, 2]:
        cameras.append(Camera(position=[2, 2, 25], angle=[55, 0, 90], distance=290))
        imgsizes.append([1200, 2000])
        output_files.append(f"docs/renders/optics_assembly_objective{frame}.png")
        objective_png_files.append(output_files[-1])
        scad_lines.append(f"render_rms_assembly({frame+5});")

    screw_png_files = []
    for frame in [1, 2, 3]:
        cameras.append(Camera(position=[-6.5, 14, 38], angle=[60, 0, 243], distance=290))
        imgsizes.append([1000, 2000])
        output_files.append(f"docs/renders/optics_assembly_screw{frame}.png")
        screw_png_files.append(output_files[-1])
        scad_lines.append(f"render_rms_assembly({frame+7});")

    ribbon_png_files = []
    for frame in [1, 2, 3]:
        cameras.append(Camera(position=[12.5, -1, 15], angle=[230, 0, 24], distance=325))
        imgsizes.append([1200, 2000])
        output_files.append(f"docs/renders/optics_assembly_ribbon{frame}.png")
        ribbon_png_files.append(output_files[-1])
        scad_lines.append(f"render_rms_assembly({frame+10});")

    for i, output_file in enumerate(output_files):
        render = ScadRender(output_file, input_file, scad_lines[i], imgsizes[i], cameras[i])
        rendersystem.register_scad_render(render)

    rendersystem.register_imagemagick_sequence(
        "docs/renders/optics_assembly_camera.png",
        camera_png_files
    )
    rendersystem.register_imagemagick_sequence(
        "docs/renders/optics_assembly_objective.png",
        objective_png_files
    )
    rendersystem.register_imagemagick_sequence(
        "docs/renders/optics_assembly_screw.png",
        screw_png_files
    )
    rendersystem.register_imagemagick_sequence(
        "docs/renders/optics_assembly_ribbon.png",
        ribbon_png_files
    )
    rendersystem.register_inkscape_annotation(
        "docs/renders/optics_assembly_tube_lens.png",
        "rendering/annotations/annotate_optics_assembly_tube_lens.svg"
    )

def register_low_cost_optics_assembly(rendersystem):
    input_file = "rendering/low_cost_optics_assembly.scad"
    cameras = []
    imgsizes = []
    scad_lines = []
    output_files = []

    for frame in [1, 2, 3]:
        cameras.append(Camera(position=[29, 0, 59], angle=[69, 0, 90], distance=290))
        imgsizes.append([1000, 2000])
        output_files.append(f"rendering/annotations/low_cost_optics_assembly_tube_lens{frame}.png")
        scad_lines.append(f"render_low_cost_assembly({frame});")

    camera_png_files = []
    for frame in [1, 2]:
        cameras.append(Camera(position=[-5, 7, 25], angle=[71, 0, 98], distance=292))
        imgsizes.append([1200, 2000])
        output_files.append(f"docs/renders/low_cost_optics_assembly_camera{frame}.png")
        camera_png_files.append(output_files[-1])
        scad_lines.append(f"render_low_cost_assembly({frame+3});")

    screw_png_files = []
    for frame in [1, 2, 3]:
        cameras.append(Camera(position=[-11, 19, 33], angle=[71, 0, 106], distance=192))
        imgsizes.append([1000, 2000])
        output_files.append(f"docs/renders/low_cost_optics_assembly_screw{frame}.png")
        screw_png_files.append(output_files[-1])
        scad_lines.append(f"render_low_cost_assembly({frame+5});")

    ribbon_png_files = []
    for frame in [1, 2, 3]:
        cameras.append(Camera(position=[-7, -7, 40.5], angle=[54, 0, 90], distance=237))
        imgsizes.append([1200, 2000])
        output_files.append(f"docs/renders/low_cost_optics_assembly_ribbon{frame}.png")
        ribbon_png_files.append(output_files[-1])
        scad_lines.append(f"render_low_cost_assembly({frame+8});")

    for i, output_file in enumerate(output_files):
        render = ScadRender(output_file, input_file, scad_lines[i], imgsizes[i], cameras[i])
        rendersystem.register_scad_render(render)

    rendersystem.register_imagemagick_sequence(
        "docs/renders/low_cost_optics_assembly_camera.png",
        camera_png_files
    )
    rendersystem.register_imagemagick_sequence(
        "docs/renders/low_cost_optics_assembly_screw.png",
        screw_png_files
    )
    rendersystem.register_imagemagick_sequence(
        "docs/renders/low_cost_optics_assembly_ribbon.png",
        ribbon_png_files
    )
    rendersystem.register_inkscape_annotation(
        "docs/renders/low_cost_optics_assembly_pi_lens.png",
        "rendering/annotations/annotate_optics_assembly_pi_lens.svg"
    )

def register_condenser_assembly(rendersystem):
    input_file = "rendering/condenser_assembly.scad"
    camera = Camera(position=[29, 0, 59], angle=[69, 0, 90], distance=290)
    imgsize = [1000, 2000]

    for frame in [1, 2, 3]:
        scad = f"assemble_condenser({frame});"
        output_file = f"rendering/annotations/optics_assembly_condenser_lens{frame}.png"
        render = ScadRender(output_file, input_file, scad, imgsize, camera)
        rendersystem.register_scad_render(render)
    rendersystem.register_inkscape_annotation(
        "docs/renders/optics_assembly_condenser_lens.png",
        "rendering/annotations/annotate_optics_assembly_condenser_lens.svg"
    )

    camera = Camera(position=[0, 8, 15.5], angle=[62, 0, 130], distance=237)
    imgsize = [2400, 2000]
    for frame in [4, 5, 6]:
        scad = f"assemble_condenser({frame});"
        output_file = f"docs/renders/assemble_condenser_thumbscrew{frame-3}.png"
        render = ScadRender(output_file, input_file, scad, imgsize, camera)
        rendersystem.register_scad_render(render)

    camera = Camera(position=[0, 8, 30], angle=[62, 0, 130], distance=137)
    imgsize = [2400, 2000]
    for frame in [7, 8, 9, 10]:
        scad = f"assemble_condenser({frame});"
        output_file = f"docs/renders/mount_led_board{frame-6}.png"
        render = ScadRender(output_file, input_file, scad, imgsize, camera)
        rendersystem.register_scad_render(render)
    for frame in [11, 12]:
        scad = f"assemble_condenser({frame});"
        output_file = f"docs/renders/mount_led_cable{frame-10}.png"
        render = ScadRender(output_file, input_file, scad, imgsize, camera)
        rendersystem.register_scad_render(render)
    camera = Camera(position=[0, 8, 30], angle=[62, 0, 130], distance=237)
    for frame in [13, 14, 15, 16]:
        scad = f"assemble_condenser({frame});"
        output_file = f"docs/renders/mount_condenser_lid{frame-12}.png"
        render = ScadRender(output_file, input_file, scad, imgsize, camera)
        rendersystem.register_scad_render(render)

def register_upright_condenser_assembly(rendersystem):
    input_file = "rendering/upright_condenser_assembly.scad"
    camera = Camera(position=[29, 0, 59], angle=[69, 0, 90], distance=290)
    imgsize = [1000, 2000]

    for frame in [1, 2, 3]:
        scad = f"upright_assemble_condenser({frame});"
        output_file = f"rendering/annotations/upright_optics_assembly_condenser_lens{frame}.png"
        render = ScadRender(output_file, input_file, scad, imgsize, camera)
        rendersystem.register_scad_render(render)
    rendersystem.register_inkscape_annotation(
        "docs/renders/upright_optics_assembly_condenser_lens.png",
        "rendering/annotations/upright_annotate_optics_assembly_condenser_lens.svg"
    )

    ## No thumbscrew for upright. Frames [4,5,6] not used so
    ## frame numbers match in upright and inverted condenser instructions

    camera = Camera(position=[0, 8, 30], angle=[62, 0, 130], distance=137)
    imgsize = [2400, 2000]
    for frame in [7, 8, 9, 10]:
        scad = f"upright_assemble_condenser({frame});"
        output_file = f"docs/renders/upright_mount_led_board{frame-6}.png"
        render = ScadRender(output_file, input_file, scad, imgsize, camera)
        rendersystem.register_scad_render(render)
    for frame in [11, 12]:
        scad = f"upright_assemble_condenser({frame});"
        output_file = f"docs/renders/upright_mount_led_cable{frame-10}.png"
        render = ScadRender(output_file, input_file, scad, imgsize, camera)
        rendersystem.register_scad_render(render)
    camera = Camera(position=[0, 8, 30], angle=[62, 0, 130], distance=237)
    for frame in [13, 14, 15, 16]:
        scad = f"upright_assemble_condenser({frame});"
        output_file = f"docs/renders/upright_mount_condenser_lid{frame-12}.png"
        render = ScadRender(output_file, input_file, scad, imgsize, camera)
        rendersystem.register_scad_render(render)


def register_workaround_5mm_led(rendersystem):
    input_file = "rendering/workaround_5mm_led.scad"
    camera = Camera(position=[0, 0, 0], angle=[42, 0, 313], distance=137)
    imgsize = [2400, 2000]
    for frame in [1, 2, 3, 4, 5]:
        scad = f"workaround_5mm_led({frame});"
        output_file = f"docs/renders/workaround_5mm_led{frame}.png"
        render = ScadRender(output_file, input_file, scad, imgsize, camera)
        rendersystem.register_scad_render(render)


def register_optics_assembled(rendersystem):
    input_file = "rendering/optics_assembly.scad"
    camera = Camera(position=[30, 5, 60], angle=[90, 0, 110], distance=440)
    output_file = "docs/renders/optics_assembled.png"
    imgsize = [1200, 2400]
    scad = "cutaway_optics();"
    render = ScadRender(output_file, input_file, scad, imgsize, camera)
    rendersystem.register_scad_render(render)


def register_band(rendersystem):
    input_file = "rendering/band_insertion_cutaway.scad"
    camera = Camera(position=[-13, 13, -30], angle=[76, 0, 216], distance=445)
    imgsize = [1200, 2400]
    png_files = []

    for frame in [1, 2, 3, 4, 5]:
        output_file = f"docs/renders/band{frame}.png"
        scad = f"render_band_insertion(band_insertion_frame_parameters({frame}));"
        png_files.append(output_file)
        render = ScadRender(output_file, input_file, scad, imgsize, camera)
        rendersystem.register_scad_render(render)
    rendersystem.register_imagemagick_sequence("docs/renders/band_instruction.png", png_files)

def register_band_tool_assembly(rendersystem):
    input_file = "rendering/band_tool_assembly.scad"
    camera = Camera(position=[-13, 13, 30], angle=[76, 0, 216], distance=445)
    imgsize = [1200, 2400]
    png_files = []

    for frame in [1, 2]:
        output_file = f"docs/renders/band_tool_assembly{frame}.png"
        scad = f"render_band_tool_assembly({frame});"
        png_files.append(output_file)
        render = ScadRender(output_file, input_file, scad, imgsize, camera)
        rendersystem.register_scad_render(render)


def register_brim_and_ties(rendersystem):
    input_file = "rendering/brim_and_ties.scad"
    cameras = [
        Camera(position=[9.7, 33, 6], angle=[45.2, 0, 315.2], distance=361),
        Camera(position=[-4, 21, 29], angle=[206, 0, 177], distance=450),
        Camera(position=[-2, 48, -12], angle=[60, 0, 4], distance=320),
    ] 
    imgsize = [2400, 2400]
    for i, camera in enumerate(cameras):
        output_file = f"docs/renders/brim_and_ties{i+1}.png"
        scad = f"render_brim_and_ties({i+1});"
        render = ScadRender(output_file, input_file, scad, imgsize, camera)
        rendersystem.register_scad_render(render)

def register_brim_and_ties_separate_z_actuator(rendersystem):
    input_file = "rendering/brim_and_ties_separate_z_actuator.scad"
    cameras = [
        Camera(position=[-4, 37, 34], angle=[57, 0, 315], distance=264),
        Camera(position=[0, 42, 17], angle=[206, 0, 180], distance=264),
    ] 
    imgsize = [2400, 2400]
    for i, camera in enumerate(cameras):
        output_file = f"docs/renders/brim_and_ties_separate_z{i+1}.png"
        scad = f"render_brim_and_ties_separate_z_actuator({i+1});"
        render = ScadRender(output_file, input_file, scad, imgsize, camera)
        rendersystem.register_scad_render(render)

def register_prepare_main_body(rendersystem):
    input_file = "rendering/prepare_main_body.scad"
    cameras = [
        Camera(position=[-8, 7, 63], angle=[50, 0, 234], distance=263),
        Camera(position=[-11, 0, 77], angle=[84, 0, 222], distance=155),
        Camera(position=[-11, 0, 77], angle=[84, 0, 222], distance=155),
        Camera(position=[-8, 7, 63], angle=[50, 0, 234], distance=263),
        Camera(position=[-8, 7, 63], angle=[50, 0, 234], distance=263),
        Camera(position=[-8, 7, 63], angle=[50, 0, 234], distance=263),
        Camera(position=[-2, 57, 64], angle=[76, 0, 176.5], distance=179),
        Camera(position=[-2, 57, 64], angle=[76, 0, 176.5], distance=179),
        Camera(position=[-2, 57, 64], angle=[76, 0, 176.5], distance=179),
    ]
    imgsize = [2400, 2000]
    for i, camera in enumerate(cameras):
        output_file = f"docs/renders/prepare_main_body{i+1}.png"
        scad = f"render_prepare_main_body({i+1});"
        render = ScadRender(output_file, input_file, scad, imgsize, camera)
        rendersystem.register_scad_render(render)

def register_prepare_stand(rendersystem):
    input_file = "rendering/prepare_stand.scad"
    cameras = [
        Camera(position=[15, 26, 41.5], angle=[47, 0, 111], distance=450),
        Camera(position=[-9, 20, 37.5], angle=[34, 0, 235], distance=450),
        Camera(position=[-9, 20, 37.5], angle=[34, 0, 235], distance=450),
        Camera(position=[-9, 20, 37.5], angle=[34, 0, 235], distance=450),
        Camera(position=[-9, 20, 37.5], angle=[34, 0, 235], distance=450),
        Camera(position=[-9, 20, 37.5], angle=[34, 0, 235], distance=450),
        Camera(position=[-9, 20, 37.5], angle=[34, 0, 235], distance=450),
        Camera(position=[75, 52, 32], angle=[65, 0, 115], distance=240),
        Camera(position=[75, 52, 32], angle=[65, 0, 115], distance=240),
    ]
    imgsize = [2400, 2000]
    for i, camera in enumerate(cameras):
        output_file = f"docs/renders/prepare_stand{i+1}.png"
        scad = f"render_prepare_stand({i+1});"
        render = ScadRender(output_file, input_file, scad, imgsize, camera)
        rendersystem.register_scad_render(render)

def register_actuator_assembly(rendersystem):
    input_file = "rendering/actuator_assembly.scad"
    cameras = [
        Camera(position=[2, 5, 14], angle=[33, 0, 242], distance=360),
        Camera(position=[4, 35, 35], angle=[71, 0, 186], distance=330),
        Camera(position=[4, 35, 35], angle=[71, 0, 186], distance=330),
        Camera(position=[4, 35, 35], angle=[71, 0, 186], distance=330),
        Camera(position=[20, 6, 35], angle=[82, 0, 166], distance=500),
        Camera(position=[4, 35, 35], angle=[71, 0, 186], distance=330),
        Camera(position=[4, 35, 35], angle=[71, 0, 186], distance=330),
        Camera(position=[0, 50, 30], angle=[62, 0, 145], distance=260),
    ]
    imgsize = [2400, 2000]
    pngs = [
        "actuator_assembly_parts.png",
        "actuator_assembly_nut.png",
        "actuator_assembly_gear.png",
        "actuator_assembly_gear2.png",
        "actuator_assembly_oil.png",
        "actuator_assembly_x.png",
        "actuators_assembled.png",
        "separate_z_actuator_assembled.png",
    ]
    for i, camera in enumerate(cameras):
        output_file = os.path.join("docs/renders/", pngs[i])
        scad = f"render_actuator_assembly({i+1});"
        render = ScadRender(output_file, input_file, scad, imgsize, camera)
        rendersystem.register_scad_render(render)

def register_picam(rendersystem):
    input_file = "rendering/prepare_picamera.scad"
    cameras = [
        Camera(position=[-6, 3, 11], angle=[46, 0, 90], distance=140),
        Camera(position=[0, 0, 0], angle=[29, 0, 90], distance=140),
        Camera(position=[1, 18, 8], angle=[52, 0, 90], distance=140),
    ]
    imgsize = [2400, 2000]
    for i, camera in enumerate(cameras):
        frame = i + 1
        output_file = f"docs/renders/picam{frame}.png"
        scad = f"render_picamera_frame(picam_frame_parameters({frame}));"
        render = ScadRender(output_file, input_file, scad, imgsize, camera)
        rendersystem.register_scad_render(render)

def register_mount_optics(rendersystem):
    input_file = "rendering/mount_optics.scad"
    cameras = [
        Camera(position=[9.6, 7, -14.5], angle=[103.5, 0, 66], distance=495),
        Camera(position=[7.75, 37, -3], angle=[135.5, 0, 32.5], distance=495),
        Camera(position=[7.75, 37, -3], angle=[135.5, 0, 32.5], distance=495),
        Camera(position=[7.75, 37, -3], angle=[135.5, 0, 32.5], distance=495),
        Camera(position=[-18.5, 42.75, 23.75], angle=[57, 0, 143], distance=495),
        Camera(position=[-18.5, 42.75, 23.75], angle=[57, 0, 143], distance=495),
        Camera(position=[-18.5, 42.75, 23.75], angle=[57, 0, 143], distance=495),
        Camera(position=[-18.5, 42.75, 23.75], angle=[57, 0, 143], distance=495),
    ]
    imgsize = [2400, 2000]
    for optics_version in ["rms", "low_cost", "upright"]:
        for i, camera in enumerate(cameras):
            frame = i + 1
            output_file = f"docs/renders/mount_optics_{optics_version}{frame}.png"
            scad = f"render_mount_optics({frame}, \"{optics_version}\");"
            render = ScadRender(output_file, input_file, scad, imgsize, camera)
            rendersystem.register_scad_render(render)

def register_mount_upright_optics(rendersystem):
    input_file = "rendering/mount_upright_optics.scad"
    cameras = [
        Camera(position=[-42, 76, 130], angle=[55, 0, 58], distance=495),
        Camera(position=[-42, 76, 130], angle=[55, 0, 58], distance=495),
        Camera(position=[-42, 76, 130], angle=[55, 0, 58], distance=495),
        Camera(position=[-42, 76, 130], angle=[55, 0, 58], distance=495),
        Camera(position=[-42, 76, 130], angle=[55, 0, 58], distance=495),
        Camera(position=[-42, 76, 130], angle=[55, 0, 58], distance=495),
        Camera(position=[-42, 76, 130], angle=[55, 0, 58], distance=495),
    ]
    imgsize = [2400, 2000]
    for i, camera in enumerate(cameras):
        frame = i + 1
        output_file = f"docs/renders/mount_upright_optics{frame}.png"
        scad = f"render_mount_upright_optics({frame}, optics_version=\"upright\");"
        render = ScadRender(output_file, input_file, scad, imgsize, camera)
        rendersystem.register_scad_render(render)

def register_mount_microscope(rendersystem):
    input_file = "rendering/mount_microscope.scad"
    cameras = [
        Camera(position=[24, 43.5, 84], angle=[65.5, 0, 103], distance=550),
        Camera(position=[24, 43.5, 84], angle=[65.5, 0, 103], distance=550),
    ]
    imgsize = [2400, 2000]
    for optics_version in ["rms", "low_cost", "upright"]:
        for i, camera in enumerate(cameras):
            frame = i + 1
            output_file = f"docs/renders/mount_microscope_{optics_version}{frame}.png"
            scad = f"render_mount_microscope({frame}, \"{optics_version}\");"
            render = ScadRender(output_file, input_file, scad, imgsize, camera)
            rendersystem.register_scad_render(render)

def register_mount_illumination(rendersystem):
    input_file = "rendering/mount_illumination.scad"
    imgsize = [2400, 2000]
    for optics_version in ["rms", "low_cost", "upright"]:
        if optics_version == "upright":
            cameras = [
                Camera(position=[0, 50, 180], angle=[68, 0, 133], distance=360),
                Camera(position=[0, 50, 180], angle=[68, 0, 133], distance=360),
                Camera(position=[0, 50, 180], angle=[60, 0, 133], distance=460),
                Camera(position=[0, 50, 180], angle=[60, 0, 133], distance=460),
            ]
        else:
            cameras = [
                Camera(position=[-6, 49, 178], angle=[68, 0, 133], distance=360),
                Camera(position=[-6, 49, 178], angle=[68, 0, 133], distance=360),
                Camera(position=[-6, 49, 178], angle=[60, 0, 308], distance=460),
                Camera(position=[-6, 49, 178], angle=[82, 0, 308], distance=360),
                Camera(position=[-6, 49, 178], angle=[82, 0, 308], distance=360),
                Camera(position=[-6, 49, 178], angle=[82, 0, 308], distance=360)
            ]
        for i, camera in enumerate(cameras):
            frame = i + 1
            output_file = f"docs/renders/mount_illumination_{optics_version}{frame}.png"
            scad = f"mount_illumination({frame}, \"{optics_version}\");"
            render = ScadRender(output_file, input_file, scad, imgsize, camera)
            rendersystem.register_scad_render(render)

def register_motor_assembly(rendersystem):
    input_file = "rendering/motor_assembly.scad"
    camera = Camera(position=[-35, 35, 13], angle=[247, 0, 232], distance=293)
    imgsize = [1200, 2000]
    for i in [1, 2]:
        output_file = f"docs/renders/motor_assembly{i}.png"
        scad = f"motor_assembly({i});"
        render = ScadRender(output_file, input_file, scad, imgsize, camera)
        rendersystem.register_scad_render(render)
    ## close up view of frame 2
    camera = Camera(position=[3,1.5,-3], angle=[230,0,120], distance=60)
    imgsize = [1200, 1200]
    output_file = "docs/renders/motor_assembly3.png"
    scad = "motor_assembly(2);"
    render = ScadRender(output_file, input_file, scad, imgsize, camera)
    rendersystem.register_scad_render(render)

def register_mount_motors(rendersystem):
    input_file = "rendering/mount_motors.scad"
    camera = Camera(position=[22, 35, 98], angle=[53, 0, 115], distance=360)
    imgsize = [2400, 2000]
    for optics_version in ["rms", "low_cost", "upright"]:
        for i in [1, 2, 3, 4]:
            if optics_version == "upright" and i > 2 :
                camera = Camera(position=[5, 30, 121], angle=[70, 0, 150], distance=360)
            output_file = f"docs/renders/mount_motors_{optics_version}{i}.png"
            scad = f"render_mount_motors({i}, \"{optics_version}\");"
            render = ScadRender(output_file, input_file, scad, imgsize, camera)
            rendersystem.register_scad_render(render)

def register_mount_sample_clips(rendersystem):
    input_file = "rendering/mount_sample_clips.scad"
    camera = Camera(position=[0, 0, 178], angle=[68, 0, 308], distance=250)
    imgsize = [2400, 2000]
    for optics_version in ["rms", "low_cost", "upright"]:
        for i in [1, 2, 3, 4]:
            output_file = f"docs/renders/mount_sample_clips_{optics}{i}.png"
            scad = f"render_mount_sample_clips({i}, {low_cost});"
            render = ScadRender(output_file, input_file, scad, imgsize, camera)
            rendersystem.register_scad_render(render)

def register_prepare_pi_and_sangaboard(rendersystem):
    input_file = "rendering/prepare_pi_and_sangaboard.scad"
    cameras = [
        Camera(position=[18.5, 20, 7], angle=[80, 0, 300], distance=190),
        Camera(position=[18.5, 20, 7], angle=[80, 0, 300], distance=190),
        Camera(position=[30, 18, 9], angle=[35, 0, 340], distance=190),
    ]
    imgsize = [2400, 2000]
    for i, camera in enumerate(cameras):
        output_file = f"docs/renders/prepare_pi_and_sangaboard{i+1}.png"
        scad = f"prepare_pi_and_sangaboard({i+1});"
        render = ScadRender(output_file, input_file, scad, imgsize, camera)
        rendersystem.register_scad_render(render)

def register_mount_electronics(rendersystem):
    input_file = "rendering/mount_electronics.scad"
    cameras = [
        Camera(position=[35, 110, 36], angle=[70, 0, 270], distance=270),
        Camera(position=[35, 110, 36], angle=[70, 0, 270], distance=270),
        Camera(position=[35, 110, 36], angle=[70, 0, 270], distance=270),
        Camera(position=[35, 110, 36], angle=[70, 0, 270], distance=270),
        Camera(position=[35, 110, 36], angle=[70, 0, 270], distance=270),
        Camera(position=[35, 110, 36], angle=[70, 0, 270], distance=270),
        Camera(position=[35, 110, 36], angle=[70, 0, 270], distance=270),
        Camera(position=[35, 110, 36], angle=[70, 0, 270], distance=270),
        Camera(position=[35, 110, 36], angle=[70, 0, 270], distance=270),
        Camera(position=[35, 110, 36], angle=[70, 0, 270], distance=270),
        Camera(position=[35, 110, 36], angle=[70, 0, 270], distance=270),
        Camera(position=[35, 110, 36], angle=[70, 0, 270], distance=270),
        Camera(position=[68, 73, 34], angle=[65, 0, 115], distance=490),
        Camera(position=[68, 73, 34], angle=[65, 0, 115], distance=490),
        Camera(position=[68, 73, 34], angle=[65, 0, 115], distance=490),
        Camera(position=[68, 73, 34], angle=[65, 0, 115], distance=490),
    ]
    imgsize = [2000, 2000]
    for i, camera in enumerate(cameras):
        output_file = f"docs/renders/mount_electronics{i+1}.png"
        scad = f"render_mount_electronics({i+1},low_cost=false);"
        render = ScadRender(output_file, input_file, scad, imgsize, camera)
        rendersystem.register_scad_render(render)

def register_complete_microscope(rendersystem):
    input_file = "rendering/complete_microscope.scad"
    imgsize = [2400, 2000]
    for optics_version in ["rms", "low_cost", "upright"]:
        if optics_version == "upright":
            cameras = [
                Camera(position=[0, 48, 98], angle=[65, 0, 133], distance=780),
                Camera(position=[0, 48, 98], angle=[65, 0, 308], distance=780),
                Camera(position=[0, 48, 98], angle=[90, 0, 90], distance=780),
                Camera(position=[0, 48, 98], angle=[90, 0, 0], distance=780),
            ]
        else:
            cameras = [
                Camera(position=[0, 48, 98], angle=[65, 0, 133], distance=700),
                Camera(position=[0, 48, 98], angle=[65, 0, 308], distance=700),
                Camera(position=[0, 48, 98], angle=[90, 0, 90], distance=700),
                Camera(position=[0, 48, 98], angle=[90, 0, 0], distance=700),
            ]
        for i, camera in enumerate(cameras):
            output_file = f"docs/renders/complete_microscope_{optics_version}{i}.png"
            scad = f"render_complete_microscope(\"{optics_version}\");"
            render = ScadRender(output_file, input_file, scad, imgsize, camera)
            rendersystem.register_scad_render(render)

def main():
    rendersystem = RenderSystem()
    rendersystem.register_zip_assets('rendering/librender/hardware.zip')
    rendersystem.register_render_stl('rendering/librender/rendered_main_body.scad')
    rendersystem.register_render_stl('rendering/librender/rendered_separate_z_actuator.scad')
    #Register all openscad renders (and associated post processing)
    register_rms_optics_assembly(rendersystem)
    register_low_cost_optics_assembly(rendersystem)
    register_condenser_assembly(rendersystem)
    register_upright_condenser_assembly(rendersystem)
    register_workaround_5mm_led(rendersystem)
    register_optics_assembled(rendersystem)
    register_band(rendersystem)
    register_brim_and_ties(rendersystem)
    register_brim_and_ties_separate_z_actuator(rendersystem)
    register_prepare_main_body(rendersystem)
    register_prepare_stand(rendersystem)
    register_actuator_assembly(rendersystem)
    register_band_tool_assembly(rendersystem)
    register_picam(rendersystem)
    register_mount_optics(rendersystem)
    register_mount_upright_optics(rendersystem)
    register_mount_microscope(rendersystem)
    register_mount_illumination(rendersystem)
    register_motor_assembly(rendersystem)
    register_mount_motors(rendersystem)
    register_mount_sample_clips(rendersystem)
    register_prepare_pi_and_sangaboard(rendersystem)
    register_mount_electronics(rendersystem)
    register_complete_microscope(rendersystem)

    rendersystem.render()

if __name__ == "__main__":
    main()
