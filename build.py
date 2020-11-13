#!/usr/bin/env python

import argparse
from ninja import Writer, ninja as run_build
import os
import sys

from build_system.json_generator import JsonGenerator
from build_system.stl_options import stl_presets, option_docs, required_stls

build_dir = "builds"

build_file = open("build.ninja", "w")
ninja = Writer(build_file, width=120)


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

# ninja looks at the arguments and would get confused if we didn't remove
# the `--generate-stl-options-json` and other options
sys.argv = sys.argv[:1]


if args.generate_stl_options_json:
    json_generator = JsonGenerator(build_dir, option_docs, stl_presets, required_stls)


if sys.platform.startswith("darwin"):
    executable = "/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD"
else:
    executable = "openscad"


ninja.rule(
    "openscad",
    command=f"{executable} --hardwarnings $parameters $in -o $out -d $out.d",
    depfile="$out.d",
)
ninja.rule("copy", command="cp $in $out")


def parameters_to_string(parameters):
    """
    Build an OpenScad parameter arguments string from a variable name and value

    Arguments:
        parameters {dict} -- Dictionary of parameters
    """
    strings = []
    for name in parameters:
        value = parameters[name]
        # Convert bools to lowercase
        if type(value) == bool:
            value = str(value).lower()
        # Wrap strings in quotes
        elif type(value) == str:
            value = f'"{value}"'

        strings.append("-D '{}={}'".format(name, value))

    return " ".join(strings)


def openscad(
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

    if args.generate_stl_options_json:
        json_generator.register(
            output,
            input_file,
            parameters=parameters,
            file_local_parameters=file_local_parameters,
            select_stl_if=select_stl_if,
        )

    ninja.build(
        os.path.join(build_dir, output),
        rule="openscad",
        inputs=os.path.join("openscad/", input_file),
        variables={
            "parameters": parameters_to_string(
                {**parameters, **file_local_parameters, **openscad_only_parameters}
            )
        },
    )



###################
# SPLIT ME HERE!!

# TODO: reinstate `logitech_c270` if it can be made compatible.
CAMERAS = ["picamera_2", "m12"]

# NOTE: "rms_f40d16" not built as standard now as we do not regularly check it. Still in OpenSCAD incase needed.
RMS_OPTICS = ["rms_f50d13", "rms_infinity_f50d13"]
# TODO: reinstate "c270_lens", "m12_lens" once the have a compatible optics module
SIMPLE_OPTICS = ["pilens", "dashcam_lens", "6ledcam_lens"]
# Generate a list of optics options for later
ALL_OPTICS = RMS_OPTICS + SIMPLE_OPTICS

#TODO: Add stands in for 6ledcam, dashcam, m12 once they are supported
# These are (camera, lens) tuples
PLATFORM_OPTICS_MODULE_OPTIONS = [("picamera_2", "pilens")]

MOTOR_DRIVER_ELECTRONICS = ["sangaboard", "arduino_nano"]


def generate_rms_optics_modules():
    for camera in CAMERAS:
        for optics in RMS_OPTICS:
            for beamsplitter in [True,False]:
                bs_text = "_beamsplitter" if beamsplitter else "",
                output = f"optics_{camera}_{optics}{bs_text}.stl"

                parameters = {"optics": optics, "camera": camera}
                openscad_only = {"beamsplitter": beamsplitter}
                select_stl_if = {"reflection_illumination": beamsplitter}

                if optics == "rms_infinity_f50d13":
                    select_stl_if["tall_bucket_base"] = True
                else:
                    select_stl_if["tall_bucket_base"] = False

                openscad(
                    output,
                    "optics.scad",
                    parameters,
                    openscad_only_parameters=openscad_only,
                    select_stl_if=select_stl_if,
                )

def generate_platform_optics_modules():
    '''This gereates both the lens spacers and the camera platforms'''
    for camera, optics in PLATFORM_OPTICS_MODULE_OPTIONS:
        parameters = {"camera": camera, "optics": optics}
        select_stl_if = {"reflection_illumination": False}

        output = f"camera_platform_{camera}_{optics}.stl"
        openscad(output, "camera_platform.scad", parameters, select_stl_if=select_stl_if)

        output = f"lens_spacer_{camera}_{optics}.stl"
        openscad(output, "lens_spacer.scad", parameters, select_stl_if=select_stl_if)

def generate_no_pi_stand():
    '''Stand without pi'''
    select_stl_if = []
    for optics in SIMPLE_OPTICS:
        select_stl_if.append({"pi_in_base": False, "optics": optics})

    openscad("microscope_stand_no_pi.stl",
             "microscope_stand_no_pi.scad",
             select_stl_if=select_stl_if)

def generate_stand_with_pi():
    '''Two heights of stand  with pi'''
    for tall_base in [True, False]:

        if tall_base:
            output = "microscope_stand_tall.stl"
            compatible_lenses = ALL_OPTICS
        else:
            output = "microscope_stand.stl"
            compatible_lenses = [l for l in ALL_OPTICS if l != "rms_infinity_f50d13"]
        parameters = {"tall_bucket_base": tall_base}

        select_stl_if = []
        for optics in compatible_lenses:
            select_stl_if.append({"pi_in_base": True, "optics": optics})

        openscad(output,
                 "microscope_stand.scad",
                 parameters,
                 select_stl_if=select_stl_if)

def generate_motor_buckets():
    '''Motor driver electronics case'''
    for board_type in MOTOR_DRIVER_ELECTRONICS:

        parameters = {"motor_driver_electronics": board_type}

        openscad(f"motor_driver_case_{board_type}.stl",
                 "motor_driver_case.scad",
                 parameters,
                 select_stl_if={"motorised": True})

def generate_bases():
    generate_no_pi_stand()
    generate_stand_with_pi()
    generate_motor_buckets()

def generate_gears_and_thumwheels():
    small_gear_selected = {"motorised": True}
    large_gear_selected = [{"motorised": True},
                           {"motorised": False, "use_motor_gears_for_hand_actuation": True}]
    thumbwheels_selected = {"motorised": False, "use_motor_gears_for_hand_actuation": False}

    openscad("small_gears.stl", "small_gears.scad", select_stl_if=small_gear_selected)
    openscad("gears.stl", "gears.scad",select_stl_if=large_gear_selected)
    openscad("thumbwheels.stl", "thumbwheels.scad", select_stl_if=thumbwheels_selected)

def generate_picamera_2_legacy_tools():
    picamera_2_legacy_tools = ["gripper", "lens_gripper"]
    for tool in picamera_2_legacy_tools:
        output = f"picamera_2_{tool}.stl"
        input_file = f"cameras/picamera_2_{tool}.scad"
        parameters = {"camera": "picamera_2"}
        openscad(output, input_file, parameters, select_stl_if={"legacy_picamera_tools": True})


def generate_small_parts():
    generate_picamera_2_legacy_tools()
    openscad("slide_riser.stl", "slide_riser.scad", select_stl_if={"slide_riser": True})
    openscad("actuator_assembly_tools.stl", "actuator_assembly_tools.scad")
    openscad("condenser.stl", "condenser.scad")
    openscad("illumination_dovetail.stl", "illumination_dovetail.scad")
    openscad("lens_tool.stl", "lens_tool.scad")
    openscad("just_nut_trap_test.stl", "just_nut_trap_test.scad")
    openscad("feet.stl", "feet.scad")
    openscad("sample_clips.stl", "sample_clips.scad")
    openscad("fl_cube.stl", "fl_cube.scad", select_stl_if={"reflection_illumination": True})

    openscad("picamera_2_cover.stl",
             "cameras/picamera_2_cover.scad",
             {"camera": "picamera_2"},
             select_stl_if={"optics": set(RMS_OPTICS)})
    openscad("actuator_tension_band.stl",
             "actuator_tension_band.scad",
             select_stl_if={"include_actuator_tension_band": True})
    openscad("actuator_drilling_jig.stl",
             "actuator_drilling_jig.scad",
             select_stl_if={"include_actuator_drilling_jig": True})
    openscad("reflection_illuminator.stl",
             "reflection_illuminator.scad",
             select_stl_if={"reflection_illumination": True})
    openscad("just_leg_test.stl",
             "just_leg_test.scad",
             openscad_only_parameters={"big_stage": False})

def generate_stls():
    openscad("main_body.stl", "main_body.scad")
    generate_rms_optics_modules()
    generate_platform_optics_modules()
    generate_bases()
    generate_gears_and_thumwheels()
    generate_small_parts()

def copy_stl(stl_file, select_stl_if=None):
    if args.generate_stl_options_json:
        json_generator.register(
            output=stl_file, input_file=stl_file, select_stl_if=select_stl_if
        )
    output = os.path.join(build_dir, stl_file)
    input_file = os.path.join("openflexure-microscope-extra", stl_file)
    ninja.build(output, rule="copy", inputs=input_file)

def copy_extra_stls():
    

    for camera in ["6ledcam", "dashcam"]:

        select_mount_top = {"camera": camera, "optics": f"{camera}_lens"}
        copy_stl(f"{camera}_mount_top.stl", select_stl_if=select_mount_top)

    select_mount_bottom = [{"camera": "dashcam", "optics": "dashcam_lens"},
                           {"camera": "6ledcam", "optics": "6ledcam_lens"}]
    copy_stl("dashcam_and_6ledcam_mount_bottom.stl", select_stl_if=select_mount_bottom)

generate_stls()
if args.include_extra_files:
    copy_extra_stls()

###############
### RUN BUILD

build_file.close()

if args.generate_stl_options_json:
    json_generator.write()

run_build()
