#!/usr/bin/env python3
import sys
from ninja import _program
from build_system.ninja_writer import NinjaWriter

NINJA_FILE = "render.ninja"

with NinjaWriter(NINJA_FILE) as w:
    w.rule(
        "openscad_render",
        command=f"build_system/openscad_render.py $parameters $in -o $out -d $out.d",
        depfile="$out.d",
    )
    w.build(
        "docs/renders/picam1.png"
        rule="openscad_render",
        inputs="rendering/prepare_picamera.scad",
        variables={
            "parameters": '-D "FRAME=1;" --camera=-6,3,11,46,0,90,140 --imgsize=2400,2000'
        },
    )

_program("ninja", ["-f", NINJA_FILE] + sys.argv[1:])
