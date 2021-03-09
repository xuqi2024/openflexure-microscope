#!/usr/bin/env python3
import sys
from ninja import _program
from build_system.render_build_writer import RenderBuildWriter

NINJA_FILE = "render.ninja"

with RenderBuildWriter(build_filename=NINJA_FILE) as rbw:
    rbw.openscad_render(
        "docs/renders/picam1.png",
        input_file="rendering/prepare_picamera.scad",
        parameters='-D "FRAME=1;" --camera=-6,3,11,46,0,90,140 --imgsize=2400,2000',
    )

_program("ninja", ["-f", NINJA_FILE] + sys.argv[1:])
