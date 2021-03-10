stl_presets = [
    {
        "key": "high_resolution_raspberry_pi",
        "title": "High Resolution with Raspberry Pi",
        "description": "A microscope using the Raspberry Pi camera and  high resolution optics, as used for medical work.",
        "parameters": {
            "objective_type": "finite_rms",
            "camera": "picamera_2",
            "reflection_illumination": False,
            "motorised": True,
            "base_type": "rpi_base",
            "slide_riser": False,
        },
    },
    {
        "key": "basic_raspberry_pi",
        "title": "Basic with Raspberry Pi",
        "description": "A basic microscope using the Raspberry Pi camera and simple optics. Best suited for low resolution microscopy and educational workshops.",
        "parameters": {
            "objective_type": "cam_lens",
            "camera": "picamera_2",
            "motorised": False,
            "base_type": "rpi_base",
            "slide_riser": False,
        },
    },
    # {
    #    "key": "low_cost_webcam",
    #    "title": "Low Cost with Webcam",
    #    "description": "The cheapest possible option using a computer webcam.",
    #    "parameters": {
    #        "optics": "6ledcam_lens",
    #        "camera": "6ledcam",
    #        "motorised": False,
    #        "pi_in_base": False,
    #        "slide_riser": False,
    #    },
    # },
]

# In the outer dictionary are the questiosn of the STL selector. The "options" inside these are the possible options.
def get_option_docs(include_extra_files):
    camera_options = [
        {
            "key": "picamera_2",
            "title": "Pi Camera",
            "description": "The Raspberry Pi camera module v2.",
        },
        # {
        #    "key": "logitech_c270",
        #    "title": "Logitech C270",
        #    "description": "The Logitech C270 webcam",
        # },
        {
            "key": "m12",
            "title": "M12 Camera",
            "description": "A M12 CCTV camera",
        },
    ]

    if include_extra_files:
        camera_options += [
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
        ]

    camera_option_doc = {
        "key": "camera",
        "default": "picamera_2",
        "description": "The type of camera to use with your microscope.",
        "options": camera_options,
    }
    return [
        {
            "key": "objective_type",
            "default": "finite_rms",
            "description": "Do you want to use a microscope objective or the lens from your camera?",
            "options": [
                {
                    "key": "finite_rms",
                    "title": "RMS Objective",
                    "description": "A finite conjugate RMS objective. (Requires a f50d13 tube lens)",
                },
                {
                    "key": "infinite_rms",
                    "title": "Ininity Corrected RMS Objective",
                    "description": "An ininity Corrected conjugate RMS objective. (Requires a f50d13 tube lens)",
                },
                {
                    "key": "cam_lens",
                    "title": "Lens from camera",
                    "description": "The lens from the camera you will use.",
                },
            ],
        },
        camera_option_doc,
        {
            "key": "motorised",
            "default": True,
            "description": "Use unipolar stepper motors and a motor controller PCB to move the stage. The alternative is to use hand-actuated thumbwheels.",
        },
        {
            "key": "motor_driver_electronics",
            "default": "sangaboard",
            "description": "The type of electronics used to drive the motors",
            "options": [
                {
                    "key": "sangaboard",
                    "title": "Sangaboard",
                    "description": "A v0.3 Sangaboard. (Custom board)",
                },
                {
                    "key": "arduino_nano",
                    "title": "Ardunio Nano",
                    "description": "Homemade driver using Arduino Nano and the driver boards that come with the motors.",
                },
            ],
        },
        {
            "key": "slide_riser",
            "default": False,
            "advanced": True,
            "description": "Also include slide riser an alternative to the standard sample clips.",
        },
        {
            "key": "reflection_illumination",
            "default": False,
            "advanced": True,
            "description": "Enable the microscope modifications required for reflection illumination and fluorescence microscopy.",
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
            "key": "base_type",
            "description": "This is the base you mount the microcope to.",
            "default": "rpi_base",
            "options": [
                {
                    "key": "rpi_base",
                    "title": "Raspberry Pi base",
                    "description": "A base that also houses a Raspberry Pi",
                },
                {
                    "key": "rpi_base_tall",
                    "title": "Tall Raspberry Pi base",
                    "description": "A base that also houses a Raspberry Pi with extra room for longer optics.",
                },
                {
                    "key": "simple_base",
                    "title": "Simple base",
                    "description": "A simple base for the Microscope. It does not have room for extra electronics, or RMS objective optics modules.",
                },
            ],
        },
        {
            "key": "include_actuator_tension_band",
            "default": False,
            "advanced": True,
            "description": "Include some bands, to replace the o-rings, that need to be printed in TPU filament.",
        },
        {
            "key": "legacy_picamera_tools",
            "default": False,
            "advanced": True,
            "description": "Include tools for older picameras where the lenses are glued in.",
        },
    ]


# constraints on what is required to build a working microscope. these are used
# to disable option combinations that result in essential parts missing
required_stls = [
    # you need an optics module or a lens spacer, also called mount in some files
    r"^(optics_|lens_spacer|(.*cam_mount_)).*\.stl",
    # you need a main microscope body
    r"^main_body\.stl",
    # you need some feet
    r"^feet.*\.stl",
]
