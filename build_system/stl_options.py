"""
This module sets the STL options which define:
    * The standard microscope configurations
    * How the options are documented in the STL selector
    * STLs that are requred for a valid microscope
"""

# Disable unused valuables in this file as some documented options may
# not be needed currently
# pylint: disable=unused-variable


def get_standard_configurations():
    """
    Return the STL selector parameters for the standard microscope configurations
    """

    # High resolution microscope config
    hi_res_description = ("A microscope using the Raspberry Pi camera and high resolution optics, "
                          "as used for laboratory work.")
    hi_res_parameters = {
        "objective_type": "finite_rms",
        "camera": "picamera_2",
        "reflection_illumination": False,
        "motorised": True,
        "base_type": "rpi_base",
        "slide_riser": False,
    }
    hi_res_config = {
        "key": "high_resolution_raspberry_pi",
        "title": "High Resolution with Raspberry Pi",
        "description": hi_res_description,
        "parameters": hi_res_parameters,
    }

    # Basic pi microscope config
    basic_pi_description = ("A basic microscope using the Raspberry Pi camera and simple optics. "
                            "Best suited for low resolution microscopy and educational workshops.")
    basic_pi_parameters = {
        "objective_type": "cam_lens",
        "camera": "picamera_2",
        "motorised": False,
        "base_type": "rpi_base",
        "slide_riser": False,
    }
    basic_pi_config = {
        "key": "basic_raspberry_pi",
        "title": "Basic with Raspberry ",
        "description": basic_pi_description,
        "parameters": basic_pi_parameters,
    }

    # Low cost/6LED webcam config
    low_cost_parameters = {
        "optics": "6ledcam_lens",
        "camera": "6ledcam",
        "motorised": False,
        "pi_in_base": False,
        "slide_riser": False,
    }
    low_cost_config = {
        "key": "basic_raspberry_pi",
        "title": "Basic with Raspberry ",
        "description": "The cheapest possible option using a computer webcam.",
        "parameters": low_cost_parameters,
    }

    # Note not returning low_cost_config until we are sure all the STLs are there.
    return [hi_res_config, basic_pi_config]


def _get_objective_options():
    """
    Return the objective/lens options and documentation strings for the STL selector
    """
    # Documentation strings for each objective/lens option
    finite_rms_doc = {
        "key": "finite_rms",
        "title": "RMS Objective",
        "description": "A finite conjugate RMS objective. (Requires a f50d13 tube lens)",
    }
    infinite_rms_doc = {
        "key": "infinite_rms",
        "title": "Ininity Corrected RMS Objective",
        "description": ("An ininity Corrected conjugate RMS objective. "
                        "(Requires a f50d13 tube lens)"),
    }
    cam_lens_doc = {
        "key": "cam_lens",
        "title": "Lens from camera",
        "description": "The lens from the camera you will use.",
    }
    # Set the documentation strings for the obective/lens option on the STL selector
    objective_options_doc = {
        "key": "objective_type",
        "default": "finite_rms",
        "description": "Do you want to use a microscope objective or the lens from your camera?",
        "options": [finite_rms_doc, infinite_rms_doc, cam_lens_doc]
    }
    return objective_options_doc

def _get_camera_options(include_extra_files):
    """
    Return the camera options and documentation strings for the STL selector
    """

    # Documentation strings for each camera in the STL selector
    picam_doc = {
        "key": "picamera_2",
        "title": "Pi Camera",
        "description": "The Raspberry Pi camera module v2.",
    }
    logitech_doc = {
        "key": "logitech_c270",
        "title": "Logitech C270",
        "description": "The Logitech C270 webcam",
    }
    m12_doc = {
        "key": "m12",
        "title": "M12 Camera",
        "description": "A M12 CCTV camera",
    }
    six_ledcam_doc = {
        "key": "6ledcam",
        "title": "6LED",
        "description": "A cheap USB '6 LED' Webcam",
    }
    dashcam_doc = {
        "key": "dashcam",
        "title": "Dashcam",
        "description": ("A cheap dash cam where a screen and camera are sold as one, "
                        "e.g. RangeTour B90s (it may be sold under different names as well)"),
    }

    # Note: that the logictech is not included until we check the STLs all work again
    camera_options = [picam_doc, m12_doc]

    # If also including the pre-built STLs then the 6LED cam and dashcam work
    if include_extra_files:
        camera_options += [six_ledcam_doc, dashcam_doc]

    # Set the documentation strings for the camera option on the STL selector
    camera_option_doc = {
        "key": "camera",
        "default": "picamera_2",
        "description": "The type of camera to use with your microscope.",
        "options": camera_options,
    }

    return camera_option_doc

def _get_motorised_options():
    """
    Return the documentation string for the STL selector when setting if the microscope is motorised
    """

    return {
        "key": "motorised",
        "default": True,
        "description": ("Use unipolar stepper motors and a motor controller PCB to move the stage. "
                        "The alternative is to use hand-actuated thumbwheels."),
    }

def _get_base_options():
    """
    Return the bucket base options and documentation strings for the STL selector
    """
    # Documentation strings for type of microscope stand in the STL selector

    pi_base_doc = {
        "key": "rpi_base",
        "title": "Raspberry Pi base",
        "description": "A base that also houses a Raspberry Pi",
    }
    rpi_base_tall_doc = {
        "key": "rpi_base_tall",
        "title": "Tall Raspberry Pi base",
        "description": "A base that also houses a Raspberry Pi with extra room for longer optics.",
    }
    simple_base_doc = {
        "key": "simple_base",
        "title": "Simple base",
        "description": ("A simple base for the Microscope. It does not have room for "
                        "extra electronics, or RMS objective optics modules."),
    }
    # Set the documentation strings for selecting the microscope stand in the STL selector
    base_option_doc = {
        "key": "base_type",
        "description": "This is the base you mount the microcope to.",
        "default": "rpi_base",
        "options": [pi_base_doc, rpi_base_tall_doc, simple_base_doc],
    }
    return base_option_doc


def _get_motor_driver_options():
    """
    Return the motor driver options and documentation strings for the STL selector
    """
    # Documentation strings for types of motor driver in the STL selector
    sangaboard_doc = {
        "key": "sangaboard",
        "title": "Sangaboard",
        "description": "A v0.3 Sangaboard. (Custom board)",
    }
    arduino_nano_doc = {
        "key": "arduino_nano",
        "title": "Ardunio Nano",
        "description": ("Homemade driver using Arduino Nano and the driver boards "
                        "that come with the motors."),
    }
    # Set the documentation strings for selecting the motor driver in the STL selector
    driver_doc = {
        "key": "motor_driver_electronics",
        "default": "sangaboard",
        "description": "The type of electronics used to drive the motors",
        "options": [sangaboard_doc, arduino_nano_doc],
    }
    return driver_doc


def _get_advanced_options():
    """
    Return a list of dictionaries. Each dictionary describes and "advanced" option in
    the STL selector.
    """

    slider_riser_doc = {
        "key": "slide_riser",
        "default": False,
        "advanced": True,
        "description": "Also include slide riser an alternative to the standard sample clips.",
    }
    reflection_illumination_doc = {
        "key": "reflection_illumination",
        "default": False,
        "advanced": True,
        "description": ("Enable the microscope modifications required for reflection illumination "
                        "and fluorescence microscopy."),
    }
    actuator_drilling_jig_doc = {
        "key": "include_actuator_drilling_jig",
        "description": ("This part is only needed to cleaning up a poorly printed microscope body"
                        " if the 3mm hole in the actuator has printed too small."),
        "advanced": True,
        "default": False,
    }
    gears_for_hand_actuation_doc = {
        "key": "use_motor_gears_for_hand_actuation",
        "default": False,
        "advanced": True,
        "description": ("Use the normal motor gears instead of the thumbwheels with the "
                        "hand-actuated version of the microscope."),
    }
    actuator_tension_band_doc = {
        "key": "include_actuator_tension_band",
        "default": False,
        "advanced": True,
        "description": ("Include some bands, to replace the o-rings, that need to be printed "
                        "in TPU filament."),
    }
    legacy_picamera_tools_doc = {
        "key": "legacy_picamera_tools",
        "default": False,
        "advanced": True,
        "description": "Include tools for older picameras where the lenses are glued in.",
    }

    return [
        slider_riser_doc,
        reflection_illumination_doc,
        actuator_drilling_jig_doc,
        gears_for_hand_actuation_doc,
        actuator_tension_band_doc,
        legacy_picamera_tools_doc
    ]

def get_option_docs(include_extra_files):
    """
    Returns the list of dictionaries needed to create the STL selector.
    Each dictionary is a question in the STL selector.
    These dictionaries have sub dictionaries that list the options and their names/descriptions.
    """
    standard_option_docs = [
        _get_objective_options(),
        _get_camera_options(include_extra_files),
        _get_motorised_options(),
        _get_motor_driver_options(),
        _get_base_options()
    ]

    return standard_option_docs + _get_advanced_options()



def get_required_stls():
    """ Return list of regexes that constrain on what is required to build a working microscope.
    These are used to disable option combinations that result in essential parts missing.
    """
    # you need an optics module or a lens spacer, also called mount in some files
    optics_regex = r"^(optics_|lens_spacer|(.*cam_mount_)).*\.stl"
    # you need a main microscope body
    body_regex = r"^main_body\.stl"
    # you need some feet
    feet_regex = r"^feet.*\.stl"
    return [optics_regex, body_regex, feet_regex]
