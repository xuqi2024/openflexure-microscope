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


# TODO: reinstate `logitech_c270` if it can be made compatible.
CAMERAS = ["picamera_2", "m12"]

# NOTE: "rms_f40d16" not built as standard now as we do not regularly check it. Still in OpenSCAD incase needed.
RMS_OPTICS = ["rms_f50d13", "rms_infinity_f50d13"]
# TODO: reinstate "c270_lens", "m12_lens" once the have a compatible optics module
SIMPLE_OPTICS = ["pilens", "dashcam_lens", "6ledcam_lens"]
# Generate a list of optics options for later
ALL_OPTICS = RMS_OPTICS + SIMPLE_OPTICS

# TODO: Add stands in for 6ledcam, dashcam, m12 once they are supported
# These are (camera, lens) tuples
PLATFORM_OPTICS_MODULE_OPTIONS = [("picamera_2", "pilens")]

MOTOR_DRIVER_ELECTRONICS = ["sangaboard", "arduino_nano"]


def generate_rms_optics_modules(writer):
    for camera in CAMERAS:
        for optics in RMS_OPTICS:
            for beamsplitter in [True, False]:
                bs_text = "_beamsplitter" if beamsplitter else ""
                output = f"optics_{camera}_{optics}{bs_text}.stl"

                parameters = {
                    "optics": optics,
                    "camera": camera,
                    "beamsplitter": beamsplitter,
                }
                select_stl_if = {
                    "optics": optics,
                    "camera": camera,
                    "reflection_illumination": beamsplitter,
                }

                if optics == "rms_infinity_f50d13":
                    select_stl_if["tall_bucket_base"] = True
                else:
                    select_stl_if["tall_bucket_base"] = False

                writer.openscad(
                    output,
                    "optics.scad",
                    parameters=parameters,
                    select_stl_if=select_stl_if,
                )


def generate_platform_optics_modules(writer):
    """This gereates both the lens spacers and the camera platforms"""
    for camera, optics in PLATFORM_OPTICS_MODULE_OPTIONS:
        parameters = {"camera": camera, "optics": optics}
        select_stl_if = {**parameters, "reflection_illumination": False}

        output = f"camera_platform_{camera}_{optics}.stl"
        writer.openscad(
            output, "camera_platform.scad", parameters, select_stl_if=select_stl_if
        )

        output = f"lens_spacer_{camera}_{optics}.stl"
        writer.openscad(
            output, "lens_spacer.scad", parameters, select_stl_if=select_stl_if
        )


def generate_no_pi_stand(writer):
    """Stand without pi"""
    select_stl_if = []
    for optics in SIMPLE_OPTICS:
        select_stl_if.append({"pi_in_base": False, "optics": optics})

    writer.openscad(
        "microscope_stand_no_pi.stl",
        "microscope_stand_no_pi.scad",
        select_stl_if=select_stl_if,
    )


def generate_stand_with_pi(writer):
    """Two heights of stand  with pi"""
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
            select_stl_if.append({**parameters, "pi_in_base": True, "optics": optics})

        writer.openscad(
            output, "microscope_stand.scad", parameters, select_stl_if=select_stl_if
        )


def generate_motor_buckets(writer):
    """Motor driver electronics case"""
    for board_type in MOTOR_DRIVER_ELECTRONICS:

        parameters = {"motor_driver_electronics": board_type}

        writer.openscad(
            f"motor_driver_case_{board_type}.stl",
            "motor_driver_case.scad",
            parameters,
            select_stl_if={**parameters, "motorised": True},
        )


def generate_bases(writer):
    generate_no_pi_stand(writer)
    generate_stand_with_pi(writer)
    generate_motor_buckets(writer)


def generate_gears_and_thumwheels(writer):
    small_gear_selected = {"motorised": True}
    large_gear_selected = [
        {"motorised": True},
        {"motorised": False, "use_motor_gears_for_hand_actuation": True},
    ]
    thumbwheels_selected = {
        "motorised": False,
        "use_motor_gears_for_hand_actuation": False,
    }

    writer.openscad(
        "small_gears.stl", "small_gears.scad", select_stl_if=small_gear_selected
    )
    writer.openscad("gears.stl", "gears.scad", select_stl_if=large_gear_selected)
    writer.openscad(
        "thumbwheels.stl", "thumbwheels.scad", select_stl_if=thumbwheels_selected
    )


def generate_picamera_2_legacy_tools(writer):
    picamera_2_legacy_tools = ["gripper", "lens_gripper"]
    for tool in picamera_2_legacy_tools:
        output = f"picamera_2_{tool}.stl"
        input_file = f"cameras/picamera_2_{tool}.scad"
        parameters = {"camera": "picamera_2"}
        writer.openscad(
            output,
            input_file,
            parameters,
            select_stl_if={**parameters, "legacy_picamera_tools": True},
        )


def generate_small_parts(writer):
    generate_picamera_2_legacy_tools(writer)
    writer.openscad(
        "slide_riser.stl", "slide_riser.scad", select_stl_if={"slide_riser": True}
    )
    writer.openscad("actuator_assembly_tools.stl", "actuator_assembly_tools.scad")
    writer.openscad("condenser.stl", "condenser.scad")
    writer.openscad("illumination_dovetail.stl", "illumination_dovetail.scad")
    writer.openscad("lens_tool.stl", "lens_tool.scad")
    writer.openscad("just_nut_trap_test.stl", "just_nut_trap_test.scad")
    writer.openscad("feet.stl", "feet.scad")
    writer.openscad("sample_clips.stl", "sample_clips.scad")
    writer.openscad(
        "fl_cube.stl", "fl_cube.scad", select_stl_if={"reflection_illumination": True}
    )

    writer.openscad(
        "picamera_2_cover.stl",
        "cameras/picamera_2_cover.scad",
        parameters={"camera": "picamera_2"},
        select_stl_if={"camera": "picamera_2", "optics": set(RMS_OPTICS)},
    )
    writer.openscad(
        "actuator_tension_band.stl",
        "actuator_tension_band.scad",
        select_stl_if={"include_actuator_tension_band": True},
    )
    writer.openscad(
        "actuator_drilling_jig.stl",
        "actuator_drilling_jig.scad",
        select_stl_if={"include_actuator_drilling_jig": True},
    )
    writer.openscad(
        "reflection_illuminator.stl",
        "reflection_illuminator.scad",
        select_stl_if={"reflection_illumination": True},
    )
    writer.openscad("just_leg_test.stl", "just_leg_test.scad")


# Use ninja to write a build.ninja file which specifies all the STLs to build
with MicroscopeBuildWriter("builds", "build.ninja", args.generate_stl_options_json) as mbw:
    # Generate basic STL files
    mbw.openscad("main_body.stl", "main_body.scad")
    generate_rms_optics_modules(mbw)
    generate_platform_optics_modules(mbw)
    generate_bases(mbw)
    generate_gears_and_thumwheels(mbw)
    generate_small_parts(mbw)
    # Include extra STL files
    if args.include_extra_files:
        add_extra_stls_to_writer(mbw)

# Run the "ninja.build" file we just created, to generate STLs
sys.argv = [sys.argv[0]]
ninja()
