#!/usr/bin/env python3

import argparse
from ninja import Writer, ninja as run_build
import os
import sys

from build_system.json_generator import JsonGenerator

stl_presets = [
    {
        "key": "high_resolution_raspberry_pi",
        "title": "High Resolution with Raspberry Pi",
        "description": "A microscope using the Raspberry Pi camera and  high resolution optics, as used for medical work.",
        "parameters": {
            "optics": "rms_f50d13",
            "camera": "picamera_2",
            "reflection_illumination": False,
            "motorised": True,
            "base": "bucket",
            "pi_in_base": True,
            "microscope_stand:h": 30,
            "riser": "sample",
        },
    },
    {
        "key": "basic_raspberry_pi",
        "title": "Basic with Raspberry Pi",
        "description": "A basic microscope using the Raspberry Pi camera and simple optics. Best suited for low resolution microscopy and educational workshops.",
        "parameters": {
            "optics": "pilens",
            "use_pilens_optics_module": False,
            "camera": "picamera_2",
            "motorised": False,
            "base": "bucket",
            "pi_in_base": True,
            "microscope_stand:h": 30,
            "riser": "no riser",
        },
    },
    {
        "key": "low_cost_webcam",
        "title": "Low Cost with Webcam",
        "description": "The cheapest possible option using a computer webcam.",
        "parameters": {
            "optics": "6ledcam_lens",
            "camera": "6ledcam",
            "motorised": False,
            "base": "feet",
            "microscope_stand:h": 30,
            "riser": "no riser",
        },
    },
]

option_docs = [
    {
        "key": "enable_smart_brim",
        "default": True,
        "description": "Add a smart brim to the main body that helps with 3D-printer bed adhesion but doesn't gunk up the spaces needed for the flexure hinges.",
    },
    {
        "key": "optics",
        "default": "rms_f50d13",
        "description": "The type of lens you'd like to use on your microscope.",
        "options": [
            {
                "key": "rms_f50d13",
                "title": "RMS F50D13",
                "description": "An RMS-threaded microscope objective with 160mm tube length, and a 12.7mm diameter, 50mm focal length achromatic doublet lens.",
            },
            {
                "key": "rms_infinity_f50d13",
                "title": "RMS Infinity F50D13",
                "description": "An RMS-threaded, infinity-corrected microscope objective with a 12.7mm diameter, 50mm focal length achromatic doublet lens.",
            },
            {
                "key": "pilens",
                "title": "Pi Lens",
                "description": "The lens included with the Raspberry Pi camera module, v1 or v2 (either will fit)",
            },
            {
                "key": "c270_lens",
                "title": "C270 Lens",
                "description": "The lens included with the Logitech C270 webcam",
            },
            {
                "key": "m12_lens",
                "title": "M12 Lens",
                "description": "A typical M12 CCTV lens",
            },
            {
                "key": "6ledcam_lens",
                "title": "6LED Camera Lens",
                "description": "The lens that comes with a cheap '6LED' camera.",
            },
            {
                "key": "dashcam_lens",
                "title": "Dashcam Lens",
                "description": "The lens that comes with the camera of a cheap dashcam e.g. the RangeTour B90 (though it may be sold under different names).",
            },
            {
                "key": "rms_f40d16",
                "title": "RMS F40D16",
                "description": "An RMS-threaded microscope objective with 160mm tube length, and a 16mm diameter, 40mm focal length lens (no longer recommended due to poor quality at the edges of the image)",
            },
        ],
    },
    {
        "key": "camera",
        "default": "picamera_2",
        "description": "The type of camera to use with your microscope.",
        "options": [
            {
                "key": "picamera_2",
                "title": "Pi Camera",
                "description": "The Raspberry Pi camera module, version 1 or 2",
            },
            {
                "key": "logitech_c270",
                "title": "Logitech C270",
                "description": "The Logitech C270 webcam",
            },
            {"key": "m12", "title": "M12 Camera", "description": "A M12 CCTV camera"},
            {
                "key": "6ledcam",
                "title": "6LED",
                "description": "A cheap USB '6 LED' Webcam",
            },
            {
                "key": "dashcam",
                "title": "Dashcam",
                "description": "A cheap dash cam where a screen and camera are sold as one , e.g. RangeTour B90s (it may be sold under different names as well)",
            },
        ],
    },
    {
        "key": "motorised",
        "default": True,
        "description": "Use unipolar stepper motors and a motor controller PCB to move the stage. The alternative is to use hand-actuated thumbwheels.",
    },
    {
        "key": "riser",
        "default": "sample",
        "description": "Type of riser to use on top of the stage for optics that require it. The slide riser is custom made for microscope slides. The sample riser is more versatile and can also hold slides using the set of included sample clips.",
    },
    {
        "key": "base",
        "default": "bucket",
        "description": "Whether to use a bucket base style microscope stand. The alternative is to let it rest on its feet without housing any electronics inside it.",
    },
    {
        "key": "reflection_illumination",
        "default": False,
        "advanced": True,
        "description": "Enable the microscope modifications required for reflection illumination and fluorescence microscopy.",
    },
    {
        "key": "pi_in_base",
        "default": True,
        "advanced": True,
        "description": "Whether you'd like to house a Raspberry Pi in the bucket base.",
    },
    {
        "key": "include_actuator_drilling_jig",
        "description": "This part is very much optional, and is only useful for cleaning up slightly dodgy prints, if the 3mm hole in the actuator has printed too small.",
        "advanced": True,
        "default": False,
    },
    {
        "key": "use_motor_gears_for_hand_actuation",
        "default": False,
        "advanced": True,
        "description": "Use the normal motor gears instead of the thumbwheels with the hand-actuated version of the microscope.",
    },
    {
        "key": "microscope_stand:h",
        "description": "Height of the microscope bucket base stand in mm.  The default 30mm height should be fine, unless you're using an infinity-corrected optics module in which case you should select 45mm, to allow it to protrude further below the bottom of the main body.",
        "advanced": True,
        "default": 30,
    },
    {
        "key": "include_actuator_tension_band",
        "default": False,
        "advanced": True,
        "description": "Include some bands, to replace the o-rings, that need to be printed in TPU filament.",
    },
    {
        "key": "use_pilens_optics_module",
        "default": False,
        "advanced": True,
        "description": "Use the optics module with the Raspberry Pi lens rather than the lens spacer. Using the lens spacer is recommended for most uses.",
    },
    {
        "key": "legacy_picamera_tools",
        "default": False,
        "advanced": True,
        "description": "Include tools for older picameras where the lenses are glued in.",
    },
]

# additional constraints on what is required to build a working microscope
# that are not already expressed through openscad parameters, these are
# used to disable option combinations that result in essential parts
# missing
required_stls = [
    # you need an optics module or a lens spacer, also called mount in some files
    r"^(optics_|lens_spacer|(.*cam_mount_)).*\.stl",
    # you need a main microscope body
    r"^main_body_.*\.stl",
    # you need some feet
    r"^feet.*\.stl",
]

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
    command=f"{executable} $parameters $in -o $out -d $out.d",
    depfile="$out.d",
)


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
    input,
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
        input {str} -- file path of the input scad file
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
            input,
            parameters=parameters,
            file_local_parameters=file_local_parameters,
            select_stl_if=select_stl_if,
        )

    ninja.build(
        os.path.join(build_dir, output),
        rule="openscad",
        inputs=os.path.join("openscad/", input),
        variables={
            "parameters": parameters_to_string(
                {**parameters, **file_local_parameters, **openscad_only_parameters}
            )
        },
    )


################################
### GENERAL, WIDELY USED OPTIONS

# All available microscope sizes
sample_z_options = [75]
# All permutations of microscope size
microscope_size_options = [f"{sample_z}" for sample_z in sample_z_options]



###################
### MICROSCOPE BODY


for sample_z in sample_z_options:
    for beamsplitter in [True, False]:
        for brim in [True, False]:
            motors = True  # Right now we never need to remove motor lugs

            output = "main_body_{sample_z}{motors}{beamsplitter}{brim}.stl".format(
                sample_z=sample_z,
                motors="-M" if motors else "",
                beamsplitter="-BS" if beamsplitter else "",
                brim="_brim" if brim else "",
            )

            parameters = {
                "sample_z": sample_z,
                "motor_lugs": motors,
                "enable_smart_brim": brim,
            }
            openscad_only = {"beamsplitter": beamsplitter}
            select_stl_if = {"reflection_illumination": beamsplitter}

            openscad(
                output,
                "main_body.scad",
                parameters,
                openscad_only_parameters=openscad_only,
                select_stl_if=select_stl_if,
            )


#################
### OPTICS MODULE

cameras = ["picamera_2", "logitech_c270", "m12"]

rms_lenses = [
    "rms_f40d16",
    "rms_f50d13",
    "rms_infinity_f50d13",
]  # NB: Only RMS lenses are compatible with the beamsplitter

optics_versions = [
    ("picamera_2", "pilens"),
    ("logitech_c270", "c270_lens"),
    ("m12", "m12_lens"),
] + [(camera, lens) for camera in cameras for lens in rms_lenses]

# Generate a list of lenses to use elsewhere
all_lenses = list(
    set(l for c, l in optics_versions).union({"dashcam_lens", "6ledcam_lens"})
)

for sample_z in sample_z_options:
    for (camera, lens) in optics_versions:
        beamsplitter_options = [True, False] if lens in rms_lenses else [False]

        for beamsplitter in beamsplitter_options:
            output = "optics_{camera}_{lens}{beamsplitter}.stl".format(
                camera=camera,
                lens=lens,
                beamsplitter="_beamsplitter" if beamsplitter else "",
            )

            parameters = {"sample_z": sample_z, "optics": lens, "camera": camera}
            openscad_only = {"beamsplitter": beamsplitter}
            select_stl_if = {"reflection_illumination": beamsplitter}

            if lens == "pilens":
                select_stl_if["use_pilens_optics_module"] = True

            if lens not in rms_lenses:
                select_stl_if["riser"] = "no riser"

            if lens == "rms_infinity_f50d13":
                select_stl_if["microscope_stand:h"] = 45
            else:
                select_stl_if["microscope_stand:h"] = 30

            openscad(
                output,
                "optics.scad",
                parameters,
                openscad_only_parameters=openscad_only,
                select_stl_if=select_stl_if,
            )


####################
### MICROSCOPE STAND

# Stand with pi
for stand_height in [30, 45]:
    for beamsplitter in [True, False]:
        output = "microscope_stand_{stand_height}{beamsplitter}.stl".format(
            stand_height=stand_height, beamsplitter="-BS" if beamsplitter else ""
        )

        openscad_only = {"beamsplitter": beamsplitter}

        if stand_height == 45:
            compatible_lenses = ["rms_infinity_f50d13"]
        else:
            compatible_lenses = [l for l in all_lenses if l != "rms_infinity_f50d13"]

        openscad(
            output,
            "microscope_stand.scad",
            openscad_only_parameters=openscad_only,
            file_local_parameters={"h": stand_height},
            select_stl_if=[
                {
                    "pi_in_base": True,
                    "base": "bucket",
                    "reflection_illumination": beamsplitter,
                    "optics": optics,
                }
                for optics in compatible_lenses
            ],
        )

# Stand without pi
openscad(
    "microscope_stand_no_pi.stl",
    input="microscope_stand_no_pi.scad",
    parameters={},
    select_stl_if={"pi_in_base": False, "base": "bucket"},
)

# Motor driver electronics case
for motor_driver_electronics in ["sangaboard", "arduino_nano"]:
    outputs = f"{build_dir}/motor_driver_case_{motor_driver_electronics}.stl"
    parameters = {"motor_driver_electronics": motor_driver_electronics}
    
    ninja.build(
        outputs,
        rule="openscad",
        inputs="openscad/motor_driver_case.scad",
        variables={"parameters": parameters_to_string(parameters)},
    )

########
### FEET

for foot_height in [15, 26]:

    # Figure out some nice names for foot heights
    if foot_height == 26:
        version_name = "_tall"
    elif foot_height == 15:
        version_name = ""
    else:
        version_name = f"_{foot_height}"

    openscad_only_parameters = {"foot_height": foot_height}

    if foot_height == 26:
        select_stl_if = {
            "base": "feet",
            "optics": set(rms_lenses),
        }
        openscad(
            "back_foot_tall.stl",
            "back_foot.scad",
            openscad_only_parameters=openscad_only_parameters,
            select_stl_if=select_stl_if,
        )
    elif foot_height == 15:
        select_stl_if = [
            {
                "base": "bucket",
                "optics": set(all_lenses),
            },
            {
                "base": "feet",
                "optics": set(l for l in all_lenses if l not in rms_lenses),
            },
        ]
        openscad(
            f"back_foot.stl",
            "back_foot.scad",
            openscad_only_parameters=openscad_only_parameters,
            select_stl_if=select_stl_if[1],
        )
    openscad(
        "feet{version}.stl".format(version=version_name),
        "feet.scad",
        openscad_only_parameters=openscad_only_parameters,
        select_stl_if=select_stl_if,
    )


###################
### CAMERA PLATFORM


camera_platform_versions = [
    ("picamera_2", "pilens"),
    ("6ledcam", "6ledcam_lens"),
    ("dashcam", "dashcam_lens"),
]


for sample_z in sample_z_options:
    for camera, optics in camera_platform_versions:
        output = f"camera_platform_{camera}_{sample_z}.stl"

        parameters = {
            "sample_z": sample_z,
            "camera": camera,
        }

        select_stl_if = {
            "riser": "no riser",
            "optics": optics,
        }

        openscad(
            output,
            "camera_platform.scad",
            parameters,
        )


###############
### LENS SPACER


    for sample_z in sample_z_options:
        output = f"lens_spacer_picamera_2_pilens_{sample_z}.stl"

        parameters = {"sample_z": sample_z, "optics": "pilens"}

        openscad(
            output,
            "lens_spacer.scad",
            parameters,
            select_stl_if={
                "camera": "picamera_2",
                "reflection_illumination": False,
                "use_pilens_optics_module": False,
                "riser": "no riser",
            },
        )


##################
### PICAMERA TOOLS

picamera_2_legacy_tools = ["gripper", "lens_gripper"]
for tool in picamera_2_legacy_tools:
    output = f"picamera_2_{tool}.stl"
    input = f"cameras/picamera_2_{tool}.scad"
    parameters = {"camera": "picamera_2"}
    openscad(output, input, parameters, select_stl_if={"legacy_picamera_tools": True})


output = "picamera_2_cover.stl"
input = "cameras/picamera_2_cover.scad"
parameters = {"camera": "picamera_2"}
openscad(output, input, parameters)


#################
### SAMPLE RISERS

for riser_type in ["sample", "slide"]:
    output = f"{riser_type}_riser_LS10.stl"
    input = f"{riser_type}_riser.scad"

    openscad(
        output,
        input,
        parameters,
        file_local_parameters={"h": 10},
        select_stl_if={"riser": riser_type},
    )


###############
### SMALL PARTS

parts = ["actuator_assembly_tools", "condenser", "illumination_dovetail", "lens_tool"]

for part in parts:
    output = f"{part}.stl"
    input = f"{part}.scad"
    openscad(output, input)

openscad(
    "actuator_tension_band.stl",
    "actuator_tension_band.scad",
    select_stl_if={"include_actuator_tension_band": True},
)

openscad(
    "actuator_drilling_jig.stl",
    "actuator_drilling_jig.scad",
    select_stl_if={"include_actuator_drilling_jig": True},
)

openscad("fl_cube.stl", "fl_cube.scad", select_stl_if={"reflection_illumination": True})

openscad(
    "motor_driver_case.stl",
    "motor_driver_case.scad",
    select_stl_if={"motorised": True, "base": "bucket"},
)

openscad("small_gears.stl", "small_gears.scad", select_stl_if={"motorised": True})

openscad(
    "thumbwheels.stl",
    "thumbwheels.scad",
    select_stl_if={"motorised": False, "use_motor_gears_for_hand_actuation": False},
)

openscad(
    "gears.stl",
    "gears.scad",
    select_stl_if=[
        {"motorised": True},
        {"motorised": False, "use_motor_gears_for_hand_actuation": True},
    ],
)

openscad("sample_clips.stl", "sample_clips.scad", select_stl_if={"riser": "sample"})

openscad(
    "reflection_illuminator.stl",
    "reflection_illuminator.scad",
    select_stl_if={"reflection_illumination": True},
)


### prebuilt STL files from openflexure-microscope-extra

if args.include_extra_files:
    ninja.rule("copy", command="cp $in $out")

    def copy_stl(stl_file, select_stl_if=None):
        if args.generate_stl_options_json:
            json_generator.register(
                output=stl_file, input=stl_file, select_stl_if=select_stl_if
            )
        output = os.path.join(build_dir, stl_file)
        input = os.path.join("openflexure-microscope-extra", stl_file)
        ninja.build(output, rule="copy", inputs=input)

    for camera in ["6ledcam", "dashcam"]:
        copy_stl(
            f"{camera}_mount_top.stl",
            select_stl_if={
                "camera": camera,
                "optics": f"{camera}_lens",
                "riser": "no riser",
            },
        )

    copy_stl(
        "dashcam_and_6ledcam_mount_bottom.stl",
        select_stl_if=[
            {"camera": "dashcam", "optics": "dashcam_lens", "riser": "no riser"},
            {"camera": "6ledcam", "optics": "6ledcam_lens", "riser": "no riser"},
        ],
    )


###############
### RUN BUILD

build_file.close()

if args.generate_stl_options_json:
    json_generator.write()

run_build()
