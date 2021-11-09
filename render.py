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
    rendersystem.register_inkscape_annotation(
        "docs/renders/optics_assembly_tube_lens.png",
        "rendering/annotations/annotate_optics_assembly_tube_lens.svg"
    )

def register_optics_assembly_condenser_lens(rendersystem):
    input_file = "rendering/optics_assembly.scad"
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


def register_brim_and_ties(rendersystem):
    input_file = "rendering/brim_and_ties.scad"
    cameras = [
        Camera(position=[9.7, 33, 6], angle=[45.2, 0, 315.2], distance=361),
        Camera(position=[-4, 21, 29], angle=[206, 0, 177], distance=450),
    ]
    imgsize = [2400, 2400]
    for i, camera in enumerate(cameras):
        output_file = f"docs/renders/brim_and_ties{i+1}.png"
        scad = "render_brim_and_ties();"
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


def register_cable_management(rendersystem):
    input_file = "rendering/cable_management.scad"
    camera = Camera(position=[8, -8, 8], angle=[69, 0, 190], distance=440)
    imgsize = [2400, 2000]
    output_file = "docs/renders/cable_management.png"
    scad = "render_cable_management();"
    render = ScadRender(output_file, input_file, scad, imgsize, camera)
    rendersystem.register_scad_render(render)

def main():
    rendersystem = RenderSystem()
    rendersystem.register_zip_assets('rendering/librender/hardware.zip')

    #Register all openscad renders (and associated post processing)
    register_rms_optics_assembly(rendersystem)
    register_optics_assembly_condenser_lens(rendersystem)
    register_optics_assembled(rendersystem)
    register_band(rendersystem)
    register_brim_and_ties(rendersystem)
    register_actuator_assembly(rendersystem)
    register_picam(rendersystem)
    register_cable_management(rendersystem)

    rendersystem.render()

if __name__ == "__main__":
    main()
