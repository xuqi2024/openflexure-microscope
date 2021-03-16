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
        return ','.join([str(i) for i in combined])

def format_render_params(camera, imgsize, frame=None):
    imgsize_str = ','.join([str(i) for i in imgsize])
    params = f"--camera={camera.as_string()} --imgsize={imgsize_str}"
    if frame is not None:
        params += f" -D 'FRAME={frame};'"
    return params

def generate_optics_assembly(writer):
    camera = Camera(position=[29, 0, 59], angle=[69, 0, 90], distance=290)
    for frame in [1, 2, 3]:
        writer.openscad_render(
            f"rendering/annotations/optics_assembly_tube_lens{frame}.png",
            input_file="rendering/rms_optics_assembly.scad",
            parameters= format_render_params(camera, imgsize=[1000,2000], frame=frame)
        )

def generate_picam(writer):
    camera = Camera(position=[-6,3,11], angle=[46,0,90], distance=140)
    for frame in [1, 2, 3]:
        writer.openscad_render(
            f"docs/renders/picam{frame}.png",
            input_file="rendering/prepare_picamera.scad",
            parameters=format_render_params(camera, imgsize=[2400,2000], frame=frame)
        )

with RenderBuildWriter(build_filename=NINJA_FILE) as rbw:
    generate_optics_assembly(rbw)
    generate_picam(rbw)

_program("ninja", ["-f", NINJA_FILE] + sys.argv[1:])
