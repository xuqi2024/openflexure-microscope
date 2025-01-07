#!/usr/bin/env python3

"""
This is a script to create the stls used in creating the gltfs.
"""

# Function docstrings are fairly redundant in this file
# pylint: disable=missing-function-docstring

import os
import argparse
from build_system.openscad_render_system import RenderSystem, ScadRender, Camera
from build_system.util import version_string

def register_rendered_microscope_stl(rendersystem, force_clean):
    input_file = "rendering/librender/rendered_main_body.scad"
    version_str = version_string(force_clean)
    parameters = {"VERSION_STRING": version_str}
    rendersystem.register_render_stl(input_file, parameters)


def main():
    parser = argparse.ArgumentParser(
        description="Run OpenSCAD to create the assembly instruction renders."
    )
    parser.add_argument(
        "--force-clean",
        help="Ensures that the repo is clean before rendering",
        action="store_true",
    )
    args  = parser.parse_args()

    rendersystem = RenderSystem()
    rendersystem.register_zip_assets('rendering/librender/hardware.zip')
    register_rendered_microscope_stl(rendersystem, force_clean=args.force_clean)

    rendersystem.render()

if __name__ == "__main__":
    main()
