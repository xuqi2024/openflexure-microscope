"""
In this submodule we create a class that writes a "render.ninja" file for the microscope renderings.
"""

from dataclasses import dataclass

from .ninja_writer import NinjaWriter



@dataclass
class Camera:
    """Data class to handle the OpenSCAD camera parameters"""

    position: list = (0, 0, 0)
    angle: list = (0, 0, 0)
    distance: float = 240

    def as_string(self):
        combined = list(self.position) + list(self.angle) + [self.distance]
        return ",".join([str(i) for i in combined])


def format_render_params(camera, imgsize, frame=None):
    imgsize_str = ",".join([str(i) for i in imgsize])
    params = f"--camera={camera.as_string()} --imgsize={imgsize_str}"
    if frame is not None:
        params += f" -D 'FRAME={frame};'"
    return params


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
            command="build_system/openscad_render.py $parameters $in -o '$out' -d '$out.d'",
            depfile="$out.d",
        )
        self.rule("imagemagick_sequence", command="convert $in +append '$out'")

    def openscad_render(self, output, input_file, camera, imgsize, frame=None):
        self.build(
            output,
            rule="openscad_render",
            inputs=input_file,
            variables={"parameters": format_render_params(camera, imgsize, frame)},
        )

    def imagemagick_sequence(self, output, input_files):
        self.build(output, rule="imagemagick_sequence", inputs=input_files)
