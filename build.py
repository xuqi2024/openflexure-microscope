#!/usr/bin/env python3

'''
This is the main build script for the OpenFlexure Microscope. Run
`./build.py -h` to see options.

The selection for which STLs are generated is in build_system/stl_generator
The options for the STL selector are in build_system/stl_options
The selection for which extra STLs are copied in is in build_system/stl_copy
'''

import argparse
import os
import shutil
import subprocess
from ninja import BIN_DIR
from build_system.microscope_build_writer import MicroscopeBuildWriter
from build_system.util import version_string

BUILD_DIR = "docs/models"

#Some constants used in generating lists of parts

CAMERAS = ["picamera_2", "m12"]

# These are the optics configuration of objective and tube lens pairs.
# Currently we only support the F50D13 option in the offical build.
# "rms_f40d16" not built as standard now as we do not regularly check it
# but is still in OpenSCAD incase needed.
RMS_OPTICS = ["rms_f50d13"]
INF_RMS_OPTICS = ["rms_infinity_f50d13"]

# These are (camera, lens) tuples
# The when building the lens is assumed to be the lens of the camera!
PLATFORM_OPTICS_MODULE_OPTIONS = [("picamera_2", "pilens")]

def write_ninja_file(build_dir):
    """
    Register all files to be built. Some files options are generated in other functions
    Once this function is complete a ninja file will have been written with all STLs that need generating.
    """

    with MicroscopeBuildWriter(build_dir, "build.ninja") as writer:
        version_str = version_string(args.force_clean)
        print(f'Compiling microscope version "{version_str}"')

        # The main body
        writer.openscad("main_body.stl", "main_body.scad", {"VERSION_STRING": version_str})

        # Bases and electronics adapters
        generate_stand_with_pi(writer)
        writer.openscad("microscope_stand_no_pi.stl", "microscope_stand_no_pi.scad")
        writer.openscad("nano_converter_plate.stl", "nano_converter_plate.scad")
        writer.openscad("nano_converter_plate_gripper.stl", "nano_converter_plate_gripper.scad")

        # Standard components
        writer.openscad("feet.stl", "feet.scad")
        writer.openscad("sample_clips.stl", "sample_clips.scad")
        writer.openscad("cable_tidies.stl", "cable_tidies.scad")
        writer.openscad("small_gears.stl", "small_gears.scad")
        writer.openscad("large_gears.stl", "large_gears.scad")

        # Optics modules and associated components
        generate_rms_optics_modules(writer)
        generate_platform_optics_modules(writer)
        writer.openscad("picamera_2_cover.stl", "picamera_2_cover.scad")

        # Standard illumination components
        writer.openscad("condenser.stl", "condenser.scad")
        writer.openscad("illumination_dovetail.stl", "illumination_dovetail.scad")
        writer.openscad("illumination_thumbscrew.stl", "illumination_thumbscrew.scad")

        # Assembly tools
        writer.openscad("actuator_assembly_tools.stl", "actuator_assembly_tools.scad")
        writer.openscad("lens_tool.stl", "lens_tool.scad")
        writer.openscad("picamera_2_gripper.stl", "accessories/picamera_2_gripper.scad")
        writer.openscad("picamera_2_lens_gripper.stl", "accessories/picamera_2_lens_gripper.scad")

        # Test pieces
        writer.openscad("nut_trap_test.stl", "test_pieces/nut_trap_test.scad")
        writer.openscad("leg_test.stl", "test_pieces/leg_test.scad")

        # Special illumination components
        writer.openscad("fl_cube.stl", "fl_cube.scad")
        writer.openscad("reflection_illuminator.stl", "reflection_illuminator.scad")
        writer.openscad("led_array_holder.stl", "led_array_holder.scad")

        # Upright microscope components
        writer.openscad("separate_z_actuator.stl", "separate_z_actuator.scad")
        writer.openscad("upright_condenser.stl", "upright_condenser.scad")
        writer.openscad("upright_large_gears.stl", "upright_large_gears.scad")
        writer.openscad("upright_feet.stl", "upright_feet.scad")
        writer.openscad("upright_z_actuator_mount.stl", "upright_z_actuator_mount.scad")
        writer.openscad("accessories/upright_z_actuator_mount_5mm_sample.stl",
                        "accessories/upright_z_actuator_mount_5mm_sample.scad")
        writer.openscad("accessories/upright_z_actuator_mount_10mm_sample.stl",
                        "accessories/upright_z_actuator_mount_10mm_sample.scad")

        # Misc components
        writer.openscad("thumbwheels.stl", "thumbwheels.scad")
        writer.openscad("slide_riser.stl", "slide_riser.scad")
        writer.openscad("accessories/actuator_tension_band.stl", "accessories/actuator_tension_band.scad")
        writer.openscad("accessories/actuator_drilling_jig.stl", "accessories/actuator_drilling_jig.scad")


def generate_rms_optics_modules(writer):
    """
    Add all rms optics modules to the ninja build
    """
    for camera in CAMERAS:
        for optics in RMS_OPTICS + INF_RMS_OPTICS:
            for beamsplitter in [True, False]:
                bs_text = "_beamsplitter" if beamsplitter else ""
                output = f"optics_{camera}_{optics}{bs_text}.stl"

                parameters = {"OPTICS": optics,
                              "CAMERA": camera,
                              "BEAMSPLITTER": beamsplitter}

                writer.openscad(output, "rms_optics_module.scad", parameters)

def generate_platform_optics_modules(writer):
    """
    Add both the lens spacers and the camera platforms to the ninja build
    """
    for camera, optics in PLATFORM_OPTICS_MODULE_OPTIONS:
        writer.openscad(f"camera_platform_{camera}_{optics}.stl", "camera_platform.scad")
        writer.openscad(f"lens_spacer_{camera}_{optics}.stl", "lens_spacer.scad")

def generate_stand_with_pi(writer):
    """
    Add two heights of stand with pi to the ninja build
    """

    writer.openscad("microscope_stand.stl", "microscope_stand.scad", {"TALL_BUCKET_BASE": False})
    writer.openscad("microscope_stand_tall.stl", "microscope_stand.scad", {"TALL_BUCKET_BASE": True})

    # Also generate the tray for the pi itself
    for pi in [3,4]:
        for sanga in ["v0.3", "v0.4"]:
            if (pi==4) and (sanga=="v0.4"):
                output = "pi_stand.stl"
            else:
                output = f"pi_stand-pi{pi}_sanga{sanga}.stl"

            parameters = {"PI_VERSION": pi,
                          "SANGA_VERSION": sanga}

            writer.openscad(output, "pi_stand.scad", parameters)


def copy_extra_stls(build_dir, extras_dir):
    """
    Copy extra STLs to output directory
    """

    for root, dirs, files in os.walk(extras_dir):
        hidden_dirs = [subdir for subdir in dirs if subdir.startswith('.')]
        for hidden_dir in hidden_dirs:
            dirs.remove(hidden_dir)
        for name in files:
            if name.endswith('.stl'):
                stl_file = os.path.join(root, name)
                rel_path = os.path.relpath(stl_file, extras_dir)
                dest_dir = 'community-contributed-stls'
                desitination = os.path.join(build_dir, dest_dir, rel_path)
                os.makedirs(os.path.dirname(desitination), exist_ok=True)
                shutil.copyfile(stl_file, desitination)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        description="Run the OpenSCAD build for the Openflexure Microscope."
    )
    parser.add_argument(
        "--include-extra-files",
        help="Copy over STL files from openflexure-microscope-extra/ into the builds/ folder.",
        action="store_true",
    )
    parser.add_argument(
        "--force-clean",
        help="Ensures that the repo is clean before compiling",
        action="store_true",
    )

    # we get the flags above and will pass the rest to ninja
    args, ninja_args = parser.parse_known_args()

    write_ninja_file(BUILD_DIR)
    # Include extra STL files
    if args.include_extra_files:
        copy_extra_stls(BUILD_DIR, extras_dir = 'openflexure-microscope-extra')
    # Run the "ninja.build" file we just created, to generate STLs
    subprocess.run([os.path.join(BIN_DIR, "ninja")] + ninja_args, check=True)
