'''
In this submodule we create a class that writes a "ninja.build" file for the microscope STLs.
'''

import os

from .util import parameters_to_string, get_openscad_exe
from .json_generator import JsonGenerator
from .stl_options import stl_presets, option_docs, required_stls
from .ninja_writer import NinjaWriter

class MicroscopeBuildWriter(NinjaWriter):
    def __init__(self, build_dir, build_filename, generate_stl_options_json=False):
        super().__init__(build_filename=build_filename)
        self._build_dir = build_dir
        if generate_stl_options_json:
            self._json_generator = JsonGenerator(build_dir, option_docs, stl_presets, required_stls)
        else:
            self._json_generator = None

    def __enter__(self, *_):
        super().__enter__()
        self._create_rules()
        return self

    def __exit__(self, *_):
        if self._json_generator is not None:
            self._json_generator.write()
        super().__exit__()

    def _create_rules(self):
        executable = get_openscad_exe()
        self.rule(
            "openscad",
            command=f"{executable} --hardwarnings $parameters $in -o $out -d $out.d",
            depfile="$out.d",
        )
        self.rule("copy", command="cp $in $out")

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
            select_stl_if {dict}|{list}|string -- parameters that when set to the
                values given mean selecting this stl when making a specific
                variant. using a list means or-ing the combinations listed.
                leaving this empty means the stl will never be selected and
                setting it to "alays" means it will always be selected.
        """

        if parameters is None:
            parameters = {}

        if self._json_generator is not None:
            self._json_generator.register(
                output,
                input_file,
                select_stl_if=select_stl_if,
            )

        self.build(
            os.path.join(self._build_dir, output),
            rule="openscad",
            inputs=os.path.join("openscad/", input_file),
            variables={
                "parameters": parameters_to_string(parameters)
                },
        )

    def copy_stl(self, stl_file, select_stl_if=None):
        if self._json_generator is not None:
            self._json_generator.register(
                output=stl_file, input_file=stl_file, select_stl_if=select_stl_if
            )
        output = os.path.join(self._build_dir, stl_file)
        input_file = os.path.join("openflexure-microscope-extra", stl_file)
        self.build(output, rule="copy", inputs=input_file)
