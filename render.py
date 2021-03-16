#!/usr/bin/env python3
import sys
import os
import subprocess
from dataclasses import dataclass
from ninja import _program
from build_system.render_build_writer import RenderBuildWriter

NINJA_FILE = "render.ninja"


@dataclass
class Camera:
    """Data class to handle the OpenSCAD camera parameters"""

    position: list = (0, 0, 0)
    angle: list = (0, 0, 0)
    distance: float = 240

    def as_string(self):
        combined = list(self.position) + list(self.angle) + [self.distance]
        return ",".join([str(i) for i in combined])


def format_render_params(camera, imgsize, frame=None):
    imgsize_str = ",".join([str(i) for i in imgsize])
    params = f"--camera={camera.as_string()} --imgsize={imgsize_str}"
    if frame is not None:
        params += f" -D 'FRAME={frame};'"
    return params


def generate_optics_assembly_tube_lens(writer):
    input_file = "rendering/rms_optics_assembly.scad"
    camera = Camera(position=[29, 0, 59], angle=[69, 0, 90], distance=290)
    for frame in [1, 2, 3]:
        output_file = f"rendering/annotations/optics_assembly_tube_lens{frame}.png"
        parameters = format_render_params(camera, imgsize=[1000, 2000], frame=frame)
        writer.openscad_render(
            output_file,
            input_file,
            parameters,
        )


def generate_optics_assembly_camera(writer):
    input_file = "rendering/rms_optics_assembly.scad"
    camera = Camera(position=[7, -14, -21], angle=[247, 0, 211], distance=250)
    png_files = []
    for frame in [1, 2]:
        output_file = f"docs/renders/optics_assembly_camera{frame}.png"
        png_files.append(output_file)
        parameters = format_render_params(camera, imgsize=[1200, 2000], frame=frame + 3)
        writer.openscad_render(
            output_file,
            input_file,
            parameters,
        )
    writer.imagemagick_append("docs/renders/optics_assembly_camera.png", png_files)


def generate_optics_assembly_objective(writer):
    input_file = "rendering/rms_optics_assembly.scad"
    camera = Camera(position=[2, 2, 25], angle=[55, 0, 90], distance=290)
    png_files = []
    for frame in [1, 2]:
        output_file = f"docs/renders/optics_assembly_objective{frame}.png"
        png_files.append(output_file)
        parameters = format_render_params(camera, imgsize=[1200, 2000], frame=frame + 5)
        writer.openscad_render(
            output_file,
            input_file,
            parameters,
        )
    writer.imagemagick_append("docs/renders/optics_assembly_objective.png", png_files)


def generate_optics_assembly_screw(writer):
    input_file = "rendering/rms_optics_assembly.scad"
    camera = Camera(position=[-6.5, 14, 38], angle=[60, 0, 243], distance=290)
    png_files = []
    for frame in [1, 2, 3]:
        output_file = f"docs/renders/optics_assembly_screw{frame}.png"
        png_files.append(output_file)
        parameters = format_render_params(camera, imgsize=[1000, 2000], frame=frame + 7)
        writer.openscad_render(
            output_file,
            input_file,
            parameters,
        )
    writer.imagemagick_append("docs/renders/optics_assembly_screw.png", png_files)


def generate_optics_assembly_condenser_lens(writer):
    input_file = "rendering/rms_optics_assembly.scad"
    camera = Camera(position=[29, 0, 59], angle=[69, 0, 90], distance=290)
    for frame in [1, 2, 3]:
        output_file = f"rendering/annotations/optics_assembly_condenser_lens{frame}.png"
        parameters = format_render_params(camera, imgsize=[1000, 2000], frame=frame)
        writer.openscad_render(
            output_file,
            input_file,
            parameters,
        )


def generate_optics_assembled(writer):
    input_file = "rendering/optics_assembly.scad"
    camera = Camera(position=[30, 5, 60], angle=[90, 0, 110], distance=440)
    output_file = "docs/renders/optics_assembled.png"
    parameters = format_render_params(camera, imgsize=[1200, 2400])
    writer.openscad_render(
        output_file,
        input_file,
        parameters,
    )


def generate_band(writer):
    input_file = "rendering/band_insertion_cutaway.scad"
    camera = Camera(position=[-13, 13, -30], angle=[76, 0, 216], distance=445)
    png_files = []
    for frame in [1, 2, 3, 4, 5]:
        output_file = f"docs/renders/band{frame}.png"
        png_files.append(output_file)
        parameters = format_render_params(camera, imgsize=[1200, 2400], frame=frame)
        writer.openscad_render(
            output_file,
            input_file,
            parameters,
        )
    writer.imagemagick_append("docs/renders/band_instruction.png", png_files)


def generate_brim_and_ties(writer):
    input_file = "rendering/brim_and_ties.scad"
    cameras = [
        Camera(position=[5, 22, 28], angle=[50, 0, 135], distance=365),
        Camera(position=[-4, 21, 29], angle=[206, 0, 177], distance=450),
    ]
    for i, camera in enumerate(cameras):
        frame = i + 1
        output_file = f"docs/renders/brim_and_ties{frame}.png"
        parameters = format_render_params(camera, imgsize=[2400, 2400], frame=frame)
        writer.openscad_render(
            output_file,
            input_file,
            parameters,
        )


def generate_actuator_assembly(writer):
    input_file = "rendering/actuator_assembly.scad"
    cameras = [
        Camera(position=[2, 5, 14], angle=[33, 0, 242], distance=360),
        Camera(position=[4, 35, 35], angle=[71, 0, 186], distance=330),
        Camera(position=[4, 35, 35], angle=[71, 0, 186], distance=330),
        Camera(position=[4, 35, 35], angle=[71, 0, 186], distance=330),
        Camera(position=[4, 35, 35], angle=[71, 0, 186], distance=330),
        Camera(position=[4, 35, 35], angle=[71, 0, 186], distance=330),
    ]
    pngs = [
        "actuator_assembly_parts.png",
        "actuator_assembly_nut.png",
        "actuator_assembly_gear.png",
        "actuator_assembly_gear2.png",
        "actuator_assembly_x.png",
        "actuators_assembled.png",
    ]
    for i, camera in enumerate(cameras):
        output_file = os.path.join("docs/renders/", pngs[i])
        parameters = format_render_params(camera, imgsize=[2400, 2000], frame=i + 1)
        writer.openscad_render(
            output_file,
            input_file,
            parameters,
        )


def generate_picam(writer):
    camera = Camera(position=[-6, 3, 11], angle=[46, 0, 90], distance=140)
    input_file = "rendering/prepare_picamera.scad"
    for frame in [1, 2, 3]:
        output_file = f"docs/renders/picam{frame}.png"
        parameters = format_render_params(camera, imgsize=[2400, 2000], frame=frame)
        writer.openscad_render(
            output_file,
            input_file,
            parameters,
        )


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
    ["unzip", "-o", "-d", "rendering/librender/", "rendering/librender/hardware.zip"]
)

_program("ninja", ["-f", NINJA_FILE] + sys.argv[1:])
