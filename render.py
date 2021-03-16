#!/usr/bin/env python3
import sys
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
    camera = Camera(position=[29, 0, 59], angle=[69, 0, 90], distance=290)
    input_file = "rendering/rms_optics_assembly.scad"
    for frame in [1, 2, 3]:
        output_file = f"rendering/annotations/optics_assembly_tube_lens{frame}.png"
        parameters = format_render_params(camera, imgsize=[1000, 2000], frame=frame)
        writer.openscad_render(
            output_file,
            input_file,
            parameters,
        )


def generate_optics_assembly_camera(writer):
    camera = Camera(position=[7, -14, -21], angle=[247, 0, 211], distance=250)
    input_file = "rendering/rms_optics_assembly.scad"
    for frame in [1, 2]:
        output_file = f"rendering/annotations/optics_assembly_camera{frame}.png"
        parameters = format_render_params(camera, imgsize=[1200, 2000], frame=frame + 3)
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
    generate_picam(rbw)

_program("ninja", ["-f", NINJA_FILE] + sys.argv[1:])
