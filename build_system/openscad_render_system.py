"""
A simple but fast render system for openscad which generated .scad files on the fly and uses
the openscad animation feature to speed up rendering similar frames.
"""

import subprocess
import sys
import shutil
import re
import os
import uuid
from dataclasses import dataclass
from tempfile import gettempdir
from .util import get_openscad_exe


@dataclass
class Camera:
    """Data class to handle the OpenSCAD camera parameters"""

    position: list = (0, 0, 0)
    angle: list = (0, 0, 0)
    distance: float = 240

    def as_string(self):
        """
        Combines all the camera paramters into a single string for the openscad cli
        """
        combined = list(self.position) + list(self.angle) + [self.distance]
        return ",".join([str(i) for i in combined])


class ScadRender():
    """
    Simple class to hold the data that defines an openscad render
    """
    def __init__(self, png_file, input_file, scad, imgsize, camera):
        self.png_file = png_file
        self.input_file = input_file
        self.scad = scad
        self.imgsize = tuple(imgsize)
        self.camera = camera
        self.rendered = False

def out_file(hash_name, i):
    return os.path.join(gettempdir(), f'frame{hash_name}-{i:05}.png')


class RenderSystem():
    """
    Class to handle openscad rendering. All renders and post processing are registered
    with a RenderSystem object. Once all steps are registered run RenderSystem.render()
    This will create the fewest number of OpenSCAD animations (one per each image size)
    allowing fast rendering based on caching.
    """
    def __init__(self):
        self._zip_assets = []
        self._renders = []
        self._imagemagick_sequences = []
        self._inkscape_annotations = []

    def register_zip_assets(self, zip_file):
        """
        Register a zip file that will be unpacked when RenderSystem.render() is run
        """
        self._zip_assets.append(zip_file)

    def register_scad_render(self, render):
        """
        Register an openscad render (ScadRender object) to be run when when RenderSystem.render() is run
        """
        self._renders.append(render)

    def register_imagemagick_sequence(self, outfile, input_files):
        """
        Register an image sequence (and output file and a list of input files).
        Each image in the sequence will be appended left to right with imagemagick once
        all openscad renders have been performed
        """
        self._imagemagick_sequences.append((outfile, input_files))

    def register_inkscape_annotation(self, outfile, svg_file):
        """
        Register an image sequence (and output file and a list of input files).
        Each image in the sequence will be appended left to right with imagemagick once
        all openscad renders have been performed
        """
        self._inkscape_annotations.append((outfile, svg_file))

    def render(self):
        """
        Run all registered render steps in the following order:
        1. Unpack zip assets
        2. Render pngs with Openscad
        3. Create sequences with imagemagick
        4. Annotate with inkscape
        """
        for zipfile in self._zip_assets:
            subprocess.run(
                ["unzip", "-o", "-d", os.path.dirname(zipfile), zipfile],
                check=True,
            )
        self._run_openscad()
        for outfile, input_files in self._imagemagick_sequences:
            subprocess.run(
                ['convert'] + input_files + ["+append", outfile],
                check=True,
                capture_output=True
            )
        for outfile, svg_file in self._inkscape_annotations:
            subprocess.run(
                ["inkscape", "--without-gui", f"--export-png={outfile}", svg_file],
                check=True,
                capture_output=True
            )


    def _run_openscad(self):
        tmpdir = gettempdir()
        tmpscad = os.path.join(tmpdir, 'scadfile.scad')
        #note that openscad will append 00000, 00001, etc to the name just before the extension
        sizes = {render.imgsize for render in self._renders}
        for size in sizes:
            renders = [render for render in self._renders if render.imgsize==size]
            while len(renders) > 0:
                hash_name = str(uuid.uuid4())
                output_template = os.path.join(tmpdir, f'frame{hash_name}-.png')
                n_renders = len(renders)
                scad = _create_scad_for_renders(renders)
                with open(tmpscad, 'w') as scadfile:
                    scadfile.write(scad)
                executable = get_openscad_exe()

                imgsize_str = ",".join([str(i) for i in size])
                imgsize_arg = f'--imgsize={imgsize_str}'
                #note we cannot use hardwarnings as we change the camera angle which always throws
                # a stupid warning see:
                # https://github.com/openscad/openscad/issues/3646
                # https://github.com/openscad/openscad/pull/3660/
                scad_args = ['--animate', str(n_renders), imgsize_arg, '-o', output_template]
                print(f"\nStarting OpenSCAD for images of size {imgsize_str}...\n\n")
                try:
                    ret = subprocess.run(
                        [executable, tmpscad] + scad_args,
                        check=True,
                        capture_output=True
                    )
                    std_err = ret.stderr.decode('UTF-8')
                    #All images are now rendered
                    for render in renders:
                        render.rendered = True
                except subprocess.CalledProcessError as error:
                    #If there is an error not all images were rendered
                    std_err = error.stderr.decode('UTF-8')
                    if "X Error of failed request" in std_err:
                        print("\n\nPartial fail due to Docker OpenGL issue. "
                              "Missing renders will be reggenerated\n\n")
                    else:
                        print(std_err)
                        raise

                print(std_err)
                warns = re.findall(r'^WARNING:.*?%', std_err, flags=re.MULTILINE)

                if warns != []:
                    if warns[0] != r'WARNING: Viewall and autocenter disabled in favor of $vp*':
                        sys.exit(1)

                rerender = _copy_renders(renders, hash_name)
                renders = rerender
                if len(renders)==n_renders:
                    RuntimeError("No renders produced for this job. Renders failed!")
                if len(renders)>0:
                    # Empty lines are not returned in gitlab CI.
                    # Using starts to make this line obvious
                    print(f"\n*\n*\nRe-rendering {len(renders)} of {n_renders}\n*\n*\n")

def _copy_renders(renders, hash_name):
    """
    Copy the output files from the temp directory to their desired location.
    """
    rerender = []
    for i, render in enumerate(renders):
        frame = out_file(hash_name, i)
        if os.path.exists(frame) and os.path.getsize(frame) > 10:
            copydir = os.path.dirname(render.png_file)
            os.makedirs(copydir, exist_ok=True)
            shutil.copy(frame, render.png_file)
        else:
            rerender.append(render)
    return rerender


def _create_scad_for_renders(renders):
    n_frames = len(renders)
    scad = ''
    inputs = {render.input_file for render in renders}
    for input_file in inputs:
        inputpath = os.path.join(os.getcwd(), input_file)
        scad += f'use <{inputpath}>\n'

    cameras = [render.camera for render in renders]
    pos_str = 'positions = ['
    angle_str = 'angles = ['
    dist_str = 'distances = ['
    for i, camera in enumerate(cameras):
        if i>0:
            pos_str += ',\n             '
            angle_str += ',\n          '
            dist_str += ', '
        pos_str += str(list(camera.position))
        angle_str += str(list(camera.angle))
        dist_str += str(camera.distance)
    pos_str += '];\n'
    angle_str += '];\n'
    dist_str += '];\n'

    scad += pos_str + angle_str + dist_str
    scad += f'frame = round($t*{n_frames});\n'
    scad += '$vpt = positions[frame];\n'
    scad += '$vpr = angles[frame];\n'
    scad += '$vpd = distances[frame];\n'

    scadlines = [render.scad for render in renders]
    render_str = ''
    for i, scadline in enumerate(scadlines):
        if i>0:
            render_str += '}\nelse '
        render_str += f'if (frame=={i})' + '{\n'
        render_str += '    '+scadline+ '\n'
    render_str += '}\n'

    scad += render_str
    return scad
