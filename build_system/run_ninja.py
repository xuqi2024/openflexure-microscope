
import sys
import os
from ninja import Writer

from .util import parameters_to_string
from .json_generator import JsonGenerator
from .stl_options import stl_presets, option_docs, required_stls
from .stl_generator import generate_stls
from .stl_copy import copy_extra_stls


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
        self._build_file = open(self._build_filename, "w")
        self._ninja = Writer(self._build_file, width=120)
        self._create_rules()
        return self

    def __exit__(self, *args, **kwargs):
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

    def generate(self, include_extra_files):
        if self._ninja is None:
            raise IOError("Build file has not been opened. Use MicroscopeBuildWriter as a context manager.")
        generate_stls(self)
        if include_extra_files:
            copy_extra_stls(self)
        if self._json_generator is not None:
            self._json_generator.write()

    def openscad(
        self,
        output,
        input_file,
        parameters=None,
        file_local_parameters=None,
        openscad_only_parameters=None,
        select_stl_if=None,
    ):
        """
        Invokes ninja task generation using the 'openscad' rule. If
        --generate-stl-options-json is enabled it registers the stl and its
        parameters at this point.

        Arguments:
            output {str} -- file path of the output stl file
            input_file {str} -- file path of the input scad file
            parameters {dict} -- values of globally used parameters
            file_local_parameters {dict} -- values of parameters only used for this specific scad file
            openscad_only_parameters {dict} -- values of parameters only used by openscad, ignored for stl selection
            select_stl_if {dict}|{list} -- values of parameters not used by openscad but relevant to selecting this stl when making a specific variant.
                                        Using a list means or-ing the combinations listed.
        """

        if parameters is None:
            parameters = {}
        if file_local_parameters is None:
            file_local_parameters = {}
        if openscad_only_parameters is None:
            openscad_only_parameters = {}
        if select_stl_if is None:
            select_stl_if = {}

        if self._json_generator is not None:
            self._json_generator.register(
                output,
                input_file,
                parameters=parameters,
                file_local_parameters=file_local_parameters,
                select_stl_if=select_stl_if,
            )

        self._ninja.build(
            os.path.join(self._build_dir, output),
            rule="openscad",
            inputs=os.path.join("openscad/", input_file),
            variables={
                "parameters": parameters_to_string(
                    {**parameters, **file_local_parameters, **openscad_only_parameters}
                )
            },
        )

    def copy_stl(self, stl_file, select_stl_if=None):
        if self._json_generator is not None:
            self._json_generator.register(
                output=stl_file, input_file=stl_file, select_stl_if=select_stl_if
            )
        output = os.path.join(self._build_dir, stl_file)
        input_file = os.path.join("openflexure-microscope-extra", stl_file)
        self._ninja.build(output, rule="copy", inputs=input_file)
