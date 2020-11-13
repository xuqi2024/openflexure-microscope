#!/usr/bin/env python3

'''
This is the main build script for the open flexure microscope. Run
`./build.py -h` to see options.

The selection for which STLs are generated is in build_stsyem/stl_generator
The options for the STL selector are in build_stsyem/stl_options
The selection for which extra STLs are coppied in is in build_stsyem/stl_copy
'''

import argparse
from build_system.run_ninja import MicroscopeBuildWriter, run_ninja

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

#Use ninja to write a build.ninja file which specifies all the STLs to build
with MicroscopeBuildWriter("builds", "build.ninja", args.generate_stl_options_json) as mbw:
    mbw.generate(args.include_extra_files)

# Run the "ninja.build" file we just created, to generate STLs
run_ninja()
