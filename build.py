#!/usr/bin/env python3
from ninja import Writer, ninja as run_build

build_file = open("build.ninja", "w")
ninja = Writer(build_file, width=120)

ninja.rule(
    "openscad", command="openscad $parameters $in -o $out -d $out.d", depfile="$out.d"
)

build_dir = "builds"


def p_string(name, value):
    """
    Build an OpenScad parameter string from a variable name and value
    
    Arguments:
        name {[str]} -- Parameter name
        value -- Parameter value
    """
    # Convert bools to lowercase
    if type(value) == bool:
        value = str(value).lower()
    # Wrap strings in quotes
    elif type(value) == str:
        value = f'"{value}"'

    return "-D '{}={}'".format(name, value)


def stage_parameters(stage_size, sample_z):
    """
    Return array of common stage parameters for a given size and sample z
    
    Arguments:
        stage_size {str} -- Stage size, e.g. "LS"
        sample_z {int} -- Sample z position, default 65
    """
    return [p_string("big_stage", (stage_size == "LS")), p_string("sample_z", sample_z)]


################################
### GENERAL, WIDELY USED OPTIONS

# All available microscope sizes
stage_size_options = ["LS"]
sample_z_options = [65]
# All permutations of microscope size
microscope_size_options = [
    f"{stage_size}{sample_z}"
    for stage_size in stage_size_options
    for sample_z in sample_z_options
]


###################
### MICROSCOPE BODY

for stage_size in stage_size_options:
    for sample_z in sample_z_options:
        for beamsplitter in [True, False]:
            for brim in [True, False]:
                motors = True  # Right now we never need to remove motor lugs

                outputs = "{build_dir}/main_body_{stage_size}{sample_z}{motors}{beamsplitter}{brim}.stl".format(
                    build_dir=build_dir,
                    stage_size=stage_size,
                    sample_z=sample_z,
                    motors="-M" if motors else "",
                    beamsplitter="-BS" if beamsplitter else "",
                    brim="_brim" if brim else "",
                )

                parameters = [
                    *stage_parameters(stage_size, sample_z),
                    p_string("motor_lugs", motors),
                    p_string("beamsplitter", beamsplitter),
                    p_string("enable_smart_brim", brim),
                ]

                ninja.build(
                    outputs,
                    rule="openscad",
                    inputs="openscad/main_body.scad",
                    variables={"parameters": " ".join(parameters)},
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

for sample_z in sample_z_options:
    for (camera, lens) in optics_versions:
        beamsplitter_options = [True, False] if lens in rms_lenses else [False]

        for beamsplitter in beamsplitter_options:
            outputs = "{build_dir}/optics_{camera}_{lens}{beamsplitter}.stl".format(
                build_dir=build_dir,
                camera=camera,
                lens=lens,
                beamsplitter="_beamsplitter" if beamsplitter else "",
            )

            parameters = [
                p_string("sample_z", sample_z),
                p_string("optics", lens),
                p_string("camera", camera),
                p_string("beamsplitter", beamsplitter),
            ]

            ninja.build(
                outputs,
                rule="openscad",
                inputs="openscad/optics.scad",
                variables={"parameters": " ".join(parameters)},
            )


####################
### MICROSCOPE STAND

# Stand with pi
for stand_height in [30]:
    for beamsplitter in [True, False]:
        outputs = "{build_dir}/microscope_stand_{stand_height}{beamsplitter}.stl".format(
            build_dir=build_dir,
            stand_height=stand_height,
            beamsplitter="-BS" if beamsplitter else "",
        )

        parameters = [
            p_string("h", stand_height),
            p_string("beamsplitter", beamsplitter),
        ]

        ninja.build(
            outputs,
            rule="openscad",
            inputs="openscad/microscope_stand.scad",
            variables={"parameters": " ".join(parameters)},
        )

# Stand without pi
parameters = []
ninja.build(
    "builds/microscope_stand_no_pi.stl",
    rule="openscad",
    inputs="openscad/microscope_stand_no_pi.scad",
    variables={"parameters": " ".join(parameters)},
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

    outputs = "{build_dir}/feet{version}.stl".format(
        build_dir=build_dir, version=version_name
    )

    parameters = [p_string("foot_height", foot_height)]

    ninja.build(
        outputs,
        rule="openscad",
        inputs="openscad/feet.scad",
        variables={"parameters": " ".join(parameters)},
    )


###################
### CAMERA PLATFORM

for stage_size in stage_size_options:
    for sample_z in sample_z_options:
        for version in ["picamera_2", "6led"]:
            outputs = "{build_dir}/camera_platform_{version}_{stage_size}{sample_z}.stl".format(
                build_dir=build_dir,
                version=version,
                stage_size=stage_size,
                sample_z=sample_z,
            )

            parameters = [
                *stage_parameters(stage_size, sample_z),
                p_string("optics", "pilens"),
                p_string("camera", version),
            ]

            ninja.build(
                outputs,
                rule="openscad",
                inputs="openscad/camera_platform.scad",
                variables={"parameters": " ".join(parameters)},
            )


###############
### LENS SPACER

for stage_size in stage_size_options:
    for sample_z in sample_z_options:
        outputs = "{build_dir}/lens_spacer_picamera_2_pilens_{stage_size}{sample_z}.stl".format(
            build_dir=build_dir, stage_size=stage_size, sample_z=sample_z
        )

        parameters = [
            *stage_parameters(stage_size, sample_z),
            p_string("optics", "pilens"),
        ]

        ninja.build(
            outputs,
            rule="openscad",
            inputs="openscad/lens_spacer.scad",
            variables={"parameters": " ".join(parameters)},
        )


##################
### PICAMERA TOOLS

picamera_2_tools = ["cover", "gripper", "lens_gripper"]
for tool in picamera_2_tools:
    outputs = f"builds/picamera_2_{tool}.stl"
    inputs = f"openscad/cameras/picamera_2_{tool}.scad"

    parameters = [p_string("camera", "picamera_2")]

    ninja.build(
        outputs,
        rule="openscad",
        inputs=inputs,
        variables={"parameters": " ".join(parameters)},
    )


#################
### SAMPLE RISERS

for riser_type in ["sample", "slide"]:
    outputs = f"builds/{riser_type}_riser_LS10.stl"
    inputs = f"openscad/{riser_type}_riser.scad"

    parameters = [p_string("big_stage", True), p_string("h", 10)]

    ninja.build(
        outputs,
        rule="openscad",
        inputs=inputs,
        variables={"parameters": " ".join(parameters)},
    )


###############
### SMALL PARTS

parts = [
    "actuator_assembly_tools",
    "actuator_drilling_jig",
    "back_foot",
    "condenser",
    "gears",
    "illumination_dovetail",
    "lens_tool",
    "motor_driver_case",
    "sample_clips",
    "small_gears",
    "thumbwheels",
]

for part in parts:
    outputs = f"builds/{part}.stl"
    inputs = f"openscad/{part}.scad"
    ninja.build(outputs, rule="openscad", inputs=inputs)


###############
### RUN BUILD

build_file.close()
run_build()
