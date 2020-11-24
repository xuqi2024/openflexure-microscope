'''
In this submodule we create a class that can writes and "ninja.build" file. There
is also a function "run_ninja()" which runs this file.
'''
import sys
import os
from ninja import Writer

from .util import parameters_to_string
from .json_generator import JsonGenerator
from .stl_options import stl_presets, option_docs, required_stls

class MicroscopeBuildWriter():
    def __init__(self, build_dir, build_filename, generate_stl_options_json=False):
        self._build_dir = build_dir
        self._build_filename = build_filename
        self._build_file = None
        self._ninja = None
        if generate_stl_options_json:
            self._json_generator = JsonGenerator(build_dir, option_docs, stl_presets, required_stls)
        else:
            self._json_generator = None

    def __enter__(self):
        # Create the ninja build file
        self._build_file = open(self._build_filename, "w")
        self._ninja = Writer(self._build_file, width=120)
        self._create_rules()
        return self

    def __exit__(self, *_):
        # Write to JSON file etc if needed
        if self._json_generator is not None:
            self._json_generator.write()
        # Close the Ninja build file
        self._build_file.close()

    def _create_rules(self):
        if sys.platform.startswith("darwin"):
            executable = "/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD"
        else:
            executable = "openscad"
        self._ninja.rule(
            "openscad",
            command=f"{executable} --hardwarnings $parameters $in -o $out -d $out.d",
            depfile="$out.d",
        )
        self._ninja.rule("copy", command="cp $in $out")

    def openscad(
        self,
        output,
        input_file,
        parameters=None,
        select_stl_if=None,
    ):
        """
        Invokes ninja task generation using the 'openscad' rule. If
        --generate-stl-options-json is enabled it registers the stl and its
        parameters at this point.

        Arguments:
            output {str} -- file path of the output stl file
            input_file {str} -- file path of the input scad file
            parameters {dict} -- parameters passed to openscad using the `-D` switch
            select_stl_if {dict}|{list} -- values of parameters not used by openscad but relevant to selecting this stl when making a specific variant.
                                        Using a list means or-ing the combinations listed.
        """

        if parameters is None:
            parameters = {}

        if self._json_generator is not None:
            self._json_generator.register(
                output,
                input_file,
                select_stl_if=select_stl_if,
            )

        self._ninja.build(
            os.path.join(self._build_dir, output),
            rule="openscad",
            inputs=os.path.join("openscad/", input_file),
            variables={
                "parameters": parameters_to_string(parameters)
                },
        )

