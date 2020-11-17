#!/usr/bin/env python3

'''
This is the main build script for the open flexure microscope. Run
`./build.py -h` to see options.

The selection for which STLs are generated is in build_system/stl_generator
The options for the STL selector are in build_system/stl_options
The selection for which extra STLs are copied in is in build_system/stl_copy
'''

import argparse
import sys
from ninja import ninja
from build_system.writer import MicroscopeBuildWriter
from build_system.stl_generator import add_stls_to_writer
from build_system.stl_copy import add_extra_stls_to_writer

parser = argparse.ArgumentParser(
    description="Run the OpenSCAD build for the Openflexure Microscope."
)
parser.add_argument(
    "--generate-stl-options-json",
    help="Generate a JSON file for the web STL selector.",
    action="store_true",
)
parser.add_argument(
    "--include-extra-files",
    help="Copy over STL files from openflexure-microscope-extra/ into the builds/ folder.",
    action="store_true",
)
args = parser.parse_args()

# Use ninja to write a build.ninja file which specifies all the STLs to build
with MicroscopeBuildWriter("builds", "build.ninja", args.generate_stl_options_json) as mbw:
    # Generate basic STL files
    add_stls_to_writer(mbw)
    # Include extra STL files
    if args.include_extra_files:
        add_extra_stls_to_writer(mbw)

# Run the "ninja.build" file we just created, to generate STLs
sys.argv = [sys.argv[0]]
ninja()