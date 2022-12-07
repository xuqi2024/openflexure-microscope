'''
In this submodule we create a class that writes a "build.ninja" file for building
the microscope STLs.
'''

import os
from ninja import Writer
from .util import parameters_to_string, get_openscad_exe

class NinjaWriter():
    '''
    A simple wrapper around `ninja.Writer` that allowes you to use `with`,
    e.g. `with NinjaWriter() as w:`
    '''
    def __init__(self, build_filename="build.ninja"):
        self._build_filename = build_filename
        self._build_file = None
        self._ninja = None

    def __enter__(self):
        # Create the ninja build file
        self._build_file = open(self._build_filename, "w")
        self._ninja = Writer(self._build_file, width=120)
        return self

    def __exit__(self, *_):
        # Close the Ninja build file
        self._build_file.close()

    def rule(self, *args, **kwargs):
        """
        See ninja.Writer.rule
        """
        self._ninja.rule(*args, **kwargs)

    def build(self, *args, **kwargs):
        """
        See ninja.Writer.rule
        """
        self._ninja.build(*args, **kwargs)


class MicroscopeBuildWriter(NinjaWriter):
    """
    A custom ninja writer for builing the microscope. This handles
    building openscad files
    """
    def __init__(
            self,
            build_dir,
            build_filename
        ):
        super().__init__(build_filename=build_filename)
        self._build_dir = build_dir

    def __enter__(self, *_):
        super().__enter__()
        self._create_rules()
        return self

    def _create_rules(self):
        executable = get_openscad_exe()
        self.rule(
            "openscad",
            command=f"{executable} --hardwarnings $parameters $in -o $out -d $out.d",
            depfile="$out.d",
        )

    def openscad(self, output, input_file, parameters=None):
        """
        Invokes ninja task generation using the 'openscad' rule. If
        --generate-stl-options-json is enabled it registers the stl and its
        parameters at this point.

        Arguments:
            output {str} -- file path of the output stl file
            input_file {str} -- file path of the input scad file
            parameters {dict} -- parameters passed to openscad using the `-D` switch
        """

        if parameters is None:
            parameters = {}

        if output.endswith(".stl"):
            output_csg = output[:-4] + ".csg"
        else:
            raise ValueError("OpenSCAD rules should output STL files ending with .stl")

        self.build(
            os.path.abspath(os.path.join(self._build_dir, output_csg)),
            rule="openscad",
            inputs=os.path.join("openscad/", input_file),
            variables={"parameters": parameters_to_string(parameters)},
        )
        self.build(
            os.path.join(self._build_dir, output),
            rule="openscad",
            inputs=os.path.join(self._build_dir, output_csg),
        )
