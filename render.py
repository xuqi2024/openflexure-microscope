#!/usr/bin/env python3

'''
This script produces all the documentation renders for the OpenFlexure microscope.
'''

import sys
import os
import subprocess
from ninja import BIN_DIR
from build_system.render_build_writer import RenderBuildWriter, Camera


NINJA_FILE = "render.ninja"

# Disable missing docstrings in this file as they explain exactly what they generate
# pylint: disable=missing-function-docstring

def generate_optics_assembly_tube_lens(writer):
    input_file = "rendering/rms_optics_assembly.scad"
    camera = Camera(position=[29, 0, 59], angle=[69, 0, 90], distance=290)
    imgsize = imgsize = [1000, 2000]

    for frame in [1, 2, 3]:
        output_file = f"rendering/annotations/optics_assembly_tube_lens{frame}.png"
        writer.openscad_render(output_file, input_file, camera, imgsize, frame)


def generate_optics_assembly_camera(writer):
    input_file = "rendering/rms_optics_assembly.scad"
    camera = Camera(position=[7, -14, -21], angle=[247, 0, 211], distance=250)
    imgsize = [1200, 2000]
    png_files = []

    for frame in [1, 2]:
        output_file = f"docs/renders/optics_assembly_camera{frame}.png"
        png_files.append(output_file)
        writer.openscad_render(
            output_file, input_file, camera, imgsize, frame=frame + 3
        )

    writer.imagemagick_sequence("docs/renders/optics_assembly_camera.png", png_files)


def generate_optics_assembly_objective(writer):
    input_file = "rendering/rms_optics_assembly.scad"
    camera = Camera(position=[2, 2, 25], angle=[55, 0, 90], distance=290)
    imgsize = [1200, 2000]
    png_files = []

    for frame in [1, 2]:
        output_file = f"docs/renders/optics_assembly_objective{frame}.png"
        png_files.append(output_file)
        writer.openscad_render(
            output_file, input_file, camera, imgsize, frame=frame + 5
        )

    writer.imagemagick_sequence("docs/renders/optics_assembly_objective.png", png_files)


def generate_optics_assembly_screw(writer):
    input_file = "rendering/rms_optics_assembly.scad"
    camera = Camera(position=[-6.5, 14, 38], angle=[60, 0, 243], distance=290)
    imgsize = [1000, 2000]
    png_files = []

    for frame in [1, 2, 3]:
        output_file = f"docs/renders/optics_assembly_screw{frame}.png"
        png_files.append(output_file)
        writer.openscad_render(
            output_file, input_file, camera, imgsize, frame=frame + 7
        )

    writer.imagemagick_sequence("docs/renders/optics_assembly_screw.png", png_files)


def generate_optics_assembly_condenser_lens(writer):
    input_file = "rendering/optics_assembly.scad"
    camera = Camera(position=[29, 0, 59], angle=[69, 0, 90], distance=290)
    imgsize = [1000, 2000]

    for frame in [1, 2, 3]:
        output_file = f"rendering/annotations/optics_assembly_condenser_lens{frame}.png"
        writer.openscad_render(output_file, input_file, camera, imgsize, frame)


def generate_optics_assembled(writer):
    input_file = "rendering/optics_assembly.scad"
    camera = Camera(position=[30, 5, 60], angle=[90, 0, 110], distance=440)
    output_file = "docs/renders/optics_assembled.png"
    imgsize = [1200, 2400]
    frame = 4
    writer.openscad_render(output_file, input_file, camera, imgsize, frame)


def generate_band(writer):
    input_file = "rendering/band_insertion_cutaway.scad"
    camera = Camera(position=[-13, 13, -30], angle=[76, 0, 216], distance=445)
    imgsize = [1200, 2400]
    png_files = []

    for frame in [1, 2, 3, 4, 5]:
        output_file = f"docs/renders/band{frame}.png"
        png_files.append(output_file)
        writer.openscad_render(output_file, input_file, camera, imgsize, frame)

    writer.imagemagick_sequence("docs/renders/band_instruction.png", png_files)


def generate_brim_and_ties(writer):
    input_file = "rendering/brim_and_ties.scad"
    cameras = [
        Camera(position=[5, 22, 28], angle=[50, 0, 135], distance=365),
        Camera(position=[-4, 21, 29], angle=[206, 0, 177], distance=450),
    ]
    imgsize = [2400, 2400]
    for i, camera in enumerate(cameras):
        frame = i + 1
        output_file = f"docs/renders/brim_and_ties{frame}.png"
        writer.openscad_render(output_file, input_file, camera, imgsize, frame)


def generate_actuator_assembly(writer):
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
        writer.openscad_render(output_file, input_file, camera, imgsize, frame=i + 1)


def generate_picam(writer):
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
        writer.openscad_render(output_file, input_file, camera, imgsize, frame)


def generate_cable_management(writer):
    input_file = "rendering/cable_management.scad"
    camera = Camera(position=[8, -8, 8], angle=[69, 0, 190], distance=440)
    imgsize = [2400, 2000]
    output_file = "docs/renders/cable_management.png"
    writer.openscad_render(output_file, input_file, camera, imgsize)


with RenderBuildWriter(build_filename=NINJA_FILE) as rbw:
    generate_optics_assembly_tube_lens(rbw)
    generate_optics_assembly_camera(rbw)
    generate_optics_assembly_objective(rbw)
    generate_optics_assembly_screw(rbw)
    generate_optics_assembly_condenser_lens(rbw)
    generate_optics_assembled(rbw)
    generate_band(rbw)
    generate_brim_and_ties(rbw)
    generate_actuator_assembly(rbw)
    generate_picam(rbw)

subprocess.run(
    ["unzip", "-o", "-d", "rendering/librender/", "rendering/librender/hardware.zip"],
    check=True,
)


subprocess.run(
    [os.path.join(BIN_DIR, "ninja"), "-f", NINJA_FILE] + sys.argv[1:], check=True
)


# inkscape annotations, make sure the SVGs use relative links. we don't use
# ninja for these because it's pretty fast and it's too much work to figure out
# the build dependencies of the SVGs
subprocess.run(
    [
        "inkscape",
        "--without-gui",
        "--export-png=docs/renders/optics_assembly_tube_lens.png",
        "rendering/annotations/annotate_optics_assembly_tube_lens.svg",
    ],
    check=True,
)
subprocess.run(
    [
        "inkscape",
        "--without-gui",
        "--export-png=docs/renders/optics_assembly_condenser_lens.png",
        "rendering/annotations/annotate_optics_assembly_condenser_lens.svg",
    ],
    check=True,
)
