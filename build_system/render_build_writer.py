"""
In this submodule we create a class that writes a "render.ninja" file for the microscope renderings.
"""

import os

from .ninja_writer import NinjaWriter


class RenderBuildWriter(NinjaWriter):
    def __init__(self, build_filename):
        super().__init__(build_filename=build_filename)

    def __enter__(self, *_):
        super().__enter__()
        self._create_rules()
        return self

    def _create_rules(self):
        self.rule(
            "openscad_render",
            command="build_system/openscad_render.py $parameters $in -o $out -d $out.d",
            depfile="$out.d",
        )
        self.rule("imagemagick_append", command="convert $in +append $out")

    def openscad_render(self, output, input_file, parameters=None):
        self.build(
            output,
            rule="openscad_render",
            inputs=input_file,
            variables={"parameters": parameters},
        )

    def imagemagick_append(self, output, input_files):
        self.build(output, rule="imagemagick_append", inputs=input_files)
